;;; solfunmeme-dashboard.el --- Gemini CLI Dashboard for Emacs -*- lexical-binding: t; -*-

;;; Commentary:
;; This file provides the main Emacs Lisp implementation for the Gemini CLI Dashboard.

;;; Code:

(require 'cl-lib) ; For `cl-loop` and other utilities
(require 'solfunmeme-gemini) ; Provides core gemini-cli interaction functions
(require 'solfunmeme-mode) ; Provides the major mode definition
(require 'widget) ; For interactive widgets
(require 'button) ; For clickable buttons

;; --- Configuration Variables ---



;; --- Utility Functions (Consolidated and Refined) ---

(defun solfunmeme-dashboard-get-task-files ()
  "Return a list of task files in the prompts/ directory relative to project root."
  (file-expand-wildcards (expand-file-name "prompts/[Tt]ask_*.md" solfunmeme-project-root)))

(defun solfunmeme-dashboard-read-file-content (file-path)
  "Read the content of FILE-PATH and return it as a string."
  (with-temp-buffer
    (insert-file-contents (expand-file-name file-path))
    (buffer-string)))

(defun solfunmeme-dashboard-run-gemini-cli (prompt-content output-file &optional callback)
  "Run gemini-cli with PROMPT-CONTENT and save output to OUTPUT-FILE asynchronously.
  If CALLBACK is provided, it's called with the output file path after completion."
  (let* ((temp-prompt-file (make-temp-file "gemini-prompt-" nil ".md"))
         (full-include-dirs (expand-file-name solfunmeme-include-directories))
         (command (format "%s --include-directories=%s --model %s --y --checkpointing --prompt-file %s | tee %s"
                          solfunmeme-nix-gemini-cli-command
                          (shell-quote-argument full-include-dirs)
                          (shell-quote-argument solfunmeme-gemini-model)
                          (shell-quote-argument temp-prompt-file)
                          (shell-quote-argument (expand-file-name output-file))))
         (process-buffer (generate-new-buffer (format "*gemini-cli-process-%s*" (file-name-nondirectory output-file)))))
    (with-temp-file temp-prompt-file
      (insert prompt-content))
    (message "Running gemini-cli command: %s" command)
    (with-current-buffer process-buffer
      (let ((proc (start-process "gemini-cli-process" process-buffer "/bin/bash" "-c" command)))
        (set-process-sentinel proc
                              `(lambda (process event)
                                 (when (memq (process-status process) '(exit signal))
                                   (message "gemini-cli finished for %s. Output saved to %s" ,output-file ,output-file)
                                   (delete-file ,temp-prompt-file)
                                   (kill-buffer ,process-buffer)
                                   ,(when callback `(funcall ,callback ,output-file))))))))))

(defun solfunmeme-dashboard-process-task-file (task-file &optional callback)
  "Process a single TASK-FILE using gemini-cli.
  If CALLBACK is provided, it's called with the output file path after completion."
  (let* ((output-file-path (concat task-file ".out1.md"))
         (prelude-content (solfunmeme-dashboard-read-file-content solfunmeme-prelude-file))
         (task-content (solfunmeme-dashboard-read-file-content task-file))
         (full-prompt (concat prelude-content task-content)))
    (solfunmeme-dashboard-run-gemini-cli full-prompt output-file-path callback)))

;; --- Dashboard Major Mode ---

(defvar gemini-dashboard-current-task nil
  "The currently selected task file in the Gemini Dashboard.")

(defun gemini-dashboard-select-task (task-file)
  "Select TASK-FILE and display its content in the prompt area."
  (interactive "fSelect task file: ")
  (setq gemini-dashboard-current-task task-file)
  (with-current-buffer (get-buffer-create "*Gemini Prompt*")
    (erase-buffer)
    (insert (solfunmeme-dashboard-read-file-content task-file))
    (set-buffer-read-only nil) ; Allow editing of the prompt
    (goto-char (point-min)))
  (with-current-buffer (get-buffer-create "*Gemini Output*")
    (erase-buffer)
    (insert "Output:\n")
    (insert "----------------------------------------\n")
    (insert "Ready to run Gemini CLI for: " (file-name-nondirectory task-file) "\n"))
  (message "Selected task: %s" (file-name-nondirectory task-file)))

(define-derived-mode gemini-dashboard-mode prog-mode "Gemini Dashboard"
  "Major mode for the Gemini CLI Dashboard."
  (setq-local buffer-read-only t) ; Dashboard buffer is read-only by default
  (setq-local truncate-lines t)
  (setq-local word-wrap nil)
  (setq-local font-lock-defaults '(gemini-dashboard-font-lock-keywords))
  (run-hooks 'gemini-dashboard-mode-hook))

(defvar gemini-dashboard-font-lock-keywords
  '(("^\\\\[ \\].*$" . font-lock-warning-face) ; Uncompleted tasks
    ("^\\\\[X\\].*$" . font-lock-comment-face) ; Completed tasks
    ("^\\\\[\\?\\].*$" . font-lock-keyword-face)) ; In progress/error tasks
  "Font lock keywords for `gemini-dashboard-mode'.")

(defun gemini-dashboard-display-tasks () "Populate the *Gemini Tasks* buffer with interactive task buttons." (with-current-buffer (get-buffer-create "*Gemini Tasks*") (gemini-dashboard-mode) (erase-buffer) (insert "Tasks:\n") (insert "----------------------------------------\n") (let* ((task-files (solfunmeme-dashboard-get-task-files)) (max-task-len 30)) (cl-loop for task-file in task-files do (let* ((task-name (file-name-nondirectory task-file)) (status (if (file-exists-p (concat task-file ".out1.md")) "[X]" "[ ]")) (task-display (format "%s %s" status (truncate-string-to-width task-name max-task-len nil nil 'right)))) (insert (format " %s " task-display)) (insert-button task-display 'action `(lambda () (interactive) (gemini-dashboard-select-task ,task-file)) 'help-echo (format "Click to select task %s" task-name)) (insert "\n")))) (insert "----------------------------------------\n") (insert-button "Run Gemini CLI" 'action 'gemini-dashboard-run-cli-for-current-task 'help-echo "Run Gemini CLI for the selected task.") (insert "  ") (insert-button "Config" 'action 'gemini-dashboard-open-config 'help-echo "Open Gemini Dashboard configuration.") (insert "  ") (insert-button "Help" 'action 'gemini-dashboard-show-help 'help-echo "Show Gemini Dashboard help.") (insert "\n") (set-buffer-read-only t) (goto-char (point-min)))) (defun gemini-dashboard-open-config () "Open the customization buffer for the Gemini Dashboard." (interactive) (customize-group 'solfunmeme-dashboard)) (defun gemini-dashboard-show-help () "Display a help message for the Gemini Dashboard." (interactive) (message "Gemini Dashboard Help: Select a task, edit the prompt, and click 'Run Gemini CLI'.")) (defun gemini-dashboard-display-prompt () "Populate the *Gemini Prompt* buffer with the current task's prompt." (with-current-buffer (get-buffer-create "*Gemini Prompt*") (gemini-dashboard-mode) (erase-buffer) (insert "Task Details / Prompt:\n") (insert "----------------------------------------\n") (if gemini-dashboard-current-task (insert (solfunmeme-dashboard-read-file-content gemini-dashboard-current-task)) (insert "Select a task to view its prompt.")) (set-buffer-read-only nil) ; Allow editing (goto-char (point-min))))

(defun gemini-dashboard-display-output ()
  "Populate the *Gemini Output* buffer."
  (with-current-buffer (get-buffer-create "*Gemini Output*")
    (gemini-dashboard-mode)
    (erase-buffer)
    (insert "Output:\n")
    (insert "----------------------------------------\n")
    (insert "Waiting for Gemini CLI output...")
    (set-buffer-read-only t)
    (goto-char (point-min))))

(defun gemini-dashboard-open ()
  "Open the Gemini Dashboard."
  (interactive)
  (let* ((tasks-buffer (get-buffer-create "*Gemini Tasks*"))
         (prompt-buffer (get-buffer-create "*Gemini Prompt*"))
         (output-buffer (get-buffer-create "*Gemini Output*")))

    ;; Save current window configuration
    (setq-local gemini-dashboard-previous-window-config (current-window-configuration))

    ;; Clear existing windows and create a new layout
    (delete-other-windows)

    ;; Create left window for tasks
    (let* ((tasks-window (split-window (selected-window) nil 'left)))
      (set-window-buffer tasks-window tasks-buffer)
      (with-current-buffer tasks-buffer (gemini-dashboard-mode)))

    ;; Create top-right window for prompt
    (let* ((prompt-window (split-window (selected-window) nil 'above)))
      (set-window-buffer prompt-window prompt-buffer)
      (with-current-buffer prompt-buffer (gemini-dashboard-mode)))

    ;; Create bottom-right window for output
    (let* ((output-window (selected-window)))
      (set-window-buffer output-window output-buffer)
      (with-current-buffer output-buffer (gemini-dashboard-mode)))

    ;; Populate initial content
    (gemini-dashboard-display-tasks)
    (gemini-dashboard-display-prompt)
    (gemini-dashboard-display-output)

    ;; Select the tasks buffer by default
    (select-window (get-buffer-window tasks-buffer))
    (message "Gemini Dashboard opened.")))

(provide 'solfunmeme-dashboard)
;;; solfunmeme-dashboard.el ends here

