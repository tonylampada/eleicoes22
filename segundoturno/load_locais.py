from datetime import datetime
import sys
import csv
import dataset

CHUNKSIZE = 10000

inttypes = [
    'NR_TURNO',
    'CD_MUNICIPIO',
    'NR_ZONA',
    'NR_SECAO',
    'CD_TIPO_SECAO_AGREGADA',
    'NR_SECAO_PRINCIPAL',
    'NR_LOCAL_VOTACAO',
    'CD_TIPO_LOCAL',
    'CD_SITU_LOCAL_VOTACAO',
    'CD_SITU_ZONA',
    'CD_SITU_SECAO',
    'CD_SITU_LOCALIDADE',
    'CD_SITU_SECAO_ACESSIBILIDADE',
    'QT_ELEITOR_SECAO',
    'QT_ELEITOR_ELEICAO_FEDERAL',
    'QT_ELEITOR_ELEICAO_ESTADUAL',
    'QT_ELEITOR_ELEICAO_MUNICIPAL',
]

deletetypes = [
    'DT_GERACAO',
    'HH_GERACAO',
    'AA_ELEICAO',
    'DT_ELEICAO',
    'DS_ELEICAO',
]

floattypes = [
    'NR_LATITUDE',
    'NR_LONGITUDE',
]

def chunker(iterable, size):
    chunk = []
    for elem in iterable:
        chunk.append(elem)
        if len(chunk) >= size:
            yield chunk
            chunk = []
    if chunk:
        yield chunk


def create_table(db, line):
    ctypes = {k:db.types.text for k in line.keys()}
    for k in inttypes:
        ctypes[k] = db.types.bigint
    for k in floattypes:
        ctypes[k] = db.types.float
    for k in deletetypes:
        del ctypes[k]
    table = db.create_table('localvotacao')
    for k in ctypes:
        table.create_column(k, ctypes[k])
    return table

def _asdate(s):
    return datetime.strptime(s, '%d/%m/%Y %H:%M:%S') if s else None

def prepare(lines):
    for line in lines:
        for k in deletetypes:
            del line[k]

def vai():
    with dataset.connect('sqlite:///eleicao22_2t.db') as db:
        table = None
        is_first = True
        filename = f'2t_eleitorado/eleitorado_local_votacao_2022.csv'
        with open(filename, encoding='iso-8859-1') as f:
            for lines in chunker(csv.DictReader(f, delimiter=';', quotechar='"'), CHUNKSIZE):
                if is_first:
                    table = create_table(db, lines[0])
                    is_first = False
                prepare(lines)
                table.insert_many(lines, chunk_size=CHUNKSIZE)

vai()
