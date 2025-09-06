#!/bin/bash

LOG_DIR="/data/data/com.termux/files/home/storage/github/"
LOG_FILES=$(find "$LOG_DIR" -maxdepth 1 -name "reindexed_files_list_*.log" -print)

if [ -z "$LOG_FILES" ]; then
    echo "No reindexed_files_list_*.log files found in $LOG_DIR."
    exit 0
fi

TOTAL_PROCESSED=0
TOTAL_ERRORS=0
DECLARE -A UNIQUE_ERRORS

echo "--- Reindexing Log Analysis ---"

for log_file in $LOG_FILES;
do
    echo "\nAnalyzing: $(basename "$log_file")"
    
    PROCESSED_COUNT=$(grep -c "^PROCESSED:" "$log_file")
    ERROR_COUNT=$(grep -c "^ERROR:" "$log_file")
    
    echo "  Processed files: $PROCESSED_COUNT"
    echo "  Errors: $ERROR_COUNT"
    
    TOTAL_PROCESSED=$((TOTAL_PROCESSED + PROCESSED_COUNT))
    TOTAL_ERRORS=$((TOTAL_ERRORS + ERROR_COUNT))
    
    # Extract unique error messages
    grep "^ERROR:" "$log_file" | while IFS= read -r line;
do
        ERROR_MESSAGE=$(echo "$line" | sed -E 's/^ERROR:.*?: (.*)$/\1/')
        UNIQUE_ERRORS["$ERROR_MESSAGE"]=1
done

done

echo "\n--- Overall Summary ---"
echo "Total Processed Files: $TOTAL_PROCESSED"
echo "Total Errors: $TOTAL_ERRORS"

if [ ${#UNIQUE_ERRORS[@]} -gt 0 ]; then
    echo "\nUnique Error Messages:"
    for error_msg in "${!UNIQUE_ERRORS[@]}";
    do
        echo "- $error_msg"
    done
else
    echo "No unique error messages."
fi

echo "--- Analysis Complete ---"
