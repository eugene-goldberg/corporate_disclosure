"""
Script to populate missing data in the corporate database
"""

import pymysql
import os
from dotenv import load_dotenv

load_dotenv()

def execute_sql_file():
    """Execute the SQL file to populate missing data"""
    
    # Database connection
    connection = pymysql.connect(
        host='localhost',
        user='root',
        password='rootpassword',
        database='corporate_data',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
    
    try:
        with connection.cursor() as cursor:
            # Read SQL file
            with open('populate_missing_data.sql', 'r') as f:
                sql_content = f.read()
            
            # Split by semicolon to execute individual statements
            statements = [s.strip() for s in sql_content.split(';') if s.strip() and not s.strip().startswith('--')]
            
            success_count = 0
            error_count = 0
            
            for i, statement in enumerate(statements, 1):
                if statement:
                    try:
                        cursor.execute(statement)
                        connection.commit()
                        success_count += 1
                        print(f"✓ Statement {i} executed successfully")
                    except Exception as e:
                        error_count += 1
                        print(f"✗ Statement {i} failed: {str(e)[:100]}...")
                        connection.rollback()
            
            print(f"\n{'='*60}")
            print(f"Execution Summary:")
            print(f"{'='*60}")
            print(f"Total statements: {len(statements)}")
            print(f"Successful: {success_count}")
            print(f"Failed: {error_count}")
            
            # Verify data was added
            print(f"\n{'='*60}")
            print(f"Verification:")
            print(f"{'='*60}")
            
            tables_to_check = [
                ('stakeholder_engagement', 'COUNT(*)'),
                ('sustainability_targets', 'COUNT(*)'),
                ('community_projects', 'COUNT(*)'),
                ('policies', 'COUNT(*)'),
                ('lobbying_activities', 'COUNT(*)')
            ]
            
            for table, query in tables_to_check:
                cursor.execute(f"SELECT {query} as count FROM {table}")
                result = cursor.fetchone()
                print(f"{table}: {result['count']} records")
    
    except Exception as e:
        print(f"Database connection error: {e}")
    finally:
        connection.close()
        print("\nDatabase connection closed.")

if __name__ == "__main__":
    print("Populating missing data in corporate database...")
    print("="*60)
    execute_sql_file()