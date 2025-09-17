# Standard Operating Procedure: Plan for Reproducible Submodule Checkout and Build with Nix

## Objective:
Develop a plan to construct a standalone and reproducible Git checkout and build process for specified submodules using Nix. This involves creating a Nix build that can reliably check out a Git repository and its submodules, and then building them.

## Core Task: Reproducible Git Checkout and Build

The overarching goal is to construct a standalone Git checkout and build process, similar to how `act` (GitHub Actions runner) or Nix handles isolated builds. This essentially means creating a Nix build that can reliably check out a Git repository and its submodules.

## Plan for `runprompt1.sh` Script:

The `runprompt1.sh` script will be designed to perform a Nix build for each of the specified submodules.

1.  **Identify Submodule Names:** Extract submodule names from their provided paths.
2.  **Create Iteration Script:** Develop a shell script that iterates through these identified submodule names.
3.  **Execute Nix Build:** For each submodule, execute a `nix build` command from the main project root (`~/pick-up-nix2`), targeting the submodule as a package within the main Nix flake (`~/pick-up-nix2/flake.nix`).
4.  **Capture Build Output:** Capture the output of each build into a dedicated log file (e.g., `build_output_<submodule_name>.log` in the `~/pick-up-nix2` directory).

## Next Steps:

*   Create a Nix derivation to run the `runprompt1.sh` script.
*   Review `~/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/prompts/task_reviewsubmodule2.md` for Nix templates for each submodule.

## Relevant Submodules (Examples):

*   `vendor/cargo_metadata`
*   `vendor/gitoxide`
*   `vendor/meta-introspector/meta-meme`
*   `vendor/meta-introspector/meta-meme.wiki`
*   `vendor/octocrab`
*   `vendor/zola`