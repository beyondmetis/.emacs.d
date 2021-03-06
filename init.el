;;; package --- Summary
;;; Commentary:
;;;     None
;;; Code:


(set-frame-font "Fantasque Sans Mono" nil t)
;; (savehist-mode 1)
(setq message-log-max 10)

(setq debug-on-error 1)

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/flycheck")
(add-to-list 'load-path "~/.emacs.d/emacs-async")
(add-to-list 'load-path "~/.emacs.d/helm")

;;; loading in from a script
(require 'helm-config)
(require 'windresize)

(helm-mode 1)


(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))


(defun ensure-package-installed (&rest packages)
    "Assure every package is installed, ask for installation if it’s not.

  Return a list of installed packages or nil for every skipped package."
    (mapcar
         (lambda (package)
                (if (package-installed-p package)
                           nil
                                  (if (y-or-n-p (format "Package %s is missing. Install it? " package))
                                               (package-install package)
                                                        package)))
            packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
        (package-refresh-contents))

;; Activate installed packages
(package-initialize)

;; Assuming you wish to install "iedit" and "magit"
(ensure-package-installed 'evil 
                          'evil-tabs
                          'evil-search-highlight-persist
                          'evil-leader
                          'evil-matchit
                          'evil-nerd-commenter
                          'evil-surround
                          'projectile 
                          'linum-relative
                          'linum-off
                          'iedit 
                          'jedi
                          'airline-themes
                          'powerline
                          'powerline-evil
                         'ace-jump-mode
                          'moe-theme
                          'magit)


(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)


(add-to-list 'custom-theme-load-path "~/.emacs.d/moe-theme.el/")
(add-to-list 'load-path "~/.emacs.d/moe-theme.el/")
(setq evil-toggle-key "C-`")
(require 'airline-themes)
(require 'powerline)
(require 'powerline-evil)
(require 'evil-matchit)
(require 'ace-jump-mode)
(require 'flycheck)
(require 'multi-term)
(setq multi-term-program "/bin/bash")

(require 'multi-term-tmux)

(add-hook 'after-init-hook #'global-flycheck-mode)

;; Auto-complete
(require 'auto-complete-config)
(ac-config-default)

;; Uncomment next line if you like the menu right away
(setq ac-show-menu-immediately-on-auto-complete t)

(defun flycheck-python-setup ()
    (flycheck-mode))
(add-hook 'python-mode-hook #'flycheck-python-setup)

(global-evil-matchit-mode 1)
(require 'evil)
(require 'moe-theme)
(require 'evil-search-highlight-persist)
(require 'evil-leader)


(defun browse-self ()
  "View current homedir"
  (interactive)
  (find-file "/home/luke")
)

(defun browse-hope ()
  "Connect to LIVE lab computer"
  (interactive)
  (find-file "/ssh:alderaan:/home/hope")
)

(defun browse-kingston ()
  "Connect to home server"
  (interactive)
  (find-file "/ssh:kingston:/home/kingston")
)

(defun tmux-self ()
  "Connect to self"
  (interactive)
  (multi-term-tmux-open)
)

(defun tmux-hope ()
  "Connect to LIVE lab computer"
  (interactive)
  (multi-term-tmux-remote-open "hope@alderaan")
)


(global-evil-tabs-mode t)
(global-evil-leader-mode)

(define-key evil-normal-state-map (kbd "C-k") (lambda ()
                    (interactive)
                    (evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-j") (lambda ()
                        (interactive)
                        (evil-scroll-down nil)))

(define-key evil-normal-state-map (kbd "C-d") 'kill-this-buffer)

(define-key evil-normal-state-map (kbd "M-f") 'find-function)

(setq scroll-margin 5
    scroll-conservatively 9999
    scroll-step 1)

(evil-leader/set-leader ",")

(evil-leader/set-key
  "ci" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
  "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
  "\\" 'evilnc-comment-operator ; if you prefer backslash key
  "b" 'switch-to-buffer
  "k" 'kill-buffer
  "e" 'find-file
  "g" 'magit-status
  "f" 'ace-jump-char-mode
  "x" 'helm-M-x
  "u" 'scroll-up-command
  "d" 'scroll-down-command
  "1" 'browse-self
  "2" 'browse-hope
  "3" 'browse-kingston
  ";" 'switch-to-previous-buffer
  ":" 'eval-last-sexp
  "5" 'tmux-self
  "6" 'tmux-hope
)

(evil-leader/set-key-for-mode 'python-mode
  "," 'jedi:goto-definition
  "." 'jedi:goto-definition-pop-marker
  "/" 'jedi:show-doc
  "|" 'ipython-run-selection
)

(defun h-resize-l (key)
   "interactively resize the window"  
   (interactive "cHit C-h/C-l to enlarge/shrink") 
     (cond                                  
       ((eq key (string-to-char "\C-l"))                      
          (windresize-left -2)             
          (call-interactively 'h-resize-l)) 
       ((eq key (string-to-char "\C-h"))                      
          (windresize-left 2)             
          (call-interactively 'h-resize-l)) 
       (t (push key unread-command-events))))

(defun h-resize-r (key)
   "interactively resize the window"  
   (interactive "cHit C-h/C-l to enlarge/shrink") 
     (cond                                  
       ((eq key (string-to-char "\C-l"))                      
          (windresize-right 2)             
          (call-interactively 'h-resize-r)) 
       ((eq key (string-to-char "\C-h"))                      
          (windresize-right -2)             
          (call-interactively 'h-resize-r)) 
       (t (push key unread-command-events))))

(defun v-resize-d (key)
   "interactively resize the window"  
   (interactive "cHit C-j/C-k to enlarge/shrink") 
     (cond                                  
       ((eq key (string-to-char "\C-j"))                      
          (windresize-down 2)             
          (call-interactively 'v-resize-d)) 
       ((eq key (string-to-char "\C-k"))                      
          (windresize-down -2)             
          (call-interactively 'v-resize-d)) 
       (t (push key unread-command-events))))

(defun v-resize-u (key)
   "interactively resize the window"  
   (interactive "cHit C-j/C-k to enlarge/shrink") 
     (cond                                  
       ((eq key (string-to-char "\C-j"))                      
          (windresize-up -2)             
          (call-interactively 'v-resize-u)) 
       ((eq key (string-to-char "\C-k"))                      
          (windresize-up 2)             
          (call-interactively 'v-resize-u)) 
       (t (push key unread-command-events))))

;; split windows and resize them just like tmux
(define-key evil-normal-state-map (kbd "C-a |") 'split-window-horizontally)
(define-key evil-normal-state-map (kbd "C-a -") 'split-window-vertically)
(define-key evil-normal-state-map (kbd "C-a k") 'windmove-up)
(define-key evil-normal-state-map (kbd "C-a j") 'windmove-down)
(define-key evil-normal-state-map (kbd "C-a h") 'windmove-left)
(define-key evil-normal-state-map (kbd "C-a l") 'windmove-right)

(define-key evil-normal-state-map (kbd "C-a C-j") 'v-resize-d)
(define-key evil-normal-state-map (kbd "C-a C-k") 'v-resize-u)
(define-key evil-normal-state-map (kbd "C-a C-h") 'h-resize-l)
(define-key evil-normal-state-map (kbd "C-a C-l") 'h-resize-r)


;; (global-set-key (kbd "H-b") 'shrink-window-horizontally)
;; (global-set-key (kbd "H-f") 'enlarge-window-horizontally)

(evil-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-evil-search-highlight-persist t)
(global-visual-line-mode nil)

(show-paren-mode 1)

(display-time-mode t)
(setq tramp-default-method "ssh")

(moe-dark)

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;; Setting up commands for ipython
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;

;; fixes a bug using code snippets with evil
(fset 'evil-visual-update-x-selection 'ignore)

;; fixes ctrl-a problem that spawns many errors
(eval-after-load "evil-maps"
  (dolist (map '(evil-insert-state-map evil-motion-state-map)) (define-key (eval map) "\C-a" nil)))

;; set path to ipython
(when (executable-find "ipython2")
  (setq python-shell-interpreter "ipython2"
	python-shell-interpreter-args "--pylab=wx --gui=wx --no-banner -i"
	python-shell-buffer-name "ipython2 shell --> "
	))

;; function to run python snippets
;; differs from simple python-shell-send-region by opening a python shell without confirmation,
;; and showing the output on the side. Also prints the stack after execution
(defun ipython-run-selection (start end &optional send-main)
  (interactive "r\nP")
  (let* ((string (python-shell-buffer-substring start end (not send-main)))
         (process (python-shell-get-or-create-process (python-shell-parse-command) 1 1))
         (original-string (buffer-substring-no-properties start end))
         (_ (string-match "\\`\n*\\(.*\\)" original-string)))
    (message "Sent: %s..." (match-string 1 original-string))
    (python-shell-send-string string process)))
    ;; (python-shell-switch-to-shell)))


;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;; Setting up commands for jedi
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;

(defvar jedi-config:use-system-python nil
  "Will use system python and active environment for Jedi server.
May be necessary for some GUI environments (e.g., Mac OS X)")

(defvar jedi-config:with-virtualenv nil
  "Set to non-nil to point to a particular virtualenv.")

(defvar jedi-config:vcs-root-sentinel ".git")

(defvar jedi-config:python-module-sentinel "__init__.py")

;; ;; Helper functions

;; Small helper to scrape text from shell output
(defun get-shell-output (cmd)
  (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string cmd)))

;; Ensure that PATH is taken from shell
;; Necessary on some environments without virtualenv
;; Taken from: http://stackoverflow.com/questions/8606954/path-and-exec-path-set-but-emacs-does-not-find-executable

;; (defun set-exec-path-from-shell-PATH ()
;;   "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell."
;;   (interactive)
;;   (let ((path-from-shell (get-shell-output "$SHELL --login -i -c 'echo $PATH'")))
;;     (setenv "PATH" path-from-shell)
;;     (setq exec-path (split-string path-from-shell path-separator))))

;; Package specific initialization
(add-hook
 'after-init-hook
 '(lambda ()

    ;; Looks like you need Emacs 24 for projectile
    (unless (< emacs-major-version 24)
      (require 'projectile)
      (projectile-global-mode))


    ;; Can also express in terms of ac-delay var, e.g.:
    ;;   (setq ac-auto-show-menu (* ac-delay 2))

    ;; Jedi
    (require 'jedi)

    ;; (Many) config helpers follow

    ;; Alternative methods of finding the current project root
    ;; Method 1: basic
    (defun get-project-root (buf repo-file &optional init-file)
      "Just uses the vc-find-root function to figure out the project root.
       Won't always work for some directory layouts."
      (let* ((buf-dir (expand-file-name (file-name-directory (buffer-file-name buf))))
	     (project-root (vc-find-root buf-dir repo-file)))
	(if project-root
	    (expand-file-name project-root)
	  nil)))

    ;; Method 2: slightly more robust
    (defun get-project-root-with-file (buf repo-file &optional init-file)
      "Guesses that the python root is the less 'deep' of either:
         -- the root directory of the repository, or
         -- the directory before the first directory after the root
            having the init-file file (e.g., '__init__.py'."

      ;; make list of directories from root, removing empty
      (defun make-dir-list (path)
        (delq nil (mapcar (lambda (x) (and (not (string= x "")) x))
                          (split-string path "/"))))
      ;; convert a list of directories to a path starting at "/"
      (defun dir-list-to-path (dirs)
        (mapconcat 'identity (cons "" dirs) "/"))
      ;; a little something to try to find the "best" root directory
      (defun try-find-best-root (base-dir buffer-dir current)
        (cond
         (base-dir ;; traverse until we reach the base
          (try-find-best-root (cdr base-dir) (cdr buffer-dir)
                              (append current (list (car buffer-dir)))))

         (buffer-dir ;; try until we hit the current directory
          (let* ((next-dir (append current (list (car buffer-dir))))
                 (file-file (concat (dir-list-to-path next-dir) "/" init-file)))
            (if (file-exists-p file-file)
                (dir-list-to-path current)
              (try-find-best-root nil (cdr buffer-dir) next-dir))))

         (t nil)))

      (let* ((buffer-dir (expand-file-name (file-name-directory (if (buffer-file-name buf) (buffer-file-name buf) "./"))))
             (vc-root-dir (vc-find-root buffer-dir repo-file)))
        (if (and init-file vc-root-dir)
            (try-find-best-root
             (make-dir-list (expand-file-name vc-root-dir))
             (make-dir-list buffer-dir)
             '())
          vc-root-dir))) ;; default to vc root if init file not given

    ;; Set this variable to find project root
    (defvar jedi-config:find-root-function 'get-project-root-with-file)

    (defun current-buffer-project-root ()
      (funcall jedi-config:find-root-function
               (current-buffer)
               jedi-config:vcs-root-sentinel
               jedi-config:python-module-sentinel))

    (defun jedi-config:setup-server-args ()
      ;; little helper macro for building the arglist
      (defmacro add-args (arg-list arg-name arg-value)
        `(setq ,arg-list (append ,arg-list (list ,arg-name ,arg-value))))
      ;; and now define the args
      (let ((project-root (current-buffer-project-root)))

        (make-local-variable 'jedi:server-args)

        (when project-root
          (message (format "Adding system path: %s" project-root))
          (add-args jedi:server-args "--sys-path" project-root))

        (when jedi-config:with-virtualenv
          (message (format "Adding virtualenv: %s" jedi-config:with-virtualenv))
          (add-args jedi:server-args "--virtual-env" jedi-config:with-virtualenv))))

    ;; Use system python
    (defun jedi-config:set-python-executable ()
      ;; (set-exec-path-from-shell-PATH)
      (make-local-variable 'jedi:server-command)
      (set 'jedi:server-command
           (list (executable-find "ipython2") ;; may need help if running from GUI
                 (cadr default-jedi-server-command))))

    ;; Now hook everything up
    ;; Hook up to autocomplete
    (add-to-list 'ac-sources 'ac-source-jedi-direct)

    ;; Enable Jedi setup on mode start
    (add-hook 'python-mode-hook 'jedi:setup)

    ;; Buffer-specific server options
    (add-hook 'python-mode-hook
              'jedi-config:setup-server-args)
    (when jedi-config:use-system-python
      (add-hook 'python-mode-hook
                'jedi-config:set-python-executable))

    ;; And custom keybindings
    ;; (defun jedi-config:setup-keys ()
    ;; (evil-leader/set-key
    ;;   (local-set-key (kbd "M-.") 'jedi:goto-definition)
    ;;   (local-set-key (kbd "M-,") 'jedi:goto-definition-pop-marker)
    ;;   (local-set-key (kbd "M-?") 'jedi:show-doc)
    ;;   )


    ;; Don't let tooltip show up automatically
    ;; (setq jedi:get-in-function-call-delay 10000000)
    ;; Start completion at method dot
    (setq jedi:complete-on-dot t)
    ;; Use custom keybinds
    ;; (add-hook 'python-mode-hook 'jedi-config:setup-keys)

    ))

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;; Setting up line nubmers on the left hand side
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;

(global-linum-mode 1)

(defface linum-current
  '((t (:inherit linum :weight bold :underline "#555")))
  "The current line number.")

(defun my-linum-get-format-string ()
  (let* ((width (max 4 (1+ (length (number-to-string
                             (count-lines (point-min) (point-max)))))))
         (format (concat "%" (number-to-string width) "d"))
         (current-line-format (concat "%" (number-to-string width) "d")))
    (setq my-linum-format-string format)
	(setq my-linum-current-line-format-string current-line-format)))

(defvar my-linum-current-line-number 0)

(defun my-linum-relative-line-numbers (line-number)
  (let* ((offset (abs (- line-number my-linum-current-line-number)))
         (linum-display-value (if (= 0 offset)
			   my-linum-current-line-number
                                offset))
         (format-string (if (= my-linum-current-line-number line-number) my-linum-current-line-format-string my-linum-format-string))
         (face (if (= my-linum-current-line-number line-number) 'linum-current 'linum)))
    (propertize (format format-string linum-display-value) 'face face)))

(defadvice linum-update (around my-linum-update)
  (let ((my-linum-current-line-number (line-number-at-pos)))
    ad-do-it))
(ad-activate 'linum-update)

;;; This is the actual line number format definition.
(setq linum-format 'my-linum-relative-line-numbers)


;;; Set up relative line numbering to mimic `:set number relativenumber`.
(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)
;; (when (require 'linum-off)
(require 'linum-off)
(add-hook 'after-change-major-mode-hook 'linum-on)

 (setq powerline-default-separator (if (display-graphic-p) 'slant
                                      nil))

  (defface my-pl-segment1-active
    '((t (:foreground "black" :background "#E1B61A")))
    "Powerline first segment active face.")
  (defface my-pl-segment1-inactive
    '((t (:foreground "#CEBFF3" :background "#3A2E58")))
    "Powerline first segment inactive face.")

  (defface my-pl-segment2-active
    '((t (:foreground "#F5E39F" :background "#8A7119")))
    "Powerline second segment active face.")
  (defface my-pl-segment2-inactive
    '((t (:foreground "#CEBFF3" :background "#3A2E58")))
    "Powerline second segment inactive face.")

  (defface my-pl-segment3-active
    '((t (:foreground "#CEBFF3" :background "#3A2E58")))
    "Powerline third segment active face.")
  (defface my-pl-segment3-inactive
    '((t (:foreground "#CEBFF3" :background "#3A2E58")))
    "Powerline third segment inactive face.")

  (defun my-powerline-default-theme ()
    "Set up my custom Powerline with Evil indicators."
    (interactive)
    (setq-default mode-line-format
                  '("%e"
                    (:eval
                     (let* ((active (powerline-selected-window-active))
                            (seg1 (if active 'my-pl-segment1-active 'my-pl-segment1-inactive))
                            (seg2 (if active 'my-pl-segment2-active 'my-pl-segment2-inactive))
                            (seg3 (if active 'my-pl-segment3-active 'my-pl-segment3-inactive))
                            (separator-left (intern (format "powerline-%s-%s"
                                                            (powerline-current-separator)
                                                            (car powerline-default-separator-dir))))
                            (separator-right (intern (format "powerline-%s-%s"
                                                             (powerline-current-separator)
                                                             (cdr powerline-default-separator-dir))))
                            (lhs (list (let ((evil-face (powerline-evil-face)))
                                         (if evil-mode
                                              (powerline-raw (powerline-evil-tag) evil-face)
                                              ))
                                       (if evil-mode
                                           (funcall separator-left (powerline-evil-face) seg1))
                                       ;;(when powerline-display-buffer-size
                                       ;;  (powerline-buffer-size nil 'l))
                                       ;;(when powerline-display-mule-info
                                       ;;  (powerline-raw mode-line-mule-info nil 'l))
                                       (powerline-buffer-id seg1 'l)
                                       (powerline-raw "[%*]" seg1 'l)
                                       (when (and (boundp 'which-func-mode) which-func-mode)
                                         (powerline-raw which-func-format seg1 'l))
                                       (powerline-raw " " seg1)
                                       (funcall separator-left seg1 seg2)
                                       (when (boundp 'erc-modified-channels-object)
                                         (powerline-raw erc-modified-channels-object seg2 'l))
                                       (powerline-major-mode seg2 'l)
                                       (powerline-process seg2)
                                       (powerline-minor-modes seg2 'l)
                                       (powerline-narrow seg2 'l)
                                       (powerline-raw " " seg2)
                                       (funcall separator-left seg2 seg3)
                                       (powerline-vc seg3 'r)
                                       (when (bound-and-true-p nyan-mode)
                                         (powerline-raw (list (nyan-create)) seg3 'l))))
                            (rhs (list (powerline-raw global-mode-string seg3 'r)
                                       (funcall separator-right seg3 seg2)
                                       (unless window-system
                                         (powerline-raw (char-to-string #xe0a1) seg2 'l))
                                       (powerline-raw "%4l" seg2 'l)
                                       (powerline-raw ":" seg2 'l)
                                       (powerline-raw "%3c" seg2 'r)
                                       (funcall separator-right seg2 seg1)
                                       (powerline-raw " " seg1)
                                       (powerline-raw "%6p" seg1 'r)
                                       (when powerline-display-hud
                                         (powerline-hud seg1 seg3)))))
                       (concat (powerline-render lhs)
                               (powerline-fill seg3 (powerline-width rhs))
                               (powerline-render rhs)))))))


(my-powerline-default-theme)
;; (setq powerline-arrow-shape 'arrow)

(setq tab-stop-list (number-sequence 4 200 4))
(provide 'init)
;; init ends here


