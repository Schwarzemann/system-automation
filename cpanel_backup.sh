#!/bin/bash

# Path to the input file containing cPanel usernames, one per line
FILE="/path/to/usernames.txt"

# Destination directory for backups
BACKUP_DIR="/path/to/backup/directory"

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

# Read the file line by line
while IFS= read -r user; do
    echo "Backing up user: $user"
    /scripts/pkgacct "$user" "$BACKUP_DIR"
done < "$FILE"

echo "All backups completed."
