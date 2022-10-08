#eleicoes 2022

brincadeirinhas com os dados disponibilizados pelo TSE

Normalmente eu gosto de brincar com os dados abertos disponibilizados pelo TSE sobre as eleicoes.
Esse ano eu decidi que iria tentar construir um banquinho relacional em sqlite com os dados da eleicao.
O primeiro passo é conseguir baixar tudo.

Num primeiro momento, o [portal da transparencia](https://dadosabertos.tse.jus.br/organization/tse-agel) nao tinha os arquivos consolidados pra baixar.
Por outro lado, este ano, o TSE fez um app bem bacana (https://resultados.tse.jus.br), que dá pra baixar até os arquivos "crus" da urna (.bu e .rdv)

Futucando na api, eu descobri como automatizar o download desses arquivos. O script `baixa_appresultados.sh` baixa isso nas pastas `municipios`, `secoes`, `hashes` e `result`

A pasta `tse/` tem uns scripts python criados pelo TSE ([disponibilizados aqui](https://www.tse.jus.br/eleicoes/eleicoes-2022/documentacao-tecnica-do-software-da-urna-eletronica)) pra poder lidar com os arquivos binários `.bu` e `.rdv`

Mas, enquanto eu tava fazendo isso, o TSE disponibilizou os dados consolidados no portal da transparencia, que simplifica demais a vida.

O script `baixa_transparencia.sh` faz esse download consolidado na pasta `buzips`

O script `constroi_banco.py` constroi o arquivo bu.db que é o banco sqlite relacional