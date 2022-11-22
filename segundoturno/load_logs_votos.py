from datetime import datetime
import os
import dataset
from py7zr import SevenZipFile
from multiprocessing import Pool
import sys

CHUNKSIZE = 50

class LinhaInesperada(Exception):
    pass

START, WAIT_TITULO, WAIT_COMPUTADO = 1, 2, 3
SEGUNDOTURNO = 'Iniciando aplicação - ELEIÇÃO OFICIAL SEGUNDO TURNO - Oficial - 2º turno'
TITULODIGITADO = 'Título digitado pelo mesário'
VOTOCOMPUTADO = 'O voto do eleitor foi computado'

class LogVotoStateMachine():
    def __init__(self, lines) -> None:
        self.lines = lines
        self.voto = None
        self.votos = []
    
    def _get_timestamp(self, line):
        return datetime.strptime(' '.join(line.split()[:2]), '%d/%m/%Y %H:%M:%S')

    def _breakon(self, line, deixas):
        for deixa in deixas:
            if deixa in line:
                raise LinhaInesperada(line)

    def comeca_voto(self, line):
        self.voto = {}
        self.voto['DT_INICIO'] = self._get_timestamp(line)
        self.state = WAIT_COMPUTADO
    
    def termina_voto(self, line):
        self.voto['DT_FIM'] = self._get_timestamp(line)
        self.voto['TEMPO_SEGUNDOS'] = (self.voto['DT_FIM'] - self.voto['DT_INICIO']).total_seconds()
        self.votos.append(self.voto)
        self.voto = None
        self.state = WAIT_TITULO

    def get_votos(self):
        """
        START ----(segundoturno)---> START1
        WAIT_TITULO ----(titulodigitado)---> WAIT_VOTOGP
        WAIT_COMPUTADO ----(votocomputado)---> WAIT_TITULO
        """
        self.state = START
        for i, line in enumerate(self.lines):
            try:
                if self.state == START:
                    if SEGUNDOTURNO in line:
                        self.state = WAIT_TITULO
                elif self.state == WAIT_TITULO:
                    self._breakon(line, {VOTOCOMPUTADO})
                    if TITULODIGITADO in line:
                        self.comeca_voto(line)
                elif self.state == WAIT_COMPUTADO:
                    if VOTOCOMPUTADO in line:
                        self.termina_voto(line)
                    if TITULODIGITADO in line:
                        self.comeca_voto(line)
            except LinhaInesperada as e:
                raise LinhaInesperada(f'[linha {i+1}] {line}')
        return self.votos


def _get_mzs(filename):
    cdmun = int(filename[7:12])
    nrzona = int(filename[12:16])
    nrsecao = int(filename[16:20])
    return cdmun, nrzona, nrsecao

def create_table(db):
    table = db.create_table('votos')
    table.create_column('idsecao', db.types.text)
    table.create_column('SG_UF', db.types.text)
    table.create_column('CD_MUNICIPIO', db.types.bigint)
    table.create_column('NR_ZONA', db.types.bigint)
    table.create_column('NR_SECAO', db.types.bigint)
    table.create_column('DT_INICIO', db.types.datetime)
    table.create_column('DT_FIM', db.types.datetime)
    table.create_column('TEMPO_SEGUNDOS', db.types.float)
    return table

def vai(uf):
    d = f'2t_logs/{uf}'
    logs = [l for l in os.listdir(d) if l.endswith('.logjez') or l.endswith('.logsajez')]
    # filename = 'o00407-7691000660029.logjez'
    # i = logs.index(filename)
    # logs = logs[i:]
    k = 0
    while k < len(logs):
        regs = []
        for log in logs[k:k+CHUNKSIZE]:
            try:
                cdmun, nrzona, nrsecao = _get_mzs(log)
                idsecao = f'{uf}_{cdmun}_{nrzona}_{nrsecao}'
                # print(cdmun, nrzona, nrsecao)
                with SevenZipFile(f'{d}/{log}') as f:
                    lines = f.readall()['logd.dat'].readlines()
                    lines = [line.decode(encoding='iso-8859-1') for line in lines]
                    votos = LogVotoStateMachine(lines).get_votos()
                    regs += [{
                        'idsecao': f'{uf}_{cdmun}_{nrzona}_{nrsecao}',
                        'SG_UF': uf,
                        'CD_MUNICIPIO': cdmun,
                        'NR_ZONA': nrzona,
                        'NR_SECAO': nrsecao,
                        'DT_INICIO': voto['DT_INICIO'],
                        'DT_FIM': voto['DT_FIM'],
                        'TEMPO_SEGUNDOS': voto['TEMPO_SEGUNDOS'],
                    } for voto in votos]
                # print(f'{idsecao} {len(votos)}')
                # exit()
            except Exception as e:
                raise Exception(f'Erro processando log {idsecao}')
        with dataset.connect('sqlite:///eleicao22_2t.db') as db:
            table = db['votos']
            table.insert_many(regs)
        k += CHUNKSIZE
        print(f'{uf} {k}/{len(logs)}')

if len(sys.argv) >= 2:
    uf = sys.argv[1]
    vai(uf)
else:
    with dataset.connect('sqlite:///eleicao22_2t.db') as db:
        table = create_table(db)

# with Pool(12) as p:
#     print(p.map(vai, UFS))

# vai('PR')