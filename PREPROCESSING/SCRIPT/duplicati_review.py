import pandas as pd
dataset = "reviews_definitivo.csv"
ds = pd.read_csv(dataset)
ds = ds.drop_duplicates(subset=['_id']) 
# Salva il DataFrame modificato su un nuovo file CSV
ds.to_csv('reviews_senza_duplicati.csv', index=False)