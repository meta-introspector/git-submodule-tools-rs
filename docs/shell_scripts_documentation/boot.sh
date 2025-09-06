## `boot.sh`

**Summary:**
This script simulates a Gemini agent (identified as `Gemini-Alpha`) booting up and claiming an unassigned task. It searches the `tasks/` directory for TOML files (`.toml`) where the `assigned_agent` field is `(Unassigned)`. If an unclaimed task is found, the script updates the corresponding TOML file, setting `assigned_agent` to `Gemini-Alpha` and `status` to `In Progress`. It then instructs the user to review and commit these changes and displays the current `git status`. This script is part of the project's task management and agent simulation framework.
