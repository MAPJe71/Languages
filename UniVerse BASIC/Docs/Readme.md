
# UniVerse BASIC

## Description


## Links

_WWW_

_Wiki_


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~


## Identifiers


## String Literals

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

### Single line comment

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function


## Grammar

BNF | ABNF | EBNF | XBNF
[UniVerse BASIC] ---------------------------------------------------------------
@=UniVerse BASIC

_WWW_=

_Wiki_=

Keywords=

   ABORT  ABORTE  ABORTM  ABS  ABSS  ACOS  ADDS  ALL  ALPHA  AND  ANDS  ARG.  ASCII  ASIN  ASSIGN  ASSIGNED  ATAN  AUTHORIZATION
   BCONVERT  BEFORE  BEGIN  BITAND  BITNOT  BITOR  BITRESET  BITSET  BITTEST  BITXOR  BREAK  BSCAN  BY
   CALL  CALLING  CAPTURING  CASE  CAT  CATS  CHAIN  CHANGE  CHAR  CHARS  CHECKSUM  CLEAR  CLEARCOMMON  CLEARDATA  CLEARFILE  CLEARINPUT  CLEARPROMPTS  CLEARSELECT  CLOSE  CLOSESEQ  COL1  COL2  COM  COMMIT  COMMON  COMPARE  CONTINUE  CONVERT  COS  COSH  COUNT  COUNTS  CREATE  CRT
   DATA  DATE  DCOUNT  DEBUG  DECLARE  DEFFUN  DEL  DELETE  DELETELIST  DELETEU  DIAGNOSTICS  DIM  DIMENSION  DISPLAY  DIV  DIVS  DO  DOWNCASE  DQUOTE  DTX
   EBCDIC  ECHO  ELSE  END  ENTER  EOF  EQ  EQS  EQU  EQUATE  EREPLACE  ERRMSG  ERROR  EXCHANGE  EXEC  EXECUTE  EXIT  EXP  EXTRACT
   FADD  FDIV  FFIX  FFLT  FIELD  FIELDS  FIELDSTORE  FILEINFO  FILELOCK  FILEUNLOCK  FIND  FINDSTR  FIX  FLUSH  FMT  FMTS  FMUL  FOLD  FOOTING  FOR  FORMLIST  FROM  FSUB  FUNCTION
   GARBAGECOLLECT  GCI  GE  GES  GET  GETLIST  GETREM  GETX  GO  GOSUB  GOTO  GROUP  GROUPSTORE  GT  GTS
   HEADING HEADINGE  HEADINGN  HUSH
   ICHECK  ICONV  ICONVS  IF  IFS  ILPROMPT  IN  INCLUDE  INDEX  INDEXS  INDICES  INMAT  INPUT  INPUTCLEAR  INPUTDISP  INPUTERR  INPUTIF  INPUTNULL  INPUTTRAP  INS  INSERT  INT  ISNULL  ISNULLS  ISOLATION  ITYPE
   KEY  KEYEDIT  KEYEXIT  KEYIN  KEYTRAP
   LE  LEFT  LEN  LENS  LES  LET  LEVEL  LIT  LITERALLY  LN  LOCATE  LOCK  LOCKED  LOOP  LOWER  LPTR  LT  LTS
   MAT  MATBUILD  MATCH  MATCHES  MATCHFIELD  MATPARSE  MATREAD  MATREADL  MATREADU  MATWRITE  MATWRITEU  MAXIMUM  MESSAGE  MINIMUM  MOD  MODS  MTU  MULS
   NAP  NE  NEG  NEGS  NES  NEXT  NOBUF  NO.ISOLATION  NOT  NOTS  NULL  NUM  NUMS
   OCONV  OCONVS  OFF  ON  OPEN  OPENCHECK  OPENDEV  OPENPATH  OPENSEQ  OR  ORS  OUT
   PAGE  PASSLIST  PCDRIVER  PERFORM  PRECISION  PRINT  PRINTER  PRINTERIO  PRINTERR  PROCREAD  PROCWRITE  PROG  PROGRAM  PROMPT  PWR
   QUOTE
   RAISE  RANDOMIZE  READ  READ.COMMITTED  READ.UNCOMMITTED  READBLK  READL  READLIST  READNEXT  READSEQ  READT  READU  READV  READVL  READVU  REAL  RECIO  RECORDLOCKED  RECORDLOCKL  RECORDLOCKU  RELEASE  REM  REMOVE  REPEAT  REPEATABLE.READ  REPLACE  RESET  RETURN  RETURNING  REUSE  REVREMOVE  REWIND  RIGHT  RND  ROLLBACK  RPC.CALL  RPC.CONNECT  RPC.DISCONNECT  RQM  RTNLIST
   SADD  SCMP  SDIV  SEEK  SELECT  SELECTE  SELECTINDEX  SELECTN  SELECTV  SEND  SENTENCE  SEQ  SEQS  SEQSUM  SERIALIZABLE  SET  SETREM  SETTING  SIN  SINH  SLEEP  SMUL  SOUNDEX  SPACE  SPACES  SPLICE  SQLALLOCONNECT  SQLALLOCENV  SQLALLOCSTMT  SQLBINDCOL  SQLCANCEL  SQLCOLATTRIBUTES  SQLCONNECT  SQLDESCRIBECOL  SQLDISCONNECT  SQLERROR  SQLEXECDIRECT  SQLEXECUTE  SQLFETCH  SQLFREECONNECT  SQLFREEENV  SQLFREESTMT  SQLGETCURSORNAME  SQLNUMRESULTCOLS  SQLPREPARE  SQLROWCOUNT  SQLSETCONNECT-OPTION  SQLSETCURSORNAME  SQLSETPARAM  SQRT  SQUOTE  SSELECT  SSELECTN  SSELECTV  SSUB  START  STATUS  STEP  STOP  STOPE  STOPM  STORAGE  STR  STRS  SUB  SUBR  SUBROUTINE  SUBS  SUBSTRINGS  SUM  SUMMATION  SYSTEM
   TABSTOP  TAN  TANH  TERMINFO  THEN  TIME  TIMEDATE  TIMEOUT  TO  TPARM  TPRINT  TRANS  TRANSACTION  TRIM  TRIMB  TRIMBS  TRIMF  TRIMFS  TRIMS  TTYCTL  TTYGET  TTYSET
   UNASSIGNED  UNIT  UNLOCK  UNTIL  UPCASE  USING
   WEOF  WEOFSEQ  WEOFSEQFWHILE  WORDSIZE  WORKWRITE  WRITEBLK  WRITELIST  WRITESEQ  WRITESEQF  WRITET  WRITEU  WRITEV  WRITEVU
   XLATE  XTD


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

