#!/usr/bin/env bash

N_STEPS=3 # Number of times to run gemini-cli for each task file
M_WINDOW_SIZE=1 # Size of the sliding window of previous responses

for task_file in prompts/task_*.md; do
    echo "Processing task file: ${task_file}"
    base_name=$(basename "${task_file}" .md) # e.g., task_reviewsubmodule

    # The original task file content, which is always included
    original_task_content=$(cat "${task_file}")

    for i in $(seq 1 "${N_STEPS}"); do
        output_file="${task_file}.out${i}.md"
        echo "  Running step ${i}, output to: ${output_file}"

        # Start the prompt with the original task content
        full_gemini_prompt="${original_task_content}"

        # Add previous responses to the prompt, respecting the sliding window
        # We need to collect the last M_WINDOW_SIZE outputs
        # For step 'i', we need outputs from 'i-M_WINDOW_SIZE' to 'i-1'
        start_window=$((i - M_WINDOW_SIZE))
        if [ "${start_window}" -lt 1 ]; then
            start_window=1
        fi

        for j in $(seq "${start_window}" $((i - 1))); do
            prev_output_file="${task_file}.out${j}.md"
            if [ -f "${prev_output_file}" ]; then
                full_gemini_prompt+="

--- Previous Response ${j} ---
"
                full_gemini_prompt+=$(cat "${prev_output_file}")
            fi
        done

        # Execute gemini-cli with the constructed prompt
        echo -e "${full_gemini_prompt}" | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt | tee "${output_file}"
    done
done
