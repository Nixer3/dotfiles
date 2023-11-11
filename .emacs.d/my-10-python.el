(require 'cl-lib)
(defun my/pip-install (pkg-list)
  (dolist (pkg pkg-list)
    (let ((pkg-name (symbol-name pkg)))
      (async-start
       `(lambda ()
          (let ((pkg-name ,pkg-name))  ; capture pkg-name explicitly
            (if (= 0 (shell-command (concat "python3 -m pip show " pkg-name)))
                "already installed"
              (if (= 0 (shell-command (concat "pip3 install " pkg-name)))
                  "installed"
                "not installed"))))
       `(lambda (result)
          (message "Package %s is %s." ,pkg-name result))))))


(my/pip-install '(jedi black autopep8 yapf))

(defun anaconda-installed-p ()
  (zerop (shell-command "python3 -m pip show anaconda")))

(unless (anaconda-installed-p)
  (shell-command "pip3 install anaconda"))

(defun ensure-anaconda-installed ()
  (unless (anaconda-installed-p)
    (when (y-or-n-p "Anaconda is not installed. Install it now? ")
      (shell-command "pip install anaconda"))))

(ensure-anaconda-installed)

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

(use-package anaconda-mode
  :ensure t
  :init
  (add-hook 'python-mode-hook 'anaconda-mode))

;; Anaconda mode setup
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(use-package jupyter
  :ensure t
  :defer t
  :init
  (setq jupyter-repl-echo-eval-p t)
  )

(use-package ein
  :commands (ein:notebooklist-open)
  )

(provide 'my-10-python)
;;; my-10-python.el ends here
