;;; init-tmhourglass.el -*- lexical-binding: t no-byte-compile: t -*-

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


;; 日期中的星期格式由中文改为英文
(setq system-time-locale "C")

;; lazycat 自动保存
(use-package auto-save
  :demand t
  :quelpa (auto-save :fetcher github :repo "manateelazycat/auto-save")
  :config
  (auto-save-enable)
  (setq auto-save-silent 1              ;quietly save
        auto-save-delete-trailing-whitespace t) ;automatically delete spaces at the end of the line when saving
  )



(provide 'init-tmhourglass)
