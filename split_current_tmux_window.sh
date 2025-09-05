#!/bin/bash

# split_current_tmux_window.sh
# Splits the current tmux window into two panes (vertical split by default).
# This script must be run from within a tmux session.

echo "Splitting the current tmux window..."
tmux split-window
echo "Window split. You should now see two panes."
echo "Use Ctrl-b <arrow-key> to navigate between panes."
