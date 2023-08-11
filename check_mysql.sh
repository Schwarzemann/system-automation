#!/bin/bash

# Check if MySQL is running
service mysql status > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "MySQL is running."
else
    echo "MySQL is not running, restarting..."
    service mysql restart > /dev/null 2>&1

    # Check if restart was successful
    if [ $? -eq 0 ]; then
        echo "MySQL restarted successfully."
    else
        echo "Failed to restart MySQL."
    fi
fi
