#!/bin/bash

# find_tmux_session.sh
# Iterates through all tmux sessions, switches to each one,
# displays the content of its active pane, and allows the user to stop with Ctrl-C.

echo "Starting session iteration. Press Ctrl-C to stop at any time."
echo "This script will switch your active tmux session. You will see the content of each session's active pane."
echo "To return to your original session, you may need to manually switch back after the script finishes or is stopped."

# Get all session names
SESSION_NAMES=$(tmux ls -F "#{session_name}")

for SESSION_NAME_ITER in $SESSION_NAMES; do
    echo "--- Switching to Session: ${SESSION_NAME_ITER} ---"

    # Switch the client to the current session in the loop
    tmux switch-client -t "${SESSION_NAME_ITER}"

    # Report on the currently active session
    ACTIVE_SESSION_INFO=$(tmux display-message -p '#{session_name} (windows: #{session_windows})')
    echo "--- Currently Active Session (as reported by tmux): ${ACTIVE_SESSION_INFO} ---"

    # Capture and display content of the active pane in the active window of this session
    # This is the closest we can get to "displaying" the session's content.
    ACTIVE_PANE_ID=$(tmux display-message -p '#{pane_id}')
    if [ -n "${ACTIVE_PANE_ID}" ]; then
        tmux capture-pane -p -t "${ACTIVE_PANE_ID}"
    else
        echo "No active pane found in this session."
    fi

    echo "--- End of Session: ${SESSION_NAME_ITER} ---"
    echo "Waiting 2 seconds. Press Ctrl-C to stop."

    trap "echo -e '\nStopping session iteration.'; exit 0" SIGINT
    if read -t 2 -n 1 -r; then
        continue
    fi
done

echo "Finished iterating through all sessions."
echo "You may need to manually switch back to your preferred tmux session."
