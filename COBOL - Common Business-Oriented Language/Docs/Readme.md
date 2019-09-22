
# COBOL

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
[COBOL] ------------------------------------------------------------------------
@=COmmon Business-Oriented Language

_WWW_=

_Wiki_=

Keywords=

   COBOL '74 Reserved Words

       ACCEPT | ACCESS | ADD | ADVANCING | AFTER | ALL | ALPHABETIC | ALSO | ALTER | ALTERNATE | AND | ARE | AREA | AREAS | ASCENDING | ASSIGN | AT | AUTHOR
        | BEFORE | BLANK | BLOCK | BOTTOM | BY
        | CALL | CANCEL | CD | CF | CH | CHARACTER | CHARACTERS | CLOCK-UNITS | CLOSE | COBOL | CODE | CODE-SET | COLLATING | COLUMN | COMMA | COMMUNICATION | COMP | COMPUTATIONAL | COMPUTE | CONFIGURATION | CONTAINS | CONTROL | CONTROLS | COPY | CORR | CORRESPONDING | COUNT | CURRENCY
        | DATA | DATE | DATE-COMPILED | DATE-WRITTEN | DAY | DE | DEBUG-CONTENTS | DEBUG-ITEM | DEBUG-LINE | DEBUG-NAME | DEBUG-SUB-1 | DEBUG-SUB-2 | DEBUG-SUB-3 | DEBUGGING | DECIMAL-POINT | DECLARATIVES | DELETE | DELIMITED | DELIMITER | DEPENDING | DESCENDING | DESTINATION | DETAIL | DISABLE | DISPLAY | DIVIDE | DIVISION | DOWN | DUPLICATES | DYNAMIC
        | EGI | ELSE | EMI | ENABLE | END | END-OF-PAGE | ENTER | ENVIRONMENT | EOP | EQUAL | ERROR | ESI | EVERY | EXCEPTION | EXIT | EXTEND
        | FD | FILE | FILE-CONTROL | FILLER | FINAL | FIRST | FOOTING | FOR | FROM
        | GENERATE | GIVING | GO | GREATER | GROUP
        | HEADING | HIGH-VALUE | HIGH-VALUES
        | I-O | I-O-CONTROL | IDENTIFICATION | IF | IN | INDEX | INDEXED | INDICATE | INITIAL | INITIATE | INPUT | INPUT-OUTPUT | INSPECT | INSTALLATION | INTO | INVALID
        | JUST | JUSTIFIED
        | KEY
        | LABEL | LAST | LEADING | LEFT | LENGTH | LESS | LIMIT | LIMITS | LINAGE | LINAGE-COUNTER | LINE | LINE-COUNTER | LINES | LINKAGE | LOCK | LOW-VALUE | LOW-VALUES
        | MEMORY | MERGE | MESSAGE | MODE | MODULES | MOVE | MULTIPLE | MULTIPLY
        | NATIVE | NEGATIVE | NEXT | NO | NOT | NUMBER | NUMERIC
        | OBJECT-COMPUTER | OCCURS | OF | OFF | OMITTED | ON | OPEN | OPTIONAL | OR | ORGANIZATION | OUTPUT | OVERFLOW
        | PAGE | PAGE-COUNTER | PERFORM | PF | PH | PIC | PICTURE | PLUS | POINTER | POSITION | POSITIVE | PRINTING | PROCEDURE | PROCEDURES | PROCEED | PROGRAM | PROGRAM-ID
        | QUEUE | QUOTE | QUOTES
        | RANDOM | RD | READ | RECEIVE | RECORD | RECORDS | REDEFINES | REEL | REFERENCES | RELATIVE | RELEASE | REMAINDER | REMOVAL | RENAMES | REPLACING | REPORT | REPORTING | REPORTS | RERUN | RESERVE | RETURN | REVERSED | REWIND | REWRITE | RF | RH | RIGHT | ROUNDED | RUN
        | SAME | SD | SEARCH | SECTION | SECURITY | SEGMENT | SEGMENT-LIMIT | SELECT | SEND | SENTENCE | SEPARATE | SEQUENCE | SEQUENTIAL | SET | SIGN | SIZE | SORT | SORT-MERGE | SOURCE | SOURCE-COMPUTER | SPACE | SPACES | SPECIAL-NAMES | STANDARD | STANDARD-1 | START | STATUS | STOP | STRING | SUB-QUEUE-1 | SUB-QUEUE-2 | SUB-QUEUE-3 | SUBTRACT | SUM | SUPPRESS | SYMBOLIC | SYNC | SYNCHRONIZED
        | TALLYING | TAPE | TERMINAL | TERMINATE | TEXT | THAN | THROUGH | THRU | TIME | TIMES | TO | TOP | TRAILING | TYPE
        | UNIT | UNSTRING | UNTIL | UP | UPON | USAGE | USE | USING
        | VALUE | VALUES | VARYING
        | WHEN | WITH | WORDS | WORKING-STORAGE | WRITE
        | ZERO | ZEROES | ZEROS


   COBOL '85 Reserved Words

       ACCEPT | ACCESS | ADD | ADVANCING | AFTER | ALL | ALPHABET | ALPHABETIC | ALPHABETIC-LOWER | ALPHABETIC-UPPER | ALPHANUMERIC | ALPHANUMERIC-EDITED | ALSO | ALTER | ALTERNATE | AND | ANY | ARE | AREA | AREAS | ASCENDING | ASSIGN | AT | AUTHOR
        | BEFORE | BINARY | BLANK | BLOCK | BOTTOM | BY
        | CALL | CANCEL | CD | CF | CH | CHARACTER | CHARACTERS | CLASS | CLOCK-UNITS | CLOSE | COBOL | CODE | CODE-SET | COLLATING | COLUMN | COMMA | COMMON | COMMUNICATION | COMP | COMPUTATIONAL | COMPUTE | CONFIGURATION | CONTAINS | CONTENT | CONTINUE | CONTROL | CONTROLS | CONVERTING | COPY | CORR | CORRESPONDING | COUNT | CURRENCY
        | DATA | DATE | DATE-COMPILED | DATE-WRITTEN | DAY | DAY-OF-WEEK | DE | DEBUG-CONTENTS | DEBUG-ITEM | DEBUG-LINE | DEBUG-NAME | DEBUG-SUB-1 | DEBUG-SUB-2 | DEBUG-SUB-3 | DEBUGGING | DECIMAL-POINT | DECLARATIVES | DELETE | DELIMITED | DELIMITER | DEPENDING | DESCENDING | DESTINATION | DETAIL | DISABLE | DISPLAY | DIVIDE | DIVISION | DOWN | DUPLICATES | DYNAMIC
        | EGI | ELSE | EMI | ENABLE | END | END-ADD | END-CALL | END-COMPUTE | END-DELETE | END-DIVIDE | END-EVALUATE | END-IF | END-MULTIPLY | END-OF-PAGE | END-PERFORM | END-READ | END-RECEIVE | END-RETURN | END-REWRITE | END-SEARCH | END-START | END-STRING | END-SUBTRACT | END-UNSTRING | END-WRITE | ENTER | ENVIRONMENT | EOP | EQUAL | ERROR | ESI | EVALUATE | EVERY | EXCEPTION | EXIT | EXTEND | EXTERNAL
        | FALSE | FD | FILE | FILE-CONTROL | FILLER | FINAL | FIRST | FOOTING | FOR | FROM | FUNCTION
        | GENERATE | GIVING | GLOBAL | GO | GREATER | GROUP
        | HEADING | HIGH-VALUE | HIGH-VALUES
        | I-O | I-O-CONTROL | IDENTIFICATION | IF | IN | INDEX | INDEXED | INDICATE | INITIAL | INITIALIZE | INITIATE | INPUT | INPUT-OUTPUT | INSPECT | INSTALLATION | INTO | INVALID
        | JUST | JUSTIFIED
        | KEY
        | LABEL | LAST | LEADING | LEFT | LENGTH | LESS | LIMIT | LIMITS | LINAGE | LINAGE-COUNTER | LINE | LINE-COUNTER | LINES | LINKAGE | LOCK | LOW-VALUE | LOW-VALUES
        | MEMORY | MERGE | MESSAGE | MODE | MODULES | MOVE | MULTIPLE | MULTIPLY
        | NATIVE | NEGATIVE | NEXT | NO | NOT | NUMBER | NUMERIC | NUMERIC-EDITED
        | OBJECT-COMPUTER | OCCURS | OF | OFF | OMITTED | ON | OPEN | OPTIONAL | OR | ORDER | ORGANIZATION | OTHER | OUTPUT | OVERFLOW
        | PACKED-DECIMAL | PADDING | PAGE | PAGE-COUNTER | PERFORM | PF | PH | PIC | PICTURE | PLUS | POINTER | POSITION | POSITIVE | PRINTING | PROCEDURE | PROCEDURES | PROCEED | PROGRAM | PROGRAM-ID | PURGE
        | QUEUE | QUOTE | QUOTES
        | RANDOM | RD | READ | RECEIVE | RECORD | RECORDS | REDEFINES | REEL | REFERENCE | REFERENCES | RELATIVE | RELEASE | REMAINDER | REMOVAL | RENAMES | REPLACE | REPLACING | REPORT | REPORTING | REPORTS | RERUN | RESERVE | RETURN | REVERSED | REWIND | REWRITE | RF | RH | RIGHT | ROUNDED | RUN
        | SAME | SD | SEARCH | SECTION | SECURITY | SEGMENT | SEGMENT-LIMIT | SELECT | SEND | SENTENCE | SEPARATE | SEQUENCE | SEQUENTIAL | SET | SIGN | SIZE | SORT | SORT-MERGE | SOURCE | SOURCE-COMPUTER | SPACE | SPACES | SPECIAL-NAMES | STANDARD | STANDARD-1 | STANDARD-2 | START | STATUS | STOP | STRING | SUB-QUEUE-1 | SUB-QUEUE-2 | SUB-QUEUE-3 | SUBTRACT | SUM | SUPPRESS | SYMBOLIC | SYNC | SYNCHRONIZED
        | TALLYING | TAPE | TERMINAL | TERMINATE | TEST | TEXT | THAN | THEN | THROUGH | THRU | TIME | TIMES | TO | TOP | TRAILING | TRUE | TYPE
        | UNIT | UNSTRING | UNTIL | UP | UPON | USAGE | USE | USING
        | VALUE | VALUES | VARYING
        | WHEN | WITH | WORDS | WORKING-STORAGE | WRITE
        | ZERO | ZEROES | ZEROS


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=[A-Za-z][\w\-]*[A-Za-z0-9]

   IdentifierBegChars:     A..Z a..z / + < <= = > >=
   IdentifierChars:        A..Z a..z _ 0..9 -          i.e. "[\w\-]"

   Cobol 85
   IdentifierBegChars:     A..Z a..z _%@. ?            i.e. "[A-Za-z_%@.?]"
   IdentifierChars:        A..Z a..z _ 0..9 ? -        i.e. "[\w?\-]"

   COBOL words must be character-strings from the set of letters, digits,
   the hyphen, and the underscore. The hyphen and the underscore cannot
   appear as the first or last character, however.

   A word must conform the following rules:
   1.  The total number of characters must not be greater than 30;
   2.  One of the characters must be a letter;
   3.  A word can not begin or end with a hyphen;
   4.  A word must not contain a blank and any special character except a hyphen;
   5.  A word should not be a reserved word.

   A COBOL word can be either a user-defined or a reserved word.

