#!/bin/bash

DRY_RUN=false # Set to true for dry run, false for actual execution





# Path to the crate_indexer binary
CRATE_INDEXER_BIN="./target/debug/crate_indexer"

SKIP_CARGO_BUILD=false # Set to true to skip cargo build

# Ensure the crate_indexer is built
if [ "$SKIP_CARGO_BUILD" = false ]; then
    cargo build --package crate_indexer
fi

# Get the current timestamp
CURRENT_TIMESTAMP=$(date +%s)

# Source the LAST_TIMESTAMP derivation logic from test.sh
source "/data/data/com.termux/files/home/storage/github/git-submodule-tools/test.sh"

# Define the output JSON file with a timestamp
INDEXED_FILES_LIST_PATH="/data/data/com.termux/files/home/storage/github/files_list_${CURRENT_TIMESTAMP}.txt"
OUTPUT_JSON_FILE="/data/data/com.termux/files/home/storage/github/files_${CURRENT_TIMESTAMP}.json"

if (( LAST_TIMESTAMP > 0 )); then
    echo "Finding files newer than $LAST_TIMESTAMP in the directory..."
    
    # Convert Unix timestamp to a date string for find -newermt
    LAST_DATE_STRING=$(date -d @"$LAST_TIMESTAMP" "+%Y-%m-%d %H:%M:%S")

    # Find files newer than the last timestamp and output to INDEXED_FILES_LIST_PATH
    if [ "$DRY_RUN" = true ]; then
        FIND_CMD="find /data/data/com.termux/files/home/storage/github/ -type f -newermt \"$LAST_DATE_STRING\" > \"/data/data/com.termux/files/home/storage/github/files_list_${CURRENT_TIMESTAMP}.txt\""
        printf "DRY RUN: %s\n" "$FIND_CMD"
    else
        find /data/data/com.termux/files/home/storage/github/ -type f -newermt "$LAST_DATE_STRING" > "$INDEXED_FILES_LIST_PATH"
    fi
    
    
else
    if [ "$DRY_RUN" = true ]; then
        FIND_CMD="find /data/data/com.termux/files/home/storage/github/ -type f  > \"${INDEXED_FILES_LIST_PATH}\""
        printf "DRY RUN: %s\n" "$FIND_CMD"
    else
        find /data/data/com.termux/files/home/storage/github/ -type f  > "$INDEXED_FILES_LIST_PATH"
    fi
    
    echo "No previous timestamp found. Indexing all files from the directory."
    echo "Processing all files from the directory..."
    echo "All files indexed and output to $OUTPUT_JSON_FILE"
fi

# Process the indexed files if any were found
if [ -s "$INDEXED_FILES_LIST_PATH" ]; then
    echo "Processing indexed files..."
    # Run crate_indexer
    if [ "$DRY_RUN" = true ]; then
        CRATE_INDEXER_CMD="${CRATE_INDEXER_BIN} --input-file \"${INDEXED_FILES_LIST_PATH}\" --output-file \"${OUTPUT_JSON_FILE}\""
        printf "DRY RUN: %s\n" "$CRATE_INDEXER_CMD"
    else
        "$CRATE_INDEXER_BIN" --input-file "$INDEXED_FILES_LIST_PATH" --output-file "$OUTPUT_JSON_FILE"
    fi
    echo "Files indexed and output to $OUTPUT_JSON_FILE"
else
    echo "No files found to process."
fi

echo "Script finished."
