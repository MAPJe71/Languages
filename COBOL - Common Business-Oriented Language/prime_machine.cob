*>******************************************************************************
*>  prime_machine.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  prime_machine.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with prime_machine.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      prime_machine.cob
*>
*> Purpose:      This example implements Conway's prime algorithm
*>               as a state machine: http://en.wikipedia.org/wiki/FRACTRAN
*>               This algorithm is very slow, but it uses only ADD and SUBTRACT.
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.09.14
*>
*> Tectonics:    cobc -x -free prime_machine.cob
*>
*> Usage:        ./prime_machine
*>
*>******************************************************************************
*> Date       Change description
*> ========== ==================================================================
*> 2014.09.14 First version.
*> 2014.26.14 sf-mensch: use FILLER instead of multiple SCREEN-REG0, using lvl78
*>            for identical lenghts to simplify changes, use screenio.cpy,
*>            reduce REG-SIZE to 36 for enabling use of OpenCOBOL/GnuCOBOL 1.1,
*>            grouped ADD and SUBTRACT and added terminators (compiles with -W)
*> 2017.10.16 License changed to GNU LGPL.
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. prime_machine.
*>   AUTHOR. Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
*> REPOSITORY.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> registers
 78 REG-SIZE                           VALUE 36.
 78 REG-SIZE-M1                        VALUE 35.
*>
 01 REG0                               PIC 9(REG-SIZE).
 01 REG1                               PIC 9(REG-SIZE).
 01 REG2                               PIC 9(REG-SIZE).
 01 REG3                               PIC 9(REG-SIZE).
 01 REG4                               PIC 9(REG-SIZE).
 01 REG5                               PIC 9(REG-SIZE).
 01 REG6                               PIC 9(REG-SIZE).
 01 REG7                               PIC 9(REG-SIZE).
 01 REG8                               PIC 9(REG-SIZE).
 01 REG9                               PIC 9(REG-SIZE).

*> colors
 copy screenio.

*> screen attributes
 78 START-COL-TITLE                    VALUE 13.
 78 START-COL-DATA                     VALUE 20.

 SCREEN SECTION.
 01 HEADER-SCREEN.
    05 FILLER LINE 3 COLUMN START-COL-TITLE
       VALUE "Conway's prime algorithm as a state machine"
       FOREGROUND-COLOR COB-COLOR-GREEN.

 01 REG-SCREEN.
    05 FILLER LINE 6 COLUMN START-COL-TITLE    VALUE "REG0:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG0
              LINE 6 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE 7 COLUMN START-COL-TITLE    VALUE "REG1:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG1
              LINE 7 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE 8 COLUMN START-COL-TITLE    VALUE "REG2:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG2
              LINE 8 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE 9 COLUMN START-COL-TITLE    VALUE "REG3:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG3
              LINE 9 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE 10 COLUMN START-COL-TITLE   VALUE "REG4:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG4
              LINE 10 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE 11 COLUMN START-COL-TITLE   VALUE "REG5:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG5
              LINE 11 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE 12 COLUMN START-COL-TITLE   VALUE "REG6:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG6
              LINE 12 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE 13 COLUMN START-COL-TITLE   VALUE "REG7:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG7
              LINE 13 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE 14 COLUMN START-COL-TITLE  VALUE "REG8:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG8
              LINE 14 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE 15 COLUMN START-COL-TITLE  VALUE "REG9:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG9
              LINE 15 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.

 01 PRIME-SCREEN.
    05 FILLER LINE 18 COLUMN START-COL-TITLE  VALUE "REG0:"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER PIC Z(REG-SIZE-M1)9 USING REG0
              LINE 18 COLUMN START-COL-DATA
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER LINE 18 COLUMN PLUS 2           VALUE "(this is a prime)"
              FOREGROUND-COLOR COB-COLOR-GREEN.
    05 FILLER LINE 21 COLUMN START-COL-TITLE
              VALUE "If the registers REG1 - REG9 are zeros, then REG0 is a prime."
              FOREGROUND-COLOR COB-COLOR-GREEN.

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-PRIME SECTION.
*>------------------------------------------------------------------------------

    DISPLAY HEADER-SCREEN END-DISPLAY

