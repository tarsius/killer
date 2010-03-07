;;; killer.el --- kill and delete text

;; Copyright (C) 2008, 2009, 2010  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Created: 20080830
;; Updated: 20100307
;; Version: 0.2
;; Homepage: http://github.com/tarsius/killer
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;  Defines additional commands to kill and delete text.

;;; Code:

(defun kill-char (arg)
  "Kill the following n characters."
  (interactive "p")
  (kill-region (point) (progn (forward-char arg) (point))))

(defun backward-kill-char (arg)
  "Kill the previous n characters."
  (interactive "p")
  (kill-char (- arg)))

(defun kill-or-delete-char (arg)
  "Kill or delete following n character."
  (interactive "p")
  (if (eq last-command 'kill-region)
      (kill-char arg)
    (delete-char arg)))

(defun backward-kill-or-delete-char (arg)
  "Kill or delete previous n character."
  (interactive "p")
  (if (eq last-command 'kill-region)
      (backward-kill-char arg)
    (backward-delete-char arg)))

(defun backward-kill-or-delete-char-untabify (arg &optional killp)
  "Kill or delete previous n character."
  (interactive "p")
  (if (eq last-command 'kill-region)
      (backward-delete-char-untabify arg t)
    (backward-delete-char-untabify arg)))

(defun backward-word-or-wspace (&optional arg)
  "Move backward over word or whitespace.
Move backward until end of word or if point is surrounded by whitespace move
to the end of the next word.  With argument, always move by that many words."
  (interactive "P")
  (if arg
      (backward-word arg)
    (if (and (looking-at "[ \t]")
	     (looking-back "[ \t]"))
	(skip-chars-backward "[:space:]")
      (backward-word))))

(defun forward-word-or-wspace (&optional arg)
  "Move forward over word or whitespace.
Move forward until end of word or if point is surrounded by whitespace move
to the end of the previous word.  With argument, always move by that many words."
  (interactive "P")
  (if arg
      (forward-word arg)
    (if (and (looking-at "[ \t]")
	     (looking-back "[ \t]"))
	(skip-chars-forward "[:space:]")
      (forward-word))))

(defun backward-delete-whitespace ()
  "Delete all spaces and tabs before point."
  (interactive)
  (let ((orig-pos (point)))
    (delete-region orig-pos
		   (progn (skip-chars-backward " \t")
			  (constrain-to-field nil orig-pos)))))

(defun forward-delete-whitespace ()
  "Delete all spaces and tabs after point."
  (interactive)
  (let ((orig-pos (point)))
    (delete-region (progn (skip-chars-forward " \t")
			  (constrain-to-field nil orig-pos))
		   orig-pos)))

(defun backward-kill-whitespace ()
  "Kill all spaces and tabs before point."
  (interactive)
  (let ((orig-pos (point)))
    (kill-region orig-pos
		 (progn (skip-chars-backward " \t")
			(constrain-to-field nil orig-pos)))))

(defun forward-kill-whitespace ()
  "Kill all spaces and tabs after point."
  (interactive)
  (let ((orig-pos (point)))
    (kill-region (progn (skip-chars-forward " \t")
			(constrain-to-field nil orig-pos))
		 orig-pos)))

(defun backward-kill-word-or-wspace (&optional arg)
  "Kill characters backward until encountering the end of a word.
If point is surrounded by whitespace kill to the end of the preciding word.
With argument, always kill that many words."
  (interactive "p")
  (setq this-command 'kill-region)
  (if arg
      (backward-kill-word arg)
    (if (looking-at "[ \t]")
	(backward-kill-whitespace)
      (backward-kill-word 1))))

(defun kill-word-or-wspace (&optional arg)
  "Kill characters forward until encountering the end of a word.
If point is surrounded by whitespace kill to the beginning of the following word.
With argument, always kill that many words."
  (interactive "p")
  (setq this-command 'kill-region)
  (if arg
      (kill-word arg)
    (if (looking-at "[ \t]")
	(forward-kill-whitespace)
      (kill-word 1))))

(defun backward-kill-line (&optional arg)
  "Kills the text before point on the current line.

With prefix argument, kill backward n lines from point.
With negative prefix arguments kill n lines forward.
Don't do this; use `kill-line' instead."
  (interactive "P")
  (kill-line (- (or arg 0))))

(provide 'killer)
;;; killer.el ends here

