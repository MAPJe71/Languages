      *-----------------------------------------------------------------                       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTFIXED.
      *-----------------------------------------------------------------
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
      *-----------------------------------------------------------------
       LINKAGE SECTION.
      *-----------------------------------------------------------------
       PROCEDURE DIVISION.
      *-----------------------------------------------------------------
       TEST1 *> nice section
    
       SECTION.
       TEST2 SECTION
  NPAR .
       PAR2.
       PAR3.
          exit section.
      *comment.
      *no section.
       TEST3
      * comment line
          SECTION
          PAR1.
       TEST4  SECTION  PAR1.
012345 exit-prog section.
       prog-exit section.
             exit program.
      *-----------------------------------------------------------------
