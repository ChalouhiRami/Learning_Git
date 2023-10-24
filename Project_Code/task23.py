from database_handler import create_connection
import json
import pandas as pd
import requests
from error_handler import log_error, print_error_console
import lookups


def read_data_as_dataframe(file_type, file_config, db_session = None):
    try:
        if file_type == lookups.FileType.CSV:
            return pd.read_csv(file_config)
        elif file_type == lookups.FileType.EXCEL:
            return pd.read_excel(file_config)
        elif file_type == lookups.FileType.SQL:
            return pd.read_sql(file_config, db_session)
    except Exception as error:
        prefix = lookups.ErrorHandling.Data_handler_error.value
        suffix = str(error)
        print_error_console(suffix,prefix)
        log_error(f'An error occurred: {str(error)}')
        return None

# return insert_statement_from_dataframe
def insert_statements(Df, table_name, schema_name ):
    columns = ','.join(Df.columns)
    for index, row in Df.iterrows():
        values_list = []
        for val in row.values:
            val_type = str(type(val))
            if val_type == lookups.HandledType.TIMESTAMP.value:
                values_list.append(str(val))
            elif val_type == lookups.HandledType.STRING.value:
                values_list.append(f"'{val}'")
            elif val_type == lookups.HandledType.LIST.value:
                val_item = ';'.join(val)
                values_list.append(f"'{val_item}'")
            else:
                values_list.append(str(val))
 
        values = ', '.join(values_list)
        insert_statement = f"INSERT INTO {schema_name}.{table_name} ({columns}) VALUES ({values});"
        print(insert_statement)



# we should create a dynamic generator of the insert statement from the dataframes
def storing_data(data, config_file):
    db_session = create_connection(config_file)
    cursor = db_session.cursor() 
    insert_data_query = f"""INSERT INTO test_table2 (data) VALUES (%s)"""

    for item in data:
        cursor.execute(insert_data_query, (json.dumps(item),))
    
    db_session.commit()
    cursor.close()
 
    
    
