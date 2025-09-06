#!/bin/bash

# boot-tmux.sh
# Starts a new tmux session and runs a gemini command inside it.

SESSION_NAME="gemini-agent-session"

echo "Starting tmux session: ${SESSION_NAME}"

# Create a new detached tmux session
tmux new-session -d -s "${SESSION_NAME}"

# Send the gemini command to the tmux session
# The command is taken from ~/storage/github/rustc/sessions/tmux/boot.sh
# We need to escape the double quotes within the -i argument.
TMUX_COMMAND='gemini --model gemini-2.5-flash --checkpointing=true --include-directories ~/storage/github -i "Read this file @boot.md"'
tmux send-keys -t "${SESSION_NAME}" "${TMUX_COMMAND}" C-m

echo "Gemini command sent to tmux session. Attaching to session..."

# Attach to the tmux session
tmux attach-session -t "${SESSION_NAME}"
