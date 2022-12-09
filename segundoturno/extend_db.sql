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
    "NR_LOCAL_VOTACAO" BIGINT,
    "IS_CAPITAL" BOOLEAN,
    "DT_CARGA_URNA_EFETIVADA" DATETIME,
    "DT_ABERTURA" DATETIME,
    "DT_ENCERRAMENTO" DATETIME,
    "DT_EMISSAO_BU" DATETIME,
    "CD_TIPO_SECAO_AGREGADA" BIGINT,
    "DS_TIPO_SECAO_AGREGADA" TEXT,
    "NR_SECAO_PRINCIPAL" BIGINT,
    "NM_LOCAL_VOTACAO" TEXT,
    "CD_TIPO_LOCAL" BIGINT,
    "DS_TIPO_LOCAL" TEXT,
    "DS_ENDERECO" TEXT,
    "NM_BAIRRO" TEXT,
    "NR_CEP" TEXT,
    "NR_TELEFONE_LOCAL" TEXT,
    "NR_LATITUDE" FLOAT,
    "NR_LONGITUDE" FLOAT,
    "CD_SITU_LOCAL_VOTACAO" BIGINT,
    "DS_SITU_LOCAL_VOTACAO" TEXT,
    "CD_SITU_ZONA" BIGINT,
    "CD_SITU_SECAO" BIGINT,
    "DS_SITU_SECAO" TEXT,
    "CD_SITU_LOCALIDADE" BIGINT,
    "DS_SITU_LOCALIDADE" TEXT,
    "CD_SITU_SECAO_ACESSIBILIDADE" BIGINT,
    "DS_SITU_SECAO_ACESSIBILIDADE" TEXT,
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

