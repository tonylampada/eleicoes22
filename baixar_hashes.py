import json

ufs = [
    'ac',
    'al',
    'ap',
    'am',
    'ba',
    'ce',
    'es',
    'go',
    'ma',
    'mt',
    'ms',
    'mg',
    'pa',
    'pb',
    'pr',
    'pe',
    'pi',
    'rj',
    'rn',
    'rs',
    'ro',
    'rr',
    'sc',
    'sp',
    'se',
    'to',
    'df',
    'zz',
]

for uf in ufs:
    with open(f'secoes/secoes_{uf}.json') as f:
        d = json.load(f)
        for iabr in d['abr']:
            for mu in iabr['mu']:
                codmun = mu['cd']
                for zon in mu['zon']:
                    codzon = zon['cd']
                    for sec in zon['sec']:
                        codsec = sec['ns']
                        url = f'https://resultados.tse.jus.br/oficial/ele2022/arquivo-urna/406/dados/{uf}/{codmun}/{codzon}/{codsec}/p000406-{uf}-m{codmun}-z{codzon}-s{codsec}-aux.json'
                        filename = f'hash-{uf}-m{codmun}-z{codzon}-s{codsec}.json'
                        print(f'wget {url} -O hashes/{filename}')
