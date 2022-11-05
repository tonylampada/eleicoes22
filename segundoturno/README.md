# Analise 2o turno 2022

Em 04/nov/2022 o site argentino [la derecha diario](https://derechadiario.com.ar/) publicou uma live expondo um padrão que sugere ter havido fraude nas urnas. Achei [o link da live aqui](https://www.youtube.com/watch?v=DMOWFnRAask). Eles tb publicaram 5 arquivos para download no site [brazilwasstolen.com](https://brazilwasstolen.com/)

Os downloads estão [disponíveis aqui no repo tb](./brazilwasstolen_files) (o [PDF em inglês](https://github.com/tonylampada/eleicoes22/blob/main/segundoturno/brazilwasstolen_files/Ballot-box-elections-2022-It-is-very-difficult-to-justify%20(2).pdf) é a explicação mais completa)

Resumindo, a alegação desse relatório é que tinham urnas honestas (modelo UE2020) e desonestas (outros modelos) sendo usadas na votação.
E o comportamento desses dois tipos de urna geram padrões diferentes, verificáveis e não explicáveis nos dados de totalização disponibilizados pelo TSE.

Vou tentar ver se consigo reproduzir as conclusões da turma do la derecha diario a partir dos dados brutos do TSE

A primeira coisa é construir um banquinho com os dados.

Se vc quiser só baixar o banco que eu já construí
 * [Banco completo (sqlite)](https://1drv.ms/u/s!Anp5dQ7ntRq8hSo2PxDJN1Wwr0D4?e=KRx07X))
 * [Resumo da tabela urna em csv](https://github.com/tonylampada/eleicoes22/blob/main/segundoturno/urnas.csv.zip) - (pequenininho. cabe na memória de um panda fácil! ;-))

Pra construir o banco:

* `baixaportaltransparencia.sh` - baixa os dados de bu e logs do portal da transparencia
* `load_db.sh` - constroi o um banco de dados sqlite `eleicao22_2t` com as tabelas `bu` e `modelo_urna` (modelo_urna deve demorar bastante)
* `extend_db.sql` - cria a tabela unificada "urna" pra facilitar analises

Fazendo umas analises preliminares, tem umas coisas estranhas mesmo. Alguns exemplos abaixo.
([resultados das queries disponiveis nesse google sheets](https://docs.google.com/spreadsheets/d/1YOYrAfUAJRc8i9ACpOLFf10lvBfZpE_HPXc_xoG6M00/edit#gid=1887669207))

### 1. Por quê é muito mais provável ter unas velhas do que novas com zero votos no bozo?
![image](https://user-images.githubusercontent.com/218821/200133308-7c0f11d2-d1d3-4419-ab53-a2b3cda1ce8f.png)
![image](https://user-images.githubusercontent.com/218821/200133344-55b2f9fa-c268-4f0c-9525-193daa0efba4.png)

### 2. Lula perde a eleição na urna nova. Eita

![image](https://user-images.githubusercontent.com/218821/200133385-7b4c0d3c-a233-4be7-9f26-ed98a29dc1d7.png)
![image](https://user-images.githubusercontent.com/218821/200133415-22f5f2fc-a82c-411f-a212-dbf278ab09a0.png)

### 3. Lula tem uma grande vantagem absoluta nas urnas velhas em quase todos os estados (~1.700.000)

![image](https://user-images.githubusercontent.com/218821/200133484-19d9fe17-8f45-4e81-8124-d8b6862b5b7f.png)
![image](https://user-images.githubusercontent.com/218821/200133513-4ac53439-4048-4cfd-a197-6cfa2ae34043.png)

#### 3.1 Mas isso não aparece nas capitais. A maior parte das capitais só tem urna nova.

![image](https://user-images.githubusercontent.com/218821/200133540-b7a28edd-b715-4b49-be56-82468be5f365.png)
![image](https://user-images.githubusercontent.com/218821/200133560-84df791e-7bd3-4f77-a195-7707dd1396d3.png)

Diferencinha mínima. Nada pra ver aqui

#### 3.2 No interior a diferença aparece

![image](https://user-images.githubusercontent.com/218821/200133598-241e21b5-0e3c-4c47-9f8b-bb30d7be276e.png)
![image](https://user-images.githubusercontent.com/218821/200133615-ae9e7d53-c087-40d6-8b09-c52b94f1536c.png)

### Conclusão

Batom na cueca do TSE? Parece.
Eu não consigo explicar por quê o comportamento do eleitor mudaria dependendo do modelo da urna que ele vota.
Não sou cientista de dados, nem estatístico.
Se alguém puder investigar mais e puder jogar mais insight em cima, ótimo. 
Espero que o [banco consolidado](https://1drv.ms/u/s!Anp5dQ7ntRq8hSo2PxDJN1Wwr0D4?e=KRx07X) ou o [csv resumido](https://github.com/tonylampada/eleicoes22/blob/main/segundoturno/urnas.csv.zip) disponivel aqui seja util pra que mais gente faça analises que completem a minha.
