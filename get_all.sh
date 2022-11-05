function get_all {
	uf=$1
	wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" https://cdn.tse.jus.br/estatistica/sead/eleicoes/eleicoes2022/arqurnatot/bu_imgbu_logjez_rdv_vscmr_2022_1t_${uf}.zip -O all_${uf}.zip
}


function sobralogs {
	uf=$1
	mkdir -p $uf
	unzip all_${uf}.zip -d ${uf}/
	rm $uf/*.pdf
	rm $uf/*.bu
	rm $uf/*.imgbu
	rm $uf/*.rdv
	rm $uf/*.vscmr
	rm all_${uf}.zip
}

get_all AC
get_all AL
get_all AP
get_all AM
get_all BA
get_all CE
get_all ES
get_all GO
get_all MA
get_all MT
get_all MS
get_all MG
get_all PA
get_all PB
get_all PR
get_all PE
get_all PI
get_all RJ
get_all RN
get_all RS
get_all RO
get_all RR
get_all SC
get_all SP
get_all SE
get_all TO
get_all DF
get_all ZZ

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
