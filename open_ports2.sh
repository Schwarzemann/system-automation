#!/bin/bash

# Specify the file containing the list of ports
PORTS_FILE="ports.txt"

read -p "Which firewall tool are you using (iptables, ufw, firewalld)? " FIREWALL_TOOL

# Function to check and open port for iptables
iptables_check_and_open() {
    local port=$1
    if ! iptables -n -L | grep "\b$port\b" &> /dev/null; then
        iptables -A INPUT -p tcp --dport $port -j ACCEPT
        echo "Opened port $port using iptables"
    else
        echo "Port $port is already open in iptables"
    fi
}

# Function to check and open port for ufw
ufw_check_and_open() {
    local port=$1
    if ! ufw status | grep "\b$port\b" &> /dev/null; then
        ufw allow $port/tcp
        echo "Opened port $port using ufw"
    else
        echo "Port $port is already open in ufw"
    fi
}

# Function to check and open port for firewalld
firewalld_check_and_open() {
    local port=$1
    if ! firewall-cmd --list-ports | grep "\b$port\b" &> /dev/null; then
        firewall-cmd --add-port=$port/tcp --permanent
        firewall-cmd --reload
        echo "Opened port $port using firewalld"
    else
        echo "Port $port is already open in firewalld"
    fi
}

# Read and process each port from the file
while IFS= read -r port; do
    if ! [[ $port =~ ^[0-9]+$ ]]; then
        echo "Skipping invalid line: $port"
        continue
    fi

    case $FIREWALL_TOOL in
        iptables)
            iptables_check_and_open $port
            ;;
        ufw)
            ufw_check_and_open $port
            ;;
        firewalld)
            firewalld_check_and_open $port
            ;;
        *)
            echo "Invalid firewall tool. Exiting."
            exit 1
            ;;
    esac
done < "$PORTS_FILE"

echo "Done!"