StringLiterals=

Comment="(?'SLC'(?m-s)(?:^[^\r\n]{6}\*|\*&gt;).*$)"

Classes_and_Methods=

Function=

     <!-- Variant for COBOL fixed-form reference format -->
     <parser
         id="cobol_fixedform_syntax" displayName="COBOL fixed-form reference format">
       <function
           mainExpr   ="(?m-s)^.{6}[ D][\t ]{0,3}(?!exit\s)[\w\-]+(\.|((?'seps'([\t ]|\*&gt;.*|([\n\r]+(.{6}([ D]|\*.*)|.{0,6}$)))+)section(\.|((?&amp;seps)(\.|[\w\-]+\.)))))"
           displayMode="$functionName">
         <functionName>
           <nameExpr expr="[\w\-]+((?=\.)|((?'seps'([\t ]|\*&gt;.*|([\n\r]+(.{6}([ D]|\*.*)|.{0,6}$)))+)section((?=\.)|(?&amp;seps)((?=\.)|[\w\-]+(?=\.)))))"/>
         </functionName>
       </function>
     </parser>

     <!-- Variant for COBOL fixed-form reference format -->
     <parser
         id="cobol_fixedform_syntax" displayName="COBOL fixed-form reference format"
         commentExpr="(?'SLC'(?m-s)(?:^[\d\t ]{6}\*|\*&gt;).*$)">
       <function
           mainExpr   ="(?m-s)^.{6}[ D][\t ]{0,3}(?!exit\s)[\w\-]+(\.|((?'seps'([\t ]|([\n\r]+(.{6}[ D]|.{0,6}$)))+)section(\.|(?&amp;seps)(\.|[\w\-]+\.))))"
           displayMode="$functionName">
         <functionName>
           <nameExpr expr="[\w\-]+((?=\.)|((?'seps'([\t ]|([\n\r]+(.{6}[ D]|.{0,6}$)))+)section((?=\.)|(?&amp;seps)((?=\.)|[\w\-]+(?=\.)))))"/>
         </functionName>
       </function>
     </parser>

     <!-- Variant for COBOL free-form reference format -->
     <parser
         id="cobol_freeform_syntax" displayName="COBOL free-form reference format">
         commentExpr="(?'SLC'(?m-s)\*&gt;.*$)">
       <!-- Variant without paragraphs (works with comment lines before section header) -->
       <function
           mainExpr="[\s\.](?!exit\s)[\w\-]+\s+section(\s*|(\s+[\w\-]+)?)(?=\.)"
           displayMode="$functionName">
         <functionName>
           <nameExpr expr="[\w\-]+\s*section"/>
         </functionName>
       </function>
     </parser>

     <!-- Variant for COBOL free-form reference format -->
     <parser
         id="cobol_freeform_syntax" displayName="COBOL free-form reference format"
         commentExpr="(?'SLC'(?m-s)\*&gt;.*$)">
       <!-- Variant with paragraphs (don't work with comment lines before section/paragraph header -->
       <function
           mainExpr="(?m-s)(?<=\.)\s*(?!exit\s)[\w\-]+(\s+section(\s*|(\s+[\w\-]+)?))(?=\.)"
           displayMode="$functionName">
         <functionName>
           <nameExpr expr="(?<=[\s\.])[\w\-]+(\s*section\s*([\w\-]+)?)?"/>
         </functionName>
       </function>
     </parser>

Grammar=
   In fixed-format, code must be aligned to fit in certain areas.

   Until COBOL 2002, these were:
   Name                    Column(s)   Usage
   Sequence number area    1-6         Originally used for card/line numbers, this
                                       area is ignored by the compiler
   Indicator area          7           The following characters are allowed here:
                                       * – a comment line
                                       / – a comment line which will be printed on
                                               a new page of a source listing
                                       - – a continuation line where words or
                                               literals from the previous line
                                               are continued
                                       D – a line enabled in debugging mode, which
                                               is otherwise ignored
   Area A                  8-11        This contains: DIVISION, SECTION and procedure
                                       headers; 01 and 77 level numbers and
                                       file/report descriptors
   Area B                  12-72       Any other code not allowed in Area A
   Program name area       73–         Historically up to column 80 for punched cards,
                                       it is used to identify the program or sequence
                                       the card belongs to

   In COBOL 2002, Areas A and B were merged and extended to column 255.
   Also, the program name area was removed.

   COBOL 2002 also introduced free-format code. Free-format code can be placed in
   any column of the file, like in newer languages such as C and Pascal.
   Comments are specified using *> which can be placed anywhere and can also
   be used in fixed-format source code.
   Continuation lines are not present and the >>PAGE directive replaces the / indicator.


