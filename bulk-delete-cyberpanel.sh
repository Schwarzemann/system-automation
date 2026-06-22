#!/bin/bash

DOMAINS_FILE="domains.txt"

if [[ ! -f "$DOMAINS_FILE" ]]; then
    echo "File $DOMAINS_FILE not found!"
    exit 1
fi

while IFS= read -r domain || [[ -n "$domain" ]]; do
    [[ -z "$domain" || "$domain" =~ ^# ]] && continue

    echo "Deleting domain: $domain"
    cyberpanel deleteWebsite --domainName "$domain"

    sleep 2
done < "$DOMAINS_FILE"

echo "Domain deleted"