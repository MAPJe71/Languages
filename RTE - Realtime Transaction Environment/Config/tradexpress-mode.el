;;; tradexpress-mode.el --- major mode for TradeXpress .rte file
;; Author: Jaime Tarrant <jdt@cookiesystems.com>
;; Version: 0.1
;; Created: 02 November 2015
;; Keywords: languages
;; Homepage: https://www.github.com/jaimetarrant/tradexpress-mode

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the GNU General Public License version 2.

;;; Commentary:

;; TradeXpress major mode

;; full doc on how to use here

;;; Code:

(setq-local comment-start "!")
(setq-local comment-end "")

;; define several category of keywords
(setq tx-codeblocks '("default" "enddefault" "function" "endfunction" "begin" "endbegin" "end" "endend" "segment" "endsegment" "line" "endline" "nodein"	"endnodein" "nodeout" "endnodeout" "message"))
(setq tx-keywords   '("break" "if" "else" "endif" "while" "endwhile"  "for" "case" "switch" "endswitch" "return" "exit" "then" "do"))
(setq tx-types      '("float" "integer" "key" "list" "rotation" "string" "vector"))
(setq tx-constants  '("TRUE" "FALSE" "NL"))
(setq tx-events     '())
(setq tx-functions  '("substr" "print" "log" "number" "build" "split" "peel" "find" "compare" "flush" "system" "substr" "strip" "remove" "length" "put" "exec" "find" "close" "debug" "time" "valid"))

;; generate regex string for each category of keywords

(setq tx-codeblock-regexp (regexp-opt tx-codeblocks 'words))
(setq tx-keywords-regexp (regexp-opt tx-keywords 'words))
(setq tx-type-regexp (regexp-opt tx-types 'words))
(setq tx-constant-regexp (regexp-opt tx-constants 'words))
(setq tx-event-regexp (regexp-opt tx-events 'words))
(setq tx-functions-regexp (regexp-opt tx-functions 'words))

;; create the list for font-lock.
;; each category of keyword is given a particular face
(setq tx-font-lock-keywords
      `(
				(,tx-codeblock-regexp . font-lock-type-face)
        (,tx-type-regexp . font-lock-type-face)
        (,tx-constant-regexp . font-lock-constant-face)
        (,tx-event-regexp . font-lock-builtin-face)
        (,tx-functions-regexp . font-lock-function-name-face)
        (,tx-keywords-regexp . font-lock-keyword-face)
        ;; note: order above matters, because once colored, that part won't change.
        ;; in general, longer words first
        ))

(defvar tradexpress-syntax-table nil "Syntax Table for `tradexpress-mode'.")
(setq tradexpress-syntax-table
			(let ((synTable (make-syntax-table)))

				(modify-syntax-entry ?! "< b" synTable)
				(modify-syntax-entry ?\n "> b" synTable)

				synTable))

;;;###autoload
(define-derived-mode tradexpress-mode fundamental-mode
  "tx mode"
  "Major mode for editing TradeXpress .rte files…"
  ;; code for syntax highlighting
	(set-syntax-table tradexpress-syntax-table)
  (setq font-lock-defaults '((tx-font-lock-keywords))))

;; clear memory. no longer needed
(setq tx-codeblocks nil)
(setq tx-keywords nil)
(setq tx-types nil)
(setq tx-constants nil)
(setq tx-events nil)
(setq tx-functions nil)

;; clear memory. no longer needed
(setq tx-codeblock-regexp nil)
(setq tx-keywords-regexp nil)
(setq tx-types-regexp nil)
(setq tx-constants-regexp nil)
(setq tx-events-regexp nil)
(setq tx-functions-regexp nil)

;; add the mode to the `features' list
(provide 'tradexpress-mode)

;; Local Variables:
;; coding: utf-8
;; End:

;;; tradexpress-mode.el ends here
