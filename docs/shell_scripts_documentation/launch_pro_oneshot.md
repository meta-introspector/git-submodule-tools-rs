## `launch_pro_oneshot.sh`

**Summary:**
This script launches a "pro" model (likely a powerful LLM) within a new tmux pane to execute a specific "oneshot" task. It first checks if the `gemini-agent-session` tmux session exists and creates it if not. It then defines the path to a prompt file (`prompts/pro_oneshot_task.md`) and a timestamped output log file (`docs/recordings/pro_oneshot_output_*.log`). A new tmux pane is created, and the "pro" model command is sent to it, piping the prompt file's content as input and teeing the output to the log file. The script informs the user about the log file location and how to switch to the new pane.
