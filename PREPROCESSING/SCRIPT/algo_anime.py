import pandas as pd


dataset = "animes.csv"
#carico il dataset
anime = pd.read_csv(dataset)
#elimino le colonne del dataset non rilevanti
anime=anime.drop(['members','ranked','link'],axis=1)
print(anime.info())
#salvo il nuovo dataset
anime.to_csv('anime_processato.csv',index=False)