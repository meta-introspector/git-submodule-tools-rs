#!/bin/bash

# find_tmux_pane.sh
# Iterates through all tmux panes in the 'gemini-agent-session',
# displays their content, and allows the user to stop the process with Ctrl-C.

SESSION_NAME="gemini-agent-session"

echo "Starting pane iteration for session '${SESSION_NAME}'. Press Ctrl-C to stop at any time."
echo "This script is best run from within a tmux session to see the pane selection."

# Get all pane IDs from the target session
# Use -t to specify the session, and -F to format the output to just pane_id
PANE_IDS=$(tmux list-panes -t "${SESSION_NAME}" -a -F "#{pane_id}")

for PANE_ID in $PANE_IDS; do
    echo "--- Displaying Pane: ${PANE_ID} ---"

    # Select the pane (this will visually switch the pane if run inside tmux)
    tmux select-pane -t "${PANE_ID}"

    # Capture and display pane content
    tmux capture-pane -p -t "${PANE_ID}"

    echo "--- End of Pane: ${PANE_ID} ---"
    echo "Waiting 2 seconds. Press Ctrl-C to stop."

    # Wait for 2 seconds or until Ctrl-C is pressed
    # The `read -t` command will return non-zero if it times out.
    # `trap` is used to catch SIGINT (Ctrl-C)
    trap "echo -e '\nStopping pane iteration.'; exit 0" SIGINT
    if read -t 2 -n 1 -r; then
        # User pressed a key, but we only care about Ctrl-C handled by trap
        # So, just continue to the next pane if no Ctrl-C
        continue
    fi
done

echo "Finished iterating through all panes in session '${SESSION_NAME}'."