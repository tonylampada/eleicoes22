# eleicoes 2022

### constrindo um banco pra fazer analise com SQL nos dados do TSE

TL;DR - se vc quiser baixar só o banco que eu construí, [toma aí (são quase 10Gb :P)](https://1drv.ms/u/s!Anp5dQ7ntRq8hAdzMazYWbbtDi-F?e=W4xatB). Se quiser reproduzir os passos pra construir o banco a partir dos ddos do TSE, continua lendo :-)

Normalmente eu gosto de brincar com os dados abertos disponibilizados pelo TSE sobre as eleicoes.
Esse ano eu decidi que iria tentar construir um banquinho relacional em sqlite com os dados da eleicao.
O primeiro passo é conseguir baixar tudo.

Num primeiro momento, o [portal da transparencia](https://dadosabertos.tse.jus.br/organization/tse-agel) nao tinha os arquivos consolidados pra baixar.
Por outro lado, este ano, o TSE fez um app bem bacana (https://resultados.tse.jus.br), que dá pra baixar até os arquivos "crus" da urna (.bu e .rdv)

Futucando na api do app, eu descobri como automatizar o download desses arquivos. O script `baixa_appresultados.sh` baixa isso nas pastas `municipios`, `secoes`, `hashes` e `result`

A pasta `tse/` tem uns scripts python criados pelo TSE ([disponibilizados aqui](https://www.tse.jus.br/eleicoes/eleicoes-2022/documentacao-tecnica-do-software-da-urna-eletronica)) pra poder lidar com os arquivos binários `.bu` e `.rdv`

Mas, enquanto eu tava fazendo isso, o TSE disponibilizou os dados consolidados no portal da transparencia, que simplifica demais a vida.

O script `baixa_transparencia.sh` faz esse download consolidado na pasta `buzips` (pra construir o banco só precisa desse)

O script `constroi_banco.py` constroi o arquivo bu.db que é o banco sqlite relacional que eu queria

Exemplos de queries: (tem mais exemplos no aruivo `consultas.sql`)

#### Exemplo: Votos de uma secao. 

A mesma informação que tem aqui: https://resultados.tse.jus.br/oficial/app/index.html#/eleicao;e=e544;uf=al;ufbu=al;mubu=27049;zn=0046;se=0108/dados-de-urna/boletim-de-urna
```sql
select 
	SG_UF UF,
	CD_MUNICIPIO,
	NM_MUNICIPIO,
	NR_ZONA ZONA,
	NR_SECAO SECAO,
	DS_CARGO_PERGUNTA CARGO,
	DS_TIPO_VOTAVEL TIPO_VOTO,
	NR_VOTAVEL NR_VOTO,
	NM_VOTAVEL NM_VOTO,
	QT_VOTOS,
	QT_APTOS,
	QT_COMPARECIMENTO 
from bu 
where SG_UF = 'AL'
  and NM_MUNICIPIO = 'ESTRELA DE ALAGOAS' -- ou pode filtrar por CD_MUNICIPIO = 27049
  and NR_ZONA = 46
  and NR_SECAO = 108
order by cargo, QT_VOTOS desc
```
![image](https://user-images.githubusercontent.com/218821/194704061-464b7489-f115-4d90-aa3c-7821842f7ad8.png)


#### Exemplo: Total geral de Presidente na Bahia

A mesma informação que tem aqui https://resultados.tse.jus.br/oficial/app/index.html#/eleicao;e=e544;uf=ba;ufbu=ba/resultados

```sql
select 
	NR_VOTAVEL NR_VOTO,
	NM_VOTAVEL NM_VOTO,
	sum(QT_VOTOS)
from bu 
where DS_CARGO_PERGUNTA = 'Presidente' and SG_UF = 'BA'
group by 1, 2
order by 3 desc
```
![image](https://user-images.githubusercontent.com/218821/194703966-efd06091-2648-4631-8e94-637c2bac536e.png)


#### Exemplo: municipios de sp em ordem de "bolsonarismo"

```sql
select 
	CD_MUNICIPIO,
	NM_MUNICIPIO,
	sum(QT_VOTOS),
	round(100.0 * sum(QT_VOTOS) filter (where NM_VOTAVEL = 'LULA') / sum(QT_VOTOS), 2) as porcento_lula,
	round(100.0 * sum(QT_VOTOS) filter (where NM_VOTAVEL = 'JAIR BOLSONARO') / sum(QT_VOTOS), 2) as porcento_bolsonaro
from bu 
where DS_CARGO_PERGUNTA = 'Presidente' 
  and SG_UF = 'SP'
group by 1, 2
order by porcento_bolsonaro desc
```
![image](https://user-images.githubusercontent.com/218821/194705549-febdf1a7-83bc-453e-844f-16200dcecb39.png)
