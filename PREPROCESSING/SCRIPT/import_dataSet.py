import pandas as pd
from pymongo import MongoClient

# Configurazione della connessione a MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['anime_hub']  # Sostituisci con il nome del tuo database

# Lista di tuple con il percorso del file CSV e il nome della collezione corrispondente
files_collections = [
    ('review_processato.csv', 'reviews'),
    ('anime_processato.csv', 'animes'),
    ('profile_processato_con_password.csv', 'profiles'),
    # Aggiungi altre tuple se necessario
]

# Funzione per importare un singolo CSV in una collezione MongoDB
def import_csv_to_mongodb(file_path, collection_name):
    # Lettura del file CSV
    df = pd.read_csv(file_path)
    
    # Conversione del DataFrame in una lista di dizionari
    data = df.to_dict(orient='records')
    
    # Inserimento dei dati nella collezione specificata
    collection = db[collection_name]
    collection.insert_many(data)
    
    print(f"Dati importati con successo in {collection_name}")

# Iterazione sui file CSV e le collezioni corrispondenti
for file_path, collection_name in files_collections:
    import_csv_to_mongodb(file_path, collection_name)
