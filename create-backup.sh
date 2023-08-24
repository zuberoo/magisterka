#!/bin/bash

# Parametry bazy danych
DB_HOST='host'
DB_USER='user'
DB_PASS='pass'
DB_NAME='database'

# Data, która zostanie dodana do nazwy pliku kopii zapasowej
DATE=$(date +%Y-%m-%d)

# Ścieżka, w której zostanie zapisana kopia zapasowa
BACKUP_PATH='/path/'
BACKUP_NAME="$DB_NAME-$DATE.sql"

# Utworzenie kopii zapasowej
mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_PATH/$BACKUP_NAME

echo "Kopia zapasowa $DB_NAME została stworzona w $BACKUP_PATH/$BACKUP_NAME"