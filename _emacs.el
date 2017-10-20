;;; emacs.el --- my emacs config
;;; Commentary:
;;; Code:

(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
;;(add-to-list 'package-archives
	     ;;'("melpa-stable" . "http://stable.melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq inhibit-startup-screen t) ; Disables the manual page on startup
(column-number-mode 1) ; Show column number in the mode line
(tool-bar-mode -1)
(menu-bar-mode -1)
(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(show-paren-mode 1) ; highlight matching paren, brace
(electric-pair-mode 1) ; auto-pair ({[]})
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files
(add-hook 'text-mode 'turn-on-auto-fill)
(setq package-enable-at-startup nil)

(defun server-remove-kill-buffer-hook ()
  "Disable the prompt for killing emacsclient buffers."
  (remove-hook 'kill-buffer-query-functions
	       'server-kill-buffer-query-function))
(add-hook 'server-visit-hook 'server-remove-kill-buffer-hook)

(defalias 'yes-or-no-p 'y-or-n-p)

;; use a mix of tabs to indent and spaces to align
;; (use-package smart-tabs-mode
;;   :ensure t
;;   :config
;;   (smart-tabs-insinuate 'c 'c++))

(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader ",")
  (evil-leader/set-key
    ","  'other-window
    "r"  'evil-edit
    "c"  'comment-dwim
    "e"  'find-file
    "i"  'indent-region
    "d"  'kill-this-buffer
    "s"  'eshell
    "g"  'magit-status
    "l"  'whitespace-mode       ;; Show invisible characters
    "o"  'delete-other-windows  ;; C-w o
    "w"  'save-buffer
    "k"  'goto-line))

(use-package evil ; vim plugin
  :ensure t
  :config
  (evil-mode 1))

(use-package paredit ; lisp plugin
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           'enable-paredit-mode)
  (use-package evil-paredit
    :ensure t
    :config
    (add-hook 'emacs-lisp-mode-hook       'evil-paredit-mode)
    (add-hook 'lisp-mode-hook             'evil-paredit-mode)
    (add-hook 'lisp-interaction-mode-hook 'evil-paredit-mode)
    (add-hook 'scheme-mode-hook           'evil-paredit-mode)))

(use-package paredit-everywhere
  :ensure t
  :config
  (add-hook 'prog-mode-hook        'paredit-everywhere-mode))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package company ; auto-complete plugin
  :ensure t
  :config
  (global-company-mode 1)
  (use-package company-jedi ; Python
    :ensure t
    :config
    (setq jedi:environment-virtualenv
          (list (expand-file-name "~/.emacs.d/.python-environments/")))
    (add-hook 'python-mode-hook 'jedi:setup)
    (setq jedi:complete-on-dot t)
    (setq jedi:use-shortcuts t)
    (defun config/enable-company-jedi ()
      (add-to-list 'company-backends 'company-jedi))
      (add-hook 'python-mode-hook 'config/enable-company-jedi))
  (use-package company-bibtex
    :ensure t
    :config
    (add-to-list 'company-backends 'company-bibtex))
  (use-package company-c-headers
    :ensure t
    :config
    (add-to-list 'company-backends 'company-c-headers)
    (add-to-list 'company-c-headers-path-system
		 "/usr/include/c++/4.8/")))
;; only /usr/include/ and /usr/local/include/ by default

(use-package geiser ; scheme plugin
  :ensure t)

(use-package magit ; git plugin
  :ensure t
  :config
  (global-magit-file-mode 1)
  (use-package evil-magit
    :ensure t))

(use-package projectile
  :ensure t
  :config
  (projectile-mode 1)
  (setq projectile-enable-caching t))

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)
  (setq-default indent-tabs-mode nil))

;; (use-package js2-mode
;;   :ensure t
;;   :config
;;   (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))
;; (use-package js2-refactor
;;   :ensure t
;;   :config
;;   (add-hook 'js2-mode-hook #'js2-refactor-mode))

;; (use-package auto-complete
;;   :ensure t
;;   :config
;;   (global-auto-complete-mode))
;; (use-package ac-js2
;;   :ensure t
;;   :config
;;   (add-hook 'js2-mode-hook 'ac-js2-mode))

;; JavaScript completion - autocomplete version
;; npm install tern
;; (use-package tern
;;   :ensure t
;;   :config
;;   (add-hook 'js-mode-hook (lambda () (tern-mode t)))
;;   (use-package tern-auto-complete
;;     :ensure t
;;     :config
;;     (tern-ac-setup)))

;; JavaScript completion - company version
;; npm install -g tern
;; needs .tern-project file on project folder
(use-package tern
  :ensure t
  :config
  (add-hook 'js-mode-hook (lambda () (tern-mode t)))
  (use-package company-tern
    :ensure t
    :config
    (add-to-list 'company-backends 'company-tern)
    (setq company-tern-property-marker " p")))

;; JavaScript: npm install -g jshint
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode 1)
  (add-hook 'flycheck-mode-hook
	    (lambda ()
	      (evil-define-key
		'normal flycheck-mode-map (kbd "]e")
		'flycheck-next-error)
	      (evil-define-key
		'normal flycheck-mode-map (kbd "[e")
		'flycheck-previous-error))))

(add-hook 'python-mode-hook`
	  (lambda ()
	    ;; underscore will be recognised as word character
	    (modify-syntax-entry ?_ "w")))

(add-hook 'c-mode-common-hook`
          (lambda ()
            (setq c-default-style
                  '((java-mode . "java")
                    (awk-mode . "awk")
                    (other . "k&r")))
            ;; underscore will be recognised as word character
            (modify-syntax-entry ?_ "w")
            ;; set old style comments
            (setq comment-style 'extra-line)
            (setq c-basic-offset 8)
            (setq tab-width 8)
            (setq indent-tabs-mode t)
            (setq c-tab-always-indent t)
            ;; DO NOT expand tabs when deleting:
            (setq backward-delete-char-untabify-method nil)
            ;; align # to the left
            (setq c-electric-pound-behavior '(alignleft))
            (setq compilation-read-command nil)
            (setq compilation-ask-about-save nil)
            (setq compile-command "make -k")
            (local-set-key (kbd "C-c C-c") 'compile)
            (local-set-key (kbd "M-n") 'next-error)
            (local-set-key (kbd "M-N") 'previous-error)
            (setq show-trailing-whitespace t)
            ;; on save delete all trailing whitespace
            (add-to-list 'write-file-functions
                         'delete-trailing-whitespace)))

(add-hook 'scheme-mode-hook`
	  (lambda ()
	    ;; underscore will be recognised as word character
	    (modify-syntax-entry ?_ "w")
	    (setq show-trailing-whitespace t)
	    ;; on save delete all trailing whitespace
	    (add-to-list 'write-file-functions
			 'delete-trailing-whitespace)
	    (setq geiser-active-implementations '(guile))
	    (setq geiser-repl-use-other-window nil)
	    (setq geiser-repl-query-on-kill-p nil)
	    (geiser-mode 1)))

(add-hook 'latex-mode-hook`
	  (lambda ()
	    (turn-on-auto-fill)
	    (setq compilation-read-command nil)))

(provide 'emacs)
;;; emacs.el ends here
