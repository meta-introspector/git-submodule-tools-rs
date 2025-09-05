#!/bin/bash

# show_session_in_pane.sh
# Splits the current tmux window and displays a specified tmux session
# in the new pane by linking a new tmux instance to it.
# This script must be run from within a tmux session.

TARGET_SESSION="$1"

if [ -z "${TARGET_SESSION}" ]; then
    echo "Usage: $0 <target_session_name>"
    echo "Example: $0 gemini-agent-session"
    exit 1
fi

echo "Splitting current window and attempting to display session '${TARGET_SESSION}' in the new pane..."

# Create a new pane (vertical split by default) and capture its ID
NEW_PANE_ID=$(tmux split-window -P -F "#{pane_id}")

# In the new pane, start a new tmux instance linked to the target session
# We use a temporary session name to avoid conflicts
tmux send-keys -t "${NEW_PANE_ID}" "tmux new-session -s temp-linked-${TARGET_SESSION} -t ${TARGET_SESSION}" C-m

echo "Window split. Session '${TARGET_SESSION}' should now be displayed in the new pane."
echo "Use Ctrl-b <arrow-key> to navigate between panes."
echo "To close the linked session in the pane, you can type 'exit' or 'Ctrl-d' in that pane."
