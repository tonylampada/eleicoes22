import json
import sys

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
exts = ['bu', 'rdv', 'logjez', 'vscmr', 'imgbu']


def main(argv):
    if len(argv) < 1:
        print(f'ERRO: parametro obrigatorio {exts}')
        exit(1)
    ext = argv[0]
    if ext not in exts:
        print(f'ERRO: {ext} nao eh um tipo conhecido {exts}')
        exit(2)
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
                            hashfilename = f'hashes/hash-{uf}-m{codmun}-z{codzon}-s{codsec}.json'
                            try:
                                with open(hashfilename) as hf:
                                    dh = json.load(hf)
                                    _hash = dh['hashes'][0]['hash']
                                    url = f'https://resultados.tse.jus.br/oficial/ele2022/arquivo-urna/406/dados/{uf}/{codmun}/{codzon}/{codsec}/{_hash}/o00406-{codmun}{codzon}{codsec}.{ext}'
                                    filename = f'{uf}-{codmun}-{codzon}-{codsec}.{ext}'
                                    print(f'wget {url} -O result/{filename}')
                            except:
                                print(f'deu ruim {hashfilename}')
                                raise
if __name__ == '__main__':
    main(sys.argv[1:])