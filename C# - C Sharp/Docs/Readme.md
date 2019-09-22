
# C# / C-sharp

## Description


## Links

_WWW_

_Wiki_
https://en.wikipedia.org/wiki/C_Sharp_(programming_language)


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~
https://msdn.microsoft.com/en-us/library/x53a06bb.aspx#Anchor_0

   A RegEx to find them all:

       \b(?!(?-i:
           a(?:bstract|s)
       |   b(?:ase|ool|reak|yte)
       |   c(?:a(?:se|tch)|h(?:ar|ecked)|lass|on(?:st|tinue))
       |   d(?:e(?:cimal|fault|legate)|o(?:uble)?)
       |   e(?:lse|num|vent|xplicit|xtern)
       |   f(?:alse|inally|ixed|loat|or(?:each)?)
       |   goto
       |   i(?:f|mplicit|n(?:t(?:er(?:face|nal))?)?|s)
       |   lo(?:ck|ng)
       |   n(?:amespace|ew|ull)
       |   o(?:bject|perator|ut|verride)
       |   p(?:arams|rivate|rotected|ublic)
       |   re(?:adonly|f|turn)
       |   s(?:byte|ealed|hort|izeof|ta(?:ckalloc|tic)?|tr(?:ing|uct)?|witch)
       |   t(?:h(?:is|row)|r(?:ue|y)|ypeof)
       |   u(?:int|long|n(?:checked|safe)|s(?:hort|ing))
       |   v(?:irtual|oid|olatile)
       |   while
       )\b)

       Contextual keywords

       \b(?!(?-i:
           a(?:dd|lias|scending|sync|wait)
       |   d(?:escending|ynamic)
       |   from
       |   g(?:et|lobal|roup)
       |   into
       |   join
       |   let
       |   orderby
       |   partial
       |   remove
       |   s(?:elect|et)
       |   v(?:alue|ar)
       |   where
       |   yield
       )\b)



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
                     mainExpr="
       ^
       [^\S\r\n]*
       (?'modifier1'
           (?-i:
               public
           |
               protected
           |
               internal
           |
               private
           )
           \s*
       )?
       (?'modifier2'
           (?:
               new
           |
               static
           |
               virtual
           |
               sealed
           |
               override
           |
               abstract
           |
               extern
           )
           \s*
       )?
       (?-i:
           partial
           \s*
       )?
       (?'type'
           (?!
               (?-i:
                   return
               |
                   if
               |
                   else
               )
           )
           \w+
           (?'genericType'
               <
               [\w,\s<>]+
               >
           )?
           \s+
       )
       (?'name'
           \w+
           (?'genericNameType'
               <
               [\w,\s<>]+
               >
           )?
           \s?
       )
       \(
       (?'params'
           [\w\s,<>\[\]\:=\.]*
       )
       \)
       (?'ctorChain'
           \s*
           \:
           \s*
           (?-i:
               base
           |
               this
           )
           \s*
           \(
           (?'ctorParams'
               [\w\s,<>\[\]\:=\.]*
           )
           \)
       )?
       [\w\s<>\:,\(\)\[\]]*
       (?:
           \{
       |
           ;
       )
       ">



## Grammar

BNF | ABNF | EBNF | XBNF
