;; Yinjiaji's Emacs config in Mac OS X
;; Email: yinjiaji110@gmail.com
;;


;;;;;;;;;;;;;;;;;;;;;;;Objc Related;;;;;;;;;;;;;;;;;;;;;;;

(require 'find-file)
(nconc (cadr (assoc "\\.h\\'" cc-other-file-alist)) '(".m" ".mm"))
(add-to-list 'cc-other-file-alist '("\\.m\\'" (".h")))
(add-to-list 'cc-other-file-alist '("\\.mm\\'" (".h")))
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))

;; Auto mode
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))

;; Jump between header and impl
(setq ff-other-file-alist
     '(("\\.mm?$" (".h"))
       ("\\.cc$"  (".hh" ".h"))
       ("\\.hh$"  (".cc" ".C"))
 
       ("\\.c$"   (".h"))
       ("\\.h$"   (".c" ".cc" ".C" ".CC" ".cxx" ".cpp" ".m" ".mm"))
 
       ("\\.C$"   (".H"  ".hh" ".h"))
       ("\\.H$"   (".C"  ".CC"))
 
       ("\\.CC$"  (".HH" ".H"  ".hh" ".h"))
       ("\\.HH$"  (".CC"))
 
       ("\\.cxx$" (".hh" ".h"))
       ("\\.cpp$" (".hpp" ".hh" ".h"))
 
       ("\\.hpp$" (".cpp" ".c"))))
 
(add-hook 'objc-mode-hook
         (lambda ()
           (define-key c-mode-base-map (kbd "C-c t") 'ff-find-other-file)
         ))


(load "adaptive-wrap-0.2")
(add-hook 'objc-mode-hook 'visual-line-mode)
(add-hook 'objc-mode-hook 'adaptive-wrap-prefix-mode)
(add-hook 'objc-mode-hook (lambda ()
                            (setq adaptive-wrap-extra-indent 4)))


(load "auto-complete-clang-async")
(require 'auto-complete-clang-async)

(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/clang-complete")
  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process)
)

(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(my-ac-config)

;;Syntax Checking auto-complete-clang-async provides syntax checking via the ac-clang-check-syntax function, but it has a problem. You need to tell it which compiler flags to use, and figuring out which flags Xcode is going to use is non-trivial.
(push '("\\.mm?\\'" objc-xcode-flymake-init) flymake-allowed-file-name-masks)
(defun objc-xcode-flymake-filter (process output)
  "Process output from xcodebuild.
Mostly copied from flymake.el."
  (let ((source-buffer (process-buffer process)))
    (flymake-log 3 "received %d byte(s) of output from process %d"
                 (length output) (process-id process))
    (when (buffer-live-p source-buffer)
      (with-current-buffer source-buffer
        (flymake-parse-output-and-residual output)))))

(defun objc-xcode-flymake-sentinel (process _event)
  "Handle termination of xcodebuild.
Mostly copied from flymake.el. Removed check for non-zero exit
status and no errors."
  (when (memq (process-status process) '(signal exit))
    (flymake-parse-residual)
    (setq flymake-err-info flymake-new-err-info)
    (setq flymake-new-err-info nil)
    (setq flymake-err-info
          (flymake-fix-line-numbers
           flymake-err-info 1 (flymake-count-lines)))
    (flymake-delete-own-overlays)
    (flymake-highlight-err-lines flymake-err-info)
    (let (err-count warn-count (exit-status (process-exit-status process)))
      (setq err-count (flymake-get-err-count flymake-err-info "e"))
      (setq warn-count  (flymake-get-err-count flymake-err-info "w"))
      (flymake-log 2 "%s: %d error(s), %d warning(s)"
                   (buffer-name) err-count warn-count)
      (setq flymake-check-start-time nil)

      (if (and (equal 0 err-count) (equal 0 warn-count))
          (if (equal 0 exit-status)
              (flymake-report-status "" "")	; PASSED
            (flymake-report-status nil ""))) ; "STOPPED"
      (flymake-report-status (format "%d/%d" err-count warn-count) ""))))


(defun objc-xcode-flymake-init ()
  "Produce command for checking syntax."
  (let ((process
         (apply 'start-file-process "flymake-proc" (current-buffer)
                "xcodebuild" `("-configuration" "Debug"
                               "-project" ,(find-xcode-proj)))))
    (set-process-filter process 'objc-xcode-flymake-filter)
    (set-process-sentinel process 'objc-xcode-flymake-sentinel)
    nil))

(defun find-xcode-proj ()
  "Attempt to locate the xcodeproj directory."
  (if (directory-files "." t ".*\.xcodeproj$" nil)
      (nth 0 (directory-files "." t ".*\.xcodeproj$" nil))
    (let ((old-dir default-directory))
      (cd "../")
      (let ((result (find-xcode-proj)))
        (cd old-dir)
        result))))
