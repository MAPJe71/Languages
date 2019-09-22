
# INI

## Description

INItialisation File

Extension

.ini
.inf
.reg


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

;

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods

   Section                 --> Class
   Property Name           --> Method


## Function

   Global Property Name    --> Function


## Grammar

BNF | ABNF | EBNF | XBNF

   file        = block* ( section block* )*
               = (?'block'comment|property)*(section(?'block'comment|property)*)*

               = (?'block1'(?'comment1'[;#][^\r\n]*(?:\r?\n|\r))|(?'property1'(?'propname1'(?'QUOTE1'['"]?)[A-Za-z_@][\w\-.]*\k'QUOTE1')[=](?'propval1'[^\r\n]*)(?:\r?\n|\r)))*(?:(?'section'\[(?'sectname'[^\]]+)][\t ]*(?:\r?\n|\r))(?'block2'(?'comment2'[;#][^\r\n]*(?:\r?\n|\r))|(?'property2'(?'propname2'(?'QUOTE2'['"]?)[A-Za-z_@][\w\-.]*\k'QUOTE2')[=](?'propval2'[^\r\n]*)(?:\r?\n|\r)))*)*
       /* minimized */
               = (?:[;#][^\r\n]*\r?\n|(?'QUOTE1'['"]?)[A-Za-z_@][\w\-.]*\k'QUOTE1'=[^\r\n]*(?:\r?\n|\r))*(?:\[[^\]+)][\t ]*(?:\r?\n|\r)(?:[;#][^\r\n]*(?:\r?\n|\r)|(?'QUOTE2'['"]?)[A-Za-z_@][\w\-.]*\k'QUOTE2'=[^\r\n]*(?:\r?\n|\r))*)*

   block       = comment | property ;
               = (?'block'(?'comment'[;#][^\r\n]*(?:\r?\n|\r))|(?'property'(?'propname'(?'QUOTE'['"]?)[A-Za-z_@][\w\-.]*\k'QUOTE')[=](?'propval'[^\r\n]*)(?:\r?\n|\r)))

   comment     = [;#][^\r\n]*(?:\r?\n|\r)
               = (?'comment'[;#][^\r\n]*(?:\r?\n|\r))

   section     = \[
                 (?:                           (?# section name    )
                   [^\]]+
                 )
                 ]
                 [\t ]*                        (?# white space     )
                 (?:\r?\n|\r)
               = (?'section'\[(?'sname'[^\]]+)][\t ]*(?:\r?\n|\r))

   property    = (?:                           (?# property name   )
                   (?'QUOTE'
                       ['"]?
                   )
                   [A-Za-z_@]
                   [\w\-.]*
                   \k'QUOTE'
                 )
                 [=]
                 (?:                           (?# property value  )
                   [^\r\n]*
                 )
                 (?:\r?\n|\r)
               = (?'property'(?'propname'(?'QUOTE'['"]?)[A-Za-z_@][\w\-.]*\k'QUOTE')[=](?'propval'[^\r\n]*)(?:\r?\n|\r))
~~~~~

#1: (?'header'\[(?'name'[^\]]+)](?'suffix'[\t ]*)(?=\r?\n|\r|$))(?'body'(?'row'(?'rowdata'(?'commentrow'[;#][^\r\n]*)|(?'proprow'(?'propname'(?'QUOTE'['&quot;]?)[A-Za-z_@][\w\-.]*\k'QUOTE')[=](?'propval'[^\r\n]*))|(?#emptyrow))(?#rowterminator)(?=\r?\n|\r|$))*)?
#2: (?:\[(?:[^\]]+)](?:[\t ]*)(?=\r?\n|\r|$))(?:(?:(?:(?:[;#][^\r\n]*)|(?:(?:(?'QUOTE'['&quot;]?)[A-Za-z_@][\w\-.]*\k'QUOTE')[=](?:[^\r\n]*))|)(?=\r?\n|\r|$))*)?
#3: \[[^\]]+][\t ]*(?=\r?\n|\r|$)(?:(?:[;#][^\r\n]*|(?'QUOTE'['&quot;]?)[A-Za-z_@][\w\-.]*\k'QUOTE'[=][^\r\n]*|)(?=\r?\n|\r|$))*
#4: \[[^\]]+][^\r\n]*(?:\r?\n|\r|$)(?:(?:(?:(?'QUOTE'['"]?)[A-Za-z_@][\w\-.]*\k'QUOTE'[=]|[;#])[^\r\n]*)?(?:\r?\n|\r|$))*

