function vaibu {
    echo vai $uf ...
	uf=$1
    cd 2t_bucsv
    unzip $uf.zip
    cd ..
    python load_bus.py $uf
    rm 2t_bucsv/bweb*
    rm 2t_bucsv/*.pdf
}

function vaieleitorado {
	uf=$1
    echo vai eleitorado $uf ...
    cd 2t_eleitorado
    unzip perfil_${uf}.zip
    cd ..
    python load_eleitorado_secao.py $uf
    rm 2t_eleitorado/*.csv
    rm 2t_eleitorado/*.pdf
}

rm 2t_bucsv/bweb*
rm 2t_bucsv/*.pdf
rm eleicao22_2t.db*

vaibu AC
vaibu AL
vaibu AP
vaibu AM
vaibu BA
vaibu CE
vaibu ES
vaibu GO
vaibu MA
vaibu MT
vaibu MS
vaibu MG
vaibu PA
vaibu PB
vaibu PR
vaibu PE
vaibu PI
vaibu RJ
vaibu RN
vaibu RS
vaibu RO
vaibu RR
vaibu SC
vaibu SP
vaibu SE
vaibu TO
vaibu DF
vaibu ZZ

python load_logs_modelos.py

yes | unzip 2t_eleitorado/local_votacao.zip -d 2t_eleitorado
yes | unzip 2t_eleitorado/perfil.zip -d 2t_eleitorado
python load_locais.py
python load_eleitorado_zona.py

rm 2t_eleitorado/*.csv
rm 2t_eleitorado/*.pdf

vaieleitorado AC
vaieleitorado AL
vaieleitorado AP
vaieleitorado AM
vaieleitorado BA
vaieleitorado CE
vaieleitorado ES
vaieleitorado GO
vaieleitorado MA
vaieleitorado MT
vaieleitorado MS
vaieleitorado MG
vaieleitorado PA
vaieleitorado PB
vaieleitorado PR
vaieleitorado PE
vaieleitorado PI
vaieleitorado RJ
vaieleitorado RN
vaieleitorado RS
vaieleitorado RO
vaieleitorado RR
vaieleitorado SC
vaieleitorado SP
vaieleitorado SE
vaieleitorado TO
vaieleitorado DF
vaieleitorado ZZ

python load_logs_votos.py
echo AC AL AP AM BA CE ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO DF ZZ | xargs -n 1 -P 12 python load_logs_votos.py
