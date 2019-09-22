     **************************************
     **** Crucial OmniScript Function Data Structure Copymembers
     ****
     **************************************
     **** FUNCDEF – Function Definition
     ****
     **** AREA USED TO STORE/CREATE FUNCTION DEFINITIONS
     **** CREATED BY OCSYN, PASSED TO EACH FUNCTION
           04  FUNCDEF-HDR.
MG8182       05  FUNCDEF-ADDR-PROC-MEM    USAGE POINTER    VALUE NULLS.
AS7876       05  FUNCDEF-NAME             PIC X(28)      VALUE SPACES.
     **** A '$' CHAR IS APPENDED TO MODULE NAME TO MARK FUNCTIONS
             05  FUNCDEF-MODULE-TO-CALL   PIC X(8)       VALUE SPACES.
             05  FUNCDEF-OPERATION        PIC X(20)      VALUE SPACES.
             05  FUNCDEF-MAX-PARMS        PIC S9(4) BINARY VALUE 100.
     **** SET BY OCSYN TO # OF PARMS PASSED
             05  FUNCDEF-NUM-PARMS        PIC S9(4) BINARY VALUE ZERO.
                 88  FUNCDEF-NUM-PARMS-LESSMAX VALUE 0 THRU 99.
MG8182*      05  FUNCDEF-ADDR-PROC-MEM    USAGE POINTER    VALUE NULLS.
     **** SET BY OCSYN TO INDICATE RETURN VALUE REQUIRED
             05  FUNCDEF-RETVAL-FLAG      PIC X    VALUE 'N'.
                 88  FUNCDEF-RETVAL-FLAG-REQ           VALUE 'Y'.
                 88  FUNCDEF-RETVAL-FLAG-NA            VALUE 'N' ' '.
     *** SET BY PROC AT COMPILE TIME
             05  FUNCDEF-RETURN-TYPE      PIC X    VALUE ' '.
                 88  FUNCDEF-RETURN-TYPE-NONE      VALUE ' '.
                 88  FUNCDEF-RETURN-TYPE-NUM       VALUE 'N'.
                 88  FUNCDEF-RETURN-TYPE-TEXT      VALUE 'X'.
                 88  FUNCDEF-RETURN-TYPE-ADDR      VALUE 'A'.
     *** FIELD-ID INTO WHICH RETURN VALUE IS STORED (SET BY OCSYN)
             05  FUNCDEF-RETURN-FIELD.
                 15  FUNCDEF-RETURN-TXT PIC X(02)  VALUE SPACES.
                 15  FUNCDEF-RETURN-VAL PIC S9(4)  BINARY VALUE ZERO.
                 15  FUNCDEF-RETURN-PARM PIC XXX.
                 15  FILLER              PIC S9(4) BINARY VALUE ZERO.
             05  FUNCDEF-HELD-DATA-LENG PIC S9(4) BINARY VALUE ZERO.
     *** SET IF 'TRACE:1' IS INCLUDED AS PROC PARAMETER
             05  FUNCDEF-TRACE-FLG      PIC X        VALUE LOW-VALUES.
                 88  FUNCDEF-TRACE-FLG-YES VALUE 'Y'.
