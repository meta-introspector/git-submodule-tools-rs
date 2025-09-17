#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
N=3 # Sliding window size: number of previous responses to include
PROJECT_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/"
PICK_UP_NIX2_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2/"

GEMINI_CLI_COMMAND="nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=${PROJECT_ROOT},${PICK_UP_NIX2_ROOT} --model gemini-2.5-flash --y --checkpointing --prompt"

# --- Store Global Initial Context (First Task File) ---
first_task_file_content=""
first_task_file_found=false
declare -a task_files_to_process # Array to store paths of actual task files

# Find all reviewsubmodule*.md files, excluding .out files
while IFS= read -r -d $'\0' file; do
    if [[ "$file" != *.out*.md ]]; then
        task_files_to_process+=("$file")
    fi
done < <(find "${PROJECT_ROOT}prompts/" -maxdepth 1 -name "reviewsubmodule*.md" -print0 | sort -z)

if [ ${#task_files_to_process[@]} -eq 0 ]; then
    echo "Error: No 'reviewsubmodule*.md' task files found in ${PROJECT_ROOT}prompts/ to establish initial context."
    exit 1
fi

# Get the first task file for global initial context
first_task_file_path="${task_files_to_process[0]}"
echo "Reading global initial context from: ${first_task_file_path}"
first_task_file_content=$(cat "${first_task_file_path}")

# --- Process Task Files Iteratively with Sliding Window ---
declare -a previous_responses # Array to store N previous responses

for task_file_path in "${task_files_to_process[@]}"; do
    task_file_name=$(basename "${task_file_path}")
    echo "--- Processing task file: ${task_file_name} ---"

    prompt_parts=()
    prompt_parts+=("$(cat "${PROJECT_ROOT}prompt.md")") # General prompt context
    prompt_parts+=("---")
    prompt_parts+=("Global Initial Context (from ${first_task_file_path})")
    prompt_parts+=("${first_task_file_content}") # Global initial context
    prompt_parts+=("---")
    prompt_parts+=("Current Task File (${task_file_name})")
    prompt_parts+=("$(cat "${task_file_path}")") # Current task file content

    # Add sliding window responses (oldest first)
    if (( ${#previous_responses[@]} > 0 )); then
        prompt_parts+=("---")
        prompt_parts+=("Sliding Window Context (Previous Responses)")
        for (( j=0; j<${#previous_responses[@]}; j++ )); do
            prompt_parts+=("---")
            prompt_parts+=(Response "$((j+1))")
            prompt_parts+=("${previous_responses[$j]}")
        done
    fi

    # Join prompt parts with newlines
    IFS=
