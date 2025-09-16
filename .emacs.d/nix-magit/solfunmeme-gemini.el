
;;; solfunmeme-gemini.el --- Emacs Lisp functions for Gemini CLI integration -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Solfunmeme

;; Author: Solfunmeme
;; Keywords: convenience, tools, gemini, nix

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file provides Emacs Lisp functions to interact with the Gemini CLI,
;; specifically for processing task files and integrating with Nix.

;;; Code:

(require 'cl-lib) ; For `cl-loop`

(defvar solfunmeme-gemini-cli-path "nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli --"
  "The command to run the Gemini CLI via Nix.")

(defvar solfunmeme-prelude-file "~/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/prompts/prelude.md"
  "Path to the prelude file for Gemini CLI prompts.")

(defvar solfunmeme-task-files-directory "~/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/prompts/"
  "Directory containing Gemini CLI task files.")

(defun solfunmeme-run-gemini-cli-with-prompt (prompt-file output-file)
  "Combines PROMPT-FILE with `solfunmeme-prelude-file` and runs Gemini CLI.
Output is saved to OUTPUT-FILE."
  (interactive "fPrompt file: 
FOutput file: ")
  (let* ((prelude-content (with-temp-buffer
                            (insert-file-contents solfunmeme-prelude-file)
                            (buffer-string)))
         (prompt-content (with-temp-buffer
                           (insert-file-contents prompt-file)
                           (buffer-string)))
         (full-prompt (concat prelude-content prompt-content))
         (command (format "%s --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt" solfunmeme-gemini-cli-path)))
    (message "Running Gemini CLI for %s..." prompt-file)
    (with-temp-file output-file
      (process-send-string
       (start-process "gemini-cli-process" (current-buffer) "bash" "-c" command)
       full-prompt)
      (while (accept-process-output "gemini-cli-process")
        (sit-for 0.1)))
    (message "Gemini CLI output saved to %s" output-file)))

(defun solfunmeme-process-task-files ()
  "Processes all task files in `solfunmeme-task-files-directory` with Gemini CLI."
  (interactive)
  (let ((default-directory solfunmeme-task-files-directory))
    (cl-loop for file in (directory-files default-directory t "[Tt]ask_.*\.md$")
             do
             (let* ((prompt-file (file-name-nondirectory file))
                    (output-file (concat file ".out1.md")))
               (unless (file-exists-p output-file)
                 (solfunmeme-run-gemini-cli-with-prompt file output-file))))))

;;;###autoload
(define-derived-mode solfunmeme-mode prog-mode "Solfunmeme"
  "Major mode for Solfunmeme-related files and interactions."
  (setq-local comment-start ";; ")
  (setq-local comment-end "")
  (setq-local show-trailing-whitespace t))

(provide 'solfunmeme-gemini)
;;; solfunmeme-gemini.el ends here
