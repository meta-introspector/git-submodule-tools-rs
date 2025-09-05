#!/bin/bash

# attach_and_show_pro_pane.sh
# Attaches to the gemini-agent-session tmux session and tries to show the pane
# where the pro model is running.

SESSION_NAME="gemini-agent-session"

echo "Attempting to attach to tmux session '${SESSION_NAME}'..."

# Attach to the session. If already attached, this will do nothing.
# If not attached, it will attach.
tmux attach-session -t "${SESSION_NAME}"

# After attaching, try to select the window where the pro model was launched.
# Assuming it was launched in the first window (index 0)
# and the new pane is the last one created in that window.
# This is a heuristic and might need adjustment based on actual tmux layout.
tmux select-window -t "${SESSION_NAME}:0"
tmux select-pane -l # Select the last pane in the current window

echo "You should now be in the tmux session '${SESSION_NAME}'."
echo "Use Ctrl-b <arrow-key> to navigate between panes."
echo "Use Ctrl-b <window-number> to navigate between windows."
