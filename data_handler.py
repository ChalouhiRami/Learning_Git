import pandas as pd
import lookups
from error_handler import log_error, print_error_console
 
import json


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
def return_insert_statement_from_df(dataframe, schema_name, full_table_name, db_session):
    columns = ', '.join(dataframe.columns)
    insert_statements = []

    try:
        with db_session.cursor() as cursor:
            for index, row in dataframe.iterrows():
                values_list = []
                for val in row.values:
                    
                    val_str = str(val)
                    values_list.append(f"'{val_str}'")

                values = ', '.join(values_list)
                insert_statement = f"INSERT INTO {schema_name}.{full_table_name} ({columns}) VALUES ({values});"
                insert_statements.append(insert_statement)
    except Exception as error:
        db_session.rollback()   
        print(f"An error occurred: {str(error)}")

    return insert_statements
import lookups
import data_handler
import database_handler

def create_table_and_insert_data(db_session, df, sheet_name):
    if df is not None:
        
        schema_name = "pluto"
        table_name = sheet_name.lower()
        full_table_name, create_statement = data_handler.return_create_statement_from_df(df, schema_name, table_name, "stg", config_path='config.json')
        database_handler.execute_query(db_session, create_statement)

        insert_statements = data_handler.return_insert_statement_from_df(df, schema_name, full_table_name, db_session)
        for insert_statement in insert_statements:
            database_handler.execute_query(db_session, insert_statement)

def read_sheet_as_dataframe(sheet_info):
    file_type = sheet_info["type"]
    file_config_parameter = sheet_info["config"]
    sheet_name = sheet_info["sheet_name"]

    df = data_handler.read_data_as_dataframe(file_type, file_config_parameter)
    return df, sheet_name

def read_dataset_create_tables_and_insert_data(db_session):
    sheets_info = [
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=countries', "sheet_name": "countries"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=avg_temperature', "sheet_name": "avg_temperature"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=prevalence_of_undernourishment', "sheet_name": "prevalence_of_undernourishment"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=disaster_types', "sheet_name": "disaster_types"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=gdp', "sheet_name": "gdp"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=world_population', "sheet_name": "world_population"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=natural_disasters', "sheet_name": "natural_disasters"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=disaster_magnitude', "sheet_name": "disaster_magnitude"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=worldcities', "sheet_name": "worldcities"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=share_without_improved_water', "sheet_name": "share_without_improved_water"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=magnitude_scale', "sheet_name": "magnitude_scale"},
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=valuable_country_data', "sheet_name": "valuable_country_data"},


    ]

    for sheet_info in sheets_info:
        df, sheet_name = read_sheet_as_dataframe(sheet_info)
        create_table_and_insert_data(db_session, df, sheet_name)



