
# Lua

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
[Lua] --------------------------------------------------------------------------
@=Lua

   character.escape                : '\\([abfnrtv\\"'']|\r?\n|\n\r?|\d\d?\d?)'
   character.escape                : '\\[xX][0-9a-fA-F][0-9a-fA-F]'
   character.escape                : '\\u\{[0-9a-fA-F]{,7}\}'

   comment.block.begin             : '--\[(=*)\['
   comment.block.end               : '\]\1\]'
   comment.line.double-dash        : '(--)(?!\[\[).*$\n?'

   constant.language               : '(?<![^.]\.|:)\b(false|nil|true|_G|_VERSION|math\.(pi|huge))\b|(?<![.])\.{3}(?!\.)'

   file_extensions                 : lua

   function                        : '(?x)
                                        \b
                                        (  function  )
                                        \s+
                                        (  [a-zA-Z_.:]+  [.:]  )?
                                        (  [a-zA-Z_]\w*  )
                                        \s*
                                        (  \(  )
                                        (  [^)]*  )
                                        (  \)  )
                                      '

   keyword.control                 : \b(break|do|else|for|if|elseif|return|then|repeat|while|until|end|function|local|in)\b
   keyword.operator                : '\+|-|%|#|\*|\/|\^|==?|~=|<=?|>=?|(?<!\.)\.{2}(?!\.)'
   keyword.operator                : \b(and|or|not)\b

   numeric                         : '(?<![\d.])\b0[xX][a-fA-F\d\.]+([pP][\-\+]?\d+)?|\b\d+(\.\d+)?([eE]-?\d+)?|\.\d+([eE]-?\d+)?'

   string.quoted.double.begin      : '"'
   string.quoted.double.end        : '"'
   string.quoted.multiline.begin   : '(?<!--)\[(=*)\['
   string.quoted.multiline.end     : '\]\1\]'
   string.quoted.single.begin      : "'"
   string.quoted.single.end        : "'"

   support.function.library        : '(?x)
                                        (?<!  [^.]\.  |  :  )
                                        \b
                                        (?: coroutine  \.  (  create  |  resume  |  running  |  status  |  wrap  |  yield  )
                                        |   string     \.  (  byte  |  char  |  dump  |  find  |  format  |  gmatch  |  gsub  |  len  |  lower  |  match  |  rep  |  reverse  |  sub  |  upper  )
                                        |   table      \.  (  concat  |  insert | maxn|remove|sort)
                                        |   math       \.  (  abs  |  acos  |  asin  |  atan2?  |  ceil  |  cosh?  |  deg  |  exp  |  floor  |  fmod  |  frexp  |  ldexp  |  log  |  log10  |  max  |  min  |  modf  |  pow  |  rad  |  random  |  randomseed  |  sinh?  |  sqrt  |  tanh?  )
                                        |   io         \.  (  close  |  flush  |  input  |  lines  |  open  |  output  |  popen  |  read  |  tmpfile  |  type  |  write  )
                                        |   os         \.  (  clock  |  date  |  difftime  |  execute  |  exit  |  getenv  |  remove  |  rename  |  setlocale  |  time  |  tmpname  )
                                        |   package    \.  (  cpath  |  loaded  |  loadlib  |  path  |  preload  |  seeall  )
                                        |   debug      \.  (  debug  |  [gs]etfenv  |  [gs]ethook  |  getinfo  |  [gs]etlocal  |  [gs]etmetatable  |  getregistry  |  [gs]etupvalue  |  traceback  )
                                        )
                                        \b
                                        (?=  [(\x20{"''\[]  )
                                      '
   support.function                : '(?<![^.]\.|:)\b(assert|collectgarbage|dofile|error|getfenv|getmetatable|ipairs|loadfile|loadstring|module|next|pairs|pcall|print|rawequal|rawget|rawset|require|select|setfenv|setmetatable|tonumber|tostring|type|unpack|xpcall)\b(?=[( {"''\[])'

   variable.language.self          : '(?<![^.]\.|:)\b(self)\b'

_WWW_=https://www.lua.org/

_Wiki_=https://en.wikipedia.org/wiki/Lua_(programming_language)

   <!-- Basic lua parser for functionList.xml in Notepad++ 6.5.3 -->
   <!-- See http://notepad-plus-plus.org/features/function-list.html -->
   <parser
       id="lua_function" displayName="Lua"
       commentExpr="--.*?$">

     <!-- Basic lua table view, nested lua table not supported -->
     <classRange
         mainExpr="[.\w]+[\s]*=[\s]*\{"
         openSymbole="\{"
         closeSymbole="\}"
         displayMode="node">
       <className>
         <nameExpr expr="[.\w]+"/>
       </className>
       <function
           mainExpr="[.\w]+[\s]*=[\s]*['&quot;]?[\w]+['&quot;]?">
         <functionName>
           <funcNameExpr expr=".*"/>
         </functionName>
       </function>
     </classRange>

     <!-- Basic lua functions support -->
     <function
         mainExpr="(function[\s]+[.\w]+(:[\w]+)?)|([.\w]+[\s]*=[\s]*function)"
         displayMode="$className->$functionName">
       <functionName>
         <nameExpr expr="((?<=function)[\s]+[.:\w]+)|(([.\w]+)(?=([\s]*=[\s]*function)))"/>
       </functionName>
       <className>
         <nameExpr expr="[.\w]+(?=:)"/>
       </className>
     </function>
   </parser>

Keywords=

   Lua 4.0 :      break  do  else  elseif  end              function        if      local  nil  not  or  repeat  return  then        until  while
   Lua 5.1 : and  break  do  else  elseif  end  false  for  function        if  in  local  nil  not  or  repeat  return  then  true  until  while
   Lua 5.2 : and  break  do  else  elseif  end  false  for  function  goto  if  in  local  nil  not  or  repeat  return  then  true  until  while
   Lua 5.3 : and  break  do  else  elseif  end  false  for  function  goto  if  in  local  nil  not  or  repeat  return  then  true  until  while

   A RegEx to find them all:

        \b(?!(?-i:
         	and
        |	break
        |	do
        |	e(?:lse(?:if)?|nd)
        |	f(?:alse|or|unction)
        |	goto
        |	i[fn]
        |	local
        |	n(?:il|ot)
        |	or
        |	re(?:peat|turn)
        |	t(?:hen|rue)
        |	until
        |	while
        )\b)

Identifiers=[A-Za-z_]\w*

StringLiterals=

Comment=

       -- A single line comment

       --[[A multi-line
           comment ]]

   Works with: Lua version 5.1 and above

       --[====[ A multi-line comment that can contain [[ many square brackets ]]
       ]====]

Classes_and_Methods=

Function=

   The syntax for function definition is

       function    ::= `function` funcbody
       funcbody    ::= `(` [ parlist ] `)` block `end`

   The following syntactic sugar simplifies function definitions:

       statement   ::= `function` funcname funcbody
                     | `local` `function` identifier funcbody
       funcname    ::= identifier { `.` identifier } [ `:` identifier ]
       funcbody    ::= `(` [ parameterlist ] `)` block `end` ;

   The statement                           Translates to
   -------------------------------------------------------------------------------------
   function f () body end                  f = function () body end

   function t.a.b.c.f () body end          t.a.b.c.f = function () body end

   local function f () body end            local f; f = function () body end

   function t.a.b.c:f (params) body end    t.a.b.c.f = function (self, params) body end

   v:name(args)                            v.name(v,args)


Grammar=

   EBNF 5.1
   ~~~~~~~~

   chunk               ::= {stat [`;`]} [laststat [`;`]]
   block               ::= chunk
   stat                ::= varlist `=` explist
                         | functioncall
                         | do block end
                         | while exp do block end
                         | repeat block until exp
                         | if exp then block {elseif exp then block} [else block] end
                         | for Name `=` exp `,` exp [`,` exp] do block end
                         | for namelist in explist do block end
                         | function funcname funcbody
                         | local function Name funcbody
                         | local namelist [`=` explist]
   laststat            ::= return [explist] | break
   funcname            ::= Name {`.` Name} [`:` Name]
   varlist             ::= var {`,` var}
   var                 ::= Name | prefixexp `[` exp `]` | prefixexp `.` Name
   namelist            ::= Name {`,` Name}
   explist             ::= {exp `,`} exp
   exp                 ::= nil | false | true | Number | String | `...`
                         | functiondef | prefixexp | tableconstructor
                         | exp binop exp | unop exp
   prefixexp           ::= var | functioncall | `(` exp `)`
   functioncall        ::= prefixexp args | prefixexp `:` Name args
   args                ::= `(` [explist] `)` | tableconstructor | String
   functiondef         ::= function funcbody
   funcbody            ::= `(` [parlist] `)` block end
   parlist             ::= namelist [`,` `...`] | `...`
   tableconstructor    ::= `{` [fieldlist] `}`
   fieldlist           ::= field {fieldsep field} [fieldsep]
   field               ::= `[` exp `]` `=` exp | Name `=` exp | exp
   fieldsep            ::= `,` | `;`
   binop               ::= `+` | `-` | `*` | `/` | `^` | `%` | `..`
                         | `<` | `<=` | `>` | `>=` | `==` | `~=`
                         | and | or
   unop                ::= `-` | not | `#`


   EBNF 5.2
   ~~~~~~~~

   chunk               ::= block
   block               ::= {stat} [retstat]
   stat                ::= `;`
                         | varlist `=` explist
                         | functioncall
                         | label
                         | break
                         | goto Name
                         | do block end
                         | while exp do block end
                         | repeat block until exp
                         | if exp then block {elseif exp then block} [else block] end
                         | for Name `=` exp `,` exp [`,` exp] do block end
                         | for namelist in explist do block end
                         | function funcname funcbody
                         | local function Name funcbody
                         | local namelist [`=` explist]
   retstat             ::= return [explist] [`;`]
   label               ::= `::` Name `::`
   funcname            ::= Name {`.` Name} [`:` Name]
   varlist             ::= var {`,` var}
   var                 ::= Name | prefixexp `[` exp `]` | prefixexp `.` Name
   namelist            ::= Name {`,` Name}
   explist             ::= exp {`,` exp}
   exp                 ::= nil | false | true | Number | String | `...`
                         | functiondef | prefixexp | tableconstructor
                         | exp binop exp | unop exp
   prefixexp           ::= var | functioncall | `(` exp `)`
   functioncall        ::= prefixexp args | prefixexp `:` Name args
   args                ::= `(` [explist] `)` | tableconstructor | String
   functiondef         ::= function funcbody
   funcbody            ::= `(` [parlist] `)` block end
   parlist             ::= namelist [`,` `...`] | `...`
   tableconstructor    ::= `{` [fieldlist] `}`
   fieldlist           ::= field {fieldsep field} [fieldsep]
   field               ::= `[` exp `]` `=` exp | Name `=` exp | exp
   fieldsep            ::= `,` | `;`
   binop               ::= `+` | `-` | `*` | `/` | `^` | `%` | `..`
                         | `<` | `<=` | `>` | `>=` | `==` | `~=`
                         | and | or
   unop                ::= `-` | not | `#`


   EBNF 5.3
   ~~~~~~~~

   chunk               ::= block
   block               ::= { stat } [ retstat ]
   stat                ::= `;`
                         | varlist `=` explist
                         | functioncall
                         | label
                         | break
                         | goto Name
                         | do block end
                         | while exp do block end
                         | repeat block until exp
                         | if exp then block { elseif exp then block } [ else block ] end
                         | for Name `=` exp `,` exp [ `,` exp ] do block end
                         | for namelist in explist do block end
                         | function funcname funcbody
                         | local function Name funcbody
                         | local namelist [ `=` explist ]
   retstat             ::= return [ explist ] [ `;` ]
   label               ::= `::` Name `::`
   funcname            ::= Name { `.` Name } [ `:` Name ]
   varlist             ::= var { `,` var }
   var                 ::= Name | prefixexp `[` exp `]` | prefixexp `.` Name
   namelist            ::= Name { `,` Name }
   explist             ::= exp { `,` exp }
   exp                 ::= nil | false | true | Numeral | LiteralString
                         | `...` | functiondef | prefixexp | tableconstructor
                         | exp binop exp | unop exp
   prefixexp           ::= var | functioncall | `(` exp `)`
   functioncall        ::= prefixexp args | prefixexp `:` Name args
   args                ::= `(` [ explist ] `)` | tableconstructor | LiteralString
   functiondef         ::= function funcbody
   funcbody            ::= `(` [ parlist ] `)` block end
   parlist             ::= namelist [ `,` `...` ] | `...`
   tableconstructor    ::= `{` [ fieldlist ] `}`
   fieldlist           ::= field { fieldsep field } [ fieldsep ]
   field               ::= `[` exp `]` `=` exp | Name `=` exp | exp
   fieldsep            ::= `,` | `;`
   binop               ::= `+` | `-` | `*` | `/` | `//` | `^` | `%`
                         | `&` | `~` | `|` | `>>` | `<<` | `..` | `<`
                         | `<=` | `>` | `>=` | `==` | `~=` | and | or
   unop                ::= `-` | not | `#` | `~`


