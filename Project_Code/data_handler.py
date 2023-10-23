import pandas as pd
import lookups
import error_handler
from logging_handler import configure_logger, log_error

# change function name to read data as dataframe

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
        error_handler.print_error(suffix,prefix)
        log_error(f'An error occurred: {str(error)}')
        return None


# you need to be able to create a new function
# it would return the create statementf from a dataframe
# create a function
# it would return the insert statement from a dataframe.
def return_create_statement_from_df(dataframe, schema_name, table_name):
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
   
    create_table_statement = f"CREATE TABLE IF NOT EXISTS {schema_name.value}.{table_name} ( \n"
    create_table_statement += "ID SERIAL PRIMARY KEY,\n"
    create_table_statement += ',\n'.join(fields)
    create_table_statement += ");"
    return create_table_statement

def return_insert_statement_from_df (dataframe, schema_name, table_name):
    columns = ', '.join(dataframe.columns)
    insert_statements = []

    for index, row in dataframe.iterrows():
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
        insert_statement = f"INSERT INTO {schema_name.value}.{table_name} ({columns}) VALUES ({values});"
        insert_statements.append(insert_statement)

    return insert_statements
 
 
   