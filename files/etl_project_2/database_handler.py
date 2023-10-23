import psycopg2
import lookups
import error_handler
import filehandler

def create_connection(config_file):
    db_session = None
    try:
        config_data = filehandler.read_config(config_file)

        if config_data is not None:
            db_host = config_data.get("db_host")
            db_name = config_data.get("db_name")
            db_user = config_data.get("db_user")
            db_pass = config_data.get("db_pass")

            if db_host and db_name and db_user and db_pass:
                db_session = psycopg2.connect(
                    host=db_host,
                    database=db_name,
                    user=db_user,
                    password=db_pass,
                    port=5433
                )
            else:
                print("Missing database connection parameters in the config file.")
        else:
            print("Failed to read the configuration file.")
    except Exception as error:
        prefix = lookups.ErrorHandling.DB_CONNECTION_ERROR.value
        suffix = str(error)
        error_handler.print_error(suffix, prefix)
    finally:
        return db_session
