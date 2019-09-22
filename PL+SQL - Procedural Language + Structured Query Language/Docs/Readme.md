
# PL/SQL

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
[PL/SQL] -----------------------------------------------------------------------
@=Procedural Language/Structured Query Language

_WWW_=http://www.oracle.com/technetwork/database/features/plsql/index.html

_Wiki_=https://en.wikipedia.org/wiki/PL/SQL

Keywords=

   Both reserved words and keywords have special meaning in PL/SQL. The
   difference between reserved words and keywords is that you cannot use
   reserved words as identifiers. You can use keywords as as identifiers, but
   it is not recommended.

   Reserved Words
   
       ALL, ALTER, AND, ANY, AS, ASC, AT
       BEGIN, BETWEEN, BY
       CASE, CHECK, CLUSTER, CLUSTERS, COLAUTH, COLUMNS, COMPRESS, CONNECT, CRASH, CREATE, CURRENT
       DECLARE, DEFAULT, DELETE, DESC, DISTINCT, DROP
       ELSE, END, EXCEPTION, EXCLUSIVE, EXISTS
       FETCH, FOR, FROM
       GOTO, GRANT, GROUP
       HAVING
       IDENTIFIED, IF, IN, INDEX, INDEXES, INSERT, INTERSECT, INTO, IS
       LIKE, LOCK
       MINUS, MODE
       NOCOMPRESS, NOT, NOWAIT, NULL
       OF, ON, OPTION, OR, ORDER, OVERLAPS
       PRIOR, PROCEDURE, PUBLIC
       RESOURCE, REVOKE
       SELECT, SHARE, SIZE, SQL, START
       TABAUTH, TABLE, THEN, TO
       UNION, UNIQUE, UPDATE
       VALUES, VIEW, VIEWS
       WHEN, WHERE, WITH
   
   Keywords
   
       A, ADD, AGENT, AGGREGATE, ARRAY, ATTRIBUTE, AUTHID, AVG
       BFILE_BASE, BINARY, BLOB_BASE, BLOCK, BODY, BOTH, BOUND, BULK, BYTE
       C, CALL, CALLING, CASCADE, CHAR, CHAR_BASE, CHARACTER, CHARSETFORM, CHARSETID, CHARSET, CLOB_BASE, CLOSE, COLLECT, COMMENT, COMMIT, COMMITTED, COMPILED, CONSTANT, CONSTRUCTOR, CONTEXT, CONTINUE, CONVERT, COUNT, CURSOR, CUSTOMDATUM
       DANGLING, DATA, DATE, DATE_BASE, DAY, DEFINE, DETERMINISTIC, DOUBLE, DURATION
       ELEMENT, ELSIF, EMPTY, ESCAPE, EXCEPT, EXCEPTIONS, EXECUTE, EXIT, EXTERNAL
       FINAL, FIXED, FLOAT, FORALL, FORCE, FUNCTION
       GENERAL
       HASH, HEAP, HIDDEN, HOUR
       IMMEDIATE, INCLUDING, INDICATOR, INDICES, INFINITE, INSTANTIABLE, INT, INTERFACE, INTERVAL, INVALIDATE, ISOLATION
       JAVA
       LANGUAGE, LARGE, LEADING, LENGTH, LEVEL, LIBRARY, LIKE2, LIKE4, LIKEC, LIMIT, LIMITED, LOCAL, LONG, LOOP
       MAP, MAX, MAXLEN, MEMBER, MERGE, MIN, MINUTE, MOD, MODIFY, MONTH, MULTISET
       NAME, NAN, NATIONAL, NATIVE, NCHAR, NEW, NOCOPY, NUMBER_BASE
       OBJECT, OCICOLL, OCIDATETIME, OCIDATE, OCIDURATION, OCIINTERVAL, OCILOBLOCATOR, OCINUMBER, OCIRAW, OCIREFCURSOR, OCIREF, OCIROWID, OCISTRING, OCITYPE, ONLY, OPAQUE, OPEN, OPERATOR, ORACLE, ORADATA, ORGANIZATION, ORLANY, ORLVARY, OTHERS, OUT, OVERRIDING
       PACKAGE, PARALLEL_ENABLE, PARAMETER, PARAMETERS, PARTITION, PASCAL, PIPE, PIPELINED, PRAGMA, PRECISION, PRIVATE
       RAISE, RANGE, RAW, READ, RECORD, REF, REFERENCE, RELIES_ON, REM, REMAINDER, RENAME, RESULT, RESULT_CACHE, RETURN, RETURNING, REVERSE, ROLLBACK, ROW
       SAMPLE, SAVE, SAVEPOINT, SB1, SB2, SB4, SECOND, SEGMENT, SELF, SEPARATE, SEQUENCE, SERIALIZABLE, SET, SHORT, SIZE_T, SOME, SPARSE, SQLCODE, SQLDATA, SQLNAME, SQLSTATE, STANDARD, STATIC, STDDEV, STORED, STRING, STRUCT, STYLE, SUBMULTISET, SUBPARTITION, SUBSTITUTABLE, SUBTYPE, SUM, SYNONYM
       TDO, THE, TIME, TIMESTAMP, TIMEZONE_ABBR, TIMEZONE_HOUR, TIMEZONE_MINUTE, TIMEZONE_REGION, TRAILING, TRANSACTION, TRANSACTIONAL, TRUSTED, TYPE
       UB1, UB2, UB4, UNDER, UNSIGNED, UNTRUSTED, USE, USING
       VALIST, VALUE, VARIABLE, VARIANCE, VARRAY, VARYING, VOID
       WHILE, WORK, WRAPPED, WRITE
       YEAR
       ZONE

   A RegEx to find them all:

       \b(?!(?i:
       	A(?:L(?:L|TER)|N[DY]|SC?|T)
       |	B(?:E(?:GI|TWEE)N|Y)
       |	C(?:ASE|HECK|LUSTERS?|O(?:L(?:AUTH|UMNS)|MPRESS|NNECT)|R(?:ASH|EATE)|URRENT)
       |	D(?:E(?:CLARE|FAULT|LETE|SC)|ISTINCT|ROP)
       |	E(?:LSE|ND|X(?:C(?:EPTION|LUSIVE)|ISTS))
       |	F(?:ETCH|OR|ROM)
       |	G(?:OTO|R(?:ANT|OUP))
       |	HAVING
       |	I(?:DENTIFIED|[FNS]|N(?:DEX(?:ES)?|SERT|T(?:ERSECT|O)))
       |	L(?:IKE|OCK)
       |	M(?:INUS|ODE)
       |	N(?:O(?:COMPRESS|T|WAIT)|ULL)
       |	O(?:[FN]|PTION|R(?:DER)?|VERLAPS)
       |	P(?:R(?:IOR|OCEDURE)|UBLIC)
       |	RE(?:SOURCE|VOKE)
       |	S(?:ELECT|HARE|IZE|QL|TART)
       |	T(?:AB(?:AUTH|LE)|HEN|O)
       |	U(?:NI(?:ON|QUE)|PDATE)
       |	V(?:ALUES|IEWS?)
       |	W(?:HE(?:N|RE)|ITH)
       )\b)

