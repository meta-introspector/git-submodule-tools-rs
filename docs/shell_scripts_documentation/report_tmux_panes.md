## `report_tmux_panes.sh`

**Summary:**
This script iterates through all panes within a specified tmux session (`gemini-agent-session`). For each pane, it attempts to select it, reports its ID and the command running within it, and then captures and displays the pane's content. The script pauses for 2 seconds between panes, allowing the user to review the content, and can be stopped at any time by pressing Ctrl-C. It's useful for systematically inspecting the state and output of all panes in a tmux session.
