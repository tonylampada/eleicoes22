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


#python load_logs.py AC
#python load_logs.py AL
#python load_logs.py AP

python load_logs.py AM
python load_logs.py BA
python load_logs.py CE

python load_logs.py ES
python load_logs.py GO
python load_logs.py MA

python load_logs.py MT
python load_logs.py MS

# python load_logs.py MG deu pau

python load_logs.py PA
python load_logs.py PB
python load_logs.py PR

python load_logs.py PE
python load_logs.py PI

python load_logs.py RJ

python load_logs.py RN
python load_logs.py RS
python load_logs.py RO

python load_logs.py RR
python load_logs.py SC

# python load_logs.py SP deu pau

python load_logs.py SE
python load_logs.py TO
python load_logs.py DF
python load_logs.py ZZ
