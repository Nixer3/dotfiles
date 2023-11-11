
;; Base config for C
(use-package cc-mode
  :ensure t
  :hook (c-mode . (lambda ()
                    (setq c-basic-offset 4)
                    (c-set-style "stroustrup"))))

;; Code Formatting
(use-package clang-format
  :ensure t
  :bind (("C-c f" . clang-format-region))
  :config
  (setq clang-format-style "llvm"))


;; Initialize setup
(defun my/c-mode-hook ()
  "Hooks for C mode."
  (setq tab-width 4))

(add-hook 'c-mode-hook 'my/c-mode-hook)




(provide 'my-10-c)
;;; my-10-c.el ends here
