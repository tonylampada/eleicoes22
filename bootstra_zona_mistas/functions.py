import pandas as pd
import numpy as np

def bootstrap(df):
    zonas = set(df["zona_unica"])
    new_df = df.head(0)
    for zona in zonas:
        df_temp = df[df["zona_unica"] == zona].copy()
        new_permutation = np.random.permutation(df_temp["is_urna_nova"])
        df_temp["is_urna_nova"] = new_permutation
        new_df = pd.concat([new_df, df_temp])
    return new_df

def calculate_lula(df):
    return sum(df["votos_lula"])/(sum(df["votos_lula"])+sum(df["votos_bozo"]))

def evaluate(df):
    zonas = set(df["zona_unica"])    
    results = []
    for zona in zonas:
        results.append(calculate_lula(df[(df["zona_unica"] == zona) & (~df["is_urna_nova"])])-calculate_lula(df[(df["zona_unica"] == zona) & (df["is_urna_nova"])]))    
    lula_acima = len([x for x in results if x > 0])
    media_diff = sum(results)/len(results)
    return {"numero_secoes_lula_acima_urnas_velhas": lula_acima, "diferenca_media": media_diff}
