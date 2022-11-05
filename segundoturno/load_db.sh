function vai {
    echo vai $uf ...
	uf=$1
    cd 2t_bucsv
    unzip $uf.zip
    cd ..
    python load_bus.py $uf
    python load_logs.py $uf
    rm 2t_bucsv/bweb*
    rm 2t_bucsv/*.pdf
}

rm 2t_bucsv/bweb*
rm 2t_bucsv/*.pdf
rm eleicao22_2t.db*

vai AC
vai AL
vai AP
vai AM
vai BA
vai CE
vai ES
vai GO
vai MA
vai MT
vai MS
vai MG
vai PA
vai PB
vai PR
vai PE
vai PI
vai RJ
vai RN
vai RS
vai RO
vai RR
vai SC
vai SP
vai SE
vai TO
vai DF
vai ZZ

python load_logs.py
