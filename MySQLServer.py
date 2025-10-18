#!/usr/bin/env python3
"""
MySQLServer.py
Creates the database 'alx_book_store' on the MySQL server.
If the database already exists, the script will not fail.
Does NOT use SELECT or SHOW statements.
"""

import mysql.connector
from mysql.connector import Error
import getpass

def create_database(host: str, user: str, password: str, db_name: str = "alx_book_store"):
    """
    Connects to MySQL server and creates the database if it doesn't exist.
    Prints success or error messages. Ensures resources are closed.
    """
    conn = None
    cursor = None
    try:
        # Connect to MySQL server (no database specified)
        conn = mysql.connector.connect(
            host=host,
            user=user,
            password=password,
            autocommit=True  # so CREATE DATABASE is applied immediately
        )
        cursor = conn.cursor()

        # Create database using IF NOT EXISTS so it won't fail if it already exists.
        create_db_sql = (
            "CREATE DATABASE IF NOT EXISTS `{}` "
            "CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
        ).format(db_name)

        cursor.execute(create_db_sql)

        # If we reach here, the CREATE statement executed successfully.
        print(f"Database '{db_name}' created successfully!")

    except Error as err:
        # Handle connection and execution errors
        print("Error: Could not connect to MySQL server or create database.")
        print("MySQL Error:", err)

    finally:
        # Close cursor and connection if they were opened
        if cursor is not None:
            try:
                cursor.close()
            except Exception:
                pass
        if conn is not None and conn.is_connected():
            try:
                conn.close()
            except Exception:
                pass

def main():
    print("Create MySQL database: alx_book_store")
    host = input("MySQL host (default: localhost): ").strip() or "localhost"
    user = input("MySQL user (default: root): ").strip() or "root"
    password = getpass.getpass("MySQL password (will not be shown): ")

    create_database(host=host, user=user, password=password)

if __name__ == "__main__":
    main()
