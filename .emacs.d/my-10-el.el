
;; LSP for enhanced IDE features
(use-package lsp-mode
  :ensure t
  :hook ((c-mode . lsp-deferred))
  :commands lsp-deferred)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(provide 'my-10-eel)
;;; my-10-el.el ends here