AS7876       05  FILLER                 PIC X(50)    VALUE LOW-VALUES.
           04  FUNCDEF-PARMS-AREA.
             05  FUNCDEF-PARM-AREA.
                 10  FUNCDEF-PARM-ENTRY OCCURS 0 TO 100 TIMES
                        DEPENDING ON FUNCDEF-NUM-PARMS.
                     15  FUNCDEF-PARM-LABEL     PIC X(20).
                     15  FUNCDEF-PARM-FIELD.
                         20  FUNCDEF-PARM-TXT   PIC X(02).
                         20  FUNCDEF-PARM-VAL   PIC S9(11)V9(6) COMP-3.
                         20  FUNCDEF-PARM-PARM  PIC XXX.
                     15  FUNCDEF-PARM-TYPE        PIC X.
                         88  FUNCDEF-PARM-TYPE-NUM         VALUE 'N'.
                         88  FUNCDEF-PARM-TYPE-TEXT        VALUE 'X'.
                     15  FUNCDEF-PARM-BIND        PIC X.
                         88  FUNCDEF-PARM-BIND-DE          VALUE 'D'.
                         88  FUNCDEF-PARM-BIND-LIT         VALUE 'L'.
     **** SET FOLLOWING FLAG TO SUPPRESS FUNCVAL FETCH OF VALUE
                     15  FUNCDEF-PARM-FETCH       PIC X.
                         88  FUNCDEF-PARM-FETCH-NO         VALUE 'N'.
                     15  FILLER             PIC X(04).
     **************************************
     **** FUNCVAL – Function Value
     ****
     **** AREA USED TO STORE/RETURN FUNCTION PARAMETER VALUES
     **** CREATED BY OCEMN, PASSED TO EACH FUNCTION
     **** CORRESPONDS TO FUNCDEF COPYMEMBER
             05  FUNCVAL-HDR.
                 10  FUNCVAL-RETURN-VAL    PIC S9(11)V9(6) COMP-3.
                 10  FUNCVAL-RETURN-STRING.
                    15  FUNCVAL-RETURN-LENG PIC S9(4) BINARY VALUE ZERO.
                    15  FUNCVAL-RETURN-VAL-X PIC X(200) VALUE SPACES.
AS7876           10  FILLER                PIC X(50)  VALUE LOW-VALUES.
             05  FUNCVAL-PARM-AREA.
                 10  FUNCVAL-PARM-ENTRY OCCURS 0 TO 100 TIMES
                        DEPENDING ON FUNCDEF-NUM-PARMS.
                     15  FUNCVAL-PARM-VAL       PIC S9(11)V9(6) COMP-3.
                     15  FUNCVAL-PARM-STRING.
                         20  FUNCVAL-PARM-LENG   PIC S9(4) BINARY.
                         20  FUNCVAL-PARM-VAL-X  PIC X(200).
     **** SET TO 'Y' TO REQUEST UPDATE OF THE FIELD
                     15  FUNCVAL-PARM-UPDATED   PIC X.
                         88  FUNCVAL-PARM-UPDATE-REQ   VALUE 'Y'.
                         88  FUNCVAL-PARM-UPDATED-YES   VALUE 'Y'.
                     15  FILLER                 PIC X(05).
     **************************************
     **** FuncIA – Function Interface Area
     ****
MG8182** FOLLOWING FIELD SET BY OCSYN TO INDICATE RETURN VALUE REQUIRED
MG8182** I.E. INVOKED AS A PROCEDURE OR AS A FUNCTION
MG8182     05  FUNCIA-ADDR-OCIA         USAGE POINTER  VALUE NULLS.
     **** AREA USED TO INVOKE OMNIPLUS FUNCTIONS
     **** CREATED BY OCSYN, PASSED TO EACH FUNCTION
           05  FUNCIA-OPER              PIC XXXX         VALUE SPACES.
               88  FUNCIA-OPER-COMPILE  VALUE 'CMPL'.
               88  FUNCIA-OPER-EXECUTE  VALUE 'EXEC'.
               88  FUNCIA-OPER-HELP     VALUE 'HELP'.
           05  FILLER                   PIC X            VALUE SPACES.
     ***
     ***   05  FUNCIA-ERROR             PIC X            VALUE SPACES.
     ***       88  FUNCIA-ERROR-YES     VALUE 'Y'.
     ***       88  FUNCIA-ERROR-NO      VALUE 'N'.
     ***  SET ERROR-MSG TO NON-BLANK TO INDICATE AN ERROR
