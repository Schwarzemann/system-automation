#!/bin/bash

DOMAINS_FILE="domains.txt"
LE_PATH="/etc/letsencrypt/live"

if [[ ! -f "$DOMAINS_FILE" ]]; then
    echo "File $DOMAINS_FILE not found!"
    exit 1
fi

while IFS= read -r domain || [[ -n "$domain" ]]; do
    [[ -z "$domain" || "$domain" =~ ^# ]] && continue

    echo "Processing domain: $domain"

    if [[ -d "$LE_PATH/$domain" ]]; then
        echo "Deleting existing SSL folder for: $domain"
        sudo rm -rf "$LE_PATH/$domain"
    else
        echo "No existing SSL folder found for: $domain"
    fi
	
    echo "Assigning new SSL to: $domain"
    cyberpanel issueSSL --domainName "$domain"

    sleep 2

done < "$DOMAINS_FILE"

echo "Done"