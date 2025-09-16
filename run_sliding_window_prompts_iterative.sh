#!/usr/bin/env bash

# Standard Operating Procedure: Implement Sliding Window Processing for LLM Prompts (Iterative)

# Objective:
# Enhance the existing script to iteratively process task files, incorporating a "sliding window" mechanism for context management.
# This will allow the LLM to maintain a coherent understanding of ongoing tasks by referencing a defined number of previous responses.
# Each task file will be processed `N` times, with a sliding window of `M` previous responses.

# Parameters:
N=42 # Total number of times gemini-cli should run for each task file
M_VALUES=(2 3 5 7 11 13 19) # Sizes of the sliding window of previous responses

# Ensure the output directory exists
mkdir -p "prompts/output"

# Get the content of the very first task file as initial context
# Assuming the first task file is alphabetically the first one
FIRST_TASK_FILE=$(ls prompts/task_*.md | head -n 1)
INITIAL_CONTEXT=$(cat "${FIRST_TASK_FILE}")

# Iterate through each task file
for task_file in prompts/task_*.md; do
    echo "Processing task file: ${task_file}"

    # Initialize an array to store recent responses for the sliding window
    RECENT_RESPONSES=()

    for ((i=1; i<=N; i++)); do
        echo "  Iteration ${i} for ${task_file}"

        # Determine current M value
        M_INDEX=$(( (i - 1) % ${#M_VALUES[@]} ))
        CURRENT_M=${M_VALUES[${M_INDEX}]}

        # Construct the prompt for gemini-cli
        PROMPT_CONTENT="${INITIAL_CONTEXT}

"
        PROMPT_CONTENT+="--- Current Task File: ${task_file} ---
"
        PROMPT_CONTENT+=$(cat "${task_file}")
        PROMPT_CONTENT+="

"

        # Add sliding window context
        if [ ${#RECENT_RESPONSES[@]} -gt 0 ]; then
            PROMPT_CONTENT+="--- Sliding Window Context (last ${CURRENT_M} responses) ---
"
            # Add responses from RECENT_RESPONSES, up to CURRENT_M, in reverse order (most recent first)
            for ((j=${#RECENT_RESPONSES[@]}-1; j>=0 && j>=${#RECENT_RESPONSES[@]}-${CURRENT_M}; j--)); do
                PROMPT_CONTENT+="${RECENT_RESPONSES[j]}

"
            done
        fi

        # Define output file name
        output_file="${task_file}.out${i}.md"

        # Execute gemini-cli
        # The --prompt flag is used to pass the prompt content directly
        # The --y flag is for auto-yes to prompts
        # The --checkpointing flag is for checkpointing
        # The --include-directories is important for context
        echo -e "${PROMPT_CONTENT}" | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt | tee "${output_file}"

        # Add the new response to RECENT_RESPONSES and trim if necessary
        NEW_RESPONSE=$(cat "${output_file}")
        RECENT_RESPONSES+=("${NEW_RESPONSE}")

        # Trim RECENT_RESPONSES to CURRENT_M elements
        if [ ${#RECENT_RESPONSES[@]} -gt ${CURRENT_M} ]; then
            RECENT_RESPONSES=("${RECENT_RESPONSES[@]:$((${#RECENT_RESPONSES[@]}-${CURRENT_M}))}")
        fi
    done
done
