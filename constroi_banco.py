# constroi o banco sqlite a partir de buzips/*
import csv
import dataset

ufs = [
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

inttypes = [
    'ANO_ELEICAO',
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

deletetypes = [
    'DT_GERACAO',
    'HH_GERACAO',
    'NM_TIPO_ELEICAO',
    'DT_PLEITO',
    'DS_ELEICAO',
    'DT_BU_RECEBIDO',
    'DS_TIPO_URNA',
    'CD_CARGA_1_URNA_EFETIVADA',
    'CD_CARGA_2_URNA_EFETIVADA',
    'CD_FLASHCARD_URNA_EFETIVADA',
    'DT_CARGA_URNA_EFETIVADA',
    'DS_CARGO_PERGUNTA_SECAO',
    'DS_AGREGADAS',
    'DT_ABERTURA',
    'DT_ENCERRAMENTO',
    'DT_EMISSAO_BU',
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
    for k in deletetypes:
        del ctypes[k]
    table = db.create_table('bu')
    for k in ctypes:
        table.create_column(k, ctypes[k])
    return table


def prepare(lines):
    for line in lines:
        for k in deletetypes:
            del line[k]

def vai():
    db = dataset.connect('sqlite:///bu.db')
    table = None
    is_first = True
    for uf in ufs:
        filename = f'buzips/bweb_1t_{uf}_051020221321.csv'
        print(f'{uf}...')
        with open(filename, encoding='iso-8859-1') as f:
            for lines in chunker(csv.DictReader(f, delimiter=';', quotechar='"'), 100000):
                if is_first:
                    table = create_table(db, lines[0])
                    is_first = False
                prepare(lines)
                table.insert_many(lines, chunk_size=100000)
    print('ok')

vai()