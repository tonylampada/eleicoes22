from datetime import datetime
import sys
import csv
import dataset

uf = sys.argv[1]

CHUNKSIZE = 10000

inttypes = [
    'NR_ZONA',
    'NR_SECAO',
    'NR_LOCAL_VOTACAO',
    'CD_MUNICIPIO',
    'CD_CARGO_PERGUNTA',
    'QT_APTOS',
    'QT_COMPARECIMENTO',
    'QT_ABSTENCOES',
    'CD_TIPO_VOTAVEL',
    'NR_VOTAVEL',
    'QT_VOTOS',
    'NR_URNA_EFETIVADA',
    'CD_CARGA_2_URNA_EFETIVADA',
    'QT_ELEITORES_BIOMETRIA_NH',
]

datetypes = [
    'DT_CARGA_URNA_EFETIVADA',
    'DT_ABERTURA',
    'DT_ENCERRAMENTO',
]

deletetypes = [
    'DT_GERACAO',
    'HH_GERACAO',
    'ANO_ELEICAO',
    'CD_PLEITO',
    'DT_PLEITO',
    'NR_TURNO',
    'CD_ELEICAO',
    'DS_ELEICAO',
    'DT_ELEICAO',
    'DS_CARGO_PERGUNTA_SECAO',
    'DS_AGREGADAS',
    'CD_TIPO_URNA',
    'DS_TIPO_URNA',
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
    for k in datetypes:
        ctypes[k] = db.types.datetime
    table = db.create_table('bu_a18t2')
    for k in ctypes:
        table.create_column(k, ctypes[k])
    return table

def _asdate(s):
    if not s or '#NULO#' in s:
        return None
    return datetime.strptime(s, '%d/%m/%Y %H:%M:%S')

def prepare(lines):
    for line in lines:
        if line.get('SG_ UF'):
            line['SG_UF'] = line['SG_ UF']
            del line['SG_ UF']
        for k in deletetypes:
            del line[k]
        for k in datetypes:
            line[k] = _asdate(line[k])

def vai():
    with dataset.connect('sqlite:///eleicao22_2t.db') as db:
        table = None
        is_first = True
        filename = f'data/a18/2t_bucsv/{uf}.csv'
        with open(filename, encoding='iso-8859-1') as f:
            for lines in chunker(csv.DictReader(f, delimiter=';', quotechar='"'), CHUNKSIZE):
                prepare(lines)
                if is_first:
                    table = create_table(db, lines[0])
                    is_first = False
                table.insert_many(lines, chunk_size=CHUNKSIZE)

vai()
