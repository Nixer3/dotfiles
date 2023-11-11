
;; Company for autocompletion
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (global-company-mode 1)
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 1))
  ;; Code snippets
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

;; On-the-fly syntax checking
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

  
;; Project Management
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/projects/")))

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode))

(use-package hydra)
(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t)
)

(use-package rainbow-mode :defer t
  :hook ((prog-mode . rainbow-mode)
         (help-mode . rainbow-mode)))


(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; ==================== SMALL PROGRAMMING LANGUAGES CONFIG======================

(use-package js)
(use-package nodejs-repl)
(defun my-run-current-js-file ()
  (interactive)
  (shell-command (concat "node " (shell-quote-argument (buffer-file-name))))
  )


(provide 'my-10-overall-prog)
;;; my-10-overall-prog.el ends here

