;; ** =========     MY/FUNCTIONS          ============ ;;
(defun copy-isearch-match ()
    (interactive)
    (copy-region-as-kill isearch-other-end (point)))


(defun my/recompile-outdated-packages ()
  "Recompile .el files in elpa directory if they are newer than their .elc counterparts."
  (interactive)
  (let ((elpa-dir (expand-file-name "~/.emacs.d/elpa")))
    (dolist (pkg-dir (directory-files elpa-dir t "\\w+"))
      (when (file-directory-p pkg-dir)
        (let ((el-files (directory-files pkg-dir t "\\.el$")))
          (dolist (el el-files)
            (let ((elc (concat el "c")))
              (when (file-newer-than-file-p el elc)
                (byte-compile-file el)))))))))


(defun my/save-or-sudo-save ()
  "Save the file or sudo save if file is read-only."
  (interactive)
  (if (file-writable-p buffer-file-name)
      (save-buffer)
    (sudo-edit)))

(defun my/load-theme (theme)
  (interactive)
  "Disable current themes and then load THEME."
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme theme t))

(defun custom-delete-or-kill-region ()
  "Delete character after point or kill region if active."
  (interactive)
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-char 1)))
(defun kill-line-or-region ()
  "Kill the current line or the region if active."
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (kill-whole-line)))
(defun copy-line-or-region ()
  "Copy the current line or the region if active."
  (interactive)
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (kill-ring-save (line-beginning-position) (line-end-position))))

(defun horizontal-shift-region (distance)
  "Shift the selected region or the current line to the right if DISTANCE is positive, or to the left if DISTANCE is negative.
   Uses the value of `tab-width` to determine the number of spaces per tab."
  (if (use-region-p)
      (let ((mark (mark)))
        (save-excursion
          (indent-rigidly (region-beginning) (region-end) distance)
          (push-mark mark t t)))
    (indent-rigidly (line-beginning-position) (line-end-position) distance)))

