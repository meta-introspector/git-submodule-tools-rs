;;; solfunmeme-mode.el --- Major mode for Solfunmeme Gemini CLI interaction -*- lexical-binding: t; -*-

;;; Commentary:
;; This major mode provides an environment for interacting with the Solfunmeme Gemini CLI.

;;; Code:

(require 'solfunmeme-gemini)

(defvar solfunmeme-mode-map
  (let ((map (make-keymap)))
    (define-key map (kbd "C-c C-r") 'solfunmeme-run-all-gemini-tasks)
    map)
  "Keymap for solfunmeme-mode.")

(defvar solfunmeme-auto-run-timer nil
  "Timer for automatically running Gemini tasks.")

(defcustom solfunmeme-auto-run-interval 300
  "Interval in seconds for automatically running Gemini tasks."
  :type 'number
  :group 'solfunmeme)

(defun solfunmeme-start-auto-run ()
  "Start the timer for automatically running Gemini tasks."
  (unless solfunmeme-auto-run-timer
    (setq solfunmeme-auto-run-timer
          (run-with-timer solfunmeme-auto-run-interval solfunmeme-auto-run-interval
                          'solfunmeme-run-all-gemini-tasks))))

(defun solfunmeme-stop-auto-run ()
  "Stop the timer for automatically running Gemini tasks."
  (when solfunmeme-auto-run-timer
    (cancel-timer solfunmeme-auto-run-timer)
    (setq solfunmeme-auto-run-timer nil)))

(define-derived-mode solfunmeme-mode prog-mode "Solfunmeme"
  "Major mode for Solfunmeme Gemini CLI interaction.

\{solfunmeme-mode-map}"
  (setq-local font-lock-defaults '(solfunmeme-font-lock-keywords))
  (run-hooks 'solfunmeme-mode-hook)
  (solfunmeme-start-auto-run)) ;; Start auto-run when mode is enabled

(defvar solfunmeme-font-lock-keywords
  '((";;; Commentary:" . font-lock-comment-face)
    (";;; Code:" . font-lock-comment-face))
  "Font lock keywords for `solfunmeme-mode'.")

(provide 'solfunmeme-mode)
;;; solfunmeme-mode.el ends here