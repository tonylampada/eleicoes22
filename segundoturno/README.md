# Analise 2o turno 2022

Em 04/nov/2022 o site argentino [la derecha diario](https://derechadiario.com.ar/) publicou uma live expondo um padrão que sugere ter havido fraude nas urnas. Achei [o link da live aqui](https://www.youtube.com/watch?v=DMOWFnRAask). Eles tb publicaram 5 arquivos para download no site [brazilwasstolen.com](https://brazilwasstolen.com/)

Os downloads estão [disponíveis aqui no repo tb](./brazilwasstolen_files) (o [PDF em inglês](https://github.com/tonylampada/eleicoes22/blob/main/segundoturno/brazilwasstolen_files/Ballot-box-elections-2022-It-is-very-difficult-to-justify%20(2).pdf) é a explicação mais completa)

Resumindo, a alegação desse relatório é que tinham urnas honestas (modelo UE2020) e desonestas (outros modelos) sendo usadas na votação.
E o comportamento desses dois tipos de urna geram padrões diferentes, verificáveis e não explicáveis nos dados de totalização disponibilizados pelo TSE.

Vou tentar ver se consigo reproduzir as conclusões da turma do la derecha diario a partir dos dados brutos do TSE

A primeira coisa é construir um banquinho com os dados.

Se vc quiser só baixar o banco que eu já construí
 * [Banco completo (sqlite)](https://1drv.ms/u/s!Anp5dQ7ntRq8hgYcotWgF2xcAShI?e=VpjfCL)
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

dados na [planilha](https://docs.google.com/spreadsheets/d/1YOYrAfUAJRc8i9ACpOLFf10lvBfZpE_HPXc_xoG6M00/edit#gid=1887669207)


### 2. Lula perde a eleição na urna nova. Eita

![image](https://user-images.githubusercontent.com/218821/200133385-7b4c0d3c-a233-4be7-9f26-ed98a29dc1d7.png)
![image](https://user-images.githubusercontent.com/218821/200133415-22f5f2fc-a82c-411f-a212-dbf278ab09a0.png)

dados na [planilha](https://docs.google.com/spreadsheets/d/1YOYrAfUAJRc8i9ACpOLFf10lvBfZpE_HPXc_xoG6M00/edit#gid=1887669207)


### 3. Lula tem uma grande vantagem absoluta nas urnas velhas em quase todos os estados (mais de 2.400.000 votos)

![image](https://user-images.githubusercontent.com/218821/200375231-9098024b-c04a-48e1-b4fe-1fd226012b81.png)
![image](https://user-images.githubusercontent.com/218821/200375455-5630f6eb-c0f3-4d8c-b130-e0da1bbec978.png)

dados na [planilha](https://docs.google.com/spreadsheets/d/1YOYrAfUAJRc8i9ACpOLFf10lvBfZpE_HPXc_xoG6M00/edit#gid=1887669207)

#### 3.1 Mas isso não aparece nas capitais. A maior parte das capitais só tem urna nova.

![image](https://user-images.githubusercontent.com/218821/200375695-1500cd84-ec3c-4805-b843-3078ec8607a3.png)
![image](https://user-images.githubusercontent.com/218821/200375887-132dc9b6-6094-4e34-9fa9-d2859126f9ff.png)

Diferencinha mínima. 40mil votos em SP. Pega nada.

dados na [planilha](https://docs.google.com/spreadsheets/d/1YOYrAfUAJRc8i9ACpOLFf10lvBfZpE_HPXc_xoG6M00/edit#gid=1887669207)

#### 3.2 No interior a diferença aparece

![image](https://user-images.githubusercontent.com/218821/200375979-dcd857d4-736c-4a91-8498-ce9bd5ae32be.png)
![image](https://user-images.githubusercontent.com/218821/200376047-8b271f7f-e129-4e1c-b4c9-ea616eed34c1.png)

dados na [planilha](https://docs.google.com/spreadsheets/d/1YOYrAfUAJRc8i9ACpOLFf10lvBfZpE_HPXc_xoG6M00/edit#gid=1887669207)

Mas as urnas velhas e novas poderiam estar distribuídas de um jeito que as urnas novas vão pra muicípios mais ricos e as velhas pros mais pobres, e talvez isso explique essa correlação.

Existem municípios mistos? Ou seja, municípios com urnas velhas e novas no mesmo município?
Sim, tem alguns.

### 4. Vantagem pro Lula nos municípios com urnas mistas

Query: municípios do interior com urnas mistas (são 303 municípios)
![image](https://user-images.githubusercontent.com/218821/200376233-b649a2b3-426d-4433-963c-7bcbbf49015e.png)

dados:
![image](https://user-images.githubusercontent.com/218821/200376297-edf13128-8540-44be-8288-bc1beefef0bf.png)

Colocando a vantagem_percentual_lula num grafico:
![image](https://user-images.githubusercontent.com/218821/200376354-6bdcd57d-84fb-41f0-a5d7-e33c4b2fc129.png)

Viés claro pra cima (vantagem lula > 0)

dados na [planilha](https://docs.google.com/spreadsheets/d/1YOYrAfUAJRc8i9ACpOLFf10lvBfZpE_HPXc_xoG6M00/edit#gid=1887669207)

Mas, ainda assim, as urnas velhas e novas poderiam estar distribuídas de um jeito que as urnas novas vão pros bairros mais ricos e as velhas pros mais pobres, e talvez isso explique essa correlação.

Existem zonas eleitorais mistas? Ou seja, zonas com urnas velhas e novas no mesmo município?
Sim, tem algumas.

### 5. Vantagem pro Lula nas zonas eleitorais com urnas mistas

Query: zonas eleitorais (interior e capital) com urnas mistas (são 461 zonas)
![image](https://user-images.githubusercontent.com/218821/200376641-ec62b4c4-2091-464a-a0c3-7a3659cd5470.png)

dados:
![image](https://user-images.githubusercontent.com/218821/200376704-0fe4ec04-1120-40fe-9338-558bbbb1bb57.png)

Colocando a vantagem_percentual_lula num grafico:
![image](https://user-images.githubusercontent.com/218821/200170923-dd67cd88-1b27-4d0a-9bc2-da0d0f30a8bd.png)

Viés claro pra cima de novo (vantagem lula > 0)

dados na [planilha](https://docs.google.com/spreadsheets/d/1YOYrAfUAJRc8i9ACpOLFf10lvBfZpE_HPXc_xoG6M00/edit#gid=1887669207)

Bom aí fica difícil explicar isso aí. Como que o comportamento do eleitor muda dependendo da urna dentro da mesma zona?

#### 5.1 Outra variavel só pra comparar: urnas ímpares dão vantagem pro lula?

O modelo da urna não deveria influenciar no comportamento do eleitor. Não deveria existir uma correlação entre os fatos "urna velha" e "vantagem pro lula", do mesmo jeito que não deveria existir uma correlação entre "o número da seção eleitoral é ímpar" e "vantagem pro lula". Vamos testar essa hipótese nas mesmas 461 urnas.

Query: zonas eleitorais (interior e capital) com urnas mistas (são 461 zonas) e votos divididos em urnas pares vs ímpares
![image](https://user-images.githubusercontent.com/218821/200203613-a4e2b062-6d2d-4771-acad-8f030ea73ab3.png)

dados:
![image](https://user-images.githubusercontent.com/218821/200203635-96bbe66c-36e8-43a0-aa2f-93b4ec932ff2.png)

Colocando a vantagem_percentual_lula num grafico:
![image](https://user-images.githubusercontent.com/218821/200203657-c6f8dcfd-467f-4bf0-9a5a-dc7adb011a80.png)

dados na [planilha](https://docs.google.com/spreadsheets/d/1YOYrAfUAJRc8i9ACpOLFf10lvBfZpE_HPXc_xoG6M00/edit#gid=1887669207)

Veja que não tem viés claro nem pra cima nem pra baixo (**esse é o comportamento esperado quando não uma coisa não tem a ver com a outra!**)

Compare isso com o gráfico anterior. Se a urna velha não tivesse correlação com vantagem pro lula, a chance de ter uma maioria positiva como aquela seria menor que 0.01%. A correlação entre urna velha e vantagem pro lula é incontestável. Tudo bem que correlação não é causa. Mas a próxima pergunta legítima pro TSE seria: como vc distribuiu essas urnas? A gente tá vendo que a distribuição **não foi aleatórea**. Se fosse aleatórea, essa correlação não existiria. Então, como essa distribuição foi feita?

### Conclusão

Batom na cueca do TSE? Parece.

Existe uma **correlação** (que *não necessariamente é causalidade*) incontestável entre urna velha e vantagem pro lula. Isso é fato, não opinião.

Mas dado que é fato, tem uma explicação. A gente não sabe qual é, mas tem.
Eu não consigo explicar por quê o comportamento do eleitor mudaria dependendo do modelo da urna que ele vota.

Então, existem algumas hipóteses que explicariam esse fato.

* a) A urna velha rouba pro lula (e nesse caso, se os votos do modelo UE2020 servem como "pesquisa eleitoral" isso teria trocado ~2400000 a favor do lula - mais do que suficiente pra mudar o resultado da eleição)
* b) A urna **nova** rouba pro bozo
* c) A distribuição de urnas velhas e novas (mesmo dentro de uma mesma zona) obedece um critério social tal que as populações que votam nessas urnas realmente se comportam diferente.

O que fazer com isso?

* Quem confia mais no TSE, acredita em c)
* Quem desconfia, provavelmente acredita em a)
* E acho q ninguem realmente acredita em b), mas é uma possibilidade (menor pq teve muito mais urnas zeradas pro bozo), mas pra ser justo, vale listar aqui.

De todo jeito o TSE (que estaria na posição de defender c) precisaria **explicar qual foi o criterio de distribuição** de modelos de urnas pelo Brasil.

Se alguém puder investigar mais e puder jogar mais insight em cima, ótimo. 
Espero que o [banco consolidado](https://1drv.ms/u/s!Anp5dQ7ntRq8hSo2PxDJN1Wwr0D4?e=KRx07X) ou o [csv resumido](https://github.com/tonylampada/eleicoes22/blob/main/segundoturno/urnas.csv.zip) disponivel aqui seja util pra que mais gente faça analises que completem a minha.

### ATENÇÃO! UPDATE IMPORTANTE!

Ontem de noite (8/11) eu tava cavucando um pouco mais nos dados e percebi que tem mais dados interessantes pra dar um "duplo clique" e enxergar melhor.
A tabela `bu` do meu banco tem a coluna NR_LOCAL_VOTACAO que representa um id da escola de votação.
Com isso é possível "descer mais um nível de zoom" e agrupar as urnas de uma zona **por local de votação**.
Usando isso, a gente em tese remove qualquer variação de comportamento do eleitor devido a diferença do local de votação.
A premissa que eleitores que votam no mesmo lugar são mais homogêneos faz bastante sentido.

Como não tinha essa coluna na minha tabela `urna`, eu tive que atualizar meu banco. Adicionei essa coluna e fiz mais alguns "upgrades" no banco:

* Adicionei o dataset dos [locais de votação](https://dadosabertos.tse.jus.br/dataset/eleitorado-2022/resource/3b003555-c69f-49cb-9c15-2700279520c7) que tem inclusive o lat-long da urna!. Isso entrou na tabela `urna`.
* Adicionei o dataset do [perfil dos eleitores](https://dadosabertos.tse.jus.br/dataset/eleitorado-2022) em cada zona/urna (escolaridade, faixa etaria e tal). Isso entrou nas tabelas `perfil_eleitorado_zona` e `perfil_eleitorado_secao`

Com isso dá pra fazer análises mais bacanas. Se vc já tinha baixado meus dados antes (banco e planilha), recomendo baixar de novo pq tem mais informação lá. Os links estão ali no topo.

Então vamo pra NOVAS ANÁLISES.

### 6. Lula tem vantagem nas ESCOLAS (locais de votação) mistas?

Spoiler: SIM, um pouco, mas é uma vantagem super dentro do que é possível estatisticamente.

Query: locais de votação com urnas mistas (são 163 escolas)
![image](https://user-images.githubusercontent.com/218821/200926105-eeb1a6d8-25e2-43cd-9ffd-6cdbaa0be2c9.png)

dados:
![image](https://user-images.githubusercontent.com/218821/200926157-4a06429f-dd85-465d-af04-aa42af2cb6bb.png)

Colocando a vantagem_percentual_lula num grafico:
![image](https://user-images.githubusercontent.com/218821/200926259-fca5d87c-7a26-4d00-be5e-5e8d7e342fce.png)

Veja que **não tem** viés claro nem pra cima nem pra baixo (**esse é o comportamento esperado quando não uma coisa não tem a ver com a outra!**)

Lula **ainda ganhou** na urna velha, mas foi de 84 a 79. A chance de isso acontecer (vc ganhar pelo menos 84 lançamentos de cara ou coroa numa partida de 163 rodadas) é de uns 37%, que não é nada absurdamente improvável como os resultados 4 e 5 acima. Pelo contrário, é bem normal.

Isso diminui drasticamente a confiança nas hipóteses a e b da conclusão anterior, e aumenta bastante a confiança na hipótese c!

E agora com o banco novo a gente tem MAIS DADOS sócio-demográficos pra testar a hipótese c!

### 7. O TSE distribuiu as urnas de maneira "discriminatória"?

Spoiler: Sim, um pouquinho.

A (nova) tabela do perfil do eleitorado tem dados de escolaridade, faixa etária, sexo e estado civil. Com isso dá pra ver se as populações que votaram na urna velha e na urna nova são realmente diferentes.

![escolaridade_brasil](https://user-images.githubusercontent.com/218821/200926905-71f0d112-e545-468c-9a3c-539c4441e3a9.png)

Acima: BRASIL - A urna nova tem uma galera mais escolarizada que a urna velha

![faixaetaria_brasil](https://user-images.githubusercontent.com/218821/200927084-c5e7303b-c76d-4349-a5ec-f87ab6c1f1f8.png)

Acima: BRASIL - Mesma distribuição de faixa etária

![escolaridade_zona](https://user-images.githubusercontent.com/218821/200927199-3eb9518f-c6c0-456d-82d1-33627d1d55dc.png)

Acima: 461 ZONAS mistas do item 5 - A urna nova tem um pouco mais de pessoas mais escolarizadas que a urna velha

![faixaetaria_zona](https://user-images.githubusercontent.com/218821/200927426-e0350e5a-1c31-435a-bf71-f18e6a321358.png)

Acima: 461 ZONAS mistas do item 5 - A urna nova tem um tiquinho de pessoas mais velhas que a urna velha

E isso novamente fortalece um pouco mais a hipótese c.

### Conclusão (de novo!)

Batom na cueca do TSE? AGORA não mais! Xandão escapou fedendo!

* Os novos dados de fato enfraquecem muito as hipóteses a) e b), e demostram que **c) é correto**: O TSE realmente conseguiu mandar mais urna nova pra coxinhas e mais urna velha pra mortadelas!
* Os argentinos do brazilwasstolen erraram! Realmente os dados que eles mostraram deixam claro que tem algo estranho, mas depois de cavar BASTANTE a gente encontra uma explicação legítima pra isso.
* Importante: ausência de evidência não é evidência de ausência. Este resultado **não prova que não houve fraude**, nem muito menos que as urnas eletrônicas são seguras!
* Sem um processo eleitoral auditável de verdade, o "crime perfeito" (que não deixa rastro) é sim, possível, e não tem como afirmar que nunca houve fraude em larga escala nem nesta eleição nem noutra anterior!

O que fazer com isso?

* Quem confia mais no TSE, fique tranquilo, tá tudo bem!
* Quem já desconfiava do TSE, pode voltar ao mesmo nível de desconfiança que você tinha antes de ler este relatório. Não há motivo pra desconfiar nem mais nem menos do que o que vc já desconfiava!
* Os mais conspiracionistas podem dizer que: "na verdade todas as urnas estão roubando igualmente, por isso não é possível descobrir na base da estatística
* Os ultra conspiracionistas (com kit completo, chapéu de alumínio e tudo mais) podem dizer que o TSE distribuiu as urnas assim só de sacanagem pra confundir os milicos que tão tentando achar algum furo! :-)

### Algumas opiniões sobre isso tudo!

Disclaimer: ficando um pouquinho político aqui.

* Fazer análise de dados é muito divertido!
* Amantes da treta, fiquem tranquilos. Enquanto não houver voto impresso no Brasil, a treta em volta das eleições estará garantida por gerações!
* Esse tipo de investigação não deveria ser necessária! O sistema eleitoral deveria ser facilmente auditável pelo cidadão médio (sem precisar de conhecimento de informática, matemática, ou estatística)
* A proposta do voto impresso resolveria o problema da auditabilidade e transparência do nosso processo eleitoral.
* Desde ~2013 que eu costumo refletir sobre esse nosso sistema eleitoral e sempre achei que o voto puramente eletrônico é um absurdo numa democracia.  Penso isso basicamente pelo mesmo motivo que [a suprema corte alemâ rejeitou esse sistema em 2005](https://www.dw.com/pt-br/tribunal-alem%C3%A3o-considera-urnas-eletr%C3%B4nicas-inconstitucionais/a-4070568): o eleitor volta pra casa sem saber se a máquina registrou o voto corretamente. O brasileiro "se acostumou" com isso, mas eu nunca :-).
* Fico feliz de não ter encontrado nenhuma evidência de uma mega fraude escrota. Seria triste demais achar uma evidência dessa e ver a história de impunidade no país se repetir (e acho que provavelmente seria o caso)

## Análises feitas por outras pessoas:

* [Fábio Emanuel](https://github.com/fabio-emanuel/Segundo_Turno_2022/blob/main/Golpista.ipynb)
* [Pedro Nauck](https://github.com/pedronauck/eleicoes2022/blob/main/README.md)
* [Cristiano Herbert](https://github.com/tonylampada/eleicoes22/issues/3)
* [André Ferreira](https://gitlab.com/sandbox279/tse_hell/-/blob/main/tse.ipynb)
* [jemferraz](https://github.com/jemferraz/Brazilwasstolen_analysis)
* [ProsperWare](https://github.com/ProsperWare/eleicoes22/tree/falha_par_impar/segundoturno/par_impar_falha) - falha par/ímpar

(se vc fez alguma análise, por gentileza abre uma issue e manda o link pra eu botar aqui)
