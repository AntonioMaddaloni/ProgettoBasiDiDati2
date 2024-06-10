import pandas as pd

dataset = "./DATASET/reviews_senza_duplicati.csv"
reviews = pd.read_csv(dataset)
reviews = reviews.rename(columns={
    'anime_uid': 'anime',
    'uid': '_id'
    # Aggiungi altri vecchi nomi e nuovi nomi qui
})

reviews.to_csv('./DATASET/reviews_definitivo.csv',index=False)
   