;; ** =========     PACKAGES CONFIG          ============ ;;
;; cool packages to include: better-scroll, avy, auto-minor-mode, spotify ? counsel-spotify, tty/ peep-dired + gui/ dired-posframe, tty/ quick-peek + scrollable-quick-peek, format-all
;; for C: flycheck-clangcheck, flycheck-clang-analyzer, flycheck-cstyle, flycheck-clang-tidy
;; for python: jupyter, ein
;; https://www.flycheck.org/en/latest/ 
;; wth is helm

(use-package dracula-theme)
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (doom-themes-visual-bell-config)
  (setq doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  (doom-themes-org-config)
)

;; (use-package beacon       ;; HIGHLIGHTS CURSOR AFTER SCROLL
;;  :after (doom-modeline)
;;  :config 
;;  (beacon-mode 1)
;;  (setq beacon-color (face-background 'doom-modeline-bar))
;; )

(use-package circadian ;; switching themes based on time
  :config
  (setq circadian-themes '(("5:30" . whiteboard)
                           ("17:30" . doom-one)))
  (circadian-setup))



;; *** dired
(add-hook 'dired-mode-hook (lambda () (setq truncate-lines t)))
(setq dired-listing-switches "-alh --time-style=+%u%t%X%t%x --color=auto -G")

;(use-package diredfl
;  :ensure t
;  :config
;  (diredfl-global-mode 1))

(use-package dired-single  :after dired) ;; dired reuse buffer functions
(setq dired-dwim-target t)


(use-package helpful
    :custom
    (counsel-describe-function-function #'helpful-callable)
    (counsel-describe-variable-function #'helpful-variable)
    :bind
    ([remap describe-function ] . counsel-describe-function)
    ([remap describe-command  ] . helpful-command          )
    ([remap describe-variable ] . counsel-describe-variable)
    ([remap describe-key      ] . helpful-key              )

)


(use-package popper ;; **** POPPER; window organizer
  :init
  (popper-mode +1)
  (popper-echo-mode +1)
  (setq popper-display-control t)
  (setq popper-mode-line '(:eval (propertize " POP" 'face 'mode-line-emphasis)))
  (setq popper-reference-buffers
        '(Custom-mode
          compilation-mode
          help-mode
          occur-mode
          helpful
          "^\\*(?!which-key|dired).*\\*$"
	  "^HELM .*"
          "^Calc:.*"
          "[Oo]utput\\*"))
  (add-to-list 'display-buffer-alist
               '("\\*ielm\\*"
                 (display-buffer-in-side-window)
                 (side . left)
                 (window-width . 50)))
  :bind ("C-`" . hy/popper-toggle/body) ;; Popper keybindings
)

(use-package ace-window
  :ensure t
  :init
  (ace-window-display-mode 1)
  
  :config
  (setq aw-keys '(?w ?i    ?e ?o    ?p ?r    ?q ?u))
  (setq aw-dispatch-always t)
  (setq aw-dispatch-alist
        '((?x aw-delete-window "Delete Window")
          (?s aw-swap-window "Swap Windows")
          (?f aw-flip-window)
          (?b aw-split-window-fair "Split Fair Window")
          (?h aw-split-window-vert "Split Vert Window") ;; Vertical means as letter V (left and right)
          (?v aw-split-window-horz "Split Horz Window") ;; Horizontal means as letter H (up and down)
          (?k delete-other-windows "Delete Other Windows")))
)

;; (use-package centaur-tabs
;;   :demand
;;   :config
;;   (centaur-tabs-mode t)
;;   (setq centaur-tabs-style "slant")
;;   (setq centaur-tabs-height 24)
;;   (setq centaur-tabs-set-icons t)
;;   (setq centaur-tabs-icon-type 'nerd-icons)
;; 
;;   (setq centaur-tabs-gray-out-icons 'buffer)
;;   (setq centaur-tabs-set-bar 'over)
;;   (setq centaur-tabs-close-button "X")
;;   (setq centaur-tabs-set-modified-marker t)
;;   (setq centaur-tabs-modified-marker "*")
;;   (centaur-tabs-change-fonts "arial" 160)
;;   (centaur-tabs-enable-buffer-alphabetical-reordering)
;;   (setq centaur-tabs-adjust-buffer-order t)
;;   
;;   :hook
;;   (dired-mode . centaur-tabs-local-mode)
;; )


(when window-system  ;; TODO
   (use-package frame
     :ensure nil
     :config
     (setq window-divider-default-right-width 1)
     (window-divider-mode 1)
     (set-face-attribute
      'window-divider nil
      :foreground (face-attribute
                   'mode-line-inactive :background)))
)


(use-package treemacs ;; **** TREEMACS; FileTree
  :defer t
  :config
  (progn
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
)

(use-package which-key
  :diminish
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3)
)

(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-width)
  ;; Check if the function exists before trying to call it
  (when (fboundp 'pdf-occur-global-minor-mode)
    (pdf-occur-global-minor-mode 1))
)


;; ***  ========   simple packages ============= ;;
(use-package gnuplot)
(use-package posframe)
(use-package which-key-posframe)
(use-package transient-posframe)
(use-package company-posframe)
(use-package sudo-edit :defer t) 
(use-package solaire-mode)
(use-package htmlize)
(use-package treemacs-projectile :after (treemacs projectile))
;(use-package treemacs-icons-dired :hook (dired-mode . treemacs-icons-dired-enable-once))
(use-package treemacs-magit :after (treemacs magit))
(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))
(use-package drag-stuff  :config  (drag-stuff-global-mode 1))
(use-package treemacs-persp  
  :after (treemacs persp-mode)
  :config (treemacs-set-scope-type 'Perspectives))
(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))
(use-package treemacs-tab-bar
  :after (treemacs)
  :config (treemacs-set-scope-type 'Tabs))

(use-package multiple-cursors 
  :config 
  (setq mc/cmds-to-run-for-all nil) ;; exapnd with time
  )

(use-package counsel  ;; better simple tasks
    :bind (
        ("M-x" . counsel-M-x)
        ("C-x b" . counsel-ibuffer)
        ("C-x C-f" . counsel-find-file)
        :map minibuffer-local-map
        ("C-r" . 'counsel-minibuffer-history)
    )
    :config 
        (setq ivy-initial-inputs-alist nil)
)

(provide 'my-03-minors)
;;; my-03-minors.el ends here
