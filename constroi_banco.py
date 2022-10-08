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

db = dataset.connect('sqlite:///bu.db')
table = db['bu']


def chunker(iterable, size):
    chunk = []
    for elem in iterable:
        chunk.append(elem)
        if len(chunk) >= size:
            yield chunk
            chunk = []
    if chunk:
        yield chunk

for uf in ufs:
    filename = f'buzips/bweb_1t_{uf}_051020221321.csv'
    print(f'{uf}...')
    with open(filename, encoding='iso-8859-1') as f:
        for lines in chunker(csv.DictReader(f, delimiter=';', quotechar='"'), 10000):
            table.insert_many(lines)
print('ok')
