from database_handler import create_connection
import json
import pandas as pd
import requests

# use return_data_as_dataframe from the database handler
def read_data(file_path, file_type):
    supported_file_types = ['csv', 'excel', 'json', 'api']

    if file_type not in supported_file_types:
        print("Unsupported type!")
        return None

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
            print("Failed to retrieve data from API")
            return None

    return data


# return insert_statement_from_dataframe

# we should create a dynamic generator of the insert statement from the dataframes
def storing_data(data, config_file):
    db_session = create_connection(config_file)
    cursor = db_session.cursor() 
    insert_data_query = f"""INSERT INTO test_table2 (data) VALUES (%s)"""

    for item in data:
        cursor.execute(insert_data_query, (json.dumps(item),))
    
    db_session.commit()
    cursor.close()
 
    
    
