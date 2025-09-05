#!/bin/bash

# report_current_tmux_pane.sh
# Reports on the currently active tmux pane and displays its content.
# This script is best run from within a tmux session.

echo "Reporting on the currently active tmux pane."

# Get the ID of the currently active pane
ACTIVE_PANE_ID=$(tmux display-message -p '#{pane_id}')

if [ -z "${ACTIVE_PANE_ID}" ]; then
    echo "Error: Could not determine active tmux pane ID. Are you running this script within a tmux session?"
    exit 1
fi

# Report on the currently active pane (what tmux thinks is active)
ACTIVE_PANE_INFO=$(tmux display-message -p '#{pane_id} #{pane_current_command}')
echo "--- Currently Active Pane (as reported by tmux): ${ACTIVE_PANE_INFO} ---"

# Capture and display pane content
tmux capture-pane -p -t "${ACTIVE_PANE_ID}"

echo "--- End of Active Pane Content ---"
