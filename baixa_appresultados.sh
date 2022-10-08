# App oficial da apuracao: https://resultados.tse.jus.br
# esse app faz umas chamadas ajax pra uns json que tem tudo que a gente precisa

# pega municipios e zonas eleitorais
wget https://resultados.tse.jus.br/oficial/ele2022/544/config/mun-e000544-cm.json -O municipios/municipios_zonas.json

function get_secoes {
	uf=$1
	wget https://resultados.tse.jus.br/oficial/ele2022/arquivo-urna/406/config/$uf/$uf-p000406-cs.json -O secoes/secoes_${uf}.json
}

# pega todas as secoes eleitorais (quase meio milhao)
get_secoes ac
get_secoes al
get_secoes ap
get_secoes am
get_secoes ba
get_secoes ce
get_secoes es
get_secoes go
get_secoes ma
get_secoes mt
get_secoes ms
get_secoes mg
get_secoes pa
get_secoes pb
get_secoes pr
get_secoes pe
get_secoes pi
get_secoes rj
get_secoes rn
get_secoes rs
get_secoes ro
get_secoes rr
get_secoes sc
get_secoes sp
get_secoes se
get_secoes to
get_secoes df
get_secoes zz

# por algum motivo a url dos arquivos de BU e RDV de cada seção tem um hash bizonho que precisa buscar de um outro json intermediario:
mkdir hashes
python baixar_hashes.py | bash

#depois de baixar os hashes na pasta hashes/ vc pode baixar os arquivos da urna que quiser (ele vai baixar na pasta result)
python baixar_bus.py bu | bash
python baixar_bus.py rdv | bash
python baixar_bus.py logjez | bash
python baixar_bus.py vscmr | bash
python baixar_bus.py imgbu | bash

