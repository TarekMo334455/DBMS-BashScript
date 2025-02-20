#!/bin/bash

DB_PATH="./databases"
mkdir -p "$DB_PATH"

while true; do
    echo "========== Main Menu =========="
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Connect To Database"
    echo "4) Drop Database"
    echo "5) Exit"
    echo "================================"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter database name: " db_name
            if [[ -z "$db_name" ]]; then
                echo "Database name cannot be empty!"
            elif [[ -d "$DB_PATH/$db_name" ]]; then
                echo "Database '$db_name' already exists!"
            else
                mkdir "$DB_PATH/$db_name"
                echo "Database '$db_name' created successfully."
            fi
            ;;
        2)
            echo "Available Databases:"
            ls "$DB_PATH"
            ;;
        3)
            read -p "Enter database name to connect: " db_name
            if [[ -d "$DB_PATH/$db_name" ]]; then
                echo "Connected to '$db_name'."
                while true; do
                    echo "##### Connected to $db_name #####"
                    echo "1) Create Table"
                    echo "2) List Tables"
                    echo "3) Drop Table"
                    echo "4) Insert into Table"
                    echo "5) Select From Table"
                    echo "6) Delete From Table"
                    echo "7) Update Table"
                    echo "8) Back to Main Menu"
                    read -p "Choose an option: " db_choice
                    case $db_choice in
                        1)
                            read -p "Enter table name: " tablename
                            if [[ -f "$DB_PATH/$db_name/$tablename" ]]; then
                                echo "Table already exists!"
                            else
                                read -p "Enter column names (comma separated): " columns
                                echo "$columns" > "$DB_PATH/$db_name/$tablename"
                                echo "Table '$tablename' created."
                            fi
                            ;;
                        2)
                            echo "Tables in $db_name:"
                            ls "$DB_PATH/$db_name"
                            ;;
                        3)
                            read -p "Enter table name to drop: " tablename
                            if [[ -f "$DB_PATH/$db_name/$tablename" ]]; then
                                rm "$DB_PATH/$db_name/$tablename"
                                echo "Table '$tablename' deleted."
                            else
                                echo "Table does not exist!"
                            fi
                            ;;
                        4)
                            read -p "Enter table name: " tablename
                            if [[ -f "$DB_PATH/$db_name/$tablename" ]]; then
                                read -p "Enter values (comma separated): " values
                                echo "$values" >> "$DB_PATH/$db_name/$tablename"
                                echo "Data inserted into '$tablename'."
                            else
                                echo "Table does not exist!"
                            fi
                            ;;
                        5)
                            read -p "Enter table name: " tablename
                            if [[ -f "$DB_PATH/$db_name/$tablename" ]]; then
                                cat "$DB_PATH/$db_name/$tablename"
                            else
                                echo "Table does not exist!"
                            fi
                            ;;
                        6)
                            read -p "Enter table name: " tablename
                            if [[ -f "$DB_PATH/$db_name/$tablename" ]]; then
                                read -p "Enter value to delete: " del_value
                                grep -v "$del_value" "$DB_PATH/$db_name/$tablename" > "$DB_PATH/$db_name/tempfile" && mv "$DB_PATH/$db_name/tempfile" "$DB_PATH/$db_name/$tablename"
                                echo "Data deleted from '$tablename'."
                            else
                                echo "Table does not exist!"
                            fi
                            ;;
                        7)
                            read -p "Enter table name: " tablename
                            if [[ -f "$DB_PATH/$db_name/$tablename" ]]; then
                                read -p "Enter old value: " old_value
                                read -p "Enter new value: " new_value
                                sed -i "s/$old_value/$new_value/g" "$DB_PATH/$db_name/$tablename"
                                echo "Data updated in '$tablename'."
                            else
                                echo "Table does not exist!"
                            fi
                            ;;
                        8)
                            break
                            ;;
                        *)
                            echo "Invalid option!"
                            ;;
                    esac
                done
            else
                echo "Database '$db_name' does not exist!"
            fi
            ;;
        4)
            read -p "Enter database name to drop: " db_name
            if [[ -d "$DB_PATH/$db_name" ]]; then
                read -p "Are you sure you want to delete '$db_name'? (y/n): " confirm
                if [[ "$confirm" == "y" ]]; then
                    rm -rf "$DB_PATH/$db_name"
                    echo "Database '$db_name' deleted successfully."
                else
                    echo "Operation cancelled."
                fi
            else
                echo "Database '$db_name' does not exist!"
            fi
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
