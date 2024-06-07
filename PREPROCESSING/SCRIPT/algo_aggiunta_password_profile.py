import pandas as pd
import secrets
import string
 
# Definire una funzione per generare password casuali
def generate_password(length=10):
    characters = string.ascii_letters + string.digits + string.punctuation
    password = ''.join(secrets.choice(characters) for _ in range(length))
    return password
 
# Caricare il dataset
dataset = 'profile_processato.csv'
profile = pd.read_csv(dataset)
 
# Aggiungere una colonna 'password' con stringhe casuali
profile['password'] = [generate_password() for _ in range(len(profile))]
 
# Riorganizzare le colonne
cols = list(profile.columns)
cols.insert(cols.index('profile') + 1, cols.pop(cols.index('password')))
profile = profile[cols]
 
# Visualizzare il DataFrame con le colonne riordinate
print(profile.head())
 
# Salvare il DataFrame con le colonne riordinate
profile.to_csv('profile_processato_con_password.csv', index=False)