from datetime import datetime
import sys
import csv
import dataset

uf = sys.argv[1]

CHUNKSIZE = 10000

inttypes = [
    'CD_TIPO_ELEICAO',
    'CD_PLEITO',
    'NR_TURNO',
    'CD_ELEICAO',
    'CD_MUNICIPIO',
    'NR_ZONA',
    'NR_SECAO',
    'NR_LOCAL_VOTACAO',
    'CD_CARGO_PERGUNTA',
    'NR_PARTIDO',
    'QT_APTOS',
    'QT_COMPARECIMENTO',
    'QT_ABSTENCOES',
    'CD_TIPO_URNA',
    'CD_TIPO_VOTAVEL',
    'NR_VOTAVEL',
    'QT_VOTOS',
    'NR_URNA_EFETIVADA',
    'QT_ELEITORES_BIOMETRIA_NH',
    'NR_JUNTA_APURADORA',
    'NR_TURMA_APURADORA',
]

datetypes = [
    'DT_BU_RECEBIDO',
    'DT_CARGA_URNA_EFETIVADA',
    'DT_ABERTURA',
    'DT_ENCERRAMENTO',
    'DT_EMISSAO_BU',
]

deletetypes = [
    'ANO_ELEICAO',
    'DT_GERACAO',
    'HH_GERACAO',
    'NM_TIPO_ELEICAO',
    'DT_PLEITO',
    'DS_ELEICAO',
    'DS_TIPO_URNA',
    'CD_CARGA_1_URNA_EFETIVADA',
    'CD_CARGA_2_URNA_EFETIVADA',
    'CD_FLASHCARD_URNA_EFETIVADA',
    'DS_CARGO_PERGUNTA_SECAO',
    'DS_AGREGADAS',
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
    for k in deletetypes:
        del ctypes[k]
    table = db.create_table('bu')
    for k in ctypes:
        table.create_column(k, ctypes[k])
    return table

def _asdate(s):
    return datetime.strptime(s, '%d/%m/%Y %H:%M:%S') if s else None

def prepare(lines):
    for line in lines:
        for k in deletetypes:
            del line[k]
        for k in datetypes:
            line[k] = _asdate(line[k])

def vai():
    with dataset.connect('sqlite:///eleicao22_2t.db') as db:
        table = None
        is_first = True
        filename = f'2t_bucsv/bweb_2t_{uf}_311020221535.csv'
        with open(filename, encoding='iso-8859-1') as f:
            for lines in chunker(csv.DictReader(f, delimiter=';', quotechar='"'), CHUNKSIZE):
                if is_first:
                    table = create_table(db, lines[0])
                    is_first = False
                prepare(lines)
                # for line in lines:
                #     for k in datetypes:
                #         if not isinstance(line[k], datetime):
                #             print('erro', k)
                #             print(line)
                #             exit()
                table.insert_many(lines, chunk_size=CHUNKSIZE)

vai()
