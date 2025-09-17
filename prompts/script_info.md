--- Script Information ---
This document describes the `runprompt3.sh` script, which is used to process task files with the `gemini-cli`.

## Script: `runprompt3.sh`

### Purpose:
Automates the process of feeding task definitions and related context to the `gemini-cli` for AI-driven task processing. It handles file validation, merges previous outputs, and provides options for dry runs and verbose output.

### Arguments:
*   **Positional Argument 1 (Optional):** `SPECIFIC_TASK_FILE` - A path to a single task file to process. If omitted, all `prompts/[Tt]ask_*.md` files are considered.
*   **Positional Argument 2 (Optional):** `FILTER_PATTERN` - A glob pattern to filter the task files. Applied after initial task file selection.

### Flags:
*   `-d`, `--dry-run`: Performs a dry run, printing the command that *would* be executed without actually running it.
*   `-v`, `--verbose`: Enables verbose output, providing detailed information about the script's execution flow.

### Key Features:
*   **Timestamped Outputs:** Generates unique output files (e.g., `task_file.out_YYYYMMDD_HHMMSS.md`) for each `gemini-cli` run.
*   **Previous Output Merging:** Automatically merges content from previous output files for a given task, providing historical context to the `gemini-cli`.
*   **Structured Input:** Combines a `prelude.md` (CLI interaction tips), `script_info.md` (this document), merged previous outputs, the main task file, and a `postlude.md` (call to action) into a single input stream for `gemini-cli`.
*   **File Validation:** Checks for the existence and non-emptiness of prelude, task, and postlude files.