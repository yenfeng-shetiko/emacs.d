;;;must key
(global-set-key (kbd "M-h") (lambda () (interactive) (find-file "~/.emacs")))
(global-set-key (kbd "M-SPC") 'set-mark-command)
(global-set-key (kbd "M-[") 'set-mark-command)
(global-set-key (kbd "C-x k") (lambda () (interactive) (kill-buffer (current-buffer))))
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x C-3") 'server-edit)
(global-set-key (kbd "C-'") 'server-edit)
(global-set-key (kbd "C-c o") 'occur)
(global-set-key (kbd "C-c g") 'jr-global-tag)
(global-set-key (kbd "C-c r") 'jr-global-root-file)
(global-set-key (kbd "<f7>") 'compile)
(global-set-key (kbd "M-o") 'jr-find-alt-buf-or-file)

;;;must mode
(ido-mode)
(transient-mark-mode 0)
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

;;;must UI
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))


;;;;;;;;;;;;;;;;;;;;;;;;must jr code
(defun jr-global-tag ()
  (interactive)
  (ignore-errors (kill-buffer "*GTAGS*"))
  (save-excursion
	(let ((buf)
		  (tag (read-string "Tag:")))
	  (setq buf (pop-to-buffer "*GTAGS*"))
	  (setq tag (replace-regexp-in-string "\\*" ".*" tag))
	  (make-local-variable 'compilation-error-regexp-alist)
	  (compilation-minor-mode)
	  (add-to-list 'compilation-error-regexp-alist
				   '("\\sw+\\s +\\([0-9]+\\)\\s +\\([^ ]+\\)" 2 1))
	  (start-process "GTAG" buf "global" "-x" "-i" tag)
	  (set-process-sentinel (get-buffer-process (current-buffer))
							(lambda (process event)
							  (when (string-match "finished" event)
								(goto-char (point-max))
								(insert
								 (format "Process: %s had finished" process))
								(goto-char (point-min))
								(font-lock-mode)))))))

(defun jr-global-root-file ()
  (interactive)
  (ignore-errors (kill-buffer "*GROOT*"))
  (save-excursion
	(let ((buf)
		  (name (read-string "Name:")))
	  (setq buf (pop-to-buffer "*GROOT*"))
	  (setq name (replace-regexp-in-string "\\*" ".*" name))
	  (make-local-variable 'compilation-error-regexp-alist)
	  (while (or (not (file-exists-p ".cr_root"))
				 (not (string-match "/\\|\\(.:/\\)" default-directory)))
		(cd ".."))
	  (when (not (file-exists-p ".cr_root"))
		(message "no .cr_root founded"))
	  (compilation-minor-mode)
	  (add-to-list 'compilation-error-regexp-alist
				   '("\\([^\n ]+\\)" 1))
	  (start-process "GROOT" buf "grep" "-i" name ".cr_root")
	  (set-process-sentinel (get-buffer-process (current-buffer))
							(lambda (process event)
							  (when (string-match "finished" event)
								(goto-char (point-max))
								(insert
								 (format "Process: %s had finished" process))
								(goto-char (point-min))
								(font-lock-mode)))))))

(defun jr-flip-file-name (fn)
  (cond ((string-match ".*\\.cpp" fn)
		 (replace-regexp-in-string "\\.cpp" ".h" fn))
		((string-match ".*\\.h" fn)
		 (if (replace-regexp-in-string "\\.h" ".cpp" fn)
			 (replace-regexp-in-string "\\.h" ".cpp" fn)
		   (replace-regexp-in-string "\\.h" ".c" fn)))
		(t "")))
(defun jr-find-alt-buf-or-file ()
  "switch between .h .cpp"
  (interactive)
  (let* ((fn (buffer-name))
		 (ffn (buffer-file-name))
		 (fn-new (jr-flip-file-name fn))
		 (ffn-new (jr-flip-file-name ffn)))
	(cond ((memq (get-buffer fn-new)
				 (buffer-list))
		   (switch-to-buffer (get-buffer fn-new)))
		  ((and (> (length ffn-new) 0) (file-exists-p ffn-new))
		   (find-file ffn-new)))))
(defun eshell/clear ()
  "04Dec2001 - sailor, to clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))
(defalias 'e/c 'eshell/clear)
;;;;;;;;;;;;;;;;;;;;;;;;jr code end

;;;must hook
(defun my-c-mode-hook ()
  (c-set-style "stroustrup"))
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)
(setq jr-customize-bg-color "black")
(when window-system
  (setq jr-customize-bg-color "#314f4f"))
(server-start)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default-tab-width 4 t)
 '(frame-title-format (quote ("%b || Emacs ||" (:eval (current-time-string)))) t)
 '(inhibit-startup-screen t)
 '(truncate-lines t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:background "#314f4f")))))


(when (not window-system)
  (custom-set-faces
 '(default ((t (:background "black"))))))
(put 'dired-find-alternate-file 'disabled nil)
————————————————
版权声明：本文为CSDN博主「JoyerHuang_悦」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/DelphiNew/article/details/6732295