with modelo_urna2 as (
    select SG_UF, CD_MUNICIPIO, NR_ZONA, NR_SECAO, GROUP_CONCAT(modelo,',') modelo
    from (select distinct SG_UF, CD_MUNICIPIO, NR_ZONA, NR_SECAO, modelo from modelo_urna)
    group by 1,2,3,4
),
resumo as (
    select
        bu.SG_UF, 
        bu.CD_MUNICIPIO,
        bu.NM_MUNICIPIO, 
        mu.MODELO,
        bu.NR_ZONA,
        bu.NR_SECAO,
        bu.NR_LOCAL_VOTACAO,
        bu.NM_MUNICIPIO = c.NM_MUNICIPIO as IS_CAPITAL,
        bu.DT_CARGA_URNA_EFETIVADA,
        bu.DT_ABERTURA,
        bu.DT_ENCERRAMENTO,
        bu.DT_EMISSAO_BU,
        bu.DT_BU_RECEBIDO,
        lv.CD_TIPO_SECAO_AGREGADA,
        lv.DS_TIPO_SECAO_AGREGADA,
        lv.NR_SECAO_PRINCIPAL,
        lv.NM_LOCAL_VOTACAO,
        lv.CD_TIPO_LOCAL,
        lv.DS_TIPO_LOCAL,
        lv.DS_ENDERECO,
        lv.NM_BAIRRO,
        lv.NR_CEP,
        lv.NR_TELEFONE_LOCAL,
        lv.NR_LATITUDE,
        lv.NR_LONGITUDE,
        lv.CD_SITU_LOCAL_VOTACAO,
        lv.DS_SITU_LOCAL_VOTACAO,
        lv.CD_SITU_ZONA,
        lv.CD_SITU_SECAO,
        lv.DS_SITU_SECAO,
        lv.CD_SITU_LOCALIDADE,
        lv.DS_SITU_LOCALIDADE,
        lv.CD_SITU_SECAO_ACESSIBILIDADE,
        lv.DS_SITU_SECAO_ACESSIBILIDADE,
        max(QT_APTOS) QT_APTOS,
        max(QT_COMPARECIMENTO) QT_COMPARECIMENTO,
        max(QT_ABSTENCOES) QT_ABSTENCOES,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'LULA'), 0) votos_lula,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'JAIR BOLSONARO'), 0) votos_bozo,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'Nulo'), 0) votos_nulo,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'Branco'), 0) votos_branco,
        coalesce(sum(QT_VOTOS), 0) votos_totais
    from bu
    left outer join modelo_urna2 mu on mu.SG_UF = bu.SG_UF and mu.CD_MUNICIPIO = bu.CD_MUNICIPIO and mu.NR_ZONA = bu.NR_ZONA and mu.NR_SECAO = bu.NR_SECAO 
    left outer join localvotacao lv on lv.NR_TURNO = 2 and lv.SG_UF = bu.SG_UF and lv.CD_MUNICIPIO = bu.CD_MUNICIPIO and lv.NR_ZONA = bu.NR_ZONA and lv.NR_SECAO = bu.NR_SECAO 
    left outer join capital c on bu.SG_UF = c.SG_UF
    where bu.DS_CARGO_PERGUNTA = 'Presidente'
    group by 1,2,3,4,5,6,7,8,9,10,11
) 
INSERT INTO urna (SG_UF,CD_MUNICIPIO,NM_MUNICIPIO,MODELO,NR_ZONA,NR_SECAO,NR_LOCAL_VOTACAO,IS_CAPITAL,DT_CARGA_URNA_EFETIVADA,DT_ABERTURA,DT_ENCERRAMENTO,DT_EMISSAO_BU,DT_BU_RECEBIDO,CD_TIPO_SECAO_AGREGADA,DS_TIPO_SECAO_AGREGADA,NR_SECAO_PRINCIPAL,NM_LOCAL_VOTACAO,CD_TIPO_LOCAL,DS_TIPO_LOCAL,DS_ENDERECO,NM_BAIRRO,NR_CEP,NR_TELEFONE_LOCAL,NR_LATITUDE,NR_LONGITUDE,CD_SITU_LOCAL_VOTACAO,DS_SITU_LOCAL_VOTACAO,CD_SITU_ZONA,CD_SITU_SECAO,DS_SITU_SECAO,CD_SITU_LOCALIDADE,DS_SITU_LOCALIDADE,CD_SITU_SECAO_ACESSIBILIDADE,DS_SITU_SECAO_ACESSIBILIDADE,QT_APTOS,QT_COMPARECIMENTO,QT_ABSTENCOES,votos_lula,votos_bozo,votos_nulo,votos_branco,votos_totais)
SELECT SG_UF,CD_MUNICIPIO,NM_MUNICIPIO,MODELO,NR_ZONA,NR_SECAO,NR_LOCAL_VOTACAO,IS_CAPITAL,DT_CARGA_URNA_EFETIVADA,DT_ABERTURA,DT_ENCERRAMENTO,DT_EMISSAO_BU,DT_BU_RECEBIDO,CD_TIPO_SECAO_AGREGADA,DS_TIPO_SECAO_AGREGADA,NR_SECAO_PRINCIPAL,NM_LOCAL_VOTACAO,CD_TIPO_LOCAL,DS_TIPO_LOCAL,DS_ENDERECO,NM_BAIRRO,NR_CEP,NR_TELEFONE_LOCAL,NR_LATITUDE,NR_LONGITUDE,CD_SITU_LOCAL_VOTACAO,DS_SITU_LOCAL_VOTACAO,CD_SITU_ZONA,CD_SITU_SECAO,DS_SITU_SECAO,CD_SITU_LOCALIDADE,DS_SITU_LOCALIDADE,CD_SITU_SECAO_ACESSIBILIDADE,DS_SITU_SECAO_ACESSIBILIDADE,QT_APTOS,QT_COMPARECIMENTO,QT_ABSTENCOES,votos_lula,votos_bozo,votos_nulo,votos_branco,votos_totais
FROM resumo;


alter table perfil_eleitorado_secao add column modelo text;
alter table perfil_eleitorado_secao add column idzona text;
alter table perfil_eleitorado_secao add column idsecao text;
alter table urna add column idzona text;
alter table urna add column idsecao text;

update urna set idzona = SG_UF || '_' || CD_MUNICIPIO || '_' || NR_ZONA, idsecao = SG_UF || '_' || CD_MUNICIPIO || '_' || NR_ZONA || '_' || NR_SECAO;
update perfil_eleitorado_secao set idzona = SG_UF || '_' || CD_MUNICIPIO || '_' || NR_ZONA, idsecao = SG_UF || '_' || CD_MUNICIPIO || '_' || NR_ZONA || '_' || NR_SECAO;

UPDATE perfil_eleitorado_secao as p SET modelo = u.modelo FROM urna u WHERE p.idsecao = u.idsecao;


