; disable annoying Ctrl-Z send to background
(global-set-key "\C-Z" nil)
; UI customizations
; Get rid of that icon tool bar
(if (memq window-system '(x w32 mac))
  (tool-bar-mode -1))
;; Remove splash screen
(setq inhibit-splash-screen t)
; shutup the beep
(setq visible-bell t)

;;Set up copy and paste
;;http://www.lingotrek.com/2010/12/integrate-emacs-with-mac-os-x-clipboard.html
(setq x-select-enable-clipboard t)
(defun mac-copy ()
(shell-command-to-string "pbpaste"))

(defun mac-paste (text &optional push)
(let ((process-connection-type nil)) 
(let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
(process-send-string proc text)
(process-send-eof proc))))

(setq interprogram-cut-function 'mac-paste)
(setq interprogram-paste-function 'mac-copy)

(custom-set-variables
 '(desktop-buffers-not-to-save "\\(^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|.*_flymake.*\\)$")
 '(desktop-files-not-to-save "^/[^/:]*:\\|.*_flymake\\..*"))

; activate textmate type snippets
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/snippets")

; activate pastie
(require 'pastie)

; auto completion
;(load "custom-autocomplete")
;;(add-to-list 'load-path (concat myoptdir "AC"))
(require 'auto-complete-config)
;;(add-to-list 'ac-dictionary-directories (concat myoptdir "AC/ac-dict"))
;(require 'custom-autocomplete)
(load "custom-autocomplete")

; automatic syntax check
(require 'flymake)
;(setq flymake-log-level 3)

; never use tabs
(setq-default indent-tabs-mode nil)
(setq show-trailing-whitespace t)

;; from http://emacseditor.tribe.net/thread/5729c619-6e30-4b75-89fe-365388da52bf
;; Trim any trailing whitespaces before saving a file
;;(defun trim-trailing-whitespace ()
;;"This will trim trailing whitespace before saving a file."
;;(interactive)
;;(save-excursion
;;(beginning-of-buffer)
;;(replace-regexp "[ \t]+$" "" nil)
;;nil)
;;)

(setq-default show-trailing-whitespace t)
;;(defun toggle-trim-whitespace-on ()
;;"This turns on whitespace trimming"
;;(interactive)
;; Add the hooks
;;(add-hook 'write-file-hooks 'trim-trailing-whitespace))
;;(defun toggle-trim-whitespace-off ()
;;"This turns pff whitespace trimming"
;;(interactive)
;; Remove the hooks
;;(remove-hook 'write-file-hooks 'trim-trailing-whitespace))
;; On by default
;;(add-hook 'write-file-hooks 'trim-trailing-whitespace)

; dont create backups
(setq make-backup-files nil)

(load "custom-cmake") ; cmake autoload
(load "custom-git") ; git mode

(global-auto-revert-mode)

; buffer list with alt-return
;(global-set-key [(meta return)] 'electric-buffer-list   )
(global-set-key (kbd "M-RET") 'electric-buffer-list   )
; I hate the ctrl-z stuff
;(global-set-key "C-Z" nil)

(load "custom-python") ; python
(load "custom-ruby") ; ruby customization
(load "custom-ycp") ; ycp customization
(load "custom-c") ; C/C++ customization
(load "custom-java") ; Java customization
(load "custom-vala")
(load "custom-objc"); Objective-c customization

;;Unicad
(load "unicad")
(require 'unicad)

;;line number display in left-margin of buffer
(load "linum")
(require 'linum)
(global-linum-mode 1)
(setq linum-format "%d ");;left a space between line number and real text

;;ido-mode
(require 'ido)
(ido-mode t)

(global-font-lock-mode 1)
(set-frame-font "Inconsolata:style=Medium")
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

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'Amelie t)

