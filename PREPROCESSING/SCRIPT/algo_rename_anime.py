import pandas as pd

dataset = "./DATASET/anime_senza_duplicati.csv"
reviews = pd.read_csv(dataset)
reviews = reviews.rename(columns={
    'uid': '_id'
    # Aggiungi altri vecchi nomi e nuovi nomi qui
})

reviews.to_csv('./DATASET/anime_definitivo.csv',index=False)
