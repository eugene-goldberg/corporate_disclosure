"""MySQL database utilities for the text2sql agent"""
import os
from langchain_community.utilities.sql_database import SQLDatabase
from sqlalchemy import create_engine, inspect
from sqlalchemy.pool import NullPool
from dotenv import load_dotenv

load_dotenv()

# MySQL connection parameters
MYSQL_HOST = os.getenv("MYSQL_HOST", "localhost")
MYSQL_PORT = int(os.getenv("MYSQL_PORT", 3306))
MYSQL_USER = os.getenv("MYSQL_USER", "chinook_user")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD", "chinook_pass")
MYSQL_DATABASE = os.getenv("MYSQL_DATABASE", "chinook")


def get_mysql_engine():
    """Create MySQL engine for Chinook database."""
    connection_string = f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DATABASE}"
    return create_engine(
        connection_string,
        poolclass=NullPool,  # Disable connection pooling for simplicity
        connect_args={
            "connect_timeout": 10
        }
    )


def get_mysql_db_table_names():
    """Get list of all table names in the MySQL database."""
    engine = get_mysql_engine()
    db = SQLDatabase(engine)
    return db.get_usable_table_names()


def get_mysql_detailed_table_info():
    """Get detailed information for each table including schema, keys, and sample data."""
    engine = get_mysql_engine()
    db = SQLDatabase(engine)
    inspector = inspect(engine)
    table_names = db.get_usable_table_names()

    detailed_info = {}

    for table_name in table_names:
        table_info = {
            "columns": [],
            "primary_key": None,
            "foreign_keys": [],
            "sample_data": [],
        }

        # Get table schema using SQLAlchemy inspector
        try:
            columns = inspector.get_columns(table_name)
            for column in columns:
                table_info["columns"].append(
                    {
                        "name": column["name"],
                        "type": str(column["type"]),
                        "nullable": column.get("nullable", "unknown"),
                    }
                )

            # Get primary key
            pk = inspector.get_pk_constraint(table_name)
            if pk["constrained_columns"]:
                table_info["primary_key"] = pk["constrained_columns"]

            # Get foreign keys
            fks = inspector.get_foreign_keys(table_name)
            for fk in fks:
                table_info["foreign_keys"].append(
                    {
                        "columns": fk["constrained_columns"],
                        "referred_table": fk["referred_table"],
                        "referred_columns": fk["referred_columns"],
                    }
                )

        except Exception as e:
            table_info["error"] = str(e)

        # Get sample data (first 3 rows)
        try:
            sample_query = f"SELECT * FROM {table_name} LIMIT 3"
            sample_result = db.run(sample_query)
            table_info["sample_data"] = sample_result
        except Exception as e:
            table_info["sample_data_error"] = str(e)

        detailed_info[table_name] = table_info

    return detailed_info


def get_mysql_schema_overview():
    """Get a concise overview of all table schemas."""
    engine = get_mysql_engine()
    db = SQLDatabase(engine)
    inspector = inspect(engine)
    table_names = db.get_usable_table_names()

    schema_overview = {}

    for table_name in table_names:
        try:
            columns = inspector.get_columns(table_name)
            schema_overview[table_name] = [
                {"name": col["name"], "type": str(col["type"])} for col in columns
            ]
        except Exception as e:
            schema_overview[table_name] = {"error": str(e)}

    return schema_overview


# Alias functions to maintain compatibility
def get_engine_for_chinook_db():
    """Alias for get_mysql_engine to maintain compatibility"""
    return get_mysql_engine()


def get_db_table_names():
    """Alias for get_mysql_db_table_names to maintain compatibility"""
    return get_mysql_db_table_names()


def get_detailed_table_info():
    """Alias for get_mysql_detailed_table_info to maintain compatibility"""
    return get_mysql_detailed_table_info()


def get_schema_overview():
    """Alias for get_mysql_schema_overview to maintain compatibility"""
    return get_mysql_schema_overview()


# Example usage
if __name__ == "__main__":
    print("=== Testing MySQL Connection ===")
    try:
        table_names = get_db_table_names()
        print(f"Connected successfully! Found {len(table_names)} tables:")
        print(table_names)
        
        print("\n=== Sample Data from Album table ===")
        engine = get_mysql_engine()
        db = SQLDatabase(engine)
        result = db.run("SELECT * FROM Album LIMIT 5")
        print(result)
    except Exception as e:
        print(f"Error connecting to MySQL: {e}")
        print("Make sure the MySQL container is running and the database is set up.")