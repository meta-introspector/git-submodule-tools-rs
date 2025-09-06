#!/bin/bash

# This script is intended to be sourced to derive LAST_TIMESTAMP.
# It should not be run directly.

# Path to the main files.txt (not used for timestamp derivation anymore, but kept for context if needed elsewhere)
# FILES_TXT_PATH="/data/data/com.termux/files/home/storage/github/files.txt"

# Path for the list of files to be indexed (not used for timestamp derivation anymore, but kept for context if needed elsewhere)
# INDEXED_FILES_LIST_PATH="/data/data/com.termux/files/home/storage/github/files_list_${CURRENT_TIMESTAMP}.txt"

# Get the current timestamp (CURRENT_TIMESTAMP should be set by the calling script)
# CURRENT_TIMESTAMP=$(date +%s)

# Determine LAST_TIMESTAMP from the most recent files_list_*.txt
LAST_TIMESTAMP=0 # Default to 0 (epoch) if no previous files_list_*.txt found

LATEST_INDEXED_FILES_LIST=$(find /data/data/com.termux/files/home/storage/github/ -maxdepth 1 -name "files_list_*.txt" -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n 1 | cut -d' ' -f2-)

if [ -n "$LATEST_INDEXED_FILES_LIST" ]; then
    LAST_TIMESTAMP=$(stat -c %Y "$LATEST_INDEXED_FILES_LIST")
    # echo "Derived LAST_TIMESTAMP from '$LATEST_INDEXED_FILES_LIST': $LAST_TIMESTAMP" # Removed for sourcing
else
    # echo "No previous files_list_*.txt found. Starting with all files." # Removed for sourcing
    : # No operation, LAST_TIMESTAMP remains 0
fi