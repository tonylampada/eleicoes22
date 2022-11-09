import random

RODADAS = 163
PLACAR = 84

def simula():
    rands = [random.random() for i in range(RODADAS)]
    ganhou = [x for x in rands if x < .5]
    return len(ganhou)

ganhou = 0
for i in range(10000):
    placar = simula()
    if placar >= PLACAR:
        ganhou += 1

print(f'ganhou {ganhou} de 10000')