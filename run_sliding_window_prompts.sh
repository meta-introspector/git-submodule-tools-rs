#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
N=42 # Total number of times gemini-cli should run for each task file
M_values=(2 3 5 7 11 13 19) # Sliding window sizes
num_m_phases=${#M_values[@]}
# Calculate iterations per M phase. If N is not perfectly divisible, the last phase will have more iterations.
iterations_per_m_phase=$((N / num_m_phases))
if (( N % num_m_phases != 0 )); then
    iterations_per_m_phase=$((iterations_per_m_phase + 1))
fi

# Absolute paths for include directories
PROJECT_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/"
PICK_UP_NIX2_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2/"

GEMINI_CLI_COMMAND="nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=${PROJECT_ROOT},${PICK_UP_NIX2_ROOT} --model gemini-2.5-flash --y --checkpointing --prompt"

# --- Store Global Initial Context (First Task File) ---
first_task_file_content=""
first_task_file_found=false

# Find the first task file lexicographically
for task_file_path in "${PROJECT_ROOT}prompts/task_*.md"; do
    if [ "$first_task_file_found" = false ]; then
        echo "Reading global initial context from: ${task_file_path}"
        first_task_file_content=$(cat "${task_file_path}")
        first_task_file_found=true
    fi
    break # Only read the first one
done

if [ "$first_task_file_found" = false ]; then
    echo "Error: No task files found in ${PROJECT_ROOT}prompts/task_*.md to establish initial context."
    exit 1
fi

# --- Process Task Files Iteratively with Sliding Window ---
# Iterate through task files in the PROJECT_ROOT
for task_file_path in "${PROJECT_ROOT}prompts/task_*.md"; do
    # Extract just the filename for display purposes
    task_file_name=$(basename "${task_file_path}")
    echo "--- Processing task file: ${task_file_name} ---"
    previous_responses=() # Array to store M previous responses for the current task file, chronologically ordered

    for i in $(seq 1 $N); do
        # Determine current M value based on iteration
        current_m_index=$(((i - 1) / iterations_per_m_phase))
        if (( current_m_index >= num_m_phases )); then
            current_m_index=$((num_m_phases - 1)) # Cap index to the last M value
        fi
        current_m=${M_values[$current_m_index]}

        echo "  Iteration ${i}/${N} for ${task_file_name} (Sliding Window M=${current_m})"

        prompt_parts=()
        prompt_parts+=("$(cat "${task_file_path}")") # Current task file content
        prompt_parts+=("--- Global Initial Context ---")
        prompt_parts+=("${first_task_file_content}") # Global initial context

        # Add sliding window responses (oldest first)
        if (( ${#previous_responses[@]} > 0 )); then
            prompt_parts+=("--- Sliding Window Context (Previous Responses) ---")
            start_index=$(( ${#previous_responses[@]} - current_m ))
            if (( start_index < 0 )); then
                start_index=0
            fi
            for (( j=start_index; j<${#previous_responses[@]}; j++ )); do
                prompt_parts+=("--- Response $((j+1)) ---")
                prompt_parts+=("${previous_responses[$j]}")
            done
        fi

        # Join prompt parts with newlines
        IFS=$'
'
        prompt_content="${prompt_parts[*]}"
        unset IFS

        output_file="${task_file_path}.out${i}.md"

        # Create temporary files for prompt input and output capture
        temp_prompt_file=$(mktemp)
        temp_output_capture_file=$(mktemp)

        echo -e "${prompt_content}" > "${temp_prompt_file}"

        echo "    Running gemini-cli for iteration ${i}..."
        # Execute gemini-cli, piping prompt content and capturing output
        # Redirect stderr to stdout for capturing all output, then check exit code
        if ! cat "${temp_prompt_file}" | $GEMINI_CLI_COMMAND > "${temp_output_capture_file}" 2>&1; then
            echo "Error running gemini-cli for ${task_file_name}, iteration ${i}."
            echo "Full output from gemini-cli:"
            cat "${temp_output_capture_file}"
            rm "${temp_prompt_file}" "${temp_output_capture_file}"
            exit 1
        fi

        # Tee the captured output to the final output file
        cat "${temp_output_capture_file}" | tee "${output_file}"

        # Read the captured output into a variable for the sliding window
        current_response=$(cat "${temp_output_capture_file}")

        # Clean up temporary files
        rm "${temp_prompt_file}" "${temp_output_capture_file}"

        # Add current_response to previous_responses
        previous_responses+=("${current_response}")

        # Trim previous_responses to current_m elements
        if (( ${#previous_responses[@]} > current_m )); then
            previous_responses=("${previous_responses[@]:$((${#previous_responses[@]} - current_m))}")
        fi
    done
    echo "--- Finished processing task file: ${task_file_name} ---"
done

echo "All task files processed."