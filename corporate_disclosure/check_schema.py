"""Check database schema"""

import pymysql

connection = pymysql.connect(
    host='localhost',
    user='root',
    password='rootpassword',
    database='corporate_data',
    charset='utf8mb4'
)

try:
    with connection.cursor() as cursor:
        cursor.execute("DESCRIBE stakeholder_engagement")
        print("stakeholder_engagement table schema:")
        print("-" * 60)
        for row in cursor.fetchall():
            print(row)
finally:
    connection.close()