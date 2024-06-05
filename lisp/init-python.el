;;; init-python.el -*- lexical-binding: t no-byte-compile: t -*-

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

;; Python Mode
;; Install: pip install pyflakes autopep8
(use-package python
  :ensure t
  :hook (inferior-python-mode . (lambda ()
                                  (process-query-on-exit-flag
                                   (get-process "Python"))))
  :init
  ;; Disable readline based native completion
  (setq python-shell-completion-native-enable nil)
  :config
  (global-leader
    :major-modes
    '(python-mode t)
    ;;and the keymaps:
    :keymaps
    '(python-mode-map)
    "e" 'live-py-set-version)
  (setq python-shell-interpreter "python3")

  ;; tmhourglass add : fix python-add-import
  (setq python-interpreter "python3")
  (add-hook 'python-ts-mode-hook #'eglot-ensure)

  ;; Live Coding in Python
  (use-package live-py-mode))


;; virtual envrionment
(use-package auto-virtualenvwrapper
  :ensure t
  :hook (python-mode-hook . #'auto-virtualenvwrapper-activate))

(use-package pyvenv
  :ensure t
  :config
  (setenv "WORKON_HOME" (expand-file-name "~/workspace/code/python/envs"))
  ;; (setq python-shell-interpreter "python3")  ; （可选）更改解释器名字
  (pyvenv-mode t)
  ;; （可选）如果希望启动后激活 miniconda 的 base 环境，就使用如下的 hook
  ;; :hook
  ;; (python-mode . (lambda () (pyvenv-workon "..")))
)

(provide 'init-python)
