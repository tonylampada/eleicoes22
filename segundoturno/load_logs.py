import sys
import os
import dataset
from py7zr import SevenZipFile
from multiprocessing import Pool

CHUNKSIZE = 100

UFS = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
    'DF',
    'ZZ',
]

def _get_modelo(lines):
    deixa = 'Identificação do Modelo de Urna: '
    mlines = [line for line in lines if deixa in line]
    versions = {line.split(deixa)[1].split()[0] for line in mlines}
    if len(versions) > 1:
        raise Exception(f'conflito de versao {versions}')
    return list(versions)[0]

def _get_mzs(filename):
    cdmun = int(filename[7:12])
    nrzona = int(filename[12:16])
    nrsecao = int(filename[16:20])
    return cdmun, nrzona, nrsecao

def create_table(db):
    table = db.create_table('modelo_urna')
    table.create_column('SG_UF', db.types.text)
    table.create_column('CD_MUNICIPIO', db.types.bigint)
    table.create_column('NR_ZONA', db.types.bigint)
    table.create_column('NR_SECAO', db.types.bigint)
    table.create_column('MODELO', db.types.text)
    return table

def vai(uf):
    d = f'2t_logs/{uf}'
    logs = [l for l in os.listdir(d) if l.endswith('.logjez')]
    k = 0
    while k < len(logs):
        regs = []
        for log in logs[k:k+CHUNKSIZE]:
            with SevenZipFile(f'{d}/{log}') as f:
                lines = f.readall()['logd.dat'].readlines()
                lines = [line.decode(encoding='iso-8859-1') for line in lines]
                modelo = _get_modelo(lines)
                cdmun, nrzona, nrsecao = _get_mzs(log)
                regs.append({
                    'SG_UF': uf,
                    'CD_MUNICIPIO': cdmun,
                    'NR_ZONA': nrzona,
                    'NR_SECAO': nrsecao,
                    'MODELO': modelo
                })
        with dataset.connect('sqlite:///eleicao22_2t.db') as db:
            table = db['modelo_urna']
            table.insert_many(regs)
        k += CHUNKSIZE
        print(f'{uf} {k}/{len(logs)}')

with dataset.connect('sqlite:///eleicao22_2t.db') as db:
    table = create_table(db)

with Pool(12) as p:
    print(p.map(vai, UFS))
