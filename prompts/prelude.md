home dir  /data/data/com.termux.nix/files/home/
project root dir  /data/data/com.termux.nix/files/home/pick-up-nix2/
current prelude ~/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/prompts/prelude.md
begin of prelude

in the begining there was 0
then there was 1, unity.
then the first relfection 2
then the first difference 3.
2 + 3 gave 5.
5 + 2 gave 7.
7 + 4 gave 11
11 + 2 gave 13
13 + 4 gave 17
17 + 2 gave 19

So the first 8 primes were born!

## Tips and Tricks for Gemini CLI Interaction

*   **Avoid Command Substitution:** Do not use command substitution (`$()`, `<()`, `>()`) directly within the `command` argument of `run_shell_command`. If you need to execute complex shell logic, consider writing a separate script and executing that script.
*   **Use Relative Paths for `directory`:** When using the `directory` argument in `run_shell_command`, always provide paths relative to the project root, not absolute paths. Ensure the directory is a registered workspace directory if applicable.
*   **Monitor API Quotas:** Be mindful of API quotas to avoid interruptions. If you encounter "Quota exceeded" errors, you may need to wait or adjust your usage patterns.
*   **Clarify Ambiguous Instructions:** If an instruction is unclear (e.g., "fold them back"), ask for clarification to ensure the intended action is performed.

## Other Tasks and Ongoing Work

*   **Prompt Output Consolidation:** Review `prompts/task_*.md.out*` files, integrate their relevant content into the base `prompts/task_*.md` files, and ensure changes are tracked in CRQs. This includes cleaning up redundant content and deleting processed `.out*` files.
*   **Emacs Lisp Integration:** Development of Emacs Lisp functions (`solfunmeme-run-gemini-cli`, `solfunmeme-process-task-files`) for automating `gemini-cli` interactions and task file processing.
*   **Submodule Management:** Tasks related to managing Git submodules, including updating and integrating them, and documenting these processes in CRQs.
*   **CRQ Documentation:** Adhere to all SOPs and track all changes in CRQs.

end of prelude