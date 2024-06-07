import pandas as pd
dataset = "profile_processato_con_password.csv"
ds = pd.read_csv(dataset)
ds = ds.drop_duplicates(subset=['profile']) 
# Salva il DataFrame modificato su un nuovo file CSV
ds.to_csv('profilo_senza_duplicati.csv', index=False)