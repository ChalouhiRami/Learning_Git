import lookups
import data_handler 
import database_handler
def read_dataset_and_return_as_df(db_session):
    
    sheets_info = [
        {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=COUNTRIES', "sheet_name": "COUNTRIES"},
         {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=avg_temperature', "sheet_name": "avg_temperature"},
           {"type": lookups.FileType.CSV, "config": 'https://docs.google.com/spreadsheets/d/18GUCOh6BzZ6eLeM1fbLGrnPpW2DeUUal-jqci93w6R8/gviz/tq?tqx=out:csv&sheet=prevalence_of_undernourishment', "sheet_name": "prevalence_of_undernourishment"}, 
        
      
    ]

    for sheet_info in sheets_info:
        file_type = sheet_info["type"]
        file_config_parameter = sheet_info["config"]
        sheet_name = sheet_info["sheet_name"]

        
        table_name = f"{sheet_name.lower()}"

        
        df = data_handler.read_data_as_dataframe(file_type, file_config_parameter)

    if df is not None:
         print(f"DataFrame for {table_name}:\n{df}\n")
         schema_name = "pluto"
         full_table_name, create_statement = data_handler.return_create_statement_from_df(df, schema_name, table_name, "stg",config_path='config.json')
         database_handler.execute_query(db_session, create_statement)

     
         insert_statements = data_handler.return_insert_statement_from_df(df, schema_name, full_table_name, db_session)
         for insert_statement in insert_statements:
           database_handler.execute_query(db_session, insert_statement)
           

 