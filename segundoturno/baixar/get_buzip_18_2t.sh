uf=$1
alias uwget='wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0"'
uwget https://cdn.tse.jus.br/estatistica/sead/eleicoes/eleicoes2018/buweb/BWEB_2t_${uf}_301020181744.zip -O data/a18/2t_bucsv/${uf}.zip
