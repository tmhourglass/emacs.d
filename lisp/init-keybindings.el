;;; init.el -*- lexical-binding: t no-byte-compile: t -*-

;; Copyright (C) 2021-2023 zilongshanren

;; Author: zilongshanren <guanghui8827@gmail.com>
;; URL: https://github.com/zilongshanren/emacs.d


;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;




(use-package which-key
  :hook (after-init . which-key-mode)
  :ensure t
  :init
  (setq which-key-side-window-location 'bottom))




(global-set-key "\C-s" 'consult-line)


(global-set-key (kbd "s-/") 'hippie-expand)
(global-set-key (kbd "<f2>") 'open-my-init-file)


(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)
(global-set-key (kbd "s-1") 'lispy-describe-inline)

;; mimic macos keybindgs
(when (or sys/win32p sys/mac-x-p)
    (progn
      (global-set-key (kbd "s-x") 'kill-region)
      (global-set-key (kbd "s-c") 'kill-ring-save)
      (global-set-key (kbd "s-v") 'yank)
      (global-set-key (kbd "s-z") 'undo)
      (global-set-key (kbd "s-l") 'goto-line)
      ;; (global-set-key (kbd "s-q") 'save-buffers-kill-emacs)
      (global-set-key (kbd "s-a") 'mark-whole-buffer)
      (global-set-key (kbd "s-s") 'save-buffer)))




(global-set-key (kbd "C-c a") 'org-agenda)

(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)
(define-key global-map (kbd "s-e") 'rime-inline-ascii)
(global-set-key (kbd "s-/") 'hippie-expand)


;; r aka remember
(global-set-key (kbd "C-c r") 'org-capture)




(global-set-key (kbd "M-s e") 'iedit-mode)

(global-set-key (kbd "C-=") 'er/expand-region)


(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-h a") 'apropos)


(global-set-key (kbd "s-r") #'revert-this-buffer)
(global-set-key (kbd "s-d") 'zilongshanren/my-mc-mark-next-like-this)
(global-set-key (kbd "C-c l") 'zilongshanren/insert-chrome-current-tab-url)



(use-package general
  :init
  (general-emacs-define-key 'global [remap imenu] 'consult-imenu)
  (general-emacs-define-key 'global [remap apropos] 'consult-apropos)
  (global-definer
    "!" 'shell-command
    ":" 'eval-expression
    "SPC" 'execute-extended-command
    "x" 'switch-to-scratch-buffer
    "TAB" 'spacemacs/alternate-buffer
    "'" 'vertico-repeat
    "=" 'indent-buffer
    "+" 'text-scale-increase
    "-" 'text-scale-decrease
    "u" 'universal-argument
    "v" 'er/expand-region
    "0" 'select-window-0
    "1" 'select-window-1
    "2" 'select-window-2
    "3" 'select-window-3
    "4" 'select-window-4
    "5" 'select-window-5
    ";" 'vterm
    "`" 'multi-vterm-project
    "hdf" 'describe-function
    "hdv" 'describe-variable
    "hdk" 'describe-key
    "qq" 'save-buffers-kill-terminal
    "qR" 'restart-emacs
    "hh" 'zilongshanren/highlight-dwim
    "hc" 'zilongshanren/clearn-highlight
    "en" 'my-goto-next-error
    "ry" 'consult-yank-pop
    "R" 'zilongshanren/run-current-file
    "ep" 'my-goto-previous-error
    "el" 'my-list-errors
    "oy" 'my/eudic
    "oo" 'zilongshanren/hotspots
    "or" 'org-roam-node-find
    "gs" 'magit-status
    "gd" 'vc-diff
    "gg" 'xref-find-definitions
    "gr" 'xref-find-references
    "gm" 'consult-mark
    "gM" 'consult-global-mark)

  (+general-global-menu! "search" "s"
    "j" 'my/imenu
    "p" 'consult-ripgrep
    "k" 'consult-keep-lines
    "f" 'consult-focus-lines)


  (+general-global-menu! "buffer" "b"
    "d" 'kill-current-buffer
    "b" '(consult-buffer :which-key "consult buffer")
    "B" 'switch-to-buffer
    "p" 'previous-buffer
    "R" 'rename-buffer
    "M" '((lambda () (interactive) (switch-to-buffer "*Messages*"))
          :which-key "messages-buffer")
    "n" 'next-buffer
    "i" 'ibuffer
    "f" 'my-open-current-directory
    "k" 'kill-buffer
    "y" 'copy-buffer-name
    "K" 'kill-other-buffers)

  (+general-global-menu! "layout" "l"
    "l" 'tabspaces-switch-or-create-workspace
    "L" 'tabspaces-restore-session
    "p" 'tabspaces-open-or-create-project-and-workspace
    "f" 'tabspaces-project-switch-project-open-file
    "s" 'tabspaces-save-session
    "B" 'tabspaces-switch-buffer-and-tab
    "b" 'tabspaces-switch-to-buffer
    "R" 'tab-rename
    "TAB" 'tab-bar-switch-to-recent-tab
    "r" 'tabspaces-remove-current-buffer
    "k" 'tabspaces-close-workspace)

  (+general-global-menu! "file" "f"
    "f" 'find-file
    "r" 'consult-recent-file
    "L" 'consult-locate
    "d" 'consult-dir
    "ed" 'open-my-init-file
    "s" 'save-buffer
    "w" 'sudo-edit
    "S" 'save-some-buffers
    "j"  'dired-jump
    "y" 'copy-file-name
    "R" 'my/rename-current-buffer-file
    "k" 'my/delete-file-and-buffer
    "!" 'my/exec-shell-on-buffer)

  (+general-global-menu! "window" "w"
    "/" 'split-window-right
    "-" 'split-window-below
    "m" 'delete-other-windows
    "u" 'winner-undo
    "z" 'winner-redo
    "w" 'esw/select-window
    "s" 'esw/swap-two-windows
    "d" 'esw/delete-window
    "=" 'balance-windows-area
    "r" 'esw/move-window
    "x" 'resize-window
    "H" 'buf-move-left
    "L" 'buf-move-right
    "J" 'buf-move-down
    "K" 'buf-move-up)

  (+general-global-menu! "toggle" "t"
    "s" 'flycheck-mode
    "S" 'flyspell-prog-mode
    "e" 'toggle-corfu-english-helper
    "r" 'read-only-mode
    "n" 'my-toggle-line-numbber
    "w" 'distraction-free
    "k" '+toggle-keycast
    "c" 'global-corfu-mode
    "m" 'consult-minor-mode-menu)

  (+general-global-menu! "project" "p"
    "f" 'project-find-file
    "r" 'consult-recent-file
    "s" 'project-find-regexp
    "d" 'project-dired
    "b" 'consult-project-buffer
    "e" 'project-eshell
    "m" 'my/project-run-makefile-target
    "c" 'project-compile
    "t" 'my/project-citre
    "p" 'project-switch-project
    "i" 'my/project-info
    "a" 'project-remember-projects-under
    "x" 'project-forget-project)

  )


(global-set-key (kbd "<f5>") 'gud-run)
(global-set-key (kbd "<f9>") 'gud-break)
(setq gdb-many-windows t)
(setq gdb-show-main t)

(evil-define-key 'normal dired-mode-map
  (kbd "<RET>") 'dired-find-alternate-file
  (kbd "C-k") 'dired-up-directory
  "`" 'dired-open-term
  "o" 'dired-find-file-other-window
  "s" 'hydra-dired-quick-sort/body
  "z" 'dired-get-size
  "!" 'zilongshanren/do-shell-and-copy-to-kill-ring
  ")" 'dired-omit-mode)

(provide 'init-keybindings)
