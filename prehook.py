import database_handler
import data_handler
import lookups
import os 
import glob 
from datetime import datetime

# def generate_list_of_csv_sources():
#     csv_list = []
#     csv_files = glob.glob(os.path.join("C:/Datasets", "*.csv"))
#     csv_list.extend(csv_files)
#     return csv_list

# def create_sql_staging_tables(db_session, csv_list, schema_name):
#     for csv_item in csv_list:
#         stg_df = data_handler.read_data_as_dataframe(lookups.FileType.CSV, csv_item)
#         schema_name = "dwreporting"
#         table_name = csv_item.replace('\\', '/').split('/')[-1].replace('.csv', '').lower()
#         create_statement = data_handler.return_create_statement_from_df(stg_df, schema_name, table_name,"stg")
#         database_handler.execute_query(db_session, create_statement)

def create_etl_watermark(db_session, schema_name, table_name):
    
    try:
        execute(db_session)
        csv_list = generate_list_of_csv_sources()
        create_sql_staging_tables(db_session, csv_list)
        
 
        current_timestamp = datetime.now()
        initial_timestamp = current_timestamp.strftime("%Y-%m-%d %H:%M:%S")
    
        schema_name = "dwreporting"
        table_name = "etl_watermark"
    
        query = f"INSERT INTO {schema_name}.{table_name} (etl_last_execution_time) VALUES ('{initial_timestamp}');"
        database_handler.execute_query(db_session, query)
        # Only update the ETL watermark if the entire ETL process was successful
        data_handler.run_etl_process(db_session, schema_name, table_name)

        #should i use the commit here, or in the main??
        db_session.commit()

    except Exception as error:
        
        print(f'An error occurred during ETL: {str(error)}')
        
    
 
def execute(db_session):
    sql_files = glob.glob("**/*.sql")

    for sql_file in sql_files:
         
        file_name = sql_file.split("\\")[-1]
         
        if "_prehook" in file_name:
            query = None
            print(file_name)   
            
            with open(sql_file, "r") as f:
                query = f.read()
            database_handler.execute_query(db_session, query)
            db_session.commit()
