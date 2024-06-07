import pandas as pd


dataset = "profiles.csv"
#carico il dataset
profile = pd.read_csv(dataset)
#elimino le colonne del dataset non rilevanti
profile=profile.drop(['link'],axis=1)
print(profile.info())
#salvo il nuovo dataset
profile.to_csv('profile_processato.csv',index=False)