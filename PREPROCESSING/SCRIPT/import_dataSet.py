import pandas as pd
from pymongo import MongoClient
import ast
import json

# Configurazione della connessione a MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['anime_hub']  # Sostituisci con il nome del tuo database

# Lista di tuple con il percorso del file CSV e il nome della collezione corrispondente
files_collections = [
    ('./DATASET/reviews_definitivo.csv', 'reviews'),
    ('./DATASET/anime_definitivo.csv', 'animes'),
    ('./DATASET/profile_definitivo.csv', 'profiles'),
    # Aggiungi altre tuple se necessario
]

# Funzione per convertire stringa in lista di interi
def convert_string_to_intlist(string):
    try:
        # Converte la stringa in una lista utilizzando ast.literal_eval
        lst = ast.literal_eval(string)
        # Converte ogni elemento della lista in int
        return [int(i) for i in lst]
    except:
        # Se la conversione fallisce, restituisce una lista vuota o None
        return []
    
# Funzione per convertire stringa in lista di stringhe
def convert_string_to_stringlist(string):
    try:
        # Converte la stringa in una lista utilizzando ast.literal_eval
        lst = ast.literal_eval(string)
        # Ritorna gli elementi come stringa
        return [i for i in lst]
    except:
        # Se la conversione fallisce, restituisce una lista vuota o None
        return []
    
# Funzione per convertire la stringa JSON in oggetto Python
def convert_string_to_json(string):
    try:
        json_obj = json.loads(string.replace("'", '"'))
        # Converte i valori del dizionario in interi
        return {k: int(v) for k, v in json_obj.items()}
    except json.JSONDecodeError as e:
        print(f"Errore nella conversione della stringa: {string}")
        return None

# Funzione per importare un singolo CSV in una collezione MongoDB
def import_csv_to_mongodb(file_path, collection_name):
    # Lettura del file CSV
    df = pd.read_csv(file_path)

    if collection_name == "profiles":
        # Conversione della colonna 'favourite_anime' da stringa ad array per la collezione profiles
        df['favorites_anime'] = df['favorites_anime'].apply(convert_string_to_intlist)

    
    if collection_name == "animes":
        # Conversione della colonna 'genre' da stringa ad array per la collezione animes
        df['genre'] = df['genre'].apply(convert_string_to_stringlist)

    if collection_name == "reviews":
        # Conversione della colonna scores da stringa JSON a oggetto Python
        df['scores'] = df['scores'].apply(convert_string_to_json)
    
    # Conversione del DataFrame in una lista di dizionari
    data = df.to_dict(orient='records')
    
    # Inserimento dei dati nella collezione specificata
    collection = db[collection_name]
    collection.insert_many(data)
    
    print(f"Dati importati con successo in {collection_name}")

# Iterazione sui file CSV e le collezioni corrispondenti
for file_path, collection_name in files_collections:
    import_csv_to_mongodb(file_path, collection_name)
