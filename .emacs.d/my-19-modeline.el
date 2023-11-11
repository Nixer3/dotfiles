(global-set-key (kbd "C-r") (lambda () (interactive) (load-file (expand-file-name "~/.emacs.d/modeline-config.el")) (message "Modeline config reloaded.")))


;; ======= modeline string-segments ============ ;;
(defvar my/modeline-string-segment/sunset-sunrise "Sunset/Sunrise")
(defvar my/modeline-string-segment/music-playing "Music Playing")
(defvar my/modeline-string-segment/window-number "Window Number")
(defvar global-mode-string "{init}")

  

(defun my/modeline-string-segment/sunset-sunrise-update () ;; NEED TO CALL SOMETIME
  (setq my/modeline-string-segment/sunset-sunrise
        (let* ((sunset-time (decimal-to-time (my/get-sunset 'today)))
               (sunrise-time (decimal-to-time (my/get-sunrise 'tomorrow))))
          (format "%s %s %s"
                  sunset-time
                  my-moon-icon
                  sunrise-time
          )
        )
  )
)


(defun my/modeline-string-segment/music-playing-update () ;; NEED TO CALL SOMETIME
  (setq my/modeline-string-segment/music-playing "Muzik"))

(defun my/modeline-string-segment/window-number-update () ;; NEED TO CALL SOMETIME
  (setq my/modeline-string-segment/window-number "{X}"))

(defun my/modeline-string-segment-refresh () ;; from variables->mode-string (no values update)    
  (setq global-mode-string
              (list (format "|%s|" 
                             my/modeline-string-segment/sunset-sunrise 
                    )
              )
  )
)
(defun my/modeline-string-update-all ()
  (interactive)
  (my/modeline-string-segment/sunset-sunrise-update)
  (my/modeline-string-segment-refresh)
)
(my/modeline-string-update-all)
(setq sun-times-timer (run-at-time "3 hours" (* 3 3600) 'my/modeline-string-update-all))

;; To cancel
;(cancel-timer sun-times-timer)



(use-package doom-modeline
  :ensure t  
  :init (doom-modeline-mode 1)


  :custom
  (doom-modeline-vcs-max-length 12) 
  (doom-modeline-remote t) 
  (doom-modeline-height 35)
  (doom-modeline-bar-width 10)
  (doom-modeline-buffer-file-icon t)
  (doom-modeline-buffer-encoding t)
  (doom-modeline-env-version t)
  (doom-modeline-workspace-name t)
  (doom-modeline-persp-name t)
  
)

(defun my-refresh-config ()
  (interactive)
  (my/modeline-string-update-all)

  
  

  (message "%s" "My resfresh done.")
)

(global-set-key (kbd "C-S-R") 'my-refresh-config)

