;; -*- lexical-binding: t; -*-
;; ============================================================
;; Package management
;; ============================================================

(setq lexical-binding t)

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(require 'use-package)
(setq use-package-always-ensure t)


;; ============================================================
;; General settings
;; ============================================================

;; Disable automatic native compilation
(setq native-comp-jit-compilation nil)

;; Disable bell
(setq ring-bell-function #'ignore)
(setq visible-bell t)

;; Custom file
(setq custom-file "~/.emacs.d/.emacs.custom.el")
(load custom-file t)

;; Disable UI elements
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; Startup
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

;; Backup files
(setq backup-directory-alist
      '((".*" . "~/.emacs.d/backups/")))

;; Auto-save files
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/auto-save-list/" t)))
;; Fonts
;; (add-to-list 'default-frame-alist
;;              '(font . "JetBrains Mono-12"))


;; ============================================================
;; Theme
;; ============================================================

(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))


;; ============================================================
;; Chinese input method
;; ============================================================

(use-package pyim
  :ensure t
  :init
  (setq default-input-method "pyim"))

(use-package pyim-basedict
  :ensure t
  :after pyim
  :config
  (pyim-basedict-enable))


;; ============================================================
;; Ido
;; ============================================================

(use-package ido
  :ensure nil
  :config
  (ido-mode 1)
  (ido-everywhere 1))


;; ============================================================
;; Multiple cursors
;; ============================================================

(use-package multiple-cursors
  :ensure t
  :bind
  (("C-c m n" . mc/mark-next-like-this)
   ("C-c m p" . mc/mark-previous-like-this)
   ("C-c m a" . mc/mark-all-like-this)
   ("C-c m l" . mc/edit-lines)))


;; ============================================================
;; Evil
;; ============================================================

(use-package evil
  :ensure t
  :init
  (setq evil-want-C-i-jump t
        evil-disable-insert-state-bindings t)

  :config
  (evil-mode 1)

  ;; Initial states
  (evil-set-initial-state 'xref--xref-buffer-mode 'emacs)
  (evil-set-initial-state 'help-mode 'emacs)

  ;; Cursor styles
  (setq evil-normal-state-cursor  'box
        evil-operator-state-cursor 'hbar
        evil-motion-state-cursor  'box
        evil-visual-state-cursor  'box
        evil-insert-state-cursor  'bar
        evil-emacs-state-cursor   'hbar)

  ;; Save buffer
  (define-key evil-normal-state-map
              (kbd "SPC w")
              #'save-buffer))

;; ============================================================
;; Evil
;; ============================================================

(use-package evil-vimish-fold
  :ensure t)

;; ============================================================
;; markdown mode
;; ============================================================

(use-package markdown-mode
  :ensure t)

;; ============================================================
;; magit mode
;; ============================================================

(use-package magit
  :ensure t)

;; ============================================================
;; Evil terminal cursor
;; ============================================================

(use-package evil-terminal-cursor-changer
  :ensure t
  :if (not (display-graphic-p))
  :after evil
  :config
  (evil-terminal-cursor-changer-activate))


;; ============================================================
;; Eldoc
;; ============================================================

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-echo-area-use-multiline-p nil))


;; ============================================================
;; Eglot
;; ============================================================

(use-package eglot
  :ensure nil

  :hook
  ((c-mode . eglot-ensure)
   (c++-mode . eglot-ensure)
   (c-ts-mode . eglot-ensure)
   (c++-ts-mode . eglot-ensure)
   (python-mode . eglot-ensure)
   (python-ts-mode . eglot-ensure))

  :config
  ;; C and C++: clangd
  (setf (alist-get '(c++-mode c-mode c-ts-mode c++-ts-mode)
                   eglot-server-programs
                   nil nil #'equal)
        '("clangd"
          "--background-index"
          "--query-driver=/usr/bin/c++,/usr/bin/g++,/usr/bin/gcc,/usr/bin/clang++,/usr/bin/clang,/usr/bin/arm-none-eabi-*"))

  ;; Python: Pyright
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 . ("pyright-langserver" "--stdio"))))


;; ============================================================
;; Dired
;; ============================================================

(use-package dired
  :ensure nil
  :custom
  (dired-dwim-target t))


;; ============================================================
;; Company
;; ============================================================

(use-package company
  :ensure t
  :demand t
  :config
  (global-company-mode 1)

  ;; Navigate completion candidates
  (define-key company-active-map
              (kbd "C-n")
              #'company-select-next)

  (define-key company-active-map
              (kbd "C-p")
              #'company-select-previous))


;; ============================================================
;; Built-in editing settings
;; ============================================================

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Align
(global-set-key (kbd "C-c a") #'align-regexp)


;; ============================================================
;; Personal functions
;; ============================================================

;; Open configuration file
(defun open-config-file ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f2>") #'open-config-file)


;; Insert current date and time
(defun wj/insert-date ()
  "Insert the current date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))

(global-set-key (kbd "C-c t") #'wj/insert-date)


;; Insert a separator
(defun wj/separate-line-elisp (content)
  "Insert a separator line with CONTENT."
  (interactive "sSeparator title: ")
  (insert (format ";; -------------------- %s --------------------\n"
                  content)))


;; Move current line up
(defun wj/move-line-up ()
  "Move current line one line up."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))


;; Move current line down
(defun wj/move-line-down ()
  "Move current line one line down."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))


;; Evil-specific movement bindings
(with-eval-after-load 'evil
  (define-key evil-normal-state-map
              (kbd "M-n") #'wj/move-line-down)
  (define-key evil-normal-state-map
              (kbd "M-p") #'wj/move-line-up)

  (define-key evil-insert-state-map
              (kbd "M-n") #'wj/move-line-down)
  (define-key evil-insert-state-map
              (kbd "M-p") #'wj/move-line-up))

