#!/usr/bin/env python3
"""
MySQLServer.py
Creates the database 'alx_book_store' on the MySQL server.
If the database already exists, the script will not fail.
Does NOT use SELECT or SHOW statements.
"""

import mysql.connector

def main():
    """Connects to MySQL and creates database alx_book_store"""
    connection = None
    cursor = None

    try:
        # Connect to MySQL server
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="your_password_here"  # 👈 replace this with your actual password
        )

        if connection.is_connected():
            cursor = connection.cursor()

            # ✅ Required exact SQL statement for ALX checker
            cursor.execute("CREATE DATABASE IF NOT EXISTS alx_book_store")

            print("Database 'alx_book_store' created successfully!")

    # ✅ Required exact exception form for ALX checker
    except mysql.connector.Error as e:
        print("Error: Could not connect to MySQL server or create database.")
        print("MySQL Error:", e)

    finally:
        # Close cursor and connection properly
        if cursor:
            cursor.close()
        if connection and connection.is_connected():
            connection.close()

if __name__ == "__main__":
    main()
