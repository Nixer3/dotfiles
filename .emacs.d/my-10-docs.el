
(use-package latex-preview-pane
  :ensure t
  :hook (latex-mode . tex-preview-pane-mode)
  :config (latex-preview-pane-enable)
  )

(use-package tex
  :ensure auctex
  :hook ( (LaTeX-mode . (lambda () (
			      add-hook 'after-save-hook (lambda () (TeX-command-run-all nil))
				       nil 'make-it-local
			     )
	               )
	   )
	 )
  ((TeX-after-compilation-finished-functions . my/TeX-revert-document-buffer))
  :config
  (defun my/TeX-revert-document-buffer (file process event)
    "Revert PDF buffer after TeX compilation has successfully finished."
    (let ((pdf-file (file-name-sans-extension file)))
      (setq pdf-file (concat pdf-file ".pdf"))
      (when (file-exists-p pdf-file)
        (find-file-other-window pdf-file)
        (pdf-view-revert-buffer nil t)
        (other-window -1))))

  
  (setq TeX-PDF-mode t)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")) TeX-source-correlate-start-server t)
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
)


(provide 'my-10-docs)
;;; my-10-docs.el ends here
