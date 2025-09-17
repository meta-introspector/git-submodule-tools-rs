# Standard Operating Procedure: Emacs Lisp Integration with Gemini CLI

## Description
This SOP outlines the process for integrating Emacs Lisp commands with the `gemini-cli` tool, specifically focusing on the `~/pick-up-nix2/source/github/meta-introspector/git-submodules-rs-nix/.emacs.d/nix-magit/` directory and the `~/pick-up-nix2/vendor/external/gemini-cli/` tool. The goal is to create Emacs Lisp commands to run `gemini-cli` and to develop a `solfunmeme-mode` for Emacs to continuously run this process.

## Procedure:
1.  **Analyze `runprompt3.sh`**: Convert the logic from `~/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/runprompt3.sh` into Emacs Lisp functions.
2.  **Create Emacs Lisp Commands**: Develop Emacs Lisp commands to execute `gemini-cli` functionalities.
3.  **Integrate with `nix-magit`**: Make necessary changes to `~/pick-up-nix2/source/github/meta-introspector/git-submodules-rs-nix/.emacs.d/nix-magit/` for better integration.
4.  **Develop `solfunmeme-mode`**: Create a major mode in Emacs, `solfunmeme-mode`, to facilitate continuous execution of the integrated `gemini-cli` processes.

## Origin
User request to integrate Emacs Lisp with `gemini-cli` for automated task processing.