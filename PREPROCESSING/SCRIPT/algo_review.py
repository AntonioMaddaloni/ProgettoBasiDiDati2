import pandas as pd


dataset = "reviews.csv"
#carico il dataset
review = pd.read_csv(dataset)
#elimino le colonne del dataset non rilevanti
review=review.drop(['link'],axis=1)
print(review.info())
#salvo il nuovo dataset
review.to_csv('review_processato.csv',index=False)