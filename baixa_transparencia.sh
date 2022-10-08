# transparencia TSE https://dadosabertos.tse.jus.br/organization/tse-agel
# BUs https://dadosabertos.tse.jus.br/dataset/resultados-2022-boletim-de-urna

mkdir buzips

function get_buzip {
	uf=$1
	wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" https://cdn.tse.jus.br/estatistica/sead/eleicoes/eleicoes2022/buweb/bweb_1t_${uf}_051020221321.zip -O buzips/${uf}.zip
}

get_buzip AC
get_buzip AL
get_buzip AP
get_buzip AM
get_buzip BA
get_buzip CE
get_buzip ES
get_buzip GO
get_buzip MA
get_buzip MT
get_buzip MS
get_buzip MG
get_buzip PA
get_buzip PB
get_buzip PR
get_buzip PE
get_buzip PI
get_buzip RJ
get_buzip RN
get_buzip RS
get_buzip RO
get_buzip RR
get_buzip SC
get_buzip SP
get_buzip SE
get_buzip TO
get_buzip DF
get_buzip ZZ

# descompactad tudo
cd buzips
yes | unzip AC.zip
yes | unzip AL.zip
yes | unzip AP.zip
yes | unzip AM.zip
yes | unzip BA.zip
yes | unzip CE.zip
yes | unzip ES.zip
yes | unzip GO.zip
yes | unzip MA.zip
yes | unzip MT.zip
yes | unzip MS.zip
yes | unzip MG.zip
yes | unzip PA.zip
yes | unzip PB.zip
yes | unzip PR.zip
yes | unzip PE.zip
yes | unzip PI.zip
yes | unzip RJ.zip
yes | unzip RN.zip
yes | unzip RS.zip
yes | unzip RO.zip
yes | unzip RR.zip
yes | unzip SC.zip
yes | unzip SP.zip
yes | unzip SE.zip
yes | unzip TO.zip
yes | unzip DF.zip
yes | unzip ZZ.zip
