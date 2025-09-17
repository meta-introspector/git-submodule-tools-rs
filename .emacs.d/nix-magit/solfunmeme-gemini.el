;;; solfunmeme-gemini.el --- Gemini CLI integration for Emacs -*- lexical-binding: t; -*-

;;; Commentary:
;; This file provides Emacs Lisp functions to interact with the gemini-cli tool.

;;; Code:

(defgroup solfunmeme nil
  "Customization group for Solfunmeme Gemini CLI integration."
  :group 'solfunmeme)

(defcustom solfunmeme-nix-gemini-cli-command
  "nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli"
  "The Nix command used to invoke the `gemini-cli` tool.
This command should be a shell command that can be executed to run the Gemini CLI.
It is recommended to use a `nix run` command for reproducibility."
  :type 'string
  :group 'solfunmeme)

(defun solfunmeme--get-project-root ()
  "Determine the project root dynamically."
  (if (fboundp 'project-root)
      (project-root (project-current))
    (default-directory)))

(defcustom solfunmeme-project-root
  (solfunmeme--get-project-root)
  "The absolute path to the root directory of the current project.
This variable is used to resolve relative paths for task files and prelude files.
It should point to the top-level directory of your project where `gemini-cli` is configured to run."
  :type 'directory
  :group 'solfunmeme)

(defcustom solfunmeme-prelude-file
  (expand-file-name "prompts/prelude.md" solfunmeme-project-root)
  "The path to the prelude markdown file, relative to `solfunmeme-project-root`.
This file contains initial context or instructions that are prepended to every prompt sent to `gemini-cli`."
  :type 'file
  :group 'solfunmeme)

(defun solfunmeme-get-task-files ()
  "Return a list of task files in the `prompts/` directory within `solfunmeme-project-root`.
This function identifies files matching the pattern `prompts/[Tt]ask_*.md`."
  
  (file-expand-wildcards (expand-file-name "prompts/[Tt]ask_*.md" solfunmeme-project-root)))

(defcustom solfunmeme-include-directories
  (expand-file-name "~/pick-up-nix2/")
  "Directories to include for gemini-cli, typically for context."
  :type 'string
  :group 'solfunmeme)

(defcustom solfunmeme-gemini-model
  "gemini-2.5-flash"
  "The Gemini model to use for CLI interactions."
  :type 'string
  :group 'solfunmeme)

(defun solfunmeme-run-gemini-cli-for-task (task-file)
  "Run `gemini-cli` for a given TASK-FILE.
This function constructs the full prompt by concatenating the content of
`solfunmeme-prelude-file` and the provided TASK-FILE. It then executes
`solfunmeme-nix-gemini-cli-command` with the necessary arguments and
saves the output to a file named `TASK-FILE.out1.md`."
  
  (let* ((output-file (concat task-file ".out1.md"))
         (prelude-content (with-temp-buffer
                            (insert-file-contents solfunmeme-prelude-file)
                            (buffer-string)))
         (task-content (with-temp-buffer
                         (insert-file-contents task-file)
                         (buffer-string)))
         (full-prompt (concat prelude-content task-content))
         (cli-args (list (format "--include-directories=%s" (expand-file-name solfunmeme-include-directories))
                         "--model" solfunmeme-gemini-model
                         "--y"
                         "--checkpointing"
                         "--prompt" full-prompt))
         (full-command (concat solfunmeme-nix-gemini-cli-command " " (mapconcat 'identity cli-args " "))))
    (unless (file-exists-p output-file)
      (message "Running gemini-cli for %s..." task-file)
      (with-temp-buffer
        (call-process-shell-command full-command nil (current-buffer) t)
        (write-file-contents output-file))))))

(defun solfunmeme-run-all-gemini-tasks ()
  "Run `gemini-cli` for all task files found in the `prompts/` directory.
This function iterates through all task files identified by `solfunmeme-get-task-files`
and calls `solfunmeme-run-gemini-cli-for-task` for each one."
  (interactive)
  (dolist (task-file (solfunmeme-get-task-files))
    (solfunmeme-run-gemini-cli-for-task task-file)))

(provide 'solfunmeme-gemini)
;;; solfunmeme-gemini.el ends here