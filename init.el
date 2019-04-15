;; Define package repositories
(require 'package)
(setq package-archives
      '(("elpa" . "http://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/"))
      package-archive-priorities
      '(("melpa-stable" . 0)
        ("elpa" . 3)
        ("melpa") .10))

(setq x-select-enable-clipboard t)
;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; Define the following variables to remove the compile-log warnings
;; when defining ido-ubiquitous
;; (defvar ido-cur-item nil)
;; (defvar ido-default-item nil)
;; (defvar ido-cur-list nil)
;; (defvar predicate nil)
;; (defvar inherit-input-method nil)

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
   '(;; makes handling lisp expressions much, much easier
     ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
     paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-completing-read+

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

     ;; project navigation
     projectile

     ;; colorful parenthesis matching
     rainbow-delimiters

     ;; edit html tags like sexps
     tagedit

     ;; git integration
     magit

     ;; ag
     ag

     ;; I like to see all symbols with the same name highlighted on point
     idle-highlight-mode

     ;; auto complete functionality
     company

     ;; for syntax checking
     flycheck

     ;; for go integrations
     go-mode
     go-eldoc
     company-go
     go-guru

     ;; for js integrations
;;     js2-mode
;;     js2-refactor
;;     xref-js2
     prettier-js
;;     rjsx-mode
     tide
     web-mode
     queue
     ))

(dolist (p my-packages)
   (when (not (package-installed-p p))
     (package-install p)))

(global-flycheck-mode)

;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")

;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; ;; goflymake and check customizations
;; ;; not sold on this yet
;; ;;(add-to-list 'load-path "~/.emacs.d/goflymake")
;; ;;(require 'go-flymake)
;; ;;(require 'go-flycheck)

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

 ;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")

;; Line length
(load "line-length.el")

;; Jake's custom keybindings

;;projectile keybindings
(global-set-key (kbd "C-p") 'projectile-find-file)
(global-set-key (kbd "C-M-i") 'projectile-ag)

;; ;; magit keybindings
(global-set-key (kbd "C-x g") 'magit-status)
(setq smerge-command-prefix "\C-cv")
;;(add-hook 'smerge-mode-hook (lambda () (setq smerge-command-prefix "^Cv")))
;; ;; UI helpers
(add-hook 'prog-mode-hook 'idle-highlight-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'after-init-hook 'global-company-mode)

;; go editing
(add-hook 'go-mode-hook 'go-eldoc-setup)
(setq gofmt-command "goimports")
(add-hook 'go-mode-hook (lambda () (add-hook 'before-save-hook 'gofmt-before-save nil 'local)))
(add-hook 'go-mode-hook (lambda () (local-set-key (kbd "M-.") 'godef-jump)))
(add-hook 'go-mode-hook (lambda () (local-set-key (kbd "M-,") 'pop-tag-mark)))
(add-hook 'go-mode-hook (lambda () (local-set-key (kbd "M-m") 'go-rename)))
(let ((govet (flycheck-checker-get 'go-vet 'command)))
  (when (equal (cadr govet) "tool")
    (setf (cdr govet) (cddr govet))))

;; js editing
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))
;;(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
;;(add-hook 'js2-mode-hook 'prettier-js-mode)

;;(add-hook 'js2-mode-hook #'js2-refactor-mode)
;;(js2r-add-keybindings-with-prefix "C-c C-r")
;;(define-key js2-mode-map (kbd "M-m") #'js2r-rename-var)
;;(define-key js-mode-map (kbd "M-.") #'js2-jump-to-definition)
;;(add-hook 'js2-mode-hook (lambda ()                           (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

;; ;; typescript
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'css-mode-hook 'prettier-js-mode)
(add-hook 'typescript-mode-hook #'setup-tide-mode)
(add-hook 'tide-mode-hook (lambda () (local-set-key (kbd "M-m") 'tide-rename-symbol)))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "ts" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "js" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

;; imenu
(global-set-key (kbd "C-r") 'imenu)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(package-selected-packages
   (quote
    (js2-mode lua-mode prettier-js web-mode tide tagedit smex rainbow-delimiters projectile paredit magit ido-completing-read+ idle-highlight-mode go-guru go-eldoc company-go clojure-mode-extra-font-locking cider ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
