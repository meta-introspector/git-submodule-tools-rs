## `show_session_in_pane.sh`

**Summary:**
This script allows a user to display the content of a specified tmux session within a new pane of their current tmux window. It takes the target session name as an argument. It first splits the current tmux window, creating a new pane. Then, it sends a command to this new pane to start a new tmux instance that is *linked* to the specified target session. This effectively shows the target session's content within the new pane. The script provides instructions for navigating between panes and how to close the linked session. It must be run from within an active tmux session.
