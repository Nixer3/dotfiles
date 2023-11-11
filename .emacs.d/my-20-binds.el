(use-package bind-key)
(use-package hydra)
;; Hydra Colors Explained 
;; :timeout X seconds
;; - :color red      -> stays, just hydra commands
;; - :color amaranth -> stays, hydra + other maps
;; - :color blue     -> closes,
;; - :color teal     -> Like amaranth, but the heads can't be disabled.
;; - :color pink     -> closes, iff cmd successful
;; - :color green    -> The Hydra will exit and the head will be interpreted as an Emacs command,
;;                        calling the before and after hooks as if the command was invoked by itself.
;;(add-to-list 'display-buffer-alist
;;             '("\\*?\\pdf\\-?\\(view\\|isearch\\)\\*?"
;;               (display-buffer-reuse-window display-buffer-in-side-window)
;;               (side . right)
;;               (reusable-frames . visible)
;;               (window-width . 0.5)))



;; *** =========     KEYBINDS    HYDRA+BIND-KEY       ============ ;;

;;(define-key input-decode-map [?\C-i] [C-i])  ;; in gui differenciate C-i vs TAB
(global-set-key (kbd "<escape>") 'keyboard-quit)
(global-set-key (kbd "C-M-u") 'universal-argument)
(global-unset-key (kbd "C-t"))
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-f")) 
(global-unset-key (kbd "C-h h")) 
(global-unset-key (kbd "C-b"))
(global-unset-key (kbd "C-n"))
(global-unset-key (kbd "C-p"))
(global-unset-key (kbd "C-w"))
(global-unset-key (kbd "C-y"))
(global-unset-key (kbd "C-u"))
(global-unset-key (kbd "C-x C-s"))
(global-unset-key (kbd "C-x k"))
(global-unset-key (kbd "C-x o")) ;;using ace-window
(global-unset-key (kbd "C-x C-k"))
(global-unset-key (kbd "C-h b"))
(global-unset-key (kbd "C-h p"))
(global-unset-key (kbd "C-S-j"))
(global-unset-key (kbd "C-S-l"))
(global-unset-key (kbd "C-x C-o"))

(define-key override-global-map (kbd "M-<backspace>") 'open-buffer-directory)

(bind-keys  ;; see M-SPC also
 ("M-i" . previous-line)      ; Up
 ("M-j" . backward-char)      ; Left
 ("M-k" . next-line)          ; Down
 ("M-l" . forward-char)       ; Right
 ("M-u" . backward-delete-char-untabify)
 ("M-o" . custom-delete-or-kill-region) ;delets char, or or region if selected
 ("C-u" . backward-kill-word)
 ("C-o" . kill-word)
 ("C-d" . duplicate-line)
 ("M-n" . kill-line-or-region)
 ("M-N" . copy-line-or-region)
 ("M-m" . yank) 
 ("M-M" . counsel-yank-pop)
 ("C-x k" . kill-current-buffer)
 ("C-x K" . kill-buffer)
 ("C-S-j" . move-beginning-of-line)
 ("C-S-l" . move-end-of-line)

 ("C-j" . backward-word)
 ("C-l" . forward-word)
 ("M-f" . copy-isearch-match)
 ("C-x o" . ace-window)
 ("M-0" . treemacs-select-window)
 ("C-x t t" . treemacs) ;DEP: TREEMACS
 ("C-h h r" . reload-my-init)
 ("C-h p" . print-doc-as-org-table)
 ("C-x C-k" . kill-buffer-window);;resume
 ("<S-mouse-4>" . scroll-right) 
 ("<S-mouse-5>" . scroll-left)
 ("C-x g" . exit-minibuffer)
 ("C-f" . swiper) ; DEP: IVY
 ("C-x C-o" . my/open-file-at-point)

 ("C-x C-s" . my/save-or-sudo-save)
 
 ;; ("M-f" . to search avy
 ("M-SPC" . hy/move/body)
 ("C-w" . hy/window-management/body)


 )      
;(bind-keys :map LaTeX-mode-map
; ("C-c c" . (lambda () (interactive) (save-buffer) (TeX-command-run-all nil)))
;)

(bind-keys :map org-mode-map
 ("C-c t m" . my/open-tree-view) ;; org minimap of headings
 ("<f5>"    . (lambda () (interactive) (org-tree-slide-mode) (hy/org-presentation/body)))
 ("C-c r"   . org-redisplay-inline-images)
 ("C-c a"   . org-fold-show-all)
 ("C-c d y" . org-download-yank)
 ("C-c d e" . org-download-edit)
 ("C-c d i" . org-download-image)
 ("C-c d d" . org-download-delete)
 ("C-c d c" . org-download-clipboard)
 ("C-c d s" . org-download-screenshot)
 ("C-c d r" . org-download-rename-at-point)
 ("C-c d l" . org-download-rename-last-file)
)
(defhydra hy/org-presentation (:color amaranth :hint nil)
				      
  ("<f1>"  treemacs)
  ("<f2>"  centaur-tabs-mode)
  ("ESC" (progn (org-tree-slide-mode -1)
                (hydra-deactivate)) :exit t)                           
  ("<right>" org-tree-slide-move-next-tree)
  ("<left>"  org-tree-slide-move-previous-tree)
  ("RET"     org-tree-slide-move-previous-tree)
  ("SPC"     org-tree-slide-move-next-tree)
)
(defhydra hy/move (:color red 
                   :hint nil 
                   ;:pre (set-cursor-color "#40e0d0")
                   ;:post (set-cursor-color "#ffffff")
                   )
  "
^Move^ ch| line           ^Word^             ^Drag-stuff^   ^CUA-universals^      
-------------^^+----------------^^-+------------^^+------------------------------------------------
_M-i_: ⇧       | _i_: ⇧ Paragraph  | _I_: drag-⇧  | _C-d_: dup.⇩ line   _C-z_ : undo            
_M-j_: ⇦  _C-j_  | _j_: ⇦ Word       | _J_: drag-⇦  | _C-x_ / _M-n_: kill   _C-a_: mark-all 
_M-k_: ⇩       | _k_: ⇩ Paragraph  | _K_: drag-⇩  | _C-c_ / _M-N_: copy   _C-s_: save-buffer 
_M-l_: ⇨ ,_C-l_  | _l_: ⇨ Word       | _L_: drag-⇨  | _C-v_ / _M-m_: yank   _y_ / _h_: mc up/down
_M-u_: 'BackSp | _u_: 'BackSp-word |--------------------------------------------------------------                    
_M-o_: 'DEL    | _o_: 'DEL-word    | _S-SPC_: set-mark   (S-)_<tab>_: (un)intend  _M-M_: yank-pop
"
  ("C-j"  move-beginning-of-line)
  ("C-l"  move-end-of-line)
  ("M-i"  previous-line)
  ("M-j"  backward-char)
  ("M-k"  next-line)
  ("M-l"  forward-char)
  ("M-u"  backward-delete-char-untabify)
  ("M-o"  custom-delete-or-kill-region)
  (  "u"  backward-kill-word)
  (  "o"  kill-word)
  (  "i"  backward-paragraph)
  (  "j"  backward-word)
  (  "k"  forward-paragraph)
  (  "l"  forward-word)
;  ("C-d"  duplicate-line)  ; is in universals
  ("M-n"  kill-line-or-region)
  ("M-N"  copy-line-or-region)
  ("M-m"  yank) 
  ("M-M"  counsel-yank-pop)
  ("S-SPC"  set-mark-command)
  ("<tab>"  (lambda () (interactive) (horizontal-shift-region tab-width)) )
  ("<backtab>"  (lambda () (interactive) (horizontal-shift-region (- tab-width))))
;;DRAG-STUFF
  ("I"  drag-stuff-up)   
  ("J"  drag-stuff-left) 
  ("K"  drag-stuff-down) 
  ("L"  drag-stuff-right)
  ("y" mc/mark-previous-like-this )
  ("h" mc/mark-next-like-this)
;; UNIVERSALS
  ("C-a" mark whole buffer)
  ("C-s" save-buffer)
  ("C-z" undo)
  ("C-x" kill-line-or-region)
  ("C-c" copy-line-or-region)
  ("C-v" yank)
  ("C-w" kill-buffer-window)
  ("C-d" duplicate-line)
;;define mouse so it wont disrupt hyra
  ("<down-mouse-1>" mouse-drag-region)
  ("<drag-mouse-1>" mouse-set-region)
  ("<mouse-1>"      mouse-set-point)
  ("M-SPC" nil "quit" :exit t)
  ("q" nil "quit" :exit t)
)

(defun toggle-word-wrap-other-window ()  ;; not working
  "Toggle word wrapping in the other window without moving focus."
  (interactive)
  (save-selected-window
    (other-window 1)
    (setq word-wrap (not word-wrap))
    (message "word-wrap: %s" word-wrap)
  )
)


(defhydra hy/window-management (:color red :hint nil)
  "
Window Management:
  ^Resize^              ^Misc^
  ^^^^^^^^------------------------------------------
  _i_: ↑   _C-i_: ↑ 5     _/_: flash-active-window  _z_: word wrap
  _j_: ←   _C-j_: ← 5     _t_: centaur-tabs (→)     _n_: line number
  _k_: ↓   _C-k_: ↓ 5     _w_: delete-window
  _l_: →   _C-l_: → 5     
  "
  ("i" (enlarge-window 1))
  ("j" (shrink-window-horizontally 1))
  ("k" (shrink-window 1))
  ("l" (enlarge-window-horizontally 1))
  ("C-i" (enlarge-window 5))
  ("C-j" (shrink-window-horizontally 5))
  ("C-k" (shrink-window 5))
  ("C-l" (enlarge-window-horizontally 5))

  ("z" visual-line-mode :color blue)
  ("n" display-line-numbers-mode :color blue)
  
  ("/" flash-active-window)
  ("t" hy/centaur-tabs/body :color blue)
  ("w" delete-window)
  ("TAB" (toggle-word-wrap-other-window))
  ("q" nil "quit")
)


(defhydra hy/popper-toggle (:color red)
  "Popper"
  ("`"    popper-cycle         "cycle")
  ("M-`"      popper-toggle-latest "toggle-latest")
  ("C-M-`"  popper-toggle-type  "toggle-type")
  ("q"      nil                 "quit" :exit t)
)

(defhydra hy/git (:color blue)
  "Git Operations"
  ("b" blamer-show-commit-info "Blamer: Show Commit Info")
  ("s" magit-status "Magit: Status")
  ("c" magit-commit "Magit: Commit")
  ;; Add more magit options here
  ("q" nil "quit" :exit t))


(defhydra hy/centaur-tabs (:color red)
  "Centaur Tabs"
  ("j" centaur-tabs-backward "Previous Tab")
  ("l" centaur-tabs-forward "Next Tab")
  ("u" centaur-tabs-close-other-tabs "Close Other Tabs") ;; TODO: close current
  ("o" centaur-tabs-close-other-tabs "Close Other Tabs")
  ("q" nil "quit" :exit t))

(defhydra hy/minor-modes (:color blue)
  "Minor Modes"
  ("g" hy/git/body "Git Functions")
  ("v" hy/verbum/body "Verbum Functions") ;; for wording minor modes
  ("q" nil "quit" :exit t)
)

(with-eval-after-load 'treemacs
  (treemacs-resize-icons 16)
  (bind-keys*
   :map treemacs-mode-map
   ("M-k" . treemacs-next-line)
   ("M-i" . treemacs-previous-line)
   ("M-l" . treemacs-RET-action)
   ("M-j" . treemacs-goto-parent-node)
   ("M-J" . treemacs-root-up)
   ("M-L" . treemacs-root-down)
   ("SPC" . (lambda () (interactive) (treemacs-find-node)))
  )
)



(bind-keys :map dired-mode-map   ;; DIRED
           ([mouse-1] . dired-single-buffer-mouse)
           ([return] . dired-single-buffer)
           ("M-l" . dired-single-buffer)
           ("M-j" . goto-parent-dir)
           ("C-l" . open-file-in-new-window-right-or-down)
           ("C-j" . open-parent-in-new-window-on-left)
)

;; Separate key bindings for counsel
(bind-keys
 ("M-x" . counsel-M-x)
 ("C-x b" . counsel-ibuffer)
 ("C-x C-f" . counsel-find-file)
 ("C-h b" . counsel-descbinds)
 :map minibuffer-local-map
       ("C-r" . counsel-minibuffer-history)
)
;; **** HYDRAS; Shortcuts and menus
(defhydra hydra-force-quit (:color blue :hint nil)
  "
  Force Quit Menu
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  _q_: Kill Emacs      _a_: Save All & Quit
  _s_: Save Session    _b_: Kill Buffer No Save
  "
  ("q" kill-emacs "Kill Emacs" :exit t)
  ("a" save-all-buffers-and-quit "Save All & Quit" :exit t)
  ("s" save-session-kill-emacs "Save Session & Quit" :exit t)
  ("b" kill-buffer-dont-save-delete-window "Kill Buffer No Save" :exit t)
  ("ESC" nil "quit" :exit t))

(defhydra hydra-quit (:color blue :hint nil)
  "
  Quit Menu
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  _m_: Quit Major Mode  _q_: Ask Save & Quit
  _a_: Save All & Quit  _b_: Kill Buffer Ask Save
  _c_: Close Frame      _f_: Force Quit Menu
  "
  ("m" fundamental-mode " Major Mode" :exit t)
  ("q" ask-save-buffers-and-quit "Ask Save & Quit" :exit t)
  ("a" save-all-buffers-and-quit "Save All & Quit" :exit t)
  ("b" kill-buffer-ask-for-save-delete-window "Kill Buffer Ask Save" :exit t)
  ("c" delete-frame "Close Frame" :exit t)
  ("f" hydra-force-quit/body "Force Quit Menu")
  ("ESC" nil "quit" :exit t))



(defhydra hydra-python (:color red :hint nil)
  "
  Quit Menu
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  _y_: Function back  
  _h_: Function fwd    
  _ESC_: Close Frame    
  "
  ("y" python-nav-backward-defun "Goto previous function")
  ("h" python-nav-forward-defun "Goto next function")
  ("ESC" nil "quit" :exit t))


;; Assign the main hydra to a key sequence
(bind-keys ("C-q" . hydra-quit/body))

(bind-keys :map pdf-view-mode-map  ;;   PDF-VIEW-MODE-MAP
           ("+" . pdf-view-enlarge)
           ("-" . pdf-view-shrink))


(bind-keys :map ivy-minibuffer-map      ;; IVY
           ("M-i" . ivy-previous-line)
           ("M-k" . ivy-next-line))

(bind-keys :map ivy-switch-buffer-map
           ("M-i" . ivy-previous-line)
           ("C-SPC" . ivy-alt-done)
           ("RET" . ivy-alt-done))

(bind-keys :map ivy-reverse-i-search-map
           ("C-r" . ivy-previous-line)
           ("C-k" . ivy-reverse-i-search-kill))

(bind-keys :map python-mode-map  ;;   PDF-VIEW-MODE-MAP
           ("C-c SPC" . hydra-python/body))

(with-eval-after-load 'treemacs
  (bind-keys :map js-mode-map
	    ("C-x C-e" . nodejs-repl-send-last-expression)
            ("C-c C-j" . nodejs-repl-send-line)
            ("C-c C-r" . nodejs-repl-send-region)
            ("C-c C-c" . nodejs-repl-send-buffer)
            ("C-c C-l" . nodejs-repl-load-file)
            ("C-c C-z" . nodejs-repl-switch-to-repl)
            ("C-c C-c" . my-run-current-js-file)
	  )
)
(provide 'my-20-binds)
;;; my-20-binds.el ends here
