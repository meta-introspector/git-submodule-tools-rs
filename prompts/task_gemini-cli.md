# Task: Enhance Gemini-CLI for Batch Task Processing and Reproducible Derivations

## Objective:
Modify the `gemini-cli` to accept and execute multiple batch task files sequentially, ensuring maximally verbose output, comprehensive data saving to the file system for each step and prompt, and treating each execution run as a distinct Nix derivation.

## Context:

The following relevant `gemini-cli` related paths exist within the project root (`~/pick-up-nix2/`):

*   `./vendor/external/gemini-cli/`
*   `./pkgs/gemini-cli/default.nix`
*   `./pkgs/gemini-cli/flake.nix`
*   `./pkgs/gemini-interaction/`
*   `./pkgs/gemini-interaction/default.nix`
*   `./vendor/nixpkgs/pkgs/by-name/ge/gemini-cli`

## Task Description:

The primary goal is to enhance the `gemini-cli` to:

1.  **Accept Multiple Batch Task Files:** Enable the `gemini-cli` to take multiple task files as input.
2.  **Sequential Execution:** Process these task files one by one in the order provided.
3.  **Maximally Verbose Mode:** Ensure all execution steps and interactions are logged with maximum verbosity.
4.  **Comprehensive Data Saving:** Save all generated data, including intermediate steps and prompts, to the file system.
5.  **Nix Derivation per Run:** Each complete run of the `gemini-cli` with a batch of tasks should result in a reproducible Nix derivation.

## References:

*   `task_ainix.md` (for inspiration on Nix derivation and task management principles)
