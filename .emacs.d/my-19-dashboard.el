(use-package dashboard
  :after (org )
  :init
  (dashboard-setup-startup-hook)
  :config
  (setq dashboard-banner-logo-title "Hello Nixer")    
  (setq dashboard-display-icons-p t) ;; display icons on both GUI and terminal
  (setq dashboard-icon-type 'nerd-icons) ;; or 'all-the-icons package
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-init-info t)
  (setq dashboard-center-content t)     ; Center the content
  (dashboard-modify-heading-icons '(
                                    (recents . "nf-oct-clock")
                                    (projects . "nf-oct-versions")
                                    (bookmarks . "nf-oct-bookmark")
                                    (agenda . "nf-oct-briefcase")
                                   )
  )
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5)
                          ;(agenda . 5) TODO <2023-09-10> fix this shit
                            )

  )
  (setq dashboard-set-heading-icons t)
  (setq dashboard-footer-messages '("Let's get to it!"))
  (setq dashboard-startup-banner "/home/nixer/.emacs.d/emacs-dino-200.png")
  (setq dashboard-set-navigator t)
  ;:custom
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
)