(defun duplicate-line ()
  "Duplicate the current line and move cursor to new line in the same position."
  (interactive)
  (save-excursion
    (move-beginning-of-line nil)
    (insert (thing-at-point 'line t))
    ;(newline)
  )
)

(defun flash-active-window ()
  "Briefly highlight the active window."
  (interactive)
  (pulse-momentary-highlight-region (window-start) (window-end)))

(defun reload-my-init ()
  "Reload the my-init.el configuration file."
  (interactive)
  (load-file (expand-file-name "~/.emacs"))
)

(defun update-window-dimensions-msg ()
  (let* ((height (window-height))
         (width (window-width)))
    (message "Window dimensions: %dx%d" width height)))

(defun my/open-file-at-point ()
  "Open the file path under the cursor."
  (interactive)
  (let (p1 p2 filePath)
    ;; find start
    (search-backward "\"" (line-beginning-position) t)
    (forward-char 1)
    (setq p1 (point))
    
    (search-forward "\"" (line-end-position) t)
    (setq p2 (- (point) 1))
    ;; Extract file path
    (setq filePath (buffer-substring-no-properties p1 p2))
    ;; open
     (if (file-exists-p filePath)
         (find-file filePath)
         (if (y-or-n-p (format "File '%s' does not exist. Create it? " filePath))
             (progn (find-file filePath) (save-buffer))
           (message "File does not exist")
         )
     )
   )
)

(defvar my/window-dimensions "N/A")
;(add-hook 'window-configuration-change-hook 'update-window-dimensions-msg)
(defun update-window-dimensions ()
  (let* ((height (window-height))
         (width (window-width)))
    (setq my/window-dimensions (format "%dx%d" width height))))
;(add-hook 'window-configuration-change-hook 'update-window-dimensions)

(defun kill-buffer-ask-for-save-delete-window ()
  "Kill the current buffer after asking for saving changes, then delete the window."
  (interactive)
  (when (or (not (buffer-modified-p))
            (and (buffer-modified-p)
                 (y-or-n-p "Buffer has unsaved changes. Save before killing? ")
                 (progn
                   (save-buffer)
                   t))
            (y-or-n-p "Buffer has unsaved changes. Really kill without saving? "))
    (kill-buffer)
    (unless (one-window-p)
      (delete-window))))

(defun kill-buffer-dont-save-delete-window ()
  "Kill the current buffer without saving or prompting, then delete the window."
  (interactive)
  (set-buffer-modified-p nil)
  (kill-buffer)
  (unless (one-window-p)
    (delete-window)))

(defun save-all-buffers-and-quit ()
  "Save all modified buffers without prompting, then quit Emacs."
  (interactive)
  (save-some-buffers t)
  (kill-emacs))

(defun ask-save-buffers-and-quit ()
  "Prompt to save each modified buffer, then quit Emacs."
  (interactive)
  (save-some-buffers)
  (kill-emacs))

(defun open-buffer-directory ()
  "Open the directory of the current buffer's file in dired."
  (interactive)
  (dired (file-name-directory (or (buffer-file-name) default-directory)))
)

(defun kill-buffer-window ()
 "kills buffer and window"
 (interactive) 
 (kill-buffer) 
 (delete-window) 
)

(defun print-doc-as-org-table ()
  (interactive)
  (let ((search-string (read-string "Search for: "))
        (buffer (get-buffer-create "*doc.org*"))
        symbols)
    (mapatoms (lambda (s)
                (when (and (boundp s)
                           (string-match-p search-string (symbol-name s))
                           (documentation-property s 'variable-documentation))
                  (push (cons s (documentation-property s 'variable-documentation)) symbols))))
    (with-current-buffer buffer
      (org-mode)
      (insert "| Symbol | Documentation |\n|--------|--------------|\n")
      (dolist (sym-desc symbols)
        (let ((sym (car sym-desc))
              (doc (cdr sym-desc)))
          (when doc
            (setq doc (replace-regexp-in-string "\n" "⏎ " doc))
            (insert (format "| %s | %s |\n" sym doc)))))
      (switch-to-buffer buffer))))

(defun light-theme ()
  "Switch to a light theme."
  (interactive)
  (my/load-theme 'whiteboard))

(defun dark-theme ()
  "Switch to a dark theme."
  (interactive)
  (my/load-theme 'dracula)) ; dracula / doom-one



;(defun theme-switch (theme-symbol)
;  "Switch the theme based on THEME-SYMBOL."
;  (interactive "Switch to theme (light or dark): ")
;  (cond
;   ((eq theme-symbol 'light) (light-theme))
;   ((eq theme-symbol 'dark ) (dark-theme))
;   (t (message "Unknown theme symbol. Use 'light or 'dark."))
;  )
;)

(defun set-theme-for-new-frame (frame)
  "Set theme based on time for newly created FRAME."
  (select-frame frame)
  (choose-theme-based-on-time))

(defun is-daytime-p ()
  (interactive)
  "Return t if current time is daytime, otherwise return nil.  curr 6 <= %H <=15"
  (let* ((current-hour (string-to-number (format-time-string "%H"))))
    (<= 6 current-hour 15)))

(defun choose-theme-based-on-time ()
  "Choose theme based on the current time."
  (if (is-daytime-p) (light-theme)
    (dark-theme)
  )
)


(defun my/setup-posframe (&optional frame)
  (when frame (select-frame frame))
  (message "New frame created")
  
  (condition-case err 
    (when (display-graphic-p)
      ;; Enable posframe or any other graphical-only setup here.
      ;; For example, for which-key-posframe:
      (which-key-posframe-mode)
      (ace-window-posframe-mode 1)
      (transient-posframe-mode)
      (ivy-posframe-mode 1)
      (setq ivy-rich-mode t)
      )
    (error (message "Error setting up posframe> %s" err))
  )
)

;; (add-hook 'after-make-frame-functions 'my/setup-posframe)

(provide 'my-02-functions)
;;; my-02-functions.el ends here
