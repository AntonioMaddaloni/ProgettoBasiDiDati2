import pandas as pd

dataset = "./DATASET/profilo_senza_duplicati.csv"
reviews = pd.read_csv(dataset)
reviews = reviews.rename(columns={
    'profile': '_id'
    # Aggiungi altri vecchi nomi e nuovi nomi qui
})

reviews.to_csv('./DATASET/profile_definitivo.csv',index=False)
