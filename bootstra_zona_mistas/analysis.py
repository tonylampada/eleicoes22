import pandas as pd
import numpy as np
from functions import bootstrap,evaluate

if __name__ == '__main__':
    df = pd.read_csv("urnas.csv")

    df["is_urna_nova"] = df["MODELO"] == "UE2020"

    df["zona_unica"] = df["CD_MUNICIPIO"].astype(str).str.cat(df["NR_ZONA"].astype(str), sep="-")
    df["secao_unica"] = df["zona_unica"].astype(str).str.cat(df["NR_SECAO"].astype(str), sep="-")

    zonas_urnas_novas = set(df["zona_unica"][df["is_urna_nova"]])
    zonas_urnas_velhas = set(df["zona_unica"][~df["is_urna_nova"]])
    zonas_mistas = zonas_urnas_novas.intersection(zonas_urnas_velhas)
    # print(len(zonas_urnas_novas), len(zonas_urnas_velhas), len(zonas_mistas))

    df_misto = df[df["zona_unica"].isin(zonas_mistas)][["zona_unica","secao_unica","is_urna_nova","votos_lula","votos_bozo"]]

    results = []
    np.random.seed(123456789)
    for i in range(100):
        # print(i)        
        results.append(evaluate(bootstrap(df_misto)))

    results_zonas = sorted([result["numero_secoes_lula_acima_urnas_velhas"] for result in results])
    results_diff = sorted([result["diferenca_media"] for result in results])
    print("p1: ", results_zonas[0], "zonas", results_diff[0], "diff")
    print("p5: ", results_zonas[4], results_diff[4], "diff")
    print("mediana: ", (results_zonas[50]+results_zonas[49])/2, (results_diff[50]+results_diff[49])/2, "diff")
    print("p95: ", results_zonas[95], results_diff[95], "diff")
    print("p99: ", results_zonas[99], results_diff[99], "diff")
    print(results)

