-- Votos de uma secao. 
-- A mesma informação que tem aqui: https://resultados.tse.jus.br/oficial/app/index.html#/eleicao;e=e544;uf=al;ufbu=al;mubu=27049;zn=0046;se=0108/dados-de-urna/boletim-de-urna
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



-- Total geral de Presidente na Bahia
-- A mesma informação que tem aqui https://resultados.tse.jus.br/oficial/app/index.html#/eleicao;e=e544;uf=ba;ufbu=ba/resultados
select 
	NR_VOTAVEL NR_VOTO,
	NM_VOTAVEL NM_VOTO,
	sum(QT_VOTOS)
from bu 
where DS_CARGO_PERGUNTA = 'Presidente' and SG_UF = 'BA'
group by 1, 2
order by 3 desc


-- municipios de sp em ordem de "bolsonarismo"
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


-- Tem inconsistencia nas colunas redundantes QT_APTOS, QT_COMPARECIMENTO?
with t as (
	select 
		DISTINCT 
		CD_MUNICIPIO,
		NM_MUNICIPIO,
		NR_ZONA,
		NR_SECAO,
		QT_APTOS,
		QT_COMPARECIMENTO 
	from bu 
)
select 
	CD_MUNICIPIO,
	NM_MUNICIPIO,
	NR_ZONA ZONA,
	NR_SECAO SECAO,
	QT_APTOS,
	QT_COMPARECIMENTO,
	count(*)
from t
group by 1,2,3,4,5,6
having count(*) > 1
