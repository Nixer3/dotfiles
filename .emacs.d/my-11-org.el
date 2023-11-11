(use-package org
    :config
    (setq org-ellipsis "-▾"
	  org-startup-indented t
	  org-pretty-entities t
          org-hide-emphasis-markers t
	  org-startup-with-inline-images t
	  org-image-actual-width '(300)
          org-src-fontify-natively t
          org-fontify-quote-and-verse-blocks t
          org-src-tab-acts-natively t
          org-edit-src-content-indentation 2
          org-hide-block-startup nil
          org-src-preserve-indentation nil
          org-startup-folded 'content
          org-cycle-separator-lines 2
          org-capture-bookmark nil
	)
;;  (add-hook 'org-agenda-mode-hook (lambda () (setq-local tab-width 4)))
  (setq org-agenda-prefix-format '((agenda . " %i %-12t%2:b\n\t\t\t  ")
                                 (todo . " %i %-12:c")
                                 (tags . " %i %-12:c")
                                 (search . " %i %-12:c")))
  (setq org-modules
    '(org-crypt
        org-habit
        org-bookmark
        org-eshell
        org-irc))
  (setq org-refile-targets '((nil :maxlevel . 1)
                             (org-agenda-files :maxlevel . 1)))
  (setq org-confirm-babel-evaluate nil)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path t)
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
        ; (ledger . t)
        (python . t)
        (gnuplot . t)
        (shell . t)
        (java . t)        
        (js . t)
        (C . t)
        (shell . t)
        (dot . t)
      ))
  :custom
  ;; Fix for including SVGs
  
  (org-edit-src-content-indentation 0)
  ;; Optional: Automatically tangle and execute code blocks when saving Org files
  (defun my/org-babel-tangle-and-execute ()
    (when (equal major-mode 'org-mode)
      (org-babel-tangle)
      (org-babel-execute-buffer)))

  :hook 
  (org-mode . variable-pitch-mode)
  (org-babel-after-execute . org-redisplay-inline-images)
  (after-save-hook . my/org-babel-tangle-and-execute)
)
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)


(use-package org-preview-html)
(use-package mixed-pitch
    :hook
    (text-mode . mixed-pitch-mode)
    :config
    (set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 130)
    (set-face-attribute 'fixed-pitch nil :font "Fira Code")
    (set-face-attribute 'variable-pitch nil :font "DejaVu Sans"))
(add-hook 'mixed-pitch-mode-hook #'solaire-mode-reset)


(use-package auto-org-md)
(use-package org-tree-slide
  :custom
  (setq org-image-actual-width nil)
  (setq org-tree-slide-slide-in-effect t)
  (setq org-tree-slide-activate-message "Presentation started!")
  (setq org-tree-slide-deactivate-message "Presentation ended!")
  (setq org-tree-slide-header t)
  (setq org-tree-slide-breadcrumbs " // ")
  (setq org-image-actual-width nil)
  (setq org-tree-slide-header "My Custom Header")
; (setq org-tree-slide-header (format "" ))
  
  
  :hook
  (org-tree-slide-play . my/org-presentation-start)
  (org-tree-slide-stop . my/org-presentation-post)
)
(defun my/org-presentation-start ()
  "Set up my Org Tree Slide environment before starting the presentation."
  (setq org-hide-emphasis-markers t)
  (beacon-mode -1)
  (message "%s" "starting, set")
  ;; Possibly other settings can be included here.
)

(defun my/org-presentation-post ()
  "Clean up my Org Tree Slide environment after stopping the presentation."
  (setq org-hide-emphasis-markers nil)
  (beacon-mode 1)
  ;; Possibly other settings can be included here.
)
(use-package org-appear
    :hook (org-mode . org-appear-mode))
(use-package org-sidebar
  :ensure t
  :bind ("C-c s" . org-sidebar)
  :custom
  (org-sidebar-default-fns '(org-sidebar--toc-sidebar))
  )
(defun my/open-tree-view ()
  "Open a clone of the current buffer to the left, resize it to 30 columns, and bind <mouse-1> to jump to the same position in the base buffer."
  (interactive)
  (let ((new-buffer-name (concat "<tree:" (buffer-name) ">")))
    ;; Create tree buffer
    (split-window-right 30)
    (if (get-buffer new-buffer-name)
        (switch-to-buffer new-buffer-name)  ; Use existing tree buffer
      ;; Make new tree buffer
      (progn  (clone-indirect-buffer new-buffer-name nil t)
              (switch-to-buffer new-buffer-name)
              (read-only-mode)
              (hide-body)
              (toggle-truncate-lines)

              ;; Do this twice in case the point is in a hidden line
              (dotimes (_ 2 (forward-line 0)))

              ;; Map keys
              (use-local-map (copy-keymap outline-mode-map))
              (local-set-key (kbd "q") 'delete-window)
              (mapc (lambda (key) (local-set-key (kbd key) 'my/jump-to-point-and-show))
                    '("<mouse-1>" "RET"))))))

(defun my/jump-to-point-and-show ()
  "Switch to a cloned buffer's base buffer and move point to the cursor position in the clone."
  (interactive)
  (let ((buf (buffer-base-buffer)))
    (unless buf
      (error "You need to be in a cloned buffer!"))
    (let ((pos (point))
          (win (car (get-buffer-window-list buf))))
      (if win
          (select-window win)
        (other-window 1)
        (switch-to-buffer buf))
      (goto-char pos)
      (when (invisible-p (point))
        (show-branches)
      )
    )
  )
)
(plist-put org-format-latex-options :scale 2)
;; Nice bullets
(use-package org-superstar
  :after org
  :config
  (setq org-superstar-special-todo-items t)
  (add-hook 'org-mode-hook (lambda ()
                             (org-superstar-mode 1))
  )
)
(use-package org-bullets
   :after org
   :hook (org-mode . org-bullets-mode)
   :custom
   (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package org-tree-slide
  :after org
  :custom 
  (org-image-actual-width nil)
)
(use-package toc-org
  :after org
  :hook
    ((org-mode . toc-org-mode)
     (markdown-mode . toc-org-mode)) 
)
(use-package org-auto-tangle :hook (org-mode . org-auto-tangle-mode))
;;(use-package org-indent  :after org)

;; Replace list hyphen with dot
(font-lock-add-keywords 'org-mode
                         '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
;; Make sure org-indent face is available
;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
;(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
;(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  ;; Distraction-free screen
(use-package olivetti
  :init
  (setq olivetti-body-width .67)
  :config
  (defun distraction-free ()
    "Distraction-free writing environment"
    (interactive)
    (if (equal olivetti-mode nil)
        (progn
          (window-configuration-to-register 1)
          (delete-other-windows)
          (text-scale-increase 2)
          (olivetti-mode t))
      (progn
        (jump-to-register 1)
        (olivetti-mode 0)
        (text-scale-decrease 2))))
  :bind
  (("<f9>" . distraction-free))
)
(require 'ob-gnuplot)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((gnuplot . t)))



(use-package org-download
  :custom
  ;; Drag-and-drop to `dired`
  (add-hook 'dired-mode-hook 'org-download-enable)
)

(provide 'my-11-org)
;;; my-11-org.el ends here
