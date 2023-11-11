(defun vterm-bottom ()
    "Split window and spawn vterm there"
    (interactive)
    (let* ((ignore-window-parameters t)
           (dedicated-p (window-dedicated-p)))
        (split-window-vertically)
        (other-window 1)
        (vterm))
)
(defun my/setup-vterm-custom-font ()
  "Set custom font for vterm."
  (setq buffer-face-mode-face '(:family "MesloLGSDZ Nerd Font Mono" :height 120))
  (buffer-face-mode t)
)

(use-package vterm
  :ensure t
  :hook (vterm-mode . my/setup-vterm-custom-font)

  :commands vterm
  :config
  (setq vterm-always-compile-module t)
  (setq vterm-max-scrollback 10000)
  (setq vterm-shell "/usr/bin/zsh")

 

  :bind
  ("<M-f12>" . vterm-bottom))

(provide 'my-10-term)
;;; my-10-term.el ends here
