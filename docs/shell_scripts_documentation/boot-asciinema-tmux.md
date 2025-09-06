## `boot-asciinema-tmux.sh`

**Summary:**
This script initiates a tmux session and wraps the entire process in an asciinema recording. It creates a new tmux session named `gemini-recorded-session` and records its output to a timestamped `.cast` file within `docs/recordings/`. The tmux session is configured to execute a `gemini` command that reads `boot.md`. This script is used to capture the agent's boot process for documentation or analysis.
