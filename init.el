;; Disable automatic native compilation
(setq native-comp-jit-compilation nil)

(setq custom-file "~/.emacs.d/.emacs.custom.el")

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(load custom-file)

(load-theme 'gruber-darker t)

;; 关闭启动欢迎界面
(setq inhibit-startup-screen t)

;; 关闭 scratch buffer 里的默认说明文字
(setq initial-scratch-message nil)

;; 备份文件集中放这里，而不是放在项目目录
(setq backup-directory-alist
      `((".*" . "~/.emacs.d/backups/")))

;; 自动保存文件集中放这里
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save-list/" t)))

;; ;; fonts
;; (add-to-list 'default-frame-alist
;; 	     '(font . "JetBrains Mono-12"))

;; pyim
(require 'pyim)

(setq default-input-method "pyim")

(ido-mode 1)
(ido-everywhere 1)

;;multiple-cursor
(autoload 'mc/mark-next-like-this "multiple-cursors" nil t)
(autoload 'mc/mark-previous-like-this "multiple-cursors" nil t)
(autoload 'mc/mark-all-like-this "multiple-cursors" nil t)
(autoload 'mc/edit-lines "multiple-cursors" nil t)

(global-set-key (kbd "C-c m n") #'mc/mark-next-like-this)
(global-set-key (kbd "C-c m p") #'mc/mark-previous-like-this)
(global-set-key (kbd "C-c m a") #'mc/mark-all-like-this)
(global-set-key (kbd "C-c m l") #'mc/edit-lines)

;; --------------------evil start----------------------------

;; (setq evil-want-C-u-scroll t)
;; (setq evil-want-C-d-scroll t)
;; Instead, use C-f and C-b to scroll

(setq evil-want-C-i-jump t)
(setq evil-disable-insert-state-bindings t) ; when in insert mode, use emacs keybindings

;; load evil
(require 'evil)

;; after loading evil
(evil-mode 1)

;; initial mode
(evil-set-initial-state 'xref--xref-buffer-mode 'emacs)
(evil-set-initial-state 'help-mode 'emacs)


;; --------------------evil end----------------------------

;; --------------------evil-terminal-cursor-changer start--------------------

(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer)
  (evil-terminal-cursor-changer-activate))

;; cursor  
(setq evil-normal-state-cursor		'box)
(setq evil-operator-state-cursor	'hbar)
(setq evil-motion-state-cursor		'box)
(setq evil-visual-state-cursor		'box)
(setq evil-insert-state-cursor		'bar)
(setq evil-emacs-state-cursor		'hbar)

;; change keybindings
;; (define-key evil-normal-state-map (kbd "C-r") #'isearch-backward)

;; file operation
(define-key evil-normal-state-map (kbd "SPC w") #'save-buffer)

;; --------------------evil-terminal-cursor-changer end--------------------

;; -------------------- Magit --------------------

;; -------------------- Eglot start --------------------

;; Start Eglot automatically
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)
(add-hook 'c-ts-mode-hook #'eglot-ensure)
(add-hook 'c++-ts-mode-hook #'eglot-ensure)

;;
(with-eval-after-load 'eglot
  (setf (alist-get '(c++-mode c-mode c-ts-mode c++-ts-mode)
                   eglot-server-programs
                   nil nil #'equal)
        '("clangd"
          "--background-index"
          "--query-driver=/usr/bin/c++,/usr/bin/g++,/usr/bin/gcc,/usr/bin/clang++,/usr/bin/clang,/usr/bin/arm-none-eabi-*")))

;; only one line below

(setq eldoc-echo-area-use-multiline-p nil)

;; -------------------- Eglot end --------------------

;; -------------------- dired start--------------------

(setq dired-dwim-target t) ;; 这个实现当有两个窗口的时候, 另一个窗口的文件夹会成为default target

;; -------------------- dired end--------------------


;;打开配置文件
(defun open-config-file()
	(interactive)
	(find-file "~/.emacs.d/init.el"))

;;把打开配置文件的命令绑定到<f2>上
(global-set-key (kbd "<f2>") `open-config-file)

					;company
(global-company-mode 1)
;; company mode 默认选择上一条和下一条候选项命令 M-n M-p
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

;; package archive
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; -------------------- align --------------------

(global-set-key (kbd "C-c a") #'align-regexp)

;; -------------------- below are some personal functions --------------------

(defun wj/insert-date ()
  "Insert the current date at point"
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))

(global-set-key (kbd "C-c t") #'wj/insert-date)

;; 实现分隔符

(defun wj/separate-line-elisp (content)
  "Insert a separator line with CONTENT"
  (interactive "sSeparator title: ")
  (insert (format ";; -------------------- %s --------------------\n"
		  content)))

;; 向上移动行
(defun wj/move-line-up ()
  "move current line one line up"
  ;; TODO 判断是否是首行, 否则交换
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(global-set-key (kbd "M-p") #'wj/move-line-up)

;; 向下移动行
(defun wj/move-line-down ()
  "move current line one line down"
  ;; TODO 判断是否是尾行, 否则交换
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "M-n") #'wj/move-line-down)
  (define-key evil-normal-state-map (kbd "M-p") #'wj/move-line-up)
  (define-key evil-insert-state-map (kbd "M-n") #'wj/move-line-down)
  (define-key evil-insert-state-map (kbd "M-p") #'wj/move-line-up))