*>  start value
    MOVE 1 TO REG0

    PERFORM FOREVER
       EVALUATE TRUE
*>        state 01
          WHEN (REG3 > ZEROES) AND (REG5 > ZEROES)
             ADD      1 TO   REG6             END-ADD
             SUBTRACT 1 FROM REG3, REG5       END-SUBTRACT

*>        state 02
          WHEN (REG2 > ZEROES) AND (REG6 > ZEROES)
             ADD      1 TO   REG0, REG1, REG5 END-ADD
             SUBTRACT 1 FROM REG2, REG6       END-SUBTRACT

*>        state 03
          WHEN (REG1 > ZEROES) AND (REG6 > ZEROES)
             ADD      1 TO   REG7             END-ADD
             SUBTRACT 1 FROM REG1, REG6       END-SUBTRACT 

*>        state 04
          WHEN (REG0 > ZEROES) AND (REG7 > ZEROES)
             ADD      1 TO   REG8             END-ADD
             SUBTRACT 1 FROM REG0, REG7       END-SUBTRACT

*>        state 05
          WHEN (REG1 > ZEROES) AND (REG4 > ZEROES)
             ADD      1 TO   REG9             END-ADD
             SUBTRACT 1 FROM REG1, REG4       END-SUBTRACT

*>        state 06
          WHEN (REG9 > ZEROES)
             ADD      1 TO   REG3, REG4       END-ADD
             SUBTRACT 1 FROM REG9             END-SUBTRACT

*>        state 07
          WHEN (REG8 > ZEROES)
             ADD      1 TO   REG2, REG7       END-ADD
             SUBTRACT 1 FROM REG8             END-SUBTRACT

*>        state 08
          WHEN (REG7 > ZEROES)
             ADD      1 TO   REG3, REG4       END-ADD
             SUBTRACT 1 FROM REG7             END-SUBTRACT

*>        state 09
          WHEN (REG6 > ZEROES)
             SUBTRACT 1 FROM REG6             END-SUBTRACT

*>        state 10
          WHEN (REG5 > ZEROES)
             ADD      1 TO   REG4             END-ADD
             SUBTRACT 1 FROM REG5             END-SUBTRACT

*>        state 11
          WHEN (REG4 > ZEROES)
             ADD      1 TO   REG5             END-ADD
             SUBTRACT 1 FROM REG4             END-SUBTRACT

*>        state 12
          WHEN (REG0 > ZEROES) AND (REG3 > ZEROES)
             ADD      1 TO   REG1, REG2       END-ADD
             SUBTRACT 1 FROM REG0, REG3       END-SUBTRACT

*>        state 13
          WHEN (REG0 > ZEROES)
             ADD      1 TO   REG1, REG2       END-ADD
             SUBTRACT 1 FROM REG0             END-SUBTRACT

*>        state 14
          WHEN OTHER
             ADD      1 TO   REG2, REG4       END-ADD
       END-EVALUATE

       DISPLAY REG-SCREEN END-DISPLAY

*>     If the registers REG1 - REG9 are zeroes, then REG0 is a prime
       IF  REG1 = ZEROES
       AND REG2 = ZEROES
       AND REG3 = ZEROES
       AND REG4 = ZEROES
       AND REG5 = ZEROES
       AND REG6 = ZEROES
       AND REG7 = ZEROES
       AND REG8 = ZEROES
       AND REG9 = ZEROES
       THEN
          DISPLAY PRIME-SCREEN END-DISPLAY
       END-IF
    END-PERFORM

    STOP RUN

    .
 MAIN-PRIME-EX.
    EXIT.
 END PROGRAM prime_machine.