RK8873     05  FUNCIA-MSG-AREA.
RK8873         10  FUNCIA-MSG-ID        PIC X(07)        VALUE SPACES.
RK8873         10  FUNCIA-MSG-PARMS.
RK8873             15  FUNCIA-ERROR-MSG PIC X(80) VALUE SPACES.
RK8873             15  FILLER           PIC X(20) VALUE SPACES.
MG8182** FOLLOWING FIELD SET BY OCSYN TO INDICATE RETURN VALUE REQUIRED
MG8182** I.E. INVOKED AS A PROCEDURE OR AS A FUNCTION
MG8182*    05  FUNCIA-ADDR-OCIA         USAGE POINTER  VALUE NULLS.
     *** -RET-CODE USED BY SOME ROUTINES (E.G. EACH);  (IS SD100)
     ***   >0 MEANS INCOMPLETE RESULTS (E.G. EOF FOR EACH ROUTINES).
           05  FUNCIA-RETURN-CODE       PIC S9(4) BINARY VALUE ZERO.
               88  FUNCIA-RETURN-CODE-NA      VALUE ZERO.
               88  FUNCIA-RETURN-CODE-WARN    VALUE 4.
               88  FUNCIA-RETURN-CODE-ERR     VALUE 8.
W16432         88  FUNCIA-RETURN-CODE-NOEXEC  VALUE 1.
     ***   FOLLOWING IS RETURNED MSG FROM PREV PROC CALL  (IS SD101)
           05  FUNCIA-RETURN-MSG        PIC X(40) VALUE SPACES.
     ***   SET TO LOOP ITERATION COUNT, STARTS AT ZERO.
           05  FUNCIA-LOOP-CTR          PIC S9(8)  BINARY VALUE ZERO.
           05  FILLER                   PIC X(06) VALUE LOW-VALUES.
           05  FUNCIA-MSG-CTR           PIC S9(4) BINARY VALUE ZERO.
               88  FUNCIA-MSG-CTR-NOTFULL VALUE 0 THRU 5.
           05  FUNCIA-MSG-ENTRY      OCCURS 5 TIMES PIC X(60).
AS7876     05  FILLER                   PIC X(100)       VALUE SPACES.
     **************************************
     **** NOTES RE CODING PROCS/FUNCTIONS
     ***   . PROCS DO NOT RETURN A VALUE
     ***      EXAMPLE: WK1=0; LOGMSG('PARTIC VAL = ZERO');
     ***   . FUNCTIONS RETURN A VALUE
     ***      EXAMPLE: WK1=0; TX1=STRING('PT VAL = ' PIC(WK1,'CASH'));
     ***
     ***   FOR OPER-COMPILE, PROCS/FUNCTIONS ARE RESPONSIBLE FOR:
     ***     1) DETECTING PARAMETER ERRORS
     ***        - INVALID/UNKNOWN/MISSING LABELS,
     ***        - INVALID PARAMETER TYPE
     ***        - INVALID PARAMETER VALUES (FOR LITERALS)
     ***     2) SETTING RETTYP TO THEIR RETURN VALUE TYPE
     ***     3) SETTING ERROR, ERROR-MSG FOR PROBLEMS
     ***     4) IF THE FUNCTION ONLY MAKES SENSE IF A VALUE IS
     ***        RETURNED (E.G. GETDATE()), GENERATE THE ERROR
     ***        "CANNOT RETURN A VALUE AS INVOKED"
     ***
     ***   FOR OPER-EXECUTE, PROCS/FUNCTIONS ARE RESPONSIBLE FOR:
     ***     1) PROCESSING THEIR SUPPLIED PARAMETERS
     ***        . CALLING 'OCFETCH' TO FETCH EACH FIELD
     ***     2) CALLING 'OCSTOR' TO UPDATE PARAMETERS
     ***     3) CALLING 'OCSTOR' TO UPDATE THE RETURNED VALUE
     ***        (IF FUNC-RETURN-FIELD IS CODED)
     **************************************
