;;;;  -*- lexical-binding: t; -*-
(require 'init-funcs)

;;
;;; Packages

(use-package all-the-icons
  :ensure t)

;; (add-to-list 'load-path "~/Github/lsp-bridge")

;; (require 'lsp-bridge)
;; (setq lsp-bridge-python-command "/usr/local/bin/python3")

;; (dolist (hook (list
;;                'python-mode-hook
;;                'ruby-mode-hook
;;                'c-mode-hook
;;                'c++-mode-hook
;;                'js2-mode-hook
;;                'typescript-mode-hook
;;                ))
;;   (add-hook hook (lambda ()
;;                    (lsp-bridge-mode))))

(use-package typescript-mode
  :ensure t)


;; For python and pyright





(when (not (display-graphic-p))
  (use-package company
    :init
    (setq company-minimum-prefix-length 1)
    (setq company-idle-delay 0)
    (global-company-mode t))

  (use-package company-flx
    :after (company)
    :init
    (company-flx-mode 1))
  (with-eval-after-load 'company
    (define-key company-active-map (kbd "M-n") nil)
    (define-key company-active-map (kbd "M-p") nil)
    (define-key company-active-map (kbd "C-j") #'company-select-next)
    (define-key company-active-map (kbd "C-k") #'company-select-previous)))

(defun nasy/orderless-dispatch-flex-first (_pattern index _total)
  "orderless-flex for corfu."
  (and (eq index 0) 'orderless-flex))

(defun nasy/setup-corfu ()
  "Setup corfu."
  (setq-local orderless-matching-styles '(orderless-flex)
              orderless-style-dispatchers nil)
  (add-hook 'orderless-style-dispatchers #'nasy/orderless-dispatch-flex-first nil 'local))

;; use corfu instead
(when (display-graphic-p)
  (use-package corfu
    :init
    (setq corfu-cycle t)
    (setq corfu-auto t)
    (setq corfu-quit-at-boundary t)
    (setq corfu-quit-no-match t)
    (setq corfu-preview-current nil)
    (setq corfu-min-width 80)
    (setq corfu-max-width 100)
    (setq corfu-auto-delay 0.1)
    (setq corfu-auto-prefix 1)
    (global-corfu-mode)
    :hook (prog-mode . nasy/setup-corfu)
    :config
    (define-key corfu-map (kbd "C-j") 'corfu-next)
    (define-key corfu-map (kbd "C-k") 'corfu-previous))

  (use-package corfu-doc
    :init
    ;; (add-hook 'corfu-mode-hook #'corfu-doc-mode)
    (define-key corfu-map (kbd "s-d") #'corfu-doc-toggle)
    (define-key corfu-map (kbd "s-p") #'corfu-doc-scroll-down) ;; corfu-next
    (define-key corfu-map (kbd "s-n") #'corfu-doc-scroll-up)   ;; corfu-previous
    )

  ;; elisp requires emacs28
  ;; (use-package kind-icon
  ;;   :ensure t
  ;;   :demand t
  ;;   :after corfu
  ;;   :custom
  ;;   (kind-icon-default-face 'corfu-default)
  ;;   :config
  ;;   (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  ;;   )

  ;; Use dabbrev with Corfu!
  (use-package dabbrev
    ;; Swap M-/ and C-M-/
    :bind (("M-/" . dabbrev-completion)
           ("C-M-/" . dabbrev-expand)))

  ;; A few more useful configurations...
  (use-package emacs
    :init
    ;; TAB cycle if there are only few candidates
    (setq completion-cycle-threshold 3)

    ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
    ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
    ;; (setq read-extended-command-predicate
    ;;       #'command-completion-default-include-p)

    ;; Enable indentation+completion using the TAB key.
    ;; `completion-at-point' is often bound to M-TAB.
    (setq tab-always-indent 'complete))

  ;; Add extensions
  (use-package cape
    ;; Bind dedicated completion commands
    :bind (("C-c p p" . completion-at-point) ;; capf
           ("C-c p t" . complete-tag)        ;; etags
           ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
           ("C-c p f" . cape-file)
           ("C-c p k" . cape-keyword)
           ("C-c p s" . cape-symbol)
           ("C-c p a" . cape-abbrev)
           ("C-c p i" . cape-ispell)
           ("C-c p l" . cape-line)
           ("C-c p w" . cape-dict)
           ("C-c p \\" . cape-tex)
           ("C-c p _" . cape-tex)
           ("C-c p ^" . cape-tex)
           ("C-c p &" . cape-sgml)
           ("C-c p r" . cape-rfc1345))
    :init
    ;; Add `completion-at-point-functions', used by `completion-at-point'.
    (add-to-list 'completion-at-point-functions #'cape-file)
    (add-to-list 'completion-at-point-functions #'cape-tex)
    (add-to-list 'completion-at-point-functions #'cape-dabbrev)
    (setq cape-dabbrev-check-other-buffers nil)
    (add-to-list 'completion-at-point-functions #'cape-keyword)
    ))



(use-package vertico
  :hook (after-init . vertico-mode)
  :config
  (setq vertico-resize nil
        vertico-count 17
        vertico-cycle t)
  ;; Cleans up path when moving directories with shadowed paths syntax, e.g.
  ;; cleans ~/foo/bar/// to /, and ~/foo/bar/~/ to ~/.
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  (define-key vertico-map (kbd "C-j") 'vertico-next)
  (define-key vertico-map (kbd "C-k") 'vertico-previous)
  (define-key vertico-map [backspace] #'vertico-directory-delete-char)
  (define-key vertico-map (kbd "s-SPC") #'+vertico/embark-preview)

  )


(use-package orderless
  :demand t
  ;;       orderless-component-separator "[ &]")
  ;; ...otherwise find-file gets different highlighting than other commands
  ;; (set-face-attribute 'completions-first-difference nil :inherit nil)
  :config
  (defvar +orderless-dispatch-alist
    '((?% . char-fold-to-regexp)
      (?! . orderless-without-literal)
      (?`. orderless-initialism)
      (?= . orderless-literal)
      (?~ . orderless-flex)))

  ;; Recognizes the following patterns:
  ;; * ~flex flex~
  ;; * =literal literal=
  ;; * %char-fold char-fold%
  ;; * `initialism initialism`
  ;; * !without-literal without-literal!
  ;; * .ext (file extension)
  ;; * regexp$ (regexp matching at end)
  (defun +orderless-dispatch (pattern index _total)
    (cond
     ;; Ensure that $ works with Consult commands, which add disambiguation suffixes
     ((string-suffix-p "$" pattern)
      `(orderless-regexp . ,(concat (substring pattern 0 -1) "[\x100000-\x10FFFD]*$")))
     ;; File extensions
     ((and
       ;; Completing filename or eshell
       (or minibuffer-completing-file-name
           (derived-mode-p 'eshell-mode))
       ;; File extension
       (string-match-p "\\`\\.." pattern))
      `(orderless-regexp . ,(concat "\\." (substring pattern 1) "[\x100000-\x10FFFD]*$")))
     ;; Ignore single !
     ((string= "!" pattern) `(orderless-literal . ""))
     ;; Prefix and suffix
     ((if-let (x (assq (aref pattern 0) +orderless-dispatch-alist))
          (cons (cdr x) (substring pattern 1))
        (when-let (x (assq (aref pattern (1- (length pattern))) +orderless-dispatch-alist))
          (cons (cdr x) (substring pattern 0 -1)))))))

  ;; Define orderless style with initialism by default
  (orderless-define-completion-style +orderless-with-initialism
                                     (orderless-matching-styles '(orderless-initialism orderless-literal orderless-regexp)))

  ;; You may want to combine the `orderless` style with `substring` and/or `basic`.
  ;; There are many details to consider, but the following configurations all work well.
  ;; Personally I (@minad) use option 3 currently. Also note that you may want to configure
  ;; special styles for special completion categories, e.g., partial-completion for files.
  ;;
  ;; 1. (setq completion-styles '(orderless))
  ;; This configuration results in a very coherent completion experience,
  ;; since orderless is used always and exclusively. But it may not work
  ;; in all scenarios. Prefix expansion with TAB is not possible.
  ;;
  ;; 2. (setq completion-styles '(substring orderless))
  ;; By trying substring before orderless, TAB expansion is possible.
  ;; The downside is that you can observe the switch from substring to orderless
  ;; during completion, less coherent.
  ;;
  ;; 3. (setq completion-styles '(orderless basic))
  ;; Certain dynamic completion tables (completion-table-dynamic)
  ;; do not work properly with orderless. One can add basic as a fallback.
  ;; Basic will only be used when orderless fails, which happens only for
  ;; these special tables.
  ;;
  ;; 4. (setq completion-styles '(substring orderless basic))
  ;; Combine substring, orderless and basic.
  ;;
  (setq completion-styles '(orderless partial-completion)
        completion-category-defaults nil
;;; Enable partial-completion for files.
;;; Either give orderless precedence or partial-completion.
;;; Note that completion-category-overrides is not really an override,
;;; but rather prepended to the default completion-styles.
        ;; completion-category-overrides '((file (styles orderless partial-completion))) ;; orderless is tried first
        completion-category-overrides '((file (styles partial-completion)) ;; partial-completion is tried first
                                        ;; enable initialism by default for symbols
                                        (command (styles +orderless-with-initialism))
                                        (variable (styles +orderless-with-initialism))
                                        (symbol (styles +orderless-with-initialism)))
        orderless-component-separator #'orderless-escapable-split-on-space ;; allow escaping space with backslash!
        orderless-style-dispatchers '(+orderless-dispatch))
  )


(use-package consult
  :defer t
  :init
  (if sys/win32p
      (progn
        (add-to-list 'process-coding-system-alist '("es" gbk . gbk))
        (add-to-list 'process-coding-system-alist '("explorer" gbk . gbk))
        (setq consult-locate-args (encode-coding-string "es.exe -i -p -r" 'gbk))))


  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)
  (advice-add #'multi-occur :override #'consult-multi-occur)
  (advice-add #'consult-line
              :around
              #'zilongshanren/consult-line
              '((name . "wrapper")))

  :config
  (global-set-key (kbd "M-y") 'consult-yank-pop)
  (setq ;; consult-project-root-function #'doom-project-root
   consult-narrow-key "<"
   consult-line-numbers-widen t
   consult-async-min-input 2
   consult-async-refresh-delay  0.15
   consult-async-input-throttle 0.2
   consult-async-input-debounce 0.1)


  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file
   :preview-key (kbd "C-SPC"))

  (consult-customize
   consult-theme
   :preview-key (list (kbd "C-SPC") :debounce 0.5 'any)))


(use-package consult-dir
  :bind (([remap list-directory] . consult-dir)
         :map vertico-map
         ("s-d" . consult-dir)))

(use-package consult-flycheck
  :after (consult flycheck))


(use-package embark
  :defer t
  :init
  (setq which-key-use-C-h-commands nil
        ;; press C-h after a prefix key, it shows all the possible key bindings and let you choose what you want
        prefix-help-command #'embark-prefix-help-command)

  (setq
   embark-verbose-indicator-display-action
   '((display-buffer-at-bottom)
     (window-parameters (mode-line-format . none))
     (window-height . fit-window-to-buffer)))

  (define-key minibuffer-local-map (kbd "C-;") 'embark-act)
  (define-key minibuffer-local-map (kbd "C-c C-;") 'embark-export)
  (define-key minibuffer-local-map (kbd "C-c C-e") '+vertico/embark-export-write)

  (with-eval-after-load 'popwin
    (progn
      (push '(occur-mode :position right :width 100) popwin:special-display-config)
      (push '(grep-mode :position right :width 100) popwin:special-display-config)
      (push '(special-mode :position right :width 100) popwin:special-display-config)))

  (global-set-key (kbd "C-;") 'embark-act)

  :config
  (define-key minibuffer-local-map (kbd "C-'") #'embark-become)
  ;; list all the keybindings in this buffer
  (global-set-key (kbd "C-h B") 'embark-bindings)
  ;; add the package! target finder before the file target finder,
  ;; so we don't get a false positive match.
  :config
  (define-key embark-identifier-map "R" #'consult-ripgrep)
  (define-key embark-identifier-map (kbd "C-s") #'consult-line)

  (define-key embark-file-map (kbd "E") #'consult-directory-externally)
  )


(use-package marginalia
  :hook (after-init . marginalia-mode)
  :init
  :config
  )


(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand
  :config
  (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode))


(use-package wgrep
  :commands wgrep-change-to-wgrep-mode
  :config (setq wgrep-auto-save-buffer t))





(provide 'init-completion)
