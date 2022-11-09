from datetime import datetime
import csv
import dataset

deletetypes = [
    'DT_GERACAO',
    'HH_GERACAO',
    'ANO_ELEICAO',
]

inttypes = [
    'CD_MUNICIPIO',
    'CD_MUN_SIT_BIOMETRICA',
    'CD_ESTADO_CIVIL',
    'NR_ZONA',
    'CD_GENERO',
    'CD_FAIXA_ETARIA',
    'CD_GRAU_ESCOLARIDADE',
    'QT_ELEITORES_PERFIL',
    'QT_ELEITORES_BIOMETRIA',
    'QT_ELEITORES_DEFICIENCIA',
    'QT_ELEITORES_INC_NM_SOCIAL',
]

CHUNKSIZE = 10000

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
    for k in deletetypes:
        del ctypes[k]
    table = db.create_table('perfil_eleitorado_zona')
    for k in ctypes:
        table.create_column(k, ctypes[k])
    return table

def prepare(lines):
    for line in lines:
        for k in deletetypes:
            del line[k]

def vai():
    with dataset.connect('sqlite:///eleicao22_2t.db') as db:
        table = None
        is_first = True
        filename = f'2t_eleitorado/perfil_eleitorado_2022.csv'
        with open(filename, encoding='iso-8859-1') as f:
            for lines in chunker(csv.DictReader(f, delimiter=';', quotechar='"'), CHUNKSIZE):
                if is_first:
                    table = create_table(db, lines[0])
                    is_first = False
                prepare(lines)
                table.insert_many(lines, chunk_size=CHUNKSIZE)

vai()
