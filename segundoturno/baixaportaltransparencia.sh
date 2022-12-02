mkdir -p data/a18/1t_bucsv
mkdir -p data/a18/1t_logs 
mkdir -p data/a18/2t_bucsv
mkdir -p data/a18/2t_logs
mkdir -p data/a18/2t_eleitorado
mkdir -p data/a22/1t_bucsv
mkdir -p data/a22/1t_logs 
mkdir -p data/a22/2t_bucsv
mkdir -p data/a22/2t_logs
mkdir -p data/a22/2t_eleitorado

function get_zip {
	uf=$1
	wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" https://cdn.tse.jus.br/estatistica/sead/eleicoes/eleicoes2022/arqurnatot/bu_imgbu_logjez_rdv_vscmr_2022_2t_${uf}.zip -O 2t_logs/${uf}.zip
	wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" https://cdn.tse.jus.br/estatistica/sead/eleicoes/eleicoes2022/buweb/bweb_2t_${uf}_311020221535.zip -O 2t_bucsv/${uf}.zip
}

function sobralogs {
	uf=$1
	mkdir -p 2t_logs/$uf
	unzip 2t_logs/${uf}.zip -d 2t_logs/${uf}/
	rm 2t_logs/$uf/*.pdf
	rm 2t_logs/$uf/*.bu
	rm 2t_logs/$uf/*.imgbu
	rm 2t_logs/$uf/*.rdv
	rm 2t_logs/$uf/*.vscmr
}

function get_perfil {
	uf=$1
	wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" https://cdn.tse.jus.br/estatistica/sead/odsele/perfil_eleitor_secao/perfil_eleitor_secao_2022_${uf}.zip -O 2t_eleitorado/perfil_${uf}.zip
}

alias uwget='wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0"'

function get_bu_zip_18_2t {
	uf=$1
	uwget https://cdn.tse.jus.br/estatistica/sead/eleicoes/eleicoes2018/buweb/BWEB_2t_${uf}_301020181744.zip -O data/a18/2t_bucsv/${uf}.zip
}

get_zip AC
get_zip AL
get_zip AP
get_zip AM
get_zip BA
get_zip CE
get_zip ES
get_zip GO
get_zip MA
get_zip MT
get_zip MS
get_zip MG
get_zip PA
get_zip PB
get_zip PR
get_zip PE
get_zip PI
get_zip RJ
get_zip RN
get_zip RS
get_zip RO
get_zip RR
get_zip SC
get_zip SP
get_zip SE
get_zip TO
get_zip DF
get_zip ZZ

sobralogs AC
sobralogs AL
sobralogs AP
sobralogs AM
sobralogs BA
sobralogs CE
sobralogs ES
sobralogs GO
sobralogs MA
sobralogs MT
sobralogs MS
sobralogs MG
sobralogs PA
sobralogs PB
sobralogs PR
sobralogs PE
sobralogs PI
sobralogs RJ
sobralogs RN
sobralogs RS
sobralogs RO
sobralogs RR
sobralogs SC
sobralogs SP
sobralogs SE
sobralogs TO
sobralogs DF
sobralogs ZZ

wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" https://cdn.tse.jus.br/estatistica/sead/odsele/eleitorado_locais_votacao/eleitorado_local_votacao_2022.zip -O 2t_eleitorado/local_votacao.zip
wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" https://cdn.tse.jus.br/estatistica/sead/odsele/perfil_eleitorado/perfil_eleitorado_2022.zip -O 2t_eleitorado/perfil.zip

get_perfil AC
get_perfil AL
get_perfil AP
get_perfil AM
get_perfil BA
get_perfil CE
get_perfil ES
get_perfil GO
get_perfil MA
get_perfil MT
get_perfil MS
get_perfil MG
get_perfil PA
get_perfil PB
get_perfil PR
get_perfil PE
get_perfil PI
get_perfil RJ
get_perfil RN
get_perfil RS
get_perfil RO
get_perfil RR
get_perfil SC
get_perfil SP
get_perfil SE
get_perfil TO
get_perfil DF
get_perfil ZZ

# 2018 2T
cat ufs.txt | xargs -n 1 baixar/get_buzip_18_2t.sh
uwget https://cdn.tse.jus.br/estatistica/sead/odsele/perfil_eleitorado/perfil_eleitorado_2018.zip -O data/a18/2t_eleitorado/perfil.zip
uwget https://cdn.tse.jus.br/estatistica/sead/odsele/eleitorado_locais_votacao/eleitorado_local_votacao_2018.zip -O data/a18/2t_eleitorado/local_votacao.zip
