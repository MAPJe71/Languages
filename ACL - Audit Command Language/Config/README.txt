ACL Script Syntax Coloring Using Notepad++

JChen
2019/01/12

Abstract
--------------------
This is the instruction for ACL (Audit Command Language) script syntax coloring using Notepad++.

Special Notes
--------------------
1. ACL Analytics version 11 supports .aclscript extension. Original .BAT is removed from the association.
2. ACL allows short name for commands, for example, DIS or DISP for DISPLAY.  However, this syntax coloring only uses full command and function names.
3. Multi-line comments: COMMENT / END not working.
4. 2015/04/16 update: add 4 new ACL 11.2 functions.
5. 2015/07/25 update: need to open .ac working file to view, so add working file keywords.
6. 2016/11/17 update: 1 new ACL 12 function.
7. 2017/01/07 update: add R and Python functions and update missing commands as in ACL12 Help document.
8. 2018/01/22 update: 4 new ACL 13 commands.
9. 2019/01/12 update: Modify coloring suggested by Mr. Turnbull to closer match to ACL editors.  Also updated ACL 14 commands.



Install Instructions
--------------------
1. Install Notepad++, a free text editor.  Latest version can be found at: http://notepad-plus-plus.org/
2. Download the userDefineLang_acl.xml file.
3. Open Notepad++, on the Menu->Language->Defined your language.  
4. Click on "Import.." and select userDefineLang_acl.xml. After import is successful, close the dialog.
5. Close Notepad++ and re-open it.  Check Menu->Language now listed ACL near the bottom of the language menu.
6. On Windows Explorer, right click on the ACL project file (.acl), ACL working file (.ac) or ACL script file (.acls or .aclscript), select on "Edit with Notepad++".  The keywords should be colored.
7. You can make the file extension .aclscript associates to Notepad++ as the default editor.
8. If copy codes from ACL script editor and paste it into Notepad++, select Menu->Language->ACL to active ACL syntax coloring.

Final Note
--------------------
I personally use this function daily, and hope you will have as much fun coding as I do.


Extra
--------------------
2016/05/06: Added Arbutus UDL under Arubutus folder.  Arbutus, a product of Arbutus Software, is a sibling product of ACL, but not maintained.

