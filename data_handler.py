import pandas as pd
import lookups
from error_handler import log_error, print_error_console
import lookups
import data_handler
import database_handler
import json
from datetime import datetime


def read_data_as_dataframe(file_type, file_config, db_session = None):
    try:
        if file_type == lookups.FileType.CSV:
            return pd.read_csv(file_config,low_memory=False)
        elif file_type == lookups.FileType.EXCEL:
            return pd.read_excel(file_config)
        elif file_type == lookups.FileType.SQL:
            return pd.read_sql(file_config, db_session)
    except Exception as error:
        prefix = lookups.ErrorHandling.DB_CONNECTION_ERROR.value
        suffix = str(error)
        print_error_console(suffix,prefix)
        log_error(f'An error occurred: {str(error)}')
        return None



def return_create_statement_from_df(dataframe, schema_name, table_name,table_type, config_path='config.json'): # i added db_session
    
    with open(config_path) as config_file:
        config_data = json.load(config_file)

    type_mapping = {
        'int64':'INT',
        'float64':'FLOAT',
        'object':'TEXT',
        'datetime64[ns]':'TIMESTAMP'
    }
    fields = []
    for column, dtype in dataframe.dtypes.items():
        sql_type = type_mapping.get(str(dtype), 'TEXT')
        fields.append(f"{column} {sql_type}")
    
    table_source = config_data.get(table_name, '')

    full_table_name = f"{table_type}_{table_name}_{table_source}"
    
    create_table_statement = f"CREATE TABLE IF NOT EXISTS {schema_name}.{full_table_name} ( \n"
    create_table_statement += "ID SERIAL PRIMARY KEY,\n"
    create_table_statement += ',\n'.join(fields)
    create_table_statement += ");"
    return full_table_name, create_table_statement
import pandas as pd
import datetime

def return_insert_statement_from_df(dataframe, schema_name, full_table_name, db_session):
    columns = ', '.join(dataframe.columns)
    insert_statements = []

    try:
        with db_session.cursor() as cursor:
            for index, row in dataframe.iterrows():
                values_list = []
                for val in row.values:
                    if pd.isnull(val):
                        values_list.append("NULL")
                    elif isinstance(val, (int, float)):
                        values_list.append(str(val))
                    elif isinstance(val, str):
                        
                        try:
                            date_obj = datetime.datetime.strptime(val, "%m/%d/%Y")
                            formatted_val = date_obj.strftime("%Y-%m-%d")
                            values_list.append(f"'{formatted_val}'")
                        except ValueError:
                             
                            values_list.append(f"'{val}'")
                    else:
                        
                        values_list.append(f"'{str(val)}'")

                values = ', '.join(values_list)
                insert_statement = f"INSERT INTO {schema_name}.{full_table_name} ({columns}) VALUES ({values});"
                insert_statements.append(insert_statement)
    except Exception as error:
        db_session.rollback()   
        print(f"An error occurred: {str(error)}")

    return insert_statements

 
def create_table_and_insert_data(db_session, df, sheet_name, config_path='config.json'):
    if df is not None:
        schema_name = "dwreporting"
        table_name = sheet_name.lower()
        watermark_table_name = "etl_watermark"

        # Load configuration from config.json
        with open(config_path, 'r') as config_file:
            config = json.load(config_file)

        # Get timestamp column for the current sheet from config
        timestamp_column_name = config['staging_tables'][table_name]['timestamp_column']

        # Convert the 'timestamp_column' in the DataFrame to datetime
        df[timestamp_column_name] = pd.to_datetime(df[timestamp_column_name], errors='coerce')

        # Create or update the staging table
        full_table_name, create_statement = data_handler.return_create_statement_from_df(df, schema_name, table_name, "stg", config_path=config_path)
        database_handler.execute_query(db_session, create_statement)

        # Retrieve last update timestamp from etl_watermark table
        last_update_query = f"""
            SELECT last_update_timestamp FROM {schema_name}.{watermark_table_name}
            WHERE table_name = '{full_table_name}';
        """
        last_update_result = database_handler.execute_query_and_fetch(db_session, last_update_query)

        if last_update_result:
            timestamp_object = last_update_result[0][0]

            # Convert the timestamp to a datetime object if it's an integer
            formatted_timestamp = timestamp_object.strftime('%Y-%m-%d %H:%M:%S')
            print(f"Last Update Timestamp: {formatted_timestamp}")
        else:
            print("No results returned.")
            timestamp_object = None

        if timestamp_object is not None:
            new_or_updated_records = df[df[timestamp_column_name] > timestamp_object]

            if not new_or_updated_records.empty:
                # Insert new or updated records into the staging table
                insert_statements = data_handler.return_insert_statement_from_df(new_or_updated_records, schema_name, full_table_name, db_session)
                for insert_statement in insert_statements:
                    database_handler.execute_query(db_session, insert_statement)

                # Update the last update timestamp in the etl_watermark table
                update_watermark_query = f"""
                    INSERT INTO {schema_name}.{watermark_table_name} (last_update_timestamp, table_name)
                    VALUES ('{datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}', '{full_table_name}')
                    ON CONFLICT (table_name)
                    DO UPDATE SET last_update_timestamp = EXCLUDED.last_update_timestamp;
                """
                database_handler.execute_query(db_session, update_watermark_query)
            else:
                print("No new or updated records found.")
        else:
            regular_records = df

            # Insert regular records into the staging table
            insert_statements = data_handler.return_insert_statement_from_df(regular_records, schema_name, full_table_name, db_session)
            for insert_statement in insert_statements:
                database_handler.execute_query(db_session, insert_statement)

            # Update the last update timestamp in the etl_watermark table
            update_watermark_query = f"""
                INSERT INTO {schema_name}.{watermark_table_name} (last_update_timestamp, table_name)
                VALUES ('{datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}', '{full_table_name}')
                ON CONFLICT (table_name)
                DO UPDATE SET last_update_timestamp = EXCLUDED.last_update_timestamp;
            """
            database_handler.execute_query(db_session, update_watermark_query)

def read_sheet_as_dataframe(sheet_info):
    file_type = sheet_info["type"]
    file_config_parameter = sheet_info["config"]
    sheet_name = sheet_info["sheet_name"]

    df = data_handler.read_data_as_dataframe(file_type, file_config_parameter)
    return df, sheet_name

 