Identifiers=

   PL/SQL programs are written as lines of text using the following characters:

       Upper- and lower-case letters A .. Z and a .. z

       Numerals 0 .. 9

       Symbols ( ) + - * / < > = ! ~ ^ ; : . ' @ % , " # $ & _ | { } ? [ ]

       Tabs, spaces, and carriage returns

   PL/SQL keywords are not case-sensitive, so lower-case letters are equivalent
   to corresponding upper-case letters except within string and character literals.

   The minimum length of an identifier is one character; the maximum length is
   30 characters. The first character must be a letter, but each later character
   can be either a letter, numeral, dollar sign ($), underscore (_), or number
   sign (#). For example, the following are acceptable identifiers:

       X
       t2
       phone#
       credit_limit
       LastName
       oracle$number
       money$$$tree
       SN##
       try_again_

   Characters other than the aforementioned are not allowed in identifiers.
   For example, the following are not acceptable identifiers:

       mine&yours      -- ampersand (&) is not allowed
       debit-amount    -- hyphen (-) is not allowed
       on/off          -- slash (/) is not allowed
       user id         -- space is not allowed

   PL/SQL is not case-sensitive with respect to identifiers. For example,
   PL/SQL considers the following to be the same:

       lastname
       LastName
       LASTNAME

   Every character, alphabetic or not, is significant. For example, PL/SQL
   considers the following to be different:

       lastname
       last_name

   Quoted Identifiers

   For flexibility, PL/SQL lets you enclose identifiers within double quotes.
   Quoted identifiers are seldom needed, but occasionally they can be useful.
   They can contain any sequence of printable characters including spaces but
   excluding double quotes. Thus, the following identifiers are valid:

       "X+Y"
       "last name"
       "on/off switch"
       "employee(s)"
       "*** header info ***"

   The maximum size of a quoted identifier is 30 characters not counting the
   double quotes. Though allowed, using PL/SQL reserved words as quoted
   identifiers is a poor programming practice.

StringLiterals=

   A character value can be represented by an identifier or explicitly written
   as a string literal, which is a sequence of zero or more characters enclosed
   by single quotes. All string literals except the null string ('') have data
   type CHAR. For example:

       'Hello, world!'
       'XYZ Corporation'
       '10-NOV-91'
       'He said "Life is like licking honey from a thorn."'
       '$1,000,000'

   PL/SQL is case sensitive within string literals. For example, PL/SQL considers
   the following literals to be different:

       'baker'
       'Baker'

   To represent an apostrophe within a string, you can write two single quotes,
   which is not the same as writing a double quote:

       'I''m a string, you''re a string.'

   You can also use the following notation to define your own delimiter characters
   for the literal. You choose a character that is not present in the string, and
   then need not escape other single quotation marks inside the literal:

       -- q'!...!' notation allows use of single quotes inside literal
       string_var := q'!I'm a string, you're a string.!';

   You can use delimiters [, {, <, and (, pair them with ], }, >, and ), pass a
   string literal representing a SQL statement to a subprogram, without doubling
   the quotation marks around 'INVALID' as follows:

       func_call(q'[SELECT index_name FROM user_indexes
         WHERE status ='INVALID']');

   For NCHAR and NVARCHAR2 literals, use the prefix nq instead of q, as in the
   following example, where 00E0 represents the character é:

       where_clause := nq'#WHERE COL_VALUE LIKE '%\00E9'#';

Comment=

   A single-line comment begins with --. It can appear anywhere on a line, and 
   it extends to the end of the line

   A multiline comments begins with /*, ends with */, and can span multiple 
   lines, as in Example 2-5. You can use multiline comment delimiters to 
   "comment out" sections of code.

Classes_and_Methods=

Function=

Grammar=

