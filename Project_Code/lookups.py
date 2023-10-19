from enum import Enum

Csv = 'CSV'
Xlsx = 'xlsx'
class FileType(Enum):
    CSV = 'CSV'
    
class ErrorHandling(Enum):
    DB_CONNECTION_ERROR = "Failed to connect to database (database_handler.py)"

class FilterFields(Enum):
    RENTAL_RATE = 'rental_rate'