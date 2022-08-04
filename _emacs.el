;;; emacs.el --- my emacs config
;;; Commentary:
;;; Code:

(setq custom-file "~/.emacs.d/custom123.el")

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

(setq initial-frame-alist (quote ((fullscreen . maximized))))

; display line numbers in the left margin
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))
;; disables the old way
(linum-mode -1)

; Disables the manual page on startup
(setq inhibit-startup-screen t)

; Show column number in the mode line
(column-number-mode 1)

(setq show-trailing-whitespace t)

(tool-bar-mode -1)
(menu-bar-mode -1)
;; (when (boundp 'scroll-bar-mode)
;;   (scroll-bar-mode -1))

(load-theme 'wombat t)

; highlight matching paren, brace
(show-paren-mode 1)

; auto-pair ({[]})
(electric-pair-mode 1)

; stop creating backup~ files
(setq make-backup-files nil)

; stop creating #autosave# files
(setq auto-save-default nil)

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

;; file tree plugin
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'treemacs
    (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   t
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   1
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-width                           25
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("<f4>"      . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package centaur-tabs
  :ensure t
  :config
  (centaur-tabs-mode t))

(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (global-set-key (kbd "M-x")     'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

(use-package evil ; vim plugin
  :ensure t
  :init
  ;; (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-define-key 'normal centaur-tabs-mode-map (kbd "g t") 'centaur-tabs-forward)
  (evil-define-key 'normal centaur-tabs-mode-map (kbd "g T") 'centaur-tabs-backward)
  (defun my/evil-shift-right ()
    (interactive)
    (evil-shift-right evil-visual-beginning evil-visual-end)
    (evil-normal-state)
    (evil-visual-restore))
  (defun my/evil-shift-left ()
    (interactive)
    (evil-shift-left evil-visual-beginning evil-visual-end)
    (evil-normal-state)
    (evil-visual-restore))
  (evil-define-key 'visual global-map (kbd ">") 'my/evil-shift-right)
  (evil-define-key 'visual global-map (kbd "<") 'my/evil-shift-left)
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader ",")
  (evil-leader/set-key
    ","  'other-window
    "r"  'evil-edit
    "c"  'comment-dwim
    ;; "e"  'find-file
    ;; "e"  'helm-find-files
    "e"  'projectile-find-file
    "i"  'indent-region
    "q"  'kill-this-buffer
    "s"  'eshell
    "g"  'magit-status
    "l"  'whitespace-mode       ;; Show invisible characters
    "o"  'delete-other-windows  ;; C-w o
    "w"  'save-buffer
    "t"  'centaur-tabs--create-new-tab
    "k"  'goto-line))

(use-package evil-surround
  :after evil
  :ensure t
  :config
  (global-evil-surround-mode 1))

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

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package eldoc
  :ensure t
  :config
  (setq eldoc-echo-area-use-multiline-p t))

(use-package tuareg
  :ensure t)

(use-package reason-mode
  :ensure t)

(use-package merlin
  :after tuareg
  :ensure t
  :config
  (add-hook 'tuareg-mode-hook #'merlin-mode))

(use-package merlin-company
  :after (company merlin)
  :ensure t)

(use-package merlin-eldoc
  :after (merlin eldoc)
  :ensure t
  :hook ((reason-mode tuareg-mode caml-mode) . merlin-eldoc-setup))

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
                 (list "/usr/include"
                       "/usr/local/include"))))
;; only /usr/include/ and /usr/local/include/ by default

(use-package geiser ; scheme plugin
  :ensure t)

(use-package magit ; git plugin
  :ensure t
  :config
  ;; (global-magit-file-mode 1)
  )

(use-package projectile
  :ensure t
  :config
  (projectile-mode 1)
  (setq projectile-enable-caching t)
  (setq compilation-read-command nil)
  (define-key projectile-mode-map (kbd "<f5>") #'projectile-compile-project)
  (define-key projectile-mode-map (kbd "<f8>") #'projectile-test-project)
  (define-key projectile-mode-map (kbd "<f9>") #'projectile-run-project)
  (projectile-register-project-type 'ocaml-dune '("dune-project")
                                    :project-file "dune-project"
                                    :compile "dune build"
                                    :test "dune runtest"
                                    :run "make run")
  (projectile-register-project-type 'purescript-spago '("spago.dhall")
                                    :project-file "spago.dhall"
                                    :compile "spago build"
                                    :test "spago test"
                                    :run "spago run"
                                    :src-dir "src"
                                    :test-dir "test"
                                    :test-suffix "_test"))

;; install silversearcher-ag
(use-package ag
  :ensure t
  :config
  (setq ag-arguments (quote ("--smart-case"))) ; --stats removed
  (setq ag-highlight-search t)
  (setq ag-reuse-buffers t)
  (setq ag-reuse-window t))

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)
  (setq-default indent-tabs-mode nil))

;; JavaScript: npm install -g jshint
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode 1)
  (add-hook 'flycheck-mode-hook
	    (lambda ()
	      (evil-define-key
		'normal flycheck-mode-map (kbd "<f6>")
		'flycheck-next-error)
	      (evil-define-key
		'normal flycheck-mode-map (kbd "<f7>")
		'flycheck-previous-error))))

(use-package flycheck-ocaml
  :after (flycheck merlin)
  :ensure t
  :config
  ;; Disable Merlin's own error checking
  (setq merlin-error-after-save nil)
  ;; Enable Flycheck checker
  (flycheck-ocaml-setup))

(use-package ocamlformat
  :ensure t
  :config (add-hook 'before-save-hook 'ocamlformat-before-save))

(use-package dune
  :ensure t
  :config
  (use-package dune-format
    :ensure t
    :config
    (add-hook 'dune-mode-hook 'dune-format-on-save-mode)))

;; :irony-install-server
;; requires
;;     cmake (pkg install cmake)
;;     libclang (FreeBSD already have)
;;         find ClangConfig.cmake and add to the install command
;;     .clang_complete file on the project root with all cc flags on it
(use-package irony
  :ensure t
  :config
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package irony-eldoc
  :ensure t
  :config
  (add-hook 'irony-mode-hook 'irony-eldoc))

(use-package company-irony
  :after (company irony)
  :ensure t
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package flycheck-irony
  :after (flycheck irony)
  :ensure t
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(use-package go-mode
  :ensure t
  :config
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; go auto completion
  (use-package company-go
    :ensure t
    :config
    (add-hook 'go-mode-hook
              (lambda ()
                (set (make-local-variable 'company-backends) '(company-go))
                (company-mode)))
    ;; bigger popup window
    (setq company-tooltip-limit 20)
    ;; decrease delay before autocompletion popup shows
    (setq company-idle-delay .3)
    ;; remove annoying blinking
    (setq company-echo-delay 0)
    ;; start autocompletion only after typing
    (setq company-begin-commands '(self-insert-command)))
  (use-package go-rename
    :ensure t))
;;   :config
;;   (use-package go-snippets
    ;; :ensure t))

;; npm install -g purescript@0.14.9 spago purty
;; git clone https://gitlab.com/joneshf/purty.git ~/projects/
(use-package purescript-mode
  :ensure t
  :config
  (add-hook
   'purescript-mode-hook
   (lambda ()
     (evil-define-key 'normal purescript-mode-map (kbd "g ]") 'psc-ide-goto-definition)
     (evil-define-key 'normal purescript-mode-map (kbd "g [") 'pop-tag-mark)
     (setq projectile-create-missing-test-files t)
     (turn-on-purescript-indentation)
     ;; (add-to-list 'load-path "~/projects/purty/")
     ;; (require 'purty)
     ;; (purty-on-save-mode)
     ))
  (use-package psc-ide
    :ensure t
    :config
    (add-hook 'purescript-mode-hook
              (lambda ()
                (psc-ide-mode)
                ;; (psc-ide-server-start (projectile-project-root))
                ))))

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
            ;; (setq comment-style 'extra-line)
            (setq c-basic-offset 8)
            (setq tab-width 8)
            (setq indent-tabs-mode t)
            (setq c-tab-always-indent t)
            ;; DO NOT expand tabs when deleting:
            (setq backward-delete-char-untabify-method nil)
            ;; align # to the left
            (setq c-electric-pound-behavior '(alignleft))
            ;; (setq flycheck-clang-include-path
            ;;       (list "/usr/include" "/usr/local/include"))
            ;; on save delete all trailing whitespace
            (add-to-list 'write-file-functions
                         'delete-trailing-whitespace)))

(add-hook 'scheme-mode-hook`
	  (lambda ()
	    ;; underscore will be recognised as word character
	    (modify-syntax-entry ?_ "w")
	    ;; on save delete all trailing whitespace
	    (add-to-list 'write-file-functions
			 'delete-trailing-whitespace)
	    (setq geiser-active-implementations '(guile))
	    (setq geiser-repl-use-other-window nil)
	    (setq geiser-repl-query-on-kill-p nil)
	    (geiser-mode 1)))

(add-hook 'latex-mode-hook`
	  (lambda ()
	    (turn-on-auto-fill)))

(custom-set-faces
 '(default
    ((t (:family "Liberation Mono"
                 :foundry "1ASC"
                 :slant normal
                 :weight normal
                 :height 90
                 :width normal)))))

(provide 'emacs)
;;; emacs.el ends here
