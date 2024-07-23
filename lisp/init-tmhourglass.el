;;; init-tmhourglass.el -*- lexical-binding: t no-byte-compile: t -*-

;; Copyright (C) 2021-2023 zilongshanren


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


;; 基于zlsr的修改：
;; 1.修改org的相关本地目录
;; 2.日期格式
;; 3.增加lazycat的auto-save  (from github)
;; 4.会话恢复  (改回去，有利于提升启动速度）
;; 5.调试python环境及eglot


;; 日期中的星期格式由中文改为英文
(setq system-time-locale "C")

;; lazycat 自动保存
;; (use-package auto-save
;;   :demand t
;;   :quelpa (auto-save :fetcher github :repo "manateelazycat/auto-save")
;;   :config
;;   (auto-save-enable)
;;   (setq auto-save-silent 1              ;quietly save
;;         auto-save-delete-trailing-whitespace nil) ;automatically delete spaces at the end of the line when saving
;;   )


;; (add-to-list 'load-path "~/config/zlsr-emacs/site-lisp/codeium/codeium.el")
;; ;; 代码助手
;; ;; we recommend using use-package to organize your init.el
;; (use-package codeium
;;     ;; if you use straight
;;     ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
;;     ;; otherwise, make sure that the codeium.el file is on load-path

;;     :init
;;     ;; use globally
;;     (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
;;     ;; or on a hook
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))

;;     ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local completion-at-point-functions
;;     ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
;;     ;; an async company-backend is coming soon!

;;     ;; codeium-completion-at-point is autoloaded, but you can
;;     ;; optionally set a timer, which might speed up things as the
;;     ;; codeium local language server takes ~0.2s to start up
;;     ;; (add-hook 'emacs-startup-hook
;;     ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

;;     ;; :defer t ;; lazy loading, if you want
;;     :config
;;     (setq use-dialog-box nil) ;; do not use popup boxes

;;     ;; if you don't want to use customize to save the api-key
;;     ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

;;     ;; get codeium status in the modeline
;;     (setq codeium-mode-line-enable
;;         (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
;;     (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
;;     ;; alternatively for a more extensive mode-line
;;     ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

;;     ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
;;     (setq codeium-api-enabled
;;         (lambda (api)
;;             (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
;;     ;; you can also set a config for a single buffer like this:
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local codeium/editor_options/tab_size 4)))

;;     ;; You can overwrite all the codeium configs!
;;     ;; for example, we recommend limiting the string sent to codeium for better performance
;;     (defun my-codeium/document/text ()
;;         (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
;;     ;; if you change the text, you should also change the cursor_offset
;;     ;; warning: this is measured by UTF-8 encoded bytes
;;     (defun my-codeium/document/cursor_offset ()
;;         (codeium-utf8-byte-length
;;             (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
;;     (setq codeium/document/text 'my-codeium/document/text)
;;     (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))


;; 试用新主题
(defun my/load-doom-theme (theme)
  "Disable active themes and load a Doom theme."
  (interactive (list (intern (completing-read "Theme: "
                                              (->> (custom-available-themes)
                                                   (-map #'symbol-name)
                                                   (--select (string-prefix-p "doom-" it)))))))
  (ap/switch-theme theme)
  (set-face-foreground 'org-indent (face-background 'default)))

(defun my/switch-theme (theme)
  "Disable active themes and load THEME."
  (interactive (list (intern (completing-read "Theme: "
                                              (->> (custom-available-themes)
                                                   (-map #'symbol-name))))))
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme theme 'no-confirm))


;; org modern
;; (use-package org-modern-indent
;;   :load-path "~/config/zlsr-emacs/elpa/org-modern-indent/"
;;   :config
;;   (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

;; Prettify UI
;; (use-package org-modern
;;   :ensure t
;;   :hook ((org-mode . org-modern-mode)
;;          (org-agenda-finalize . org-modern-agenda)
;;          (org-modern-mode . (lambda ()
;;                               "Adapt `org-modern-mode'."
;;                               ;; Disable Prettify Symbols mode
;;                               (setq prettify-symbols-alist nil)
;;                               (prettify-symbols-mode -1)))))


;; (use-package org-modern ;; 安卓下 Droid Sans Mono 字体不能显示 bullet. 最好安装 Iosevka Aile 字体.
;;   :ensure t
;;   ;; :config
;;   ;; (setq org-modern-hide-stars nil) ; adds extra indentation
;;   ;; (setq org-modern-table nil)
;;   :init
;;   (global-org-modern-mode))


(provide 'init-tmhourglass)