-- 2018 T2
alter table localvotacao add column idlocal text;
alter table localvotacao_a18t2 add column idlocal text;
update localvotacao set idlocal = SG_UF || '_' || CD_MUNICIPIO || '_' || NR_ZONA || '_' || NR_LOCAL_VOTACAO;
update localvotacao_a18t2 set idlocal = SG_UF || '_' || CD_MUNICIPIO  || '_' || NR_ZONA  || '_' || NR_LOCAL_VOTACAO;

CREATE TABLE locais_1822 (
	id INTEGER NOT NULL, 
    "idlocal" TEXT, 
    "SG_UF" TEXT, 
    "CD_MUNICIPIO" BIGINT,
    "NR_ZONA" BIGINT,
    "NR_LOCAL_VOTACAO" BIGINT,
    "NM_LOCAL_VOTACAO_18" TEXT, 
    "NM_LOCAL_VOTACAO_22" TEXT, 
    "CD_TIPO_LOCAL_18" BIGINT, 
    "CD_TIPO_LOCAL_22" BIGINT, 
    "DS_TIPO_LOCAL_18" TEXT, 
    "DS_TIPO_LOCAL_22" TEXT, 
    "DS_ENDERECO_18" TEXT, 
    "DS_ENDERECO_22" TEXT, 
    "NM_BAIRRO_18" TEXT, 
    "NM_BAIRRO_22" TEXT, 
    "NR_CEP_18" TEXT, 
    "NR_CEP_22" TEXT, 
    "NR_LATITUDE_18" TEXT, 
    "NR_LATITUDE_22" TEXT, 
    "NR_LONGITUDE_18" FLOAT, 
    "NR_LONGITUDE_22" FLOAT,
    "tipomodelo" TEXT,
	PRIMARY KEY (id)
);

with l18 as (select distinct idlocal, SG_UF, CD_MUNICIPIO, NR_ZONA, NR_LOCAL_VOTACAO, NM_LOCAL_VOTACAO, CD_TIPO_LOCAL, DS_TIPO_LOCAL, DS_ENDERECO, NM_BAIRRO, NR_CEP, NR_LATITUDE, NR_LONGITUDE from localvotacao_a18t2 where nr_turno = 2),
l22 as (select distinct idlocal, NM_LOCAL_VOTACAO, CD_TIPO_LOCAL, DS_TIPO_LOCAL, DS_ENDERECO, NM_BAIRRO, NR_CEP, NR_LATITUDE, NR_LONGITUDE from localvotacao where nr_turno = 2),
c18 as (select idlocal, count(*) cnt from l18 group by 1 having cnt = 1),
c22 as (select idlocal, count(*) cnt from l22 group by 1 having cnt = 1),
locais_coincidentes as (
    select 
        l18.idlocal, l18.SG_UF, l18.CD_MUNICIPIO, l18.NR_ZONA, l18.NR_LOCAL_VOTACAO,
        l18.NM_LOCAL_VOTACAO NM_LOCAL_VOTACAO_18, l22.NM_LOCAL_VOTACAO NM_LOCAL_VOTACAO_22, 
        l18.CD_TIPO_LOCAL CD_TIPO_LOCAL_18, l22.CD_TIPO_LOCAL CD_TIPO_LOCAL_22, 
        l18.DS_TIPO_LOCAL DS_TIPO_LOCAL_18, l22.DS_TIPO_LOCAL DS_TIPO_LOCAL_22, 
        l18.DS_ENDERECO DS_ENDERECO_18, l22.DS_ENDERECO DS_ENDERECO_22, 
        l18.NM_BAIRRO NM_BAIRRO_18, l22.NM_BAIRRO NM_BAIRRO_22, 
        l18.NR_CEP NR_CEP_18, l22.NR_CEP NR_CEP_22, 
        l18.NR_LATITUDE NR_LATITUDE_18, l22.NR_LATITUDE NR_LATITUDE_22, 
        l18.NR_LONGITUDE NR_LONGITUDE_18, l22.NR_LONGITUDE NR_LONGITUDE_22
    from c18
    join c22 on c18.idlocal = c22.idlocal
    join l18 on c18.idlocal = l18.idlocal
    join l22 on c18.idlocal = l22.idlocal
    where abs(l18.NR_LATITUDE - l22.NR_LATITUDE) < 0.01 and abs(l18.NR_LONGITUDE - l22.NR_LONGITUDE) < 0.01
),
lm as (
    select 
        SG_UF || '_' || CD_MUNICIPIO  || '_' || NR_ZONA  || '_' || NR_LOCAL_VOTACAO as idlocal,
        count(*) filter (where modelo = 'UE2020') as cnovas,
        count(*) filter (where modelo != 'UE2020') as cvelhas
    from urna
    group by 1
), 
ltm as (
    select 
        idlocal,
        case 
            when cnovas > 0 and cvelhas = 0 then 'nova'
            when cnovas = 0 and cvelhas > 0 then 'velha'
            when cnovas > 0 and cvelhas > 0 then 'mista'
            else 'wtf'
        end as tipomodelo
    from lm
)
INSERT INTO locais_1822 (idlocal, SG_UF, CD_MUNICIPIO, NR_ZONA, NR_LOCAL_VOTACAO, NM_LOCAL_VOTACAO_18, NM_LOCAL_VOTACAO_22, CD_TIPO_LOCAL_18, CD_TIPO_LOCAL_22, DS_TIPO_LOCAL_18, DS_TIPO_LOCAL_22, DS_ENDERECO_18, DS_ENDERECO_22, NM_BAIRRO_18, NM_BAIRRO_22, NR_CEP_18, NR_CEP_22, NR_LATITUDE_18, NR_LATITUDE_22, NR_LONGITUDE_18, NR_LONGITUDE_22, tipomodelo)
select lc.*, ltm.tipomodelo
from locais_coincidentes lc
inner join ltm on lc.idlocal = ltm.idlocal;

