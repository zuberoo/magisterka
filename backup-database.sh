#!/bin/bash

# Parametry bazy danych
DB_HOST='host'
DB_USER='user'
DB_PASS='pass'
DB_NAME='database'

# Ścieżka do kopii zapasowej
BACKUP_PATH='/path/'
BACKUP_NAME="$DB_NAME-$1.sql" # Przywróć kopię z określonej daty

if [ ! -f $BACKUP_PATH/$BACKUP_NAME ]; then
    echo "Nie znaleziono kopii zapasowej o nazwie $BACKUP_NAME w lokalizacji $BACKUP_PATH"
    exit 1
fi

# Przywracanie kopii zapasowej
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < $BACKUP_PATH/$BACKUP_NAME

echo "Kopia zapasowa $BACKUP_NAME została przywrócona do bazy $DB_NAME"