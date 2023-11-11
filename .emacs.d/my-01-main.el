
;; ** ========= CLEAN EMACS  =========================== ;;

(setq package-enable-at-startup nil)
(setq inhibit-startup-message nil)
(setq inhibit-startup-screen nil)
(scroll-bar-mode -1) ; disable scrollbar
(tool-bar-mode -1) ; disable toolbar
(tooltip-mode -1)
(set-fringe-mode 10) ; some breathing room ?
(menu-bar-mode -1)
(setq visible-bell t)
(setq initial-frame-alist '((width . 160) (height . 60)))    ; Set the initial width to Columns X Lines
(set-default-coding-systems 'utf-8)
(display-time-mode 1)
(setq display-time-24hr-format t)

;; The default is 180 MB.  Measured in bytes.
(setq gc-cons-threshold (* 180 1000 1000))


;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.emacs.d/cache")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

(column-number-mode)
(global-display-line-numbers-mode t)


(dolist (ext '("png" "webp" "jpeg"))
  (add-to-list 'image-file-name-extensions ext))



(use-package fira-code-mode
  :custom (fira-code-mode-disabled-ligatures '("[]" "#{" "#(" "#_" "#_(" "x" ":\n")) ;; List of ligatures to turn off
  ;:config (global-fira-code-mode)
  ;:hook prog-mode ;; Enables fira-code-mode automatically for programming major modes
)
(set-face-attribute 'italic nil
                    :family "DejaVu Sans" 
                    :slant 'oblique
                    :underline nil)



(provide 'my-01-main)
;;; my-01-main.el ends here
