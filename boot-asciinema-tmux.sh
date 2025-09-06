#!/bin/bash

# boot-asciinema-tmux.sh
# Wraps the tmux boot process in an asciinema recording.

SESSION_NAME="gemini-recorded-session"
RECORDING_DIR="/data/data/com.termux/files/home/storage/github/git-submodule-tools/docs/recordings"
RECORDING_FILE="${RECORDING_DIR}/gemini_boot_$(date +%Y%m%d_%H%M%S).cast"

mkdir -p "${RECORDING_DIR}"

echo "Starting asciinema recording to: ${RECORDING_FILE}"
echo "Launching tmux session: ${SESSION_NAME}"

# The command to be executed inside tmux
# We need to escape the double quotes within the -i argument for the inner gemini command.
#TMUX_INNER_COMMAND='./boot.sh'
TMUX_INNER_COMMAND='gemini --model gemini-2.5-flash --checkpointing=true --include-directories ~/storage/github -i "Read this file @boot.md"'

# Start asciinema recording, and inside it, start/attach to a tmux session.
# The tmux session will then execute the gemini command.
# The 'bash -c' is used to ensure the inner command is executed correctly within tmux.
asciinema rec "${RECORDING_FILE}" --command "tmux new-session -A -s \"${SESSION_NAME}\" \; send-keys -t \"${SESSION_NAME}\" \"${TMUX_INNER_COMMAND}\" C-m"

echo "Recording finished. To play: asciinema play ${RECORDING_FILE}"

# Optional: Attach to the session if it's still running (e.g., if asciinema was stopped prematurely)
# tmux attach-session -t "${SESSION_NAME}"
