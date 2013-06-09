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

  (put 'upcase-region 'disabled nil)

  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(scalable-fonts-allowed t))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   )

   (when (eq system-type 'darwin)
        ;; default Latin font (e.g. Consolas)
        (set-face-attribute 'default nil :family "Bitstream Vera Sans Mono")
        ;; default font size (point * 10)
        ;; WARNING!  Depending on the default font,
        ;; if the size is not supported very well, the frame will be clipped
        ;; so that the beginning of the buffer may not be visible correctly. 
        (set-face-attribute 'default nil :height 165)
        ;; use specific font for Korean charset.
        ;; if you want to use different font size for specific charset,
        ;; add :size POINT-SIZE in the font-spec.
  ;      (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))
        ;; you may want to add different for other charset in this way.
        )
