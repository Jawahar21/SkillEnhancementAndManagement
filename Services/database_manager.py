# connecting to database
import psycopg2

class DataBaseManager:
    @classmethod
    def database_connection ( cls ):
        conn = psycopg2.connect ( host = "localhost",\
         database = "seam", \
         user = "postgres", password = "postgres")
        return conn