CREATE TABLE urna_a18t2 (
	id INTEGER NOT NULL, 
    "SG_UF" TEXT, 
    "CD_MUNICIPIO" BIGINT,
    "NM_MUNICIPIO" TEXT, 
    "NR_ZONA" BIGINT,
    "NR_SECAO" BIGINT,
    "NR_LOCAL_VOTACAO" BIGINT,
    "IS_CAPITAL" BOOLEAN,
    "DT_CARGA_URNA_EFETIVADA" DATETIME,
    "DT_ABERTURA" DATETIME,
    "DT_ENCERRAMENTO" DATETIME,
    "QT_APTOS" BIGINT,
    "QT_COMPARECIMENTO" BIGINT,
    "QT_ABSTENCOES" BIGINT,
    "votos_poste" BIGINT,
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
        bu.NR_ZONA,
        bu.NR_SECAO,
        bu.NR_LOCAL_VOTACAO,
        bu.NM_MUNICIPIO = c.NM_MUNICIPIO as IS_CAPITAL,
        bu.DT_CARGA_URNA_EFETIVADA,
        bu.DT_ABERTURA,
        bu.DT_ENCERRAMENTO,
        max(QT_APTOS) QT_APTOS,
        max(QT_COMPARECIMENTO) QT_COMPARECIMENTO,
        max(QT_ABSTENCOES) QT_ABSTENCOES,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'FERNANDO HADDAD'), 0) votos_poste,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'JAIR BOLSONARO'), 0) votos_bozo,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'Nulo'), 0) votos_nulo,
        coalesce(sum(QT_VOTOS) filter (where NM_VOTAVEL = 'Branco'), 0) votos_branco,
        coalesce(sum(QT_VOTOS), 0) votos_totais
    from bu_a18t2 bu
    left outer join capital c on bu.SG_UF = c.SG_UF
    where bu.DS_CARGO_PERGUNTA = 'Presidente'
    group by 1,2,3,4,5,6
) 
INSERT INTO urna_a18t2 (SG_UF,CD_MUNICIPIO,NM_MUNICIPIO,NR_ZONA,NR_SECAO,NR_LOCAL_VOTACAO,IS_CAPITAL,DT_CARGA_URNA_EFETIVADA,DT_ABERTURA,DT_ENCERRAMENTO,QT_APTOS,QT_COMPARECIMENTO,QT_ABSTENCOES,votos_poste,votos_bozo,votos_nulo,votos_branco,votos_totais)
SELECT SG_UF,CD_MUNICIPIO,NM_MUNICIPIO,NR_ZONA,NR_SECAO,NR_LOCAL_VOTACAO,IS_CAPITAL,DT_CARGA_URNA_EFETIVADA,DT_ABERTURA,DT_ENCERRAMENTO,QT_APTOS,QT_COMPARECIMENTO,QT_ABSTENCOES,votos_poste,votos_bozo,votos_nulo,votos_branco,votos_totais
FROM resumo;

