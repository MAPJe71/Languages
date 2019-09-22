*>-----------------------------------------------------------------                       
 IDENTIFICATION DIVISION.
 PROGRAM-ID. TESTFREE.
*>-----------------------------------------------------------------
 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 SPECIAL-NAMES. DECIMAL-POINT IS COMMA
                CONSOLE IS CRT
                .
 INPUT-OUTPUT SECTION.
 FILE-CONTROL.
 DATA DIVISION.
 FILE SECTION.
 WORKING-STORAGE SECTION.
*>-----------------------------------------------------------------
 LINKAGE SECTION.
*>-----------------------------------------------------------------
 PROCEDURE DIVISION.
*>-----------------------------------------------------------------
TEST1
SECTION
. *> some comment   
TEST2 SECTION 
 .
 PAR2.
 PAR3.
  exit section.
*>a comment.
*>no section.
TEST3
SECTION
PAR1.
TEST4 SECTION PAR1.
exit-prog section.
prog-exit section.
  exit program.
*>-----------------------------------------------------------------
