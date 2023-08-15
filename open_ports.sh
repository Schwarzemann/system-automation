#!/bin/bash

# Specify the file containing the list of ports
PORTS_FILE="ports.txt"

# Function to check if a port is already open in iptables
is_port_open() {
    local port=$1
    iptables -n -L | grep "\b$port\b" &> /dev/null
    return $?
}

# Check each port from the file
while IFS= read -r port; do
    # Skip any lines that don't look like port numbers
    if ! [[ $port =~ ^[0-9]+$ ]]; then
        echo "Skipping invalid line: $port"
        continue
    fi

    # Check if port is open, and if not, open it
    if ! is_port_open $port; then
        echo "Opening port $port"
        iptables -A INPUT -p tcp --dport $port -j ACCEPT
    else
        echo "Port $port is already open"
    fi
done < "$PORTS_FILE"

# Save the iptables configuration
service iptables save

echo "Done!"
