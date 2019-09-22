
# Pascal

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
[Pascal] -----------------------------------------------------------------------
@=(?-i)(?:Turbo )?Pascal

_WWW_=

_Wiki_=https://en.wikipedia.org/wiki/Pascal_(programming_language)

Keywords=

   AND ARRAY BEGIN CASE CONST DIV DO DOWNTO ELSE END FILE FOR FUNCTION GOTO
   IF IN LABEL MOD NIL NOT OF OR PACKED PROCEDURE PROGRAM RECORD REPEAT
   SET THEN TO TYPE UNTIL VAR WHILE WITH

   A RegEx to find them all:

       \b(?!(?-i:
       	A(?:ND|ARRAY)
       |	B(?:EGIN|OOLEAN)
       |	C(?:ASE|HAR|HR|ONST)
       |	D(?:IV|O(?:WNTO)?)
       |	E(?:LSE|ND)
       |	F(?:ILE|OR|UNCTION)
       |	GOTO
       |	I(?:F|MPLEMENTATION|N(?:TE(?:GER|RFACE))?)
       |	LABEL
       |	MOD
       |	N(?:IL|OT)
       |	O[FR]
       |	P(?:ACKED|RO(?:CEDURE|GRAM))
       |	RE(?:AL|CORD|PEAT)
       |	S(?:ET|TRING)
       |	T(?:HEN|O|YPE)
       |	U(?:N(?:IT|TIL)|SES)
       |	VAR
       |	W(?:HILE|ITH)
       )\b)

Identifiers=

   ('a' .. 'z' | 'A' .. 'Z') ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_')*

   [A-Za-z]\w*

StringLiterals=

    '\'' ('\'\'' | ~ ('\''))* '\''
    \x27(?:[^\x27]|\x27{2})*\x27

Comment=

   (* This is a comment.
      It may extend across multiple lines. *)

   { Alternatively curly braces
     can be used. }

   (* This is a valid comment in Standard Pascal,
      but not valid in [[Turbo Pascal]]. }

   { The same is true in this case *)


        (?'MLC1'\x28\x2A(?:[^\x2A]|\x2A[^\x29])*?\x2A\x29)
    |   (?'MLC2'\x7B       [^\x7D]             *?    \x7D)

Classes_and_Methods=

Function=

       function identifier ( arguments ) : returntype;
       begin
       end;

       procedure identifier ( arguments );
       begin
       end;

   (all versions and dialects)

       function multiply(a,b: real): real;
       begin
         multiply := a*b;
       end;

   (?:
       (?:function)
       [\t ]+
       (?'function identifier'
           \b[A-Za-z_]\w*\b
       )
       (?'function arguments'
           \s*
           \(
           [^\)]*
           \)
       )?
       (?'type'
           \s*
           :
           \s*
           (?'type name'
               \b
               [A-Za-z_]\w*
               \b
           )
       )
   |
       (?:procedure)
       [\t ]+
       (?'procedure identifier'
           \b[A-Za-z_]\w*\b
       )
       (?'procedure arguments'
           \s*
           \(
           [^\)]*
           \)
       )?
   )
   \s*
   ;
   .*?
   ((?!begin).)*
   (?:begin)

   (?:(?:function)[\t ]+(?'function identifier'\b[A-Za-z_]\w*\b)(?'function arguments'\s*\([^\)]*\))?(?'type'\s*:\s*(?'type name'\b[A-Za-z_]\w*\b))|(?:procedure)[\t ]+(?'procedure identifier'\b[A-Za-z_]\w*\b)(?'procedure arguments'\s*\([^\)]*\))?)\s*;.*?((?!begin).)*(?:begin)
   (?:(?:\bfunction\b)[\t ]+\b[A-Za-z_]\w*\b(?:\s*\([^\)]*\))?\s*:\s*\b[A-Za-z_]\w*\b|(?:\bprocedure\b)[\t ]+\b[A-Za-z_]\w*\b(?:\s*\([^\)]*\))?)\s*;.*?((?!begin).)*(?:begin)


   (?:function|procedure)[\t ]+\b[A-Za-z_]\w*\b

Grammar=

    <Language name="Pascal" imagelistpath="">
        <CommList param1="//"     param2=""       />
        <CommList param1="&apos;" param2="&apos;" />
        <CommList param1="\{"     param2="\}"     />
        <CommList param1="\(\*"   param2="\*\)"   />
        <Group
            name       = "OBJECT"       subgroup   = ""        keywords = ""
            icon       = "0"            child      = "0"       autoexp  = "0"   matchcase = "0"
            fendtobbeg = ""             bbegtobend = ""
        >
            <Rules
                regexbeg  = "^\s*"              regexfunc = "\w+"                   regexend = "\s*=\s*object\(.*\)"
                bodybegin = ""                  bodyend   = "&lt;end&gt;"
                sep       = ""
            />
        </Group>
        <Group
            name       = "PROCEDURE"    subgroup   = ""        keywords = ""
            icon       = "0"            child      = "0"       autoexp  = "0"   matchcase = "0"
            fendtobbeg = ""             bbegtobend = "&lt;begin&gt;"
        >
            <Rules
                regexbeg  = "procedure\s+"      regexfunc = "\w*\.*\w+"             regexend = "\s*.*;"
                bodybegin = "&lt;begin&gt;"     bodyend   = "&lt;end&gt;"
                sep       = "&lt;end&gt;"
            />
        </Group>
        <Group
            name       = "FUNCTION"     subgroup   = ""        keywords = ""
            icon       = "0"            child      = "0"       autoexp  = "0"   matchcase = "0"
            fendtobbeg = ""             bbegtobend = "&lt;begin&gt;"
        >
            <Rules
                regexbeg  = "function\s+"       regexfunc = "\w*\.*\w+"             regexend = "\s*.*;"
                bodybegin = "&lt;begin&gt;"     bodyend   = "&lt;end&gt;"
                sep       = "&lt;end&gt;"
            />
        </Group>
        <Group
            name       = "CONSTRUCTOR"  subgroup   = ""        keywords = ""
            icon       = "0"            child      = "0"       autoexp  = "0"   matchcase = "0"
            fendtobbeg = ""             bbegtobend = "&lt;begin&gt;"
        >
            <Rules
                regexbeg  = "constructor\s+"    regexfunc = "\w*\.*\w+"             regexend = "\s*.*;"
                bodybegin = "&lt;begin&gt;"     bodyend   = "&lt;end&gt;"
                sep       = "&lt;end&gt;"
            />
        </Group>
        <Group
            name       = "DESTRUCTOR"   subgroup   = ""        keywords = ""
            icon       = "0"            child      = "0"       autoexp  = "0"   matchcase = "0"
            fendtobbeg = ""             bbegtobend = "&lt;begin&gt;"
        >
            <Rules
                regexbeg  = "destructor\s+"     regexfunc = "\w*\.*\w+"             regexend = "\s*.*;"
                bodybegin = "&lt;begin&gt;"     bodyend   = "&lt;end&gt;"
                sep       = "&lt;end&gt;"
            />
        </Group>
        <Group
            name       = "VAR"          subgroup   = "OBJECT"  keywords = ""
            icon       = "0"            child      = "0"       autoexp  = "0"   matchcase = "0"
            fendtobbeg = ""             bbegtobend = ""
        >
            <Rules
                regexbeg  = "\s*"               regexfunc = "\w+\s*:\s*[\w\[\]_]+"  regexend = "\s*;"
                bodybegin = ""                  bodyend   = "$"
                sep       = ""
            />
        </Group>
    </Language>
