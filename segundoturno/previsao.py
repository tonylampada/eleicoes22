import json

estados = ['ac','al','ap','am','ba','ce','es','go','ma','mt','ms','mg','pa','pb','pr','pe','pi','rj','rn','rs','ro','rr','sc','sp','se','to','df','zz']

def _load(uf):
	with open(f'/home/tonylampada/work/solo/eleicoes22/segundoturno/resumojson/{uf}.json') as f:
		return json.load(f)

dbr = _load('br')
destados = [_load(uf) for uf in estados]
# print(dbr)
# print(destados)

for destado in destados:
	destado['psi'] = float(destado['psi'].replace(',','.'))

destados = sorted(destados, key=lambda d: d['psi'])

pvlula, pvbolsonaro = 0,0


for d in destados[::-1]:
	s = f'{d["cdabr"]} {d["psi"]}% apurado'
	cands = sorted(d['cand'], key=lambda c:c['nm'])
	bolsonaro = cands[0]
	lula = cands[1]
	assert bolsonaro['nm'] == 'JAIR BOLSONARO' 
	assert lula['nm'] == 'LULA' 
	s += f' / {bolsonaro["nm"]} {bolsonaro["pvap"]}% ({bolsonaro["vap"]} votos)'
	s += f' / {lula["nm"]} {lula["pvap"]}% ({lula["vap"]} votos)'
	p = d['psi']/100
	pvlula += int(lula['vap']) * (1 - p)/p
	pvbolsonaro += int(bolsonaro['vap']) * (1 - p)/p
	print(s)

print(pvlula, pvbolsonaro)

print(f'seções totalizadas {dbr["psi"]}%')
print('-----------------')
candbr = dbr['cand']
candbr = sorted(dbr['cand'], key=lambda c:c['nm'])
for c in candbr:
	print(f'{c["nm"]} {c["pvap"]}% ({c["vap"]} votos)')

bolsonaro = candbr[0]
lula = candbr[1]
assert bolsonaro['nm'] == 'JAIR BOLSONARO' 
assert lula['nm'] == 'LULA' 
print('--------PREVISAO---------')
print(f'Lula +{int(pvlula)} votos / Bolsonaro +{int(pvbolsonaro)} votos')
print('Total previsto')
tpvlula = int(lula['vap']) + int(pvlula)
tpvbolsonaro = int(bolsonaro['vap']) + int(pvbolsonaro)
tpv = tpvlula + tpvbolsonaro
ppvlula = 100 * tpvlula / tpv
ppvbolsonaro = 100 * tpvbolsonaro / tpv
print(f'Lula {tpvlula} ({ppvlula:.2f}%) x Bolsonaro {tpvbolsonaro} ({ppvbolsonaro:.2f}%)')