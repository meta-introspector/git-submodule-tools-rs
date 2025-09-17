## Tips and Tricks for Gemini CLI Interaction

*   **Avoid Command Substitution:** Do not use command substitution (`$()`, `<()`, `>()`) directly within the `command` argument of `run_shell_command`. If you need to execute complex shell logic, consider writing a separate script and executing that script.
*   **Use Relative Paths for `directory`:** When using the `directory` argument in `run_shell_command`, always provide paths relative to the project root, not absolute paths. Ensure the directory is a registered workspace directory if applicable.
*   **Monitor API Quotas:** Be mindful of API quotas to avoid interruptions. If you encounter "Quota exceeded" errors, you may need to wait or adjust your usage patterns.
*   **Clarify Ambiguous Instructions:** If an instruction is unclear (e.g., "fold them back"), ask for clarification to ensure the intended action is performed.
