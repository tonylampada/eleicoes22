mkdir 1t_bucsv 2t_bucsv 1t_logs 2t_logs

function get_zip {
	uf=$1
	wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" https://cdn.tse.jus.br/estatistica/sead/eleicoes/eleicoes2022/arqurnatot/bu_imgbu_logjez_rdv_vscmr_2022_2t_${uf}.zip -O 2t_logs/${uf}.zip
	wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" https://cdn.tse.jus.br/estatistica/sead/eleicoes/eleicoes2022/buweb/bweb_2t_${uf}_311020221535.zip -O 2t_bucsv/${uf}.zip
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
