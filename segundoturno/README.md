# Analise 2o turno 2022

Em 04/nov/2022 o site argentino [la derecha diario](https://derechadiario.com.ar/) publicou uma live expondo um padrão que sugere ter havido fraude nas urnas. Achei [o link da live aqui](https://www.youtube.com/watch?v=DMOWFnRAask). Eles tb publicaram 5 arquivos para download no site [brazilwasstolen.com](https://brazilwasstolen.com/)

Os downloads estão [disponíveis aqui no repo tb](./brazilwasstolen_files) (o PDF em inglês é a explicação mais completa)

Vou tentar ver se consigo reproduzir as conclusões da turma do la derecha diario a partir dos dados brutos do TSE

A primeira coisa é construir um banquinho com os dados
(se vc quiser só baixar o banco que eu já construí, [tá aqui](https://1drv.ms/u/s!Anp5dQ7ntRq8hSo2PxDJN1Wwr0D4?e=KRx07X))

Pra construir o banco:

* `baixaportaltransparencia.sh` - baixa os dados de bu e logs do portal da transparencia
* `load_db.sh` - constroi o um banco de dados sqlite `eleicao22_2t` com as tabelas `bu` e `modelo_urna` (modelo_urna deve demorar bastante)
* `extend_db.sql` - cria a tabela unificada "urna" pra facilitar analises
