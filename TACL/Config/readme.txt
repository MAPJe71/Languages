Tandem Advanced Command Langauge (TACL) Syntax Highlighting and Auto-Completion
Written by Adam Woolfrom (woolfrom20@hotmail.com)
Written on 10/03/2013
Version 1.0


About:

TACL syntax highlighting will do the following:

	- Highlight in blue TACL commands / builtins
	- Highlight in blue and bold for the following: #CASE, #DEF, #IF, #LOOP
	- Highlight in red for anything prefixed with a # that doesn't match a valid command / builtin
	- Highlight in orange for numbers
	- Highlight in green for comments
	- Highlight in purple for: ?BLANK, ?FORMAT, ?SECTION, ?TACL
	- Fold comments on multiple lines and areas between [ ] on different lines

TACL auto-completion will provide auto-completion of all commands and builtins.  There is
currently a limitation in Notepad++ that only supports auto-completion of words starting with 
the following: A-Z, a-z, 0-9 and '_'.  Therefore, the commands starting with # and ? are not working.


Installation:

For TACL syntax highlighting:

	Refer to: http://sourceforge.net/apps/mediawiki/notepad-plus/index.php?title=User_Defined_Language_Files#How_to_install_user_defined_language_files


For TACL auto-completion:

	1. Copy the TACL.xml auto-completion file to the plugins\APIs\ subfolder of the Notepad++ installation folder.
	2. Ensure the auto-completion features are enabled in the preferences.