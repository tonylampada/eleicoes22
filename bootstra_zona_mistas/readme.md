Segregamos apenas as zonas que possuíam os modelos novos e velhos em suas seções, e comparamos os resultados

A essência é comparar, dentro da mesma zona, os resultados em urnas velhas e urnas novas. Para cada zona, é rearranjado os modelos das urnas (entre novas e velhas), de modo a simular uma distribuição aleatória de modelos de urna. É reportado como resultado a quantidade de zonas em que o Lula tem porcentagem de votos maior nas urnas velhas que novas, e a diferença média dessa vantagem (a média da diferença entre o percentual de votos para Lula em urnas velhas e novas, em cada zona).

O resultado gerado por analysis.py está em output.txt

O resumo dos resultados foi:
- p1:  207 zonas -0.0017724388311262348 diff
- p5:  211 -0.0013336884278273122 diff
- mediana:  232.5 0.0001321111733088952 diff
- p95:  248 0.0012997699363475118 diff
- p99:  254 0.00231954433285097 diff

Os dados lidos em urnas.csv vieram do arquivo disponibilizado na raiz, não foi copiado aqui para evitar duplicidade

O resultado indica que é extremamente improvável encontrar a distribuição real encontrada (311 zonas com o Lula acima, e 1.7% de média de diferença).

Esse resultado, entretanto, não é indicativo forte de fraude. A hipótese mais provável é que, mesmo dentro da mesma zona, a distribuição de urnas não é feita de maneira não viesada. Um estudo mais profundo nas zonas e distribuições de urnas é necessário para confirmar ou descartar a hipótese.
