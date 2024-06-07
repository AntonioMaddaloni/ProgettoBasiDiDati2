import pandas as pd
dataset = "anime_processato.csv"
ds = pd.read_csv(dataset)
ds = ds.drop_duplicates(subset=['uid']) 
# Salva il DataFrame modificato su un nuovo file CSV
ds.to_csv('anime_senza_duplicati.csv', index=False)