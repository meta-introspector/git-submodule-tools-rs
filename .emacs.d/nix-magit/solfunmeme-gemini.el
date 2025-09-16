;;; solfunmeme-gemini.el --- Gemini CLI integration for Emacs -*- lexical-binding: t; -*-

;;; Commentary:
;; This file provides Emacs Lisp functions to interact with the gemini-cli tool.

;;; Code:

(defvar solfunmeme-nix-gemini-cli-command
  "nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli"
  "The Nix command to run gemini-cli.")

(defvar solfunmeme-project-root
  (expand-file-name "~/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/")
  "Root directory of the current project.")

(defvar solfunmeme-prelude-file
  (expand-file-name "prompts/prelude.md" solfunmeme-project-root)
  "Path to the prelude markdown file.")

(defun solfunmeme-get-task-files ()
  "Return a list of task files in the prompts/ directory."
  (file-expand-wildcards (expand-file-name "prompts/[Tt]ask_*.md" solfunmeme-project-root)))

(defun solfunmeme-run-gemini-cli-for-task (task-file)
  "Run gemini-cli for a given TASK-FILE."
  (let* ((output-file (concat task-file ".out1.md"))
         (prelude-content (with-temp-buffer
                            (insert-file-contents solfunmeme-prelude-file)
                            (buffer-string)))
         (task-content (with-temp-buffer
                         (insert-file-contents task-file)
                         (buffer-string)))
         (full-prompt (concat prelude-content task-content))
         (cli-args (list "--include-directories=~/pick-up-nix2/"
                         "--model" "gemini-2.5-flash"
                         "--y"
                         "--checkpointing"
                         "--prompt" full-prompt))
         (full-command (concat solfunmeme-nix-gemini-cli-command " " (mapconcat 'identity cli-args " "))))
    (unless (file-exists-p output-file)
      (message "Running gemini-cli for %s..." task-file)
      (with-temp-buffer
        (call-process-shell-command full-command nil (current-buffer) t)
        (write-file-contents output-file)))))

(defun solfunmeme-run-all-gemini-tasks ()
  "Run gemini-cli for all task files in the prompts/ directory."
  (interactive)
  (dolist (task-file (solfunmeme-get-task-files))
    (solfunmeme-run-gemini-cli-for-task task-file)))

(provide 'solfunmeme-gemini)
;;; solfunmeme-gemini.el ends here