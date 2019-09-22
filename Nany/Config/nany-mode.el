;; Emacs major mode for Nany language. Written by the Yuni project team.
;; Free to use, redistribute, and modify freely.
;; No implied warranty of any kind.
;;
;; You may add the following to your init.el :
;; (autoload 'nany-mode "/path/to/nany-mode.el" "Major mode for editing Nany source code." t)
;; (setq auto-mode-alist (append '(("\\.ny$" . nany-mode)) auto-mode-alist))


(defgroup nany nil
	"Major mode for editing Nany source code."
	; :link '(custom-group-link :tag "Font Lock Faces group" font-lock-faces)
	:prefix "nany-"
	:group 'languages
	)

(defvar nany-mode-hook nil "List of functions to call when entering Nany mode")

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.ny\\'" . nany-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.pny\\'" . nany-mode))

(defvar nany-mode-abbrev-table nil
	"Abbrev table in use in nany-mode buffers.")
(define-abbrev-table 'nany-mode-abbrev-table ())

;; Syntax table
(defvar nany-mode-syntax-table
	(let ((table (make-syntax-table c-mode-syntax-table)))
		(modify-syntax-entry ?\( "()" table)
		(modify-syntax-entry ?\) ")(" table)
		(modify-syntax-entry ?\[ "(]" table)
		(modify-syntax-entry ?\] ")[" table)
		(modify-syntax-entry ?\{ "(}" table)
		(modify-syntax-entry ?\} "){" table)
		(modify-syntax-entry ?/ ".124b" table)
		(modify-syntax-entry ?* ".23" table)
		(modify-syntax-entry ?\n "> b" table)
		table
		)
	)


;; Keywords
(defconst nany-keywords
	'("allow" "and" "break" "case" "class" "const" "cref" "continue" "default" "do" "each" "enum" "else" "event" "every" "for" "forbid" "func" "if" "in" "internal" "mod" "new" "not" "on" "operator" "or" "override" "private" "property" "protected" "public" "published" "raise" "ref" "return" "self" "state" "states" "switch" "then" "transitions" "typedef" "typeof" "unittest" "var" "view" "while" "workflow" "xor")
	"Nany keywords"
	)
;; Regexped version
(defvar nany-keywords-regexp (regexp-opt nany-keywords 'words))

;; File-level keywords
(defconst nany-file-keywords
	'("uses", "namespace")
	"Nany file-level keywords"
	)
;; Regexped version
(defvar nany-file-keywords-regexp (regexp-opt nany-file-keywords 'words))

;; Built-in Types
(defconst nany-builtin-types
	'("i8" "i16" "i32" "i64" "u8" "u16" "u32" "u64" "f32" "f64" "char" "bool" "string" "any" "void" "__i8" "__i16" "__i32" "__i64" "__u8" "__u16" "__u32" "__u64" "__f32" "__f64" "__pointer" "pointer")
	"Nany builtin types"
	)
;; Regexped version
(defvar nany-builtin-types-regexp (regexp-opt nany-builtin-types 'words))

;; Operators
(defconst nany-operators
	'(":" "=>" ">" "->" "<" "<=" ":=" "=" ">=" "|")
	"Nany operators"
	)

;; Regexped version
(defvar nany-operators-regexp (regexp-opt nany-operators))

;; Special operators for Multi-threading need to appear clearly
(defconst nany-special-operators
	'("&" "?")
	"Nany special operators"
	)

;; Regexped version
(defvar nany-special-operators-regexp (regexp-opt nany-special-operators))

;; Constants
(defvar nany-constants
	'("true" "false" "null" "__true" "__false")
	"Nany constants"
	)
;; Regexped version
(defvar nany-constants-regexp (regexp-opt nany-constants 'words))


;; Syntax highlighting
(defvar nany-font-lock-keywords
	`(
		;; Strings
		("\".*\"" 0 font-lock-string-face)
		("\'.\'" 0 font-lock-string-face)
		;; All sorts of comments :
		;; //!
		("\\(//!\\)\\(.*\\)$" (1 font-lock-comment-delimiter-face) (2 font-lock-doc-face))
		;; /*! */
		("\\(/\\*!\\)\\(.*\\)\\(\\*/\\)" (1 font-lock-comment-face) (2 font-lock-doc-face) (3 font-lock-comment-face))
		;; /* */
		("/\\*.*\\*/" 0 font-lock-comment-face)
		;; //
		("//.*$" . font-lock-comment-face)
		(,nany-keywords-regexp . font-lock-keyword-face)
		(,nany-file-keywords-regexp . font-lock-preprocessor-face)
		(,nany-constants-regexp . font-lock-constant-face)
		(,nany-builtin-types-regexp . font-lock-type-face)
		(,nany-operators-regexp . font-lock-reference-face)
		(,nany-special-operators-regexp . font-lock-warning-face)
		;; Type names
		(":[ \t]*\\([A-Za-z][A-Za-z0-9_]*\\)" 1 font-lock-type-face)
		("\\(new\\|class\\|enum\\|workflow\\|predicate\\)[ \t]+\\([A-Za-z][A-Za-z0-9_]*\\)" 2 font-lock-type-face)
		;; Variables and attributes
		("\\(var\\|property\\|not\\)[ \t]+\\([A-Za-z][A-Za-z0-9_]*\\)" 2 font-lock-variable-name-face)
		("if[ \t]+\\([A-Za-z][A-Za-z0-9_]*\\)" 1 font-lock-variable-name-face)
		("\\([A-Za-z][A-Za-z0-9_]*\\)[ \t]*=" 1 font-lock-variable-name-face)
		;; Method prototype
		("\\(operator\\|func\\|function\\)[ \t]+\\([A-Za-z][A-Za-z0-9_]*\\)" (2 font-lock-function-name-face))
		;; Function calls
		("\\.?\\([A-Za-z][A-Za-z0-9_]*\\)[ \t]*(" (1 font-lock-function-name-face))
		)
	"Syntax highlighting in Nany mode"
	)



(defcustom nany-indent-level 4
	"Indentation of Nany statements with respect to containing block."
	:type 'integer
	:group 'nany
	)



;; Command to comment/uncomment text
(defun nany-comment-dwim (arg)
	"Comment or uncomment current line or region in a smart way.
	For detail, see `comment-dwim'."
	(interactive "*P")
	(require 'newcomment)
	(let ((deactivate-mark nil) (comment-start "//") (comment-end ""))
		(comment-dwim arg)
		)
	)

;; Command to indent a line
(defun nany-indent-line ()
	"Indent current line as Nany code"
	(interactive)
	(beginning-of-line)
	; Beginning of buffer
	(if (bobp)
			(indent-line-to 0)
		(let ((not-indented t) cur-indent)
			; End of scope, indent -1
			(if (looking-at "^[ \t]*}")
					(progn
						(save-excursion
							(forward-line -1)
							(if (looking-at "^[ \t]*{")
									()
								(setq cur-indent (- (current-indentation) tab-width))
								)
							)
						(if (< cur-indent 0)
								(setq cur-indent 0)
							)
						)
				; Find an indentation hint from above the current line
				(save-excursion
					(while not-indented
						(forward-line -1)
						; If we found an end of scope, use its indent level
						(if (looking-at "^[ \t]*}")
								(progn
									(setq cur-indent (current-indentation))
									(setq not-indented nil)
									)
							; If we found a beginning of scope, increase indent level from this one
							(if (looking-at "^[ \t]*{")
									(progn
										(setq cur-indent (+ (current-indentation) tab-width))
										(setq not-indented nil)
										)
								; Default
								(if (bobp)
										(setq not-indented nil)
									)
								)
							)
						)
					)
				)
			; Do the actual indentation if we found an indentation hint
			(if cur-indent
					(indent-line-to cur-indent)
				(indent-line-to 0)
				)
			)
		)
	)



;; Command for keyword completion
(defun nany-complete-symbol ()
	"Perform keyword completion on word before cursor."
	(interactive)
	(let
			((posEnd (point))
			 (meat (thing-at-point 'symbol))
			 maxMatchResult
			 )

		;; When nil, set it to empty string, so user can see all lang's keywords.
		;; If not done, try-completion on nil result lisp error.
		(when (not meat) (setq meat ""))
		(setq maxMatchResult (try-completion meat nany-keywords))

		(cond
		 ((eq maxMatchResult t))
		 ((null maxMatchResult)
			(message "Can't find completion for “%s”" meat) (ding)
			)
		 ((not (string= meat maxMatchResult))
			(delete-region (- posEnd (length meat)) posEnd)
			(insert maxMatchResult)
			)
		 (t (message "Making completion list...")
				(with-output-to-temp-buffer "*Completions*"
					(display-completion-list
					 (all-completions meat nany-keywords)
					 meat
					 )
					)
				(message "Making completion list...%s" "done")
				)
		)
		)
	)

;; Set keymap
(defvar nany-mode-map
	(let ((map (make-keymap)))
		(define-key map "\C-j" 'newline-and-indent)
		(define-key map [remap comment-dwim] 'nany-comment-dwim)
		(define-key map (kbd "C-c C-c") 'comment-region)
		(define-key map (kbd "C-c c") 'nany-complete-symbol)
		map
		)
	"Keymap for Nany major mode"
	)

;; Define the major mode
(defun nany-mode ()
	"Major mode for editing Nany code. You may use nany-indent-line, nany-complete-symbol, nany-comment-dwim."
	(interactive)
	(kill-all-local-variables)
	;; Key mappings
	(use-local-map nany-mode-map)
	;; Major mode definition
	(setq major-mode 'nany-mode)
	;; Mode name
	(setq mode-name "Nany")
	;; Abbrev table
	(setq local-abbrev-table nany-mode-abbrev-table)
	;; Syntax table
	(set-syntax-table nany-mode-syntax-table)
	;; Comments
	(set (make-local-variable 'comment-start) "//")
	(set (make-local-variable 'comment-end) "")
	;; Use tab indents
	(set (make-local-variable 'indent-tabs-mode) t)
	;; Font lock
	(make-local-variable 'font-lock-defaults)
	(setq font-lock-defaults '(nany-font-lock-keywords t))
	;; Indentation
	(set (make-local-variable 'indent-line-function) 'nany-indent-line)
	;; Hooks
	(run-mode-hooks 'nany-mode-hook)
	)

(provide 'nany-mode)
