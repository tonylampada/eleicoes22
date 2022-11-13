### Intro

Algumas pessoas me perguntam "que ferramenta é essa que vc usa pra plotar os gráficos?", "como faço pra rodar aqui no meu computador?".
Estou escrevendo as instruções aqui pra facilitar quem quiser reproduzir. Com um pouquinho de intimidade com o pc, não é pra ser difícil.

### Metabase

A ferramenta é o [metabase](https://www.metabase.com/). O metabase é uma aplicação web - isso significa que quando vc executa o metabase ele 
sobe um servidorzinho no seu computador e vc pode acessar pelo navegador.

O metabase permite que vc se conecte num banco de dados qualquer e faça consultas em SQL. Se os resultados da consulta puderem ser plotados num gráfico, 
o metabase te dá várias maneiras fáceis de fazer isso.

### Download do banco.

Eu já compilei os dados do TSE e agreguei tudo nesse banco aqui. [Link pra baixar](https://onedrive.live.com/?cid=bc1ab5e70e75797a&id=BC1AB5E70E75797A%21774&authkey=%21AByi1aAXbFwBKEg)

Depois de fazer o download vc descompacta ele num pastinha (digamos `c:\eleicoes22`, se vc tiver num windows - vc tiver num linux 
provavelmente vc não precisa de instruções tão detalhadas)

c:\eleicoes22
```
eleicao22_2t.db
eleicao22_2t.db-shm
eleicao22_2t.db-wal
```

Beleza, isso aí é o banco de dados. Deixa aí

### Rodando o metabase

O jeito que eu acho mais fácil de rodar o metabase é usando o docker.
O docker é uma ferramenta que permite rodar "containers" (que é como se fosse uma máquina virtual) que já vem 
prontinhos com os softwares que a gente quer rodar. Usando o docker a gente pode baixar uma imagem do metabase e rodar um container 
pra olhar pro nosso banco aí.

Dá teus pulos pra [instalar o docker](https://docs.docker.com/engine/install/).

Pode ser uma boa idéia assistir esse mini tutorial sobre docker pra entender melhor: [docker em 20 minutos](https://www.youtube.com/watch?v=caGS9EztYlc)

Então vc já tem o banco e o docker.

Bora testar rodar o metabase. Executa isso aqui na linha de comando:

```
docker run --rm -p 3000:3000 --name metabase metabase/metabase
```

A primeira vez que vc rodar esse comando deve demorar um pouco pq o docker vai baixar a imagem do metabase. 
Quando terminar, sua linha de comando vai ficar paradinha lá. 

Mais ou menos assim

![image](https://user-images.githubusercontent.com/218821/201528732-f9858ff1-c59f-454e-a373-1468bf735738.png)


Deixa isso aí. Agora abre um navegador e acessa http://localhost:3000

![image](https://user-images.githubusercontent.com/218821/201528789-039484d7-156d-43b6-bed7-9291d93b8d4b.png)

Deu isso aí? Welcome to metabase? Excelente. Mas calma que não dá pra usar ainda não. Precisa mudar essa linha de comando pra gente conseguir conectar o metabase no nosso banco.

Derruba o metabase. Vai lá no terminal que tá rodando o comando do metabase e digita `ctrl+C` pra derrubar o metabase (no terminal, o comando ctrl+C é pra interromper o programa que está rodando)

Agora vc vai rodar o metase de um jeito que:

* ele grave as alterações que vc fizer (senão vc vai perder seu trabalho)
* ele vai conseguir abrir seu banco de dados

Atenção: no comando abaixo, substitua `c:\eleicoes22` pelo caminho da pasta que tem os arquivos do banco que vc descompactou.

```
docker run --rm -v c:\eleicoes22:/dados -e MB_DB_FILE=/dados/metabase.db -p 3000:3000 --name metabase metabase/metabase
```

Welcome to metabase de novo? Agora sim, clica aí no "get started" vai dando next. Vai precisar criar um usuario admin com email e senha. Poe qualquer coisa que vc consiga lembrar depois.

![image](https://user-images.githubusercontent.com/218821/201529227-c65e32ec-7ed9-47f1-9447-ea74bcfc2faa.png)

Aí ele vai te pedir pra dizer onde estão os dados

![image](https://user-images.githubusercontent.com/218821/201529272-582e3d19-4a97-4760-bd5a-921620c8ee1d.png)

Show more options

![image](https://user-images.githubusercontent.com/218821/201529289-04da753e-43bb-4335-a39f-9a1fb3e2ad58.png)

Sqlite

![image](https://user-images.githubusercontent.com/218821/201529428-5989aabc-08ab-4ff7-8787-d98955ba2ce6.png)

Nome: eleicoes22_2t (ou outra coisa q vc quiser)
Path: /dados/eleicao22_2t.db

Connect, finish, take me to metabase.

Testando: New / SQL Query

![image](https://user-images.githubusercontent.com/218821/201529504-23c057ad-73d1-464f-83c9-4cd5aca150f7.png)

Select database: eleicoes22

![image](https://user-images.githubusercontent.com/218821/201529550-909e5040-42d9-471b-ac6f-ec2eeece5e67.png)

`select * from urna`

![image](https://user-images.githubusercontent.com/218821/201529619-0172bb4b-493e-4452-9df0-489e7f6bbc8b.png)

Chegou aí? Beleza. Tá funcionando.

### Usando o metabase

Dá pra fazer análises aí usando o próprio metabase ou dá pra fazer uma consulta sql, baixar o csv e levar pro excel.
Repara no print anterior, o botão de download no rodapé do lado direito (dica: não faça download de xls com muitos dados, vai travar o metabase. Prefira o csv)

Exemplo de uma consulta um pouquinho mais complexa com SQL

```
select 
    modelo, 
    sum(votos_lula) lula,
    sum(votos_bozo) bozo,
    sum(votos_branco) branco,
    sum(votos_nulo) nulo
from urna
group by modelo
order by modelo
```

![image](https://user-images.githubusercontent.com/218821/201529911-1bf1bd32-0610-4661-8b38-a2601b92b20d.png)

Aí clicando ali no botão visualization vc pode por exemplo mostrar isso num grafico de barras.

![image](https://user-images.githubusercontent.com/218821/201529978-711cc272-952f-4c21-929e-ef5ca28bfdfe.png)

E aí vc pode salvar essa pergunta aih pra voltar nela depois. Também dá pra criar dashboards mostrando o resultado de várias perguntas numa mesma tela. 
Fuça aí que é fácil de aprender.

Se vc não sabe SQL, vai atrás de uns toturiais no google. Pra quem já manja de excel não vai ser tão difícil.
Mas mesmo sem saber o SQL o metabase dá uma colher de chá, e dá pra criar umas consultas com filtros, agregações, etc usando um wizard. 
Até que dá pra ir um pouco longe sem saber SQL também!

Espero que ajude!


