#!/bin/bash

# Prompt for SSH server address
read -p "Enter SSH Server Address: " SSH_SERVER

# Prompt for SSH port (default is 22)
read -p "Enter SSH Port (default is 22): " SSH_PORT
SSH_PORT=${SSH_PORT:-22}

# Prompt for SSH user
read -p "Enter SSH User: " SSH_USER

# Prompt for SSH key file (optional)
read -p "Enter SSH Key File (leave empty if not using key-based auth): " SSH_KEY

# Prompt for SSH password
read -s -p "Enter SSH Password: " SSH_PASSWORD
echo

# Prompt for the number of SSH connections to create
read -p "Enter the Number of SSH Connections to Create: " NUM_CONNECTIONS

# Function to establish an SSH connection and log the result
establish_connection() {
    if [ -z "$SSH_KEY" ]; then
        result=$(sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no -p "$SSH_PORT" "$SSH_USER"@"$SSH_SERVER" "echo SSH connection established.")
    else
        result=$(sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" -p "$SSH_PORT" "$SSH_USER"@"$SSH_SERVER" "echo SSH connection established.")
    fi
    echo "Connection attempt: $1 - Status: $result"
}

# Loop to create multiple SSH connections
for ((i=1; i<=NUM_CONNECTIONS; i++)); do
    echo "Connecting (Attempt $i)..."
    establish_connection "$i" &
done

# Wait for all background processes to finish
wait

echo "All connections have been established."
