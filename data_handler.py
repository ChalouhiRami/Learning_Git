import pandas as pd
import lookups
from error_handler import log_error, print_error_console
from database_handler import execute_query


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



def return_create_statement_from_df(dataframe, schema_name, table_name): # i added db_session
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
    
    create_table_statement = f"CREATE TABLE IF NOT EXISTS {schema_name}.{table_name} ( \n"
    create_table_statement += "ID SERIAL PRIMARY KEY,\n"
    create_table_statement += ',\n'.join(fields)
    create_table_statement += ");"
    return create_table_statement

# use a function to return sql insert statement / statement(s) and use execute query from database handler.
def return_insert_statement_from_df(dataframe, schema_name, table_name, db_session):
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
                insert_statement = f"INSERT INTO {schema_name}.{table_name} ({columns}) VALUES ({values});"
                insert_statements.append(insert_statement)

        db_session.commit()  

    except Exception as error:
        db_session.rollback()   
        print(f"An error occurred: {str(error)}")

    return insert_statements



