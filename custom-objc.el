;; Yinjiaji's Emacs config in Mac OS X
;; Email: yinjiaji110@gmail.com
;;


;;;;;;;;;;;;;;;;;;;;;;;Objc Related;;;;;;;;;;;;;;;;;;;;;;;
;;Auto into objc-mode                                                                  
(add-to-list 'auto-mode-alist '("\\.mm?$" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.h$" . objc-mode))

;;Switch  between header (.h) and source (.m) file
;;-- Obj-C switch between header and source ---
(defun objc-in-header-file ()
  (let* ((filename (buffer-file-name))
         (extension (car (last (split-string filename "\\.")))))
    (string= "h" extension)))

(defun objc-jump-to-extension (extension)
  (let* ((filename (buffer-file-name))
         (file-components (append (butlast (split-string filename
                                                         "\\."))
                                  (list extension))))
    (find-file (mapconcat 'identity file-components "."))))

;;; Assumes that Header and Source file are in same directory
(defun objc-jump-between-header-source ()
       (interactive)
       (if (objc-in-header-file)
       (objc-jump-to-extension "m")
       (objc-jump-to-extension "h")))

(defun objc-mode-customizations ()
  (define-key objc-mode-map (kbd "C-c t") 'objc-jump-between-header-source)
  (global-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'objc-mode-hook 'objc-mode-customizations)

(load "adaptive-wrap-0.2")
(add-hook 'objc-mode-hook 'visual-line-mode)
(add-hook 'objc-mode-hook 'adaptive-wrap-prefix-mode)
(add-hook 'objc-mode-hook (lambda ()
                            (setq adaptive-wrap-extra-indent 4)))


