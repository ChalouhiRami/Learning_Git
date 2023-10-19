import lookups
import error_handler
from database_handler import create_connection
from logging_handler import log_error


def execute_query(config_file, sql_query):
    
    connection = create_connection(config_file)

    if connection is not None:
        try:
             
            cursor = connection.cursor()
 
            cursor.execute(sql_query)

            
            result = cursor.fetchall()
            return result

        except Exception as error:
             
            prefix = lookups.ErrorHandling.DB_QUERY_ERROR.value
            suffix = str(error)
            error_handler.print_error(suffix, prefix)
            log_error(f'An error occurred: {str(error)}')

        finally:
         
            cursor.close()
            connection.close()
    else:
         
        print(" Errror , Cannot execute query.")