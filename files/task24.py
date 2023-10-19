import pandas as pd
import json
import requests
import psycopg2
from database_handler import create_connection

def return_data_as_object_and_store_in_db(file_path, file_type, config_file):
    db_session = create_connection(config_file)

    supported_file_types = ['csv', 'excel', 'json', 'api']

    if file_type not in supported_file_types:
         print("Unsupported type!")
         return -1 

    if file_type == 'csv':
        data = pd.read_csv(file_path)
    elif file_type == 'excel':
        data = pd.read_excel(file_path)
    elif file_type == 'json':
        with open(file_path, 'r') as json_file:
            data = json.load(json_file)
    elif file_type == 'api':
        
        response = requests.get(file_path)
        if response.status_code == 200:
            data = response.json()
        else:
            print("failed to retrieve data from API")
            return -2

        cursor = db_session.cursor() 
        insert_data_query = f"""INSERT INTO test_table (data) VALUES (%s)"""
        for item in data:
            cursor.execute(insert_data_query, (json.dumps(item),))
        db_session.commit()
        cursor.close()

    return data

 
file_path = 'https://jsonplaceholder.typicode.com/posts'   
file_type = 'api'
config_file = 'config.json'
table_name = 'test_table'  
data = return_data_as_object_and_store_in_db(file_path, file_type, config_file)
print(data)
