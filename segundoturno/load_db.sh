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

python load_logs.py

yes | unzip 2t_eleitorado/local_votacao.zip -d 2t_eleitorado
yes | unzip 2t_eleitorado/perfil.zip -d 2t_eleitorado
python load_eleitorado.py