StringLiterals=

   In UniVerse BASIC source code, character string constants are a sequence of
   ASCII characters enclosed in single or double quotation marks, or
   backslashes (\). These marks are not part of the character string value.
   The length of character string constants is limited to the length of a
   statement. Some examples of character string constants are the following:

       "Emily Daniels"
       '$42,368.99'
       'Number of Employees'
       "34 Cairo Lane"
       \"Fred's Place" isn't open\

   The beginning and terminating marks enclosing character string data must
   match. In other words, if you begin a string with a single quotation mark,
   you must end the string with a single quotation mark.

   If you use either a double or a single quotation mark within the character
   string, you must use the opposite kind to begin and end the string.
   For example, this string should be written:

       "It's a lovely day."

   And this string should be written:

       'Double quotation marks (") enclosing this string would be wrong.'

   The empty string is a special instance of character string data. It is a
   character string of zero length. Two adjacent double or single quotation
   marks, or backslashes, specify an empty string:

       '' or "" or \\

   In your source code you can use any ASCII character in character string
   constants except ASCII character 0 (NUL), which the compiler interprets as
   an end-of-string character, and ASCII character 10 (linefeed), which
   separates the logical lines of a program. Use CHAR(0) and CHAR(10) to embed
   these characters in a string constant

       \x22[^\x22\r\n]*\x22
       \x27[^\x27\r\n]*\x27
       \x5C[^\x5C\r\n]*\x5C

Comment=

   You can document your program by including optional comments that explain or
   document various parts of the program. Comments are part of the source code
   only, and are not executable. They do not affect the size of the object
   code. Comments must begin with one of the following:

       REM    *    !    $*

   Any text that appears between a comment symbol and a carriage return is
   treated as part of the comment. You cannot embed comments in a BASIC
   statement. If you want to put a comment on the same physical line as a
   statement, you must end the statement with a semicolon (;), then add the
   comment, as shown in the following example:

       IF X THEN
           A = B; REM correctly formatted comment statement
           B = C
       END

Classes_and_Methods=

Function=

   A BASIC source line has the following syntax:

       [ label ] statement [ ; statement ... ] <Return>

   You can put more than one statement on a line. Separate the statements with
   semicolons.
   A BASIC source line can begin with a statement label. It always ends with a
   carriage return (Return). It can contain up to 256 characters and can
   extend over more than one physical line.

   A statement label is a unique identifier for a program line. A statement
   label consists of a string of characters followed by a colon. If the
   statement label is completely numeric, the colon is optional. Like variable
   names, alphanumeric statement labels begin with an alphabetic character,
   and can include periods (.), dollar signs ($), and percent signs (%).

   UniVerse interprets upper- and lowercase letters are interpreted as
   different; that is, ABC and Abc are different labels. Statement labels,
   like variable names, can be as long as the length of the physical line, but
   only the first 64 characters are significant. A statement label can be put
   either in front of a BASIC statement, or on its own line. The label must be
   first on the line—that is, the label cannot begin with a space.

       (?m-i)^(?:\d+:?|[A-Za-z_][\w.$%]*:)


DEFFUN statement
Defines a user-written function

    DEFFUN function[ ( [MAT]argument[ , [MAT]argument ...] ) ]
              [CALLING call.ID]

FUNCTION statement
Identifies a user-written function.

    FUNCTION [name][ ([MAT]variable[ , [MAT]variable ...] ) ]

SUBROUTINE statement
Identifies a series of statements as a subroutine.

    SUBROUTINE [name][ ([MAT]variable[ ,[MAT]variable ... ] ) ]

END statement
Indicates the end of a program or a block of statements.

RETURN statement
Transfers program control from an internal or external subroutine back to the calling program.

    RETURN [TO statement.label]

RETURN (value) statement
Returns a value from a user-written function.

    RETURN (expression)




Grammar=

