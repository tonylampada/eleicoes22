CREATE TABLE capital (
	id INTEGER NOT NULL, 
    "SG_UF" TEXT, 
    "NM_MUNICIPIO" TEXT, 
	PRIMARY KEY (id)
);

insert into capital(NM_MUNICIPIO, SG_UF)
values
('RIO BRANCO', 'AC'),
('MACEIÓ', 'AL'),
('MACAPÁ', 'AP'),
('MANAUS', 'AM'),
('SALVADOR', 'BA'),
('FORTALEZA', 'CE'),
('BRASÍLIA', 'DF'),
('VITÓRIA', 'ES'),
('GOIÂNIA', 'GO'),
('SÃO LUÍS', 'MA'),
('CUIABÁ', 'MT'),
('CAMPO GRANDE', 'MS'),
('BELO HORIZONTE', 'MG'),
('BELÉM', 'PA'),
('JOÃO PESSOA', 'PB'),
('CURITIBA', 'PR'),
('RECIFE', 'PE'),
('TERESINA', 'PI'),
('RIO DE JANEIRO', 'RJ'),
('NATAL', 'RN'),
('PORTO ALEGRE', 'RS'),
('PORTO VELHO', 'RO'),
('BOA VISTA', 'RR'),
('FLORIANÓPOLIS', 'SC'),
('SÃO PAULO', 'SP'),
('ARACAJU', 'SE'),
('PALMAS', 'TO');

CREATE TABLE urna (
	id INTEGER NOT NULL, 
    "SG_UF" TEXT, 
    "CD_MUNICIPIO" BIGINT,
    "NM_MUNICIPIO" TEXT, 
    "MODELO" TEXT,
    "NR_ZONA" BIGINT,
    "NR_SECAO" BIGINT,
    "IS_CAPITAL" BOOLEAN,
    "DT_CARGA_URNA_EFETIVADA" DATETIME,
    "DT_ABERTURA" DATETIME,
    "DT_ENCERRAMENTO" DATETIME,
    "DT_EMISSAO_BU" DATETIME,
    "DT_BU_RECEBIDO" DATETIME,
    "QT_APTOS" BIGINT,
    "QT_COMPARECIMENTO" BIGINT,
    "QT_ABSTENCOES" BIGINT,
    "votos_lula" BIGINT,
    "votos_bozo" BIGINT,
    "votos_nulo" BIGINT,
    "votos_branco" BIGINT,
    "votos_totais" BIGINT,
	PRIMARY KEY (id)
);


with resumo as (
    select
        bu.SG_UF, 
        bu.CD_MUNICIPIO,
        bu.NM_MUNICIPIO, 
        mu.MODELO,
        bu.NR_ZONA,
        bu.NR_SECAO,
        bu.NM_MUNICIPIO = c.NM_MUNICIPIO as IS_CAPITAL,
        bu.DT_CARGA_URNA_EFETIVADA,
        bu.DT_ABERTURA,
        bu.DT_ENCERRAMENTO,
        bu.DT_EMISSAO_BU,
        bu.DT_BU_RECEBIDO,
        max(QT_APTOS) QT_APTOS,
        max(QT_COMPARECIMENTO) QT_COMPARECIMENTO,
        max(QT_ABSTENCOES) QT_ABSTENCOES,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'LULA'), 0) votos_lula,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'JAIR BOLSONARO'), 0) votos_bozo,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'Nulo'), 0) votos_nulo,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'Branco'), 0) votos_branco,
        coalesce(sum(QT_VOTOS), 0) votos_totais
    from bu
    join modelo_urna mu on mu.SG_UF = bu.SG_UF and mu.CD_MUNICIPIO = bu.CD_MUNICIPIO and mu.NR_ZONA = bu.NR_ZONA and mu.NR_SECAO = bu.NR_SECAO 
    left outer join capital c on bu.SG_UF = c.SG_UF
    where bu.DS_CARGO_PERGUNTA = 'Presidente'
    group by 1,2,3,4,5,6,7,8,9,10,11
) 
INSERT INTO urna (SG_UF,CD_MUNICIPIO,NM_MUNICIPIO,MODELO,NR_ZONA,NR_SECAO,IS_CAPITAL,DT_CARGA_URNA_EFETIVADA,DT_ABERTURA,DT_ENCERRAMENTO,DT_EMISSAO_BU,DT_BU_RECEBIDO,QT_APTOS,QT_COMPARECIMENTO,QT_ABSTENCOES,votos_lula,votos_bozo,votos_nulo,votos_branco,votos_totais)
SELECT SG_UF,CD_MUNICIPIO,NM_MUNICIPIO,MODELO,NR_ZONA,NR_SECAO,IS_CAPITAL,DT_CARGA_URNA_EFETIVADA,DT_ABERTURA,DT_ENCERRAMENTO,DT_EMISSAO_BU,DT_BU_RECEBIDO,QT_APTOS,QT_COMPARECIMENTO,QT_ABSTENCOES,votos_lula,votos_bozo,votos_nulo,votos_branco,votos_totais
FROM resumo;

