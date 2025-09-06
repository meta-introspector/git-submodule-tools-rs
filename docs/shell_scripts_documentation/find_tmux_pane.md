## `find_tmux_pane.sh`

**Summary:**
This script iterates through all panes within a specified tmux session (`gemini-agent-session`). For each pane, it visually selects it (if run inside tmux) and then captures and displays its content. The script pauses for 2 seconds between panes, allowing the user to review the content, and can be stopped at any time by pressing Ctrl-C. It's useful for inspecting the state and output of multiple processes running in different tmux panes.
