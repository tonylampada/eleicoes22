uf=$1
yes | unzip data/a18/2t_bucsv/$uf.zip -d data/a18/2t_bucsv/
mv data/a18/2t_bucsv/bweb_2t_${uf}_*.csv data/a18/2t_bucsv/${uf}.csv
python load_bus_a18.py $uf
rm data/a18/2t_bucsv/$uf.csv
rm data/a18/2t_bucsv/*.pdf
