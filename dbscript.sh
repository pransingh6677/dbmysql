#!/bin/bash

# Set database credentials
DB_USER="your_mysql_user"
DB_PASSWORD="your_mysql_password"
DB_NAME="your_database_name"

# Directory containing the .sql files in the repo
SQL_DIR="pran"

# Clone the latest code from the Git repository (this is done automatically by Jenkins if configured properly)
# cd $WORKSPACE
# git pull

# Fetch the latest changes from GitHub
git fetch --all

# Get the list of modified or newly added .sql files in the 'pran' directory
MODIFIED_SQL_FILES=$(git diff --name-only HEAD HEAD~1 | grep "^$SQL_DIR/.*\.sql$")

if [ -z "$MODIFIED_SQL_FILES" ]; then
  echo "No SQL file changes detected in the 'pran' directory."
  exit 0
fi

echo "Found SQL files with changes: $MODIFIED_SQL_FILES"

# Loop through each modified SQL file and run them
for sql_file in $MODIFIED_SQL_FILES; do
  echo "Running SQL file: $sql_file"
  mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < $sql_file
  
  if [ $? -ne 0 ]; then
    echo "Error running SQL file: $sql_file"
    exit 1
  else
    echo "Successfully ran: $sql_file"
  fi
done

echo "SQL file execution completed."
