mkdir -p resumojson
rm resumojson/*

function get_resumo {
	uf=$1
	wget https://resultados.tse.jus.br/oficial/ele2022/545/dados-simplificados/${uf}/${uf}-c0001-e000545-r.json -O resumojson/${uf}.json
}

get_resumo br
get_resumo ac
get_resumo al
get_resumo ap
get_resumo am
get_resumo ba
get_resumo ce
get_resumo es
get_resumo go
get_resumo ma
get_resumo mt
get_resumo ms
get_resumo mg
get_resumo pa
get_resumo pb
get_resumo pr
get_resumo pe
get_resumo pi
get_resumo rj
get_resumo rn
get_resumo rs
get_resumo ro
get_resumo rr
get_resumo sc
get_resumo sp
get_resumo se
get_resumo to
get_resumo df
get_resumo zz


python3 previsao.py