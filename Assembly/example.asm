; Assemble options needed: none

       .286

       INCLUDELIB os2.lib
       INCLUDE os2.inc

DGROUP GROUP _DATA

STACK  SEGMENT PARA STACK 'STACK'     ;stack segment declared
       WORD   256 dup(?)
STACK  ENDS

_DATA      SEGMENT WORD PUBLIC 'DATA'     ;data segment declared
message    BYTE  "Hello World", 13,10
bytecount  DW ?
_DATA      ENDS

_TEXT  SEGMENT WORD PUBLIC 'CODE'     ;code segment declared
       ASSUME   CS:_TEXT, DS:_DATA, SS:STACK

@Startup:

       INVOKE DosWrite, 1, ADDR message, LENGTHOF message
                           ADDR bytecount

       ;Code generated by INVOKE
       ;------------------------
       ;   push   1                   ;output to Stdout
       ;   push   ds                  ;pass address of msg
       ;   push   OFFSET message
       ;   push   LENGTHOF message    ;pass length of msg
       ;   push   ds
       ;   push   OFFSET bytecount    ;pass address of count
       ;   call   DosWrite

       INVOKE   DosExit,+1h, +0h

       ;Code generated by INVOKE
       ;------------------------
       ;   push   +1h                 ;Ends all threads
       ;   push   +0h                 ;Pass 0 return code
       ;   call   DosExit

_TEXT  ENDS
       END @Startup
