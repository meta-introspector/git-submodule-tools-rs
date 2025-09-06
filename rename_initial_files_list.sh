#!/bin/bash

OLD_FILE="/data/data/com.termux/files/home/storage/github/files_list_.txt"

if [ -f "$OLD_FILE" ]; then
    # Get the modification time of the old file in Unix timestamp format
    MOD_TIME_UNIX=$(stat -c %Y "$OLD_FILE")
    
    NEW_FILE="/data/data/com.termux/files/home/storage/github/files_list_${MOD_TIME_UNIX}.txt"

    # Get the modification time of the old file in human-readable format for touch -d
    MOD_TIME_HUMAN=$(stat -c %y "$OLD_FILE")

    # Rename the file
    mv "$OLD_FILE" "$NEW_FILE"

    # Set the modification time of the new file to the old one
    touch -d "$MOD_TIME_HUMAN" "$NEW_FILE"

    echo "Renamed '$OLD_FILE' to '$NEW_FILE' and preserved modification time."
else
    echo "Error: '$OLD_FILE' not found. No rename performed."
fi