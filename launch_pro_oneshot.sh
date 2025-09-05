#!/bin/bash

# launch_pro_oneshot.sh
# Launches the "pro" model in a new tmux pane with a specific oneshot task.

SESSION_NAME="gemini-agent-session" # Assuming the main session name
PANE_TARGET="${SESSION_NAME}:." # Target the current window, new pane

# Check if the tmux session exists, create it if not
if ! tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
    echo "Tmux session '${SESSION_NAME}' not found. Creating it..."
    tmux new-session -d -s "${SESSION_NAME}"
    echo "Session '${SESSION_NAME}' created."
fi

# Define the path to the prompt file
PROMPT_FILE="/data/data/com.termux/files/home/storage/github/git-submodule-tools/prompts/pro_oneshot_task.md"

# Define the output log file
OUTPUT_LOG_DIR="/data/data/com.termux/files/home/storage/github/git-submodule-tools/docs/recordings"
OUTPUT_LOG_FILE="${OUTPUT_LOG_DIR}/pro_oneshot_output_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "${OUTPUT_LOG_DIR}" # Ensure the directory exists

# Command to execute the "pro" model with the prompt from the file and tee its output
# The `cat` command pipes the content of the prompt file to gemini's stdin.
PRO_MODEL_COMMAND="cat ${PROMPT_FILE} | gemini --model gemini-2.5-pro -p - | tee ${OUTPUT_LOG_FILE}"

echo "Launching pro model in new tmux pane..."

# Create a new pane (vertical split by default) and capture its ID
NEW_PANE_ID=$(tmux split-window -P -F "#{pane_id}" -t "${PANE_TARGET}")

# Send the command to the new pane and execute it
tmux send-keys -t "${NEW_PANE_ID}" "${PRO_MODEL_COMMAND}" C-m

echo "Pro model launched in new tmux pane. Output is being logged to ${OUTPUT_LOG_FILE}"
echo "You may need to switch to the new pane using Ctrl-b <arrow-key>."
