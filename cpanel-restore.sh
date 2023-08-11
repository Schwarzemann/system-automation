#!/bin/bash

# Define the directory where the backup files are located
BACKUP_DIR="/path/to/your/backup/directory"

# Change to the backup directory
cd "$BACKUP_DIR"

# Loop over each backup file and restore it
for backup_file in cpmove-*.tar.gz; do
    echo "Restoring $backup_file..."
    /scripts/restorepkg "$backup_file"
    echo "$backup_file restored."
done

echo "All accounts have been restored!"
