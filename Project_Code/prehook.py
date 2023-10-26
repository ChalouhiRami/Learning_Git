import database_handler
import data_handler
import lookups

def execute_prehook_statements(db_session):
    # read SQL files inside the folder
    sql_files = []
    for sql_file in sql_files:
        if sql_file.split('_')[1] == 'prehook':
            query = None
            # read content of the file
            database_handler.execute_query(db_session, query)


def generate_list_of_csv_sources():
    csv_list = []
    'C:/Users/Hawchan/natrual_disaster_country.csv'
    csv_list.append('.csv')


def create_sql_staging_tables(db_session, csv_list):
    for csv_item in csv_list:
        stg_df = data_handler.read_data_as_dataframe(lookups.FileType.CSV, csv_item)
        schema_name = "dwreporting"
        table_name = csv_item.split('/')[len(csv_item.split('/')) - 1].replace('.csv','').tolower()
        create_statement = data_handler.return_create_statement_from_df(stg_df, schema_name, table_name)
        database_handler.execute_query(db_session, create_statement)
    
    