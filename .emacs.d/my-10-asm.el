(use-package asm-mode)
(add-to-list 'auto-mode-alist '("\\.asm\\'" . asm-mode))
(use-package realgud)
(define-key asm-mode-map (kbd "C-c C-d") 
  (lambda () 
    (interactive)
    (let* ((filename (file-name-sans-extension buffer-file-name))
           (execname (file-name-nondirectory filename)))
      (realgud:gdb (concat "gdb ./" execname "-elf.out")))))

(define-key asm-mode-map (kbd "C-c C-c") 'compile-asm-to-elf)


(defun compile-asm-to-elf ()
  "Compile the current asm file using nasm and gcc."
  (interactive)
  (save-buffer)
  (let* ((filename (buffer-file-name))
         (basename (file-name-sans-extension filename))
         (objname (concat basename ".o"))
         (outname (concat basename "-elf.out"))
         (nasm-command (format "nasm -f elf64 -o %s %s" objname filename))
         (gcc-command (format "gcc -g -o %s %s -no-pie -nostdlib" outname objname))
         (nasm-output (shell-command-to-string nasm-command))
         (nasm-result (shell-command nasm-command))
         (gcc-output (shell-command-to-string gcc-command))
         (gcc-result (shell-command gcc-command)))

    (if (not (string-empty-p nasm-output))
        (progn
          (message "Failed during NASM compilation! Output: %s" nasm-output)
          (cl-return-from compile-asm-to-elf))
      (if (or (not (string-empty-p gcc-output)) (not (zerop gcc-result)))
          (message "Failed during GCC linking! Output: %s" gcc-output)
        (message "Compilation done!")))))



;; Optional key binding
(define-key asm-mode-map (kbd "C-c C-r") 'my-run-compiled-shellcode)
(defun my-run-compiled-shellcode ()
  "Run the compiled shellcode of the current ASM file."
  (interactive)
  (let* ((filename (file-name-sans-extension buffer-file-name))
         (executable (concat filename ".run")))
    (if (file-executable-p executable)
        (shell-command executable)
      (message "Executable not found or not executable!"))))

(provide 'my-10-asm)
;;; my-10-asm.el ends here
