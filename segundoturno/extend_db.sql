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
