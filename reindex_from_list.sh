#!/bin/bash

# Path to the crate_indexer binary
CRATE_INDEXER_BIN="./target/debug/crate_indexer"

# Ensure the crate_indexer is built
cargo build --package crate_indexer

# Find all files_list_*.txt files
FILES_LIST_TXT_FILES=$(find /data/data/com.termux/files/home/storage/github/ -maxdepth 1 -name "files_list_*.txt" -print)

if [ -z "$FILES_LIST_TXT_FILES" ]; then
    echo "Error: No files_list_*.txt found to reindex from."
    exit 1
fi

for input_file in $FILES_LIST_TXT_FILES;
do
    echo "Reindexing from: $input_file"
    
    # Derive output JSON filename
    filename=$(basename -- "$input_file")
    extension="${filename##*.}"
    filename_no_ext="${filename%.*}"
    output_json_file="/data/data/com.termux/files/home/storage/github/reindexed_${filename_no_ext}.json"
    status_log_file="/data/data/com.termux/files/home/storage/github/reindexed_${filename_no_ext}.log"

    # Define the base path to prepend
    BASE_PATH="/data/data/com.termux/files/home/storage/github/"

    # Create a temporary file with absolute paths
    TEMP_INPUT_FILE=$(mktemp)
    while IFS= read -r line;
    do
        echo "${BASE_PATH}${line}" >> "$TEMP_INPUT_FILE"
    done < "$input_file"

    # Run crate_indexer
    "$CRATE_INDEXER_BIN" --input-file "$TEMP_INPUT_FILE" --output-file "$output_json_file" --status-log-file "$status_log_file"
    
    # Clean up the temporary file
    rm "$TEMP_INPUT_FILE"
    
    echo "Reindexing complete for $input_file. Output to $output_json_file"
done

echo "All reindexing tasks finished."
