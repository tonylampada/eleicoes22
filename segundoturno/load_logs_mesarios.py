from datetime import datetime
import os
import dataset
from py7zr import SevenZipFile
from multiprocessing import Pool
import sys
import re

DB_URL = 'sqlite:///eleicao22_2t.db'

CHUNKSIZE = 50
START, WAIT_INDAGADO, WAIT_CANCELOU, WAIT_ENCERROU, ENCERROU  = 1, 2, 3, 4, 5
SEGUNDOTURNO = 'Iniciando aplicação - ELEIÇÃO OFICIAL SEGUNDO TURNO - Oficial - 2º turno'
OPERADORINDAGADO = 'Operador indagado se ocorrerá registro de mesários'
OPERADORCANCELOU = 'Operador cancelou para registrar mesários'
OPERADORENCERROU = 'Operador encerrou ciclo de registro de mesários'
MESARIOREGISTRADO = '^.*Mesário ([0-9]+) registrado.*$'

class LogMesariosStateMachine():
    def __init__(self, lines) -> None:
        self.lines = lines
        self.mesarios = []
        self.cancelou = {'FLAG_CANCELOU': False, 'DT_CANCELOU': None}
    
    def _get_timestamp(self, line):
        return datetime.strptime(' '.join(line.split()[:2]), '%d/%m/%Y %H:%M:%S')

    def _add_mesario(self, codmesario, line):
        self.mesarios.append({
            'COD_MESARIO': codmesario,
            'DT_REGISTRO': self._get_timestamp(line)
        })
    
    def _cancela(self, line):
        self.cancelou['FLAG_CANCELOU'] = True
        self.cancelou['DT_CANCELOU'] = self._get_timestamp(line)

    def parse(self):
        """
        START ----(SEGUNDOTURNO)---> WAIT_INDAGADO
        WAIT_INDAGADO ----(OPERADORINDAGADO)---> WAIT_CANCELOU
        WAIT_CANCELOU ----(OPERADORCANCELOU)---> WAIT_ENCERROU
        WAIT_ENCERROU ----(OPERADORENCERROU)---> ENCERROU
        """
        self.state = START
        for i, line in enumerate(self.lines):
            if self.state == START:
                if SEGUNDOTURNO in line:
                    self.state = WAIT_INDAGADO
            else:
                match = re.match(MESARIOREGISTRADO, line)
                if match:
                    self._add_mesario(match.groups()[0], line)
                if self.state == WAIT_INDAGADO:
                    if OPERADORINDAGADO in line:
                        self.state = WAIT_CANCELOU
                elif self.state == WAIT_CANCELOU:
                    if OPERADORCANCELOU in line:
                        self.state = WAIT_ENCERROU
                    else:
                        self.state = WAIT_INDAGADO
                elif self.state == WAIT_ENCERROU:
                    if OPERADORENCERROU in line:
                        self.state = ENCERROU
                        self._cancela(line)
                    else:
                        self.state = WAIT_INDAGADO
                elif self.state == ENCERROU:
                    pass
        return self.mesarios, self.cancelou

def _get_mzs(filename):
    cdmun = int(filename[7:12])
    nrzona = int(filename[12:16])
    nrsecao = int(filename[16:20])
    return cdmun, nrzona, nrsecao

def create_tables(db):
    table = db.create_table('log_registro_mesarios')
    table.create_column('idsecao', db.types.text)
    table.create_column('SG_UF', db.types.text)
    table.create_column('CD_MUNICIPIO', db.types.bigint)
    table.create_column('NR_ZONA', db.types.bigint)
    table.create_column('NR_SECAO', db.types.bigint)
    table.create_column('COD_MESARIO', db.types.text)
    table.create_column('DT_REGISTRO', db.types.datetime)

    table = db.create_table('log_cancelou_mesarios')
    table.create_column('idsecao', db.types.text)
    table.create_column('SG_UF', db.types.text)
    table.create_column('CD_MUNICIPIO', db.types.bigint)
    table.create_column('NR_ZONA', db.types.bigint)
    table.create_column('NR_SECAO', db.types.bigint)
    table.create_column('FLAG_CANCELOU', db.types.boolean)
    table.create_column('DT_CANCELOU', db.types.datetime)

def vai(uf):
    d = f'data/a22/2t_logs/{uf}'
    with dataset.connect(DB_URL) as db:
        mzs_bd = db.query(f"select CD_MUNICIPIO m, NR_ZONA z, NR_SECAO s from log_cancelou_mesarios where SG_UF = '{uf}'")
        mzs_bd = {(d['m'], d['z'], d['s']) for d in mzs_bd}
    logs = [l for l in os.listdir(d) if (l.endswith('.logjez') or l.endswith('.logsajez')) and _get_mzs(l) not in mzs_bd]
    # filename = 'o00407-7691000660029.logjez'
    # i = logs.index(filename)
    # logs = logs[i:]
    k = 0
    while k < len(logs):
        cancelamentos = []
        mesarios = []
        for log in logs[k:k+CHUNKSIZE]:
            try:
                cdmun, nrzona, nrsecao = _get_mzs(log)
                idsecao = f'{uf}_{cdmun}_{nrzona}_{nrsecao}'
                # print(cdmun, nrzona, nrsecao)
                with SevenZipFile(f'{d}/{log}') as f:
                    lines = f.readall()['logd.dat'].readlines()
                    lines = [line.decode(encoding='iso-8859-1') for line in lines]
                    newmesarios, cancelou = LogMesariosStateMachine(lines).parse()
                    mesarios += [{
                        'idsecao': f'{uf}_{cdmun}_{nrzona}_{nrsecao}',
                        'SG_UF': uf,
                        'CD_MUNICIPIO': cdmun,
                        'NR_ZONA': nrzona,
                        'NR_SECAO': nrsecao,
                        'COD_MESARIO': m['COD_MESARIO'],
                        'DT_REGISTRO': m['DT_REGISTRO'],
                    } for m in newmesarios]
                    cancelamentos.append({
                        'idsecao': f'{uf}_{cdmun}_{nrzona}_{nrsecao}',
                        'SG_UF': uf,
                        'CD_MUNICIPIO': cdmun,
                        'NR_ZONA': nrzona,
                        'NR_SECAO': nrsecao,
                        'FLAG_CANCELOU': cancelou['FLAG_CANCELOU'],
                        'DT_CANCELOU': cancelou['DT_CANCELOU'],
                    })
            except Exception as e:
                raise Exception(f'Erro processando log {idsecao}')
        with dataset.connect(DB_URL) as db:
            db['log_registro_mesarios'].insert_many(mesarios)
            db['log_cancelou_mesarios'].insert_many(cancelamentos)
        k += CHUNKSIZE
        print(f'{uf} {k}/{len(logs)}')

if len(sys.argv) >= 2:
    uf = sys.argv[1]
    vai(uf)
else:
    with dataset.connect(DB_URL) as db:
        create_tables(db)

# with Pool(12) as p:
#     print(p.map(vai, UFS))

# vai('PR')