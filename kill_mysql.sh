#!/bin/bash

# Get a list of MySQL process IDs
processes=$(pgrep mysqld)

# Check if any processes were found
if [ -z "$processes" ]; then
    echo "No MySQL processes found."
    exit 0
fi

# Kill each MySQL process
for pid in $processes; do
    echo "Killing MySQL process with PID $pid..."
    kill -9 $pid
done

echo "All MySQL processes killed."
