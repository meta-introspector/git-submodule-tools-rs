;;; solfunmeme.el -- Emacs Lisp for solfunmeme mode
;; 
;;; Commentary: 
;; 
;; This file provides Emacs Lisp functions and a minor mode to integrate
;; with the gemini-cli, specifically to automate the processing of task files
;; similar to the functionality of runprompt3.sh.
;; 
;;; Code:

(require 'cl-lib)

(defvar solfunmeme-nix-gemini-cli-command
  "nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli"
  "The Nix command to run gemini-cli.")

(defvar solfunmeme-include-directories
  "~/pick-up-nix2/"
  "Directories to include for gemini-cli.")

(defvar solfunmeme-gemini-model
  "gemini-2.5-flash"
  "The Gemini model to use.")

(defun solfunmeme-run-gemini-cli (prompt-content output-file)
  "Run gemini-cli with PROMPT-CONTENT and save output to OUTPUT-FILE."
  (interactive "sPrompt content: 
FOutput file: ")
  (let* ((temp-prompt-file (make-temp-file "gemini-prompt-" nil ".md"))
         (command (format "%s --include-directories=%s --model %s --y --checkpointing --prompt-file %s | tee %s"
                          solfunmeme-nix-gemini-cli-command
                          (expand-file-name solfunmeme-include-directories)
                          solfunmeme-gemini-model
                          (shell-quote-argument temp-prompt-file)
                          (shell-quote-argument (expand-file-name output-file))))
         (process-buffer (generate-new-buffer "*gemini-cli-process*")))
    (with-temp-file temp-prompt-file
      (insert prompt-content))
    (message "Running gemini-cli command: %s" command)
    (with-current-buffer process-buffer
      (call-process-shell-command command nil (current-buffer) nil))
    (message "gemini-cli finished. Output saved to %s" output-file)
    (delete-file temp-prompt-file)
    (kill-buffer process-buffer)))

(defun solfunmeme-read-file-content (file-path)
  "Read the content of FILE-PATH and return it as a string."
  (with-temp-buffer
    (insert-file-contents (expand-file-name file-path))
    (buffer-string)))

(defun solfunmeme-process-task-files ()
  "Process task files using gemini-cli, similar to runprompt3.sh."
  (interactive)
  (message "solfunmeme: Processing task files...")
  (let* ((prompts-dir (expand-file-name "prompts/"
                                        "/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/"))
         (prelude-file (concat prompts-dir "prelude.md"))
         (prelude-content (solfunmeme-read-file-content prelude-file)))
    (dolist (file (directory-files prompts-dir t "^task_.*\\.md$"))
      (let* ((task-file-path file)
             (output-file-path (concat task-file-path ".out1.md"))
             (task-content (solfunmeme-read-file-content task-file-path)))
        (unless (file-exists-p output-file-path)
          (message "solfunmeme: Processing task file: %s" task-file-path)
          (let ((full-prompt (concat prelude-content task-content)))
            (solfunmeme-run-gemini-cli full-prompt output-file-path)))))
  (message "solfunmeme: Finished processing task files."))

(defvar solfunmeme-timer nil
  "Timer for continuous processing.")

(defvar solfunmeme-polling-interval 60
  "Interval in seconds for continuous processing.")

(defun solfunmeme-start-continuous-processing ()
  "Start continuous processing of task files."
  (interactive)
  (unless solfunmeme-timer
    (setq solfunmeme-timer
          (run-with-timer 0 solfunmeme-polling-interval 'solfunmeme-process-task-files))
    (message "solfunmeme: Continuous processing started (interval: %s seconds)." solfunmeme-polling-interval))
  (solfunmeme-process-task-files))

(defun solfunmeme-stop-continuous-processing ()
  "Stop continuous processing of task files."
  (interactive)
  (when solfunmeme-timer
    (cancel-timer solfunmeme-timer)
    (setq solfunmeme-timer nil)
    (message "solfunmeme: Continuous processing stopped.")))

(defvar solfunmeme-mode-map
  (let ((map (make-keymap)))
    (define-key map (kbd "C-c C-p") 'solfunmeme-process-task-files)
    (define-key map (kbd "C-c C-s") 'solfunmeme-start-continuous-processing)
    (define-key map (kbd "C-c C-x") 'solfunmeme-stop-continuous-processing)
    map)
  "Keymap for solfunmeme-mode.")

(define-minor-mode solfunmeme-mode
  "A minor mode for solfunmeme operations."
  :init-value nil
  :lighter " SolFun"
  :keymap solfunmeme-mode-map
  (if solfunmeme-mode
      (message "solfunmeme-mode enabled")
    (message "solfunmeme-mode disabled")))

(provide 'solfunmeme)
