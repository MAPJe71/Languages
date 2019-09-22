      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST.
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
       TEST1 SECTION.  *> inline comment
       TEST2 SECTION PAR1.
       PAR2.
          exit section.
      *comment.
      *no section.
       TEST3
          SECTION
          PAR1.
       exit-prog section.
             exit program.
      *-----------------------------------------------------------------
