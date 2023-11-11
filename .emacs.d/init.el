
(require 'package)
(let ((default-directory "~/.emacs.d/elpa"))
     (normal-top-level-add-subdirs-to-load-path))
     (setq package-check-signature nil)
     (setq use-package-verbose nil)
     (setq package-enable-at-startup t)
     (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                             ; ("marmalade" . "https://marmalade-repo.org/packages/")
                             ; ("org" . "https://orgmode.org/elpa/")
                              ("gnu" . "https://elpa.gnu.org/packages/")
                              ("elpy" . "https://jorgenschaefer.github.io/packages/")))
(setq package-check-signature nil)
(setq package-enable-at-startup t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)
(message "%s" "package used")

(setq byte-compile-warnings '(not line-length))
(setq byte-compile-warnings nil)
(setq warning-minimum-level :error)
;(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))


(defun load-all-configs-in-dir (dir)
  "Load all `.el` files (except init.el) in the specified directory DIR in order of their filenames."
  (let ((files (remove (expand-file-name "init.el" dir)
                       (directory-files dir t "\\.el$"))))
    (mapc 'load-file (sort files 'string<))))

(load-all-configs-in-dir "~/.emacs.d/")

(setq gc-cons-threshold (* 1000 1000))

(use-package server)
(unless (server-running-p)
  (server-start))
