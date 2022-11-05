# Analise 2o turno 2022

Em 04/nov/2022 o site argentino [la derecha diario](https://derechadiario.com.ar/) publicou uma live expondo um padrão que sugere ter havido fraude nas urnas. Achei [o link da live aqui](https://www.youtube.com/watch?v=DMOWFnRAask). Eles tb publicaram 5 arquivos para download no site [brazilwasstolen.com](https://brazilwasstolen.com/)

Os downloads estão [disponíveis aqui no repo tb](./brazilwasstolen_files) (o [PDF em inglês](https://github.com/tonylampada/eleicoes22/blob/main/segundoturno/brazilwasstolen_files/Ballot-box-elections-2022-It-is-very-difficult-to-justify%20(2).pdf) é a explicação mais completa)

Resumindo, a alegação desse relatório é que tinham urnas honestas (modelo UE2020) e desonestas (outros modelos) sendo usadas na votação.
E o comportamento desses dois tipos de urna geram padrões diferentes, verificáveis e não explicáveis nos dados de totalização disponibilizados pelo TSE.

Vou tentar ver se consigo reproduzir as conclusões da turma do la derecha diario a partir dos dados brutos do TSE

A primeira coisa é construir um banquinho com os dados
(se vc quiser só baixar o banco que eu já construí, [tá aqui](https://1drv.ms/u/s!Anp5dQ7ntRq8hSo2PxDJN1Wwr0D4?e=KRx07X))

Pra construir o banco:

* `baixaportaltransparencia.sh` - baixa os dados de bu e logs do portal da transparencia
* `load_db.sh` - constroi o um banco de dados sqlite `eleicao22_2t` com as tabelas `bu` e `modelo_urna` (modelo_urna deve demorar bastante)
* `extend_db.sql` - cria a tabela unificada "urna" pra facilitar analises

Fazendo umas analises preliminares, tem umas coisas estranhas mesmo, tipo isso aqui:

```sql
select 
  SG_UF,
  count(*) filter (where modelo = 'UE2020') urnas_boas,
  count(*) filter (where modelo != 'UE2020') urnas_mas,
  count(*) filter (where modelo = 'UE2020' and votos_bozo = 0) bozo0_bom,
  count(*) filter (where modelo != 'UE2020' and votos_bozo = 0) bozo0_mau
from urna 
group by 1 order by 1
```

![image](https://user-images.githubusercontent.com/218821/200117952-bc14d6e5-f1ac-42b6-9c7c-3cd00f175ccb.png)

Parece ser um batom na cueca do TSE. Carece de investigar mais. Espero que o banco consolidado disponivel aqui seja util pra que mais gente faça analises mais sofisticadas que a minha.
