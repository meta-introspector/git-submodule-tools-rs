# Standard Operating Procedure: Enhance Gemini-CLI for Batch Task Processing and Reproducible Derivations

## Description
This SOP outlines the procedure to enhance the `gemini-cli` to accept and execute multiple batch task files sequentially, ensuring maximally verbose output, comprehensive data saving to the file system for each step and prompt, and treating each execution run as a distinct Nix derivation.

## Procedure:
1.  **Accept Multiple Batch Task Files:** Enable the `gemini-cli` to take multiple task files as input.
2.  **Sequential Execution:** Process these task files one by one in the order provided.
3.  **Maximally Verbose Mode:** Ensure all execution steps and interactions are logged with maximum verbosity.
4.  **Comprehensive Data Saving:** Save all generated data, including intermediate steps and prompts, to the file system.
5.  **Nix Derivation per Run:** Each complete run of the `gemini-cli` with a batch of tasks should result in a reproducible Nix derivation.

## Next Steps
- Analyze the structure of the `gemini-cli` directory to understand its current implementation.
- Modify `cli.rs` to add `task_files: Option<Vec<PathBuf>>` to `Args` for multiple task file paths and `verbose: bool` for verbosity control.
- Modify `main.rs` to handle `task_files` and `verbose`.
- Implement batch task processing by iterating through `task_files`, processing each as a prompt, implementing verbose logging, and saving intermediate data.
- Create a timestamped directory per run, saving task content, prompts, responses, and verbose logs.
- Structure outputs for Nix derivation generation.