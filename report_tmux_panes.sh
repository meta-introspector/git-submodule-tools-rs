#!/bin/bash

# report_tmux_panes.sh
# Iterates through all tmux panes in the 'gemini-agent-session',
# selects each one, reports on the active pane, displays its content,
# and allows the user to stop the process with Ctrl-C.

SESSION_NAME="gemini-agent-session"

echo "Starting pane iteration for session '${SESSION_NAME}'. Press Ctrl-C to stop at any time."
echo "This script is best run from within a tmux session to see the pane selection."

# Get all pane IDs from the target session
PANE_IDS=$(tmux list-panes -t "${SESSION_NAME}" -a -F "#{pane_id}")

for PANE_ID in $PANE_IDS; do
    echo "--- Attempting to select Pane: ${PANE_ID} ---"

    # Select the pane
    tmux select-pane -t "${PANE_ID}"

    # Report on the currently active pane (what tmux thinks is active)
    ACTIVE_PANE_INFO=$(tmux display-message -p '#{pane_id} #{pane_current_command}')
    echo "--- Currently Active Pane (as reported by tmux): ${ACTIVE_PANE_INFO} ---"

    # Capture and display pane content
    tmux capture-pane -p -t "${PANE_ID}"

    echo "--- End of Pane: ${PANE_ID} ---"
    echo "Waiting 2 seconds. Press Ctrl-C to stop."

    trap "echo -e '\nStopping pane iteration.'; exit 0" SIGINT
    if read -t 2 -n 1 -r; then
        continue
    fi
done

echo "Finished iterating through all panes in session '${SESSION_NAME}'."
