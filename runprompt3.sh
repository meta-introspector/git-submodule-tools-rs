#!/usr/bin/env bash

DRY_RUN=false
VERBOSE=false

# Parse command-line options
while getopts "dv" opt;
do
  case $opt in
    d) DRY_RUN=true ;; 
    v) VERBOSE=true ;; 
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;; 
  esac
done
shift $((OPTIND-1)) # Shift positional parameters past the options

# If a task file is provided as an argument, process only that file.
# Otherwise, process all task files matching the pattern.
SPECIFIC_TASK_FILE="$1"
FILTER_PATTERN="$2"
TEMP_TASK_FILES=()

if [ -n "${SPECIFIC_TASK_FILE}" ]; then
    TEMP_TASK_FILES=("${SPECIFIC_TASK_FILE}")
else
    # If no specific task file is provided, use the default pattern
    for f in prompts/[Tt]ask_*.md; do
        TEMP_TASK_FILES+=("$f")
    done
fi

TASK_FILES=()
if [ -n "${FILTER_PATTERN}" ]; then
    for f in "${TEMP_TASK_FILES[@]}"; do
        # Use bash's pattern matching for glob filtering
        if [[ "$f" == $FILTER_PATTERN ]]; then
            TASK_FILES+=("$f")
        fi
    done
else
    # No filter pattern, use all collected task files
    TASK_FILES=("${TEMP_TASK_FILES[@]}")
fi

# Handle case where no task files are found after filtering
if [ ${#TASK_FILES[@]} -eq 0 ]; then
    echo "No task files found matching the criteria. Exiting."
    exit 1
fi

for x in "${TASK_FILES[@]}";
do
   if ${VERBOSE}; then echo "Processing task file: ${x}"; fi

   # Extract task name (without .md extension)
   TASK_BASE_NAME=$(basename "${x}" .md)
   OUTPUT_DIR="prompts/${TASK_BASE_NAME}/outputs"
   
   # Create output directory if it doesn't exist
   if ${DRY_RUN}; then
       if ${VERBOSE}; then echo "DRY RUN: Would create output directory: ${OUTPUT_DIR}"; fi
   else
       mkdir -p "${OUTPUT_DIR}"
       if ${VERBOSE}; then echo "Created output directory: ${OUTPUT_DIR}"; fi
   fi

   # Generate a timestamp for the output file
   TIMESTAMP=$(date +%Y%m%d_%H%M%S)
   OUTPUT_FILE="${OUTPUT_DIR}/out_${TIMESTAMP}.md"
   if ${VERBOSE}; then echo "Output will be written to: ${OUTPUT_FILE}"; fi

   PRELUDE_FILE="prompts/prelude.md"
   TASK_FILE="${x}"

   if [ ! -f "${PRELUDE_FILE}" ]; then
       echo "Error: Prelude file not found at ${PRELUDE_FILE}. Skipping task ${TASK_FILE}."
       continue
   fi

   if [ ! -f "${TASK_FILE}" ]; then
       echo "Error: Task file not found at ${TASK_FILE}. Skipping task." 
       continue
   fi

   # Check if PRELUDE_FILE is empty
   if [ ! -s "${PRELUDE_FILE}" ]; then
       echo "Warning: Prelude file ${PRELUDE_FILE} is empty. Skipping task ${TASK_FILE}."
       continue
   fi

   # Check if TASK_FILE is empty
   if [ ! -s "${TASK_FILE}" ]; then
       echo "Warning: Task file ${TASK_FILE} is empty. Skipping task."
       continue
   fi

   MERGED_OUTPUTS=""
   # Find and merge previous output files for this task
   # Sort by timestamp (oldest first)
   PREV_OUTPUT_FILES=$(ls -v "${OUTPUT_DIR}"/out_*.md 2>/dev/null)
   if ${VERBOSE} && [ -n "${PREV_OUTPUT_FILES}" ]; then echo "Found previous output files in ${OUTPUT_DIR}: ${PREV_OUTPUT_FILES}"; fi

   for prev_output_file in ${PREV_OUTPUT_FILES};
   do
       if [ -s "${prev_output_file}" ]; then
           MERGED_OUTPUTS+="\n--- Previous Output from ${prev_output_file} ---"
           MERGED_OUTPUTS+=$(cat "${prev_output_file}")
           MERGED_OUTPUTS+="\n--- End Previous Output ---"
           if ${VERBOSE}; then echo "Merged content from ${prev_output_file}"; fi
       fi
   done

   # If there are merged outputs, add a header
   if [ -n "${MERGED_OUTPUTS}" ]; then
       MERGED_OUTPUTS="\n--- Merged Previous Outputs ---"${MERGED_OUTPUTS}"\n--- End Merged Previous Outputs ---"
       if ${VERBOSE}; then echo "Constructed merged outputs block."; fi
   fi

   POSTLUDE_FILE="prompts/postlude.md"
   SCRIPT_INFO_FILE="prompts/script_info.md"
   COMMAND_TO_RUN="cat \"${PRELUDE_FILE}\" \"${SCRIPT_INFO_FILE}\" <(echo -e \"${MERGED_OUTPUTS}\") \"${TASK_FILE}\" \"${POSTLUDE_FILE}\" | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt | tee \"${OUTPUT_FILE}\""

   if ${DRY_RUN}; then
       echo "DRY RUN: Would execute command:"
       echo "${COMMAND_TO_RUN}"
   else
       if ${VERBOSE}; then echo "Executing command:"; echo "${COMMAND_TO_RUN}"; fi
       eval "${COMMAND_TO_RUN}"
   fi
done