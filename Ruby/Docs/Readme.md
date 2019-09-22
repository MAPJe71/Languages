
# Ruby

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
[Ruby] -------------------------------------------------------------------------
@=Ruby

_WWW_=http://web.njit.edu/all_topics/Prog_Lang_Docs/html/ruby/index.html

_Wiki_=https://en.wikipedia.org/wiki/Ruby_(programming_language)

Keywords=

   Ruby 1.9.1

       BEGIN  END  __ENCODING__  __END__  __FILE__  __LINE__  alias  and  begin
       break  case  class  def  defined?  do  else  elsif  end  ensure  false
       for  if  in  module  next  nil  not  or  redo  rescue  retry  return
       self  super  then  true  undef  unless  until  when  while  yield

       A RegEx to find them all:

           \b(?!(?-i:
               BEGIN|END
           |   __(?:EN(?:CODING|D)|FILE|LINE)__
           |   a(?:lias|nd)
           |   b(?:egin|reak)
           |   c(?:ase|lass)
           |   def(?:ined\?)?|do
           |   els(?:e|if)|en(?:d|sure)
           |   f(?:alse|or)
           |   i[fn]
           |   module
           |   n(?:ext|il|ot)
           |   or
           |   re(?:do|scue|t(?:ry|urn))
           |   s(?:elf|uper)
           |   t(?:hen|rue)
           |   un(?:def|less|til)
           |   wh(?:en|ile)
           |   yield
           )\b)

   Ruby 2.2.0

       http://docs.ruby-lang.org/en/2.2.0/keywords_rdoc.html

       BEGIN  END  __ENCODING__  __FILE__  __LINE__  alias  and  begin  break
       case  class  def  defined?  do  else  elsif  end  ensure  false  for
       if  in  module  next  nil  not  or  redo  rescue  retry  return  self
       super  then  true  undef  unless  until  when  while  yield

       A RegEx to find them all:

           \b(?!(?-i:
               BEGIN|END
           |   __(?:ENCODING|FILE|LINE)__
           |   a(?:lias|nd)
           |   b(?:egin|reak)
           |   c(?:ase|lass)
           |   def(?:ined\?)?|do
           |   els(?:e|if)|en(?:d|sure)
           |   f(?:alse|or)
           |   i[fn]
           |   module
           |   n(?:ext|il|ot)
           |   or
           |   re(?:do|scue|t(?:ry|urn))
           |   s(?:elf|uper)
           |   t(?:hen|rue)
           |   un(?:def|less|til)
           |   wh(?:en|ile)
           |   yield
           )\b)

       Compressed:

           (?'KEYWORDS'\b(?!(?-i:(?:BEGIN|END)|(?:__(?:ENCODING|FILE|LINE)__)|(?:a(?:lias|nd))|(?:b(?:egin|reak))|(?:c(?:ase|lass))|(?:def(?:ined\?)?|do)|(?:els(?:e|if)|en(?:d|sure))|(?:f(?:alse|or))|(?:i(?:f|n))|(?:module)|(?:n(?:ext|il|ot))|(?:or)|(?:re(?:do|scue|t(?:ry|urn)))|(?:s(?:elf|uper))|(?:t(?:hen|rue))|(?:un(?:def|less|til))|(?:wh(?:en|ile))|(?:yield))\b))

Identifiers=

   Ruby identifiers consist of alphabets, decimal digits, and the underscore
   character, and begin with a alphabets (including underscore). There are no
   restrictions on the lengths of Ruby identifiers.

   (?:
     (?'identifier1'[A-Za-z_]\w*[?!=]?)
   |
     (?'identifier2':{2}|\*{1,2}|![=~]?|=(?:~|={1,2})?|[~+\-/%&amp;|\^]|&lt;(?:&lt;|=&gt;?)?|&gt;[&gt;=]?|\[]=?)
   )

StringLiterals=

   Double- and single-quoting have different effects in some cases. A double-
   quoted string allows character escapes by a leading backslash, and the
   evaluation of embedded expressions using #{}. A single-quoted string does
   not do this interpreting; what you see is what you get.

   Ruby's string handling is smarter and more intuitive than C's. For instance,
   you can concatenate strings with +, and repeat a string many times with *.

   http://docs.ruby-lang.org/en/2.2.0/syntax/literals_rdoc.html

   https://en.wikipedia.org/wiki/Here_document

Comment=
   (?'comment'
       (?'slc'                                         (?# single line comment )
          
           [^{]
           (?'nolinebreak'[^\r\n]*)
           (?:
               (?'linebreak'\r?\n|\r)
           |
               $
           )
       )
   |
       (?'mlc'                                         (?# multi line comment )
           (?:
               ^
           |
               (?<=[\r\n])
           )
           (?'mlcheader'
               (?-i:=begin\b)
               (?:
                   [\t ]
                   (?'nolinebreak'[^\r\n]+)
               )?
               (?'linebreak'\r?\n|\r)
           )
           (?'mlcbody'
               (?'nolinebreak'[^\r\n]*)
               (?'linebreak'\r?\n|\r)
           )*?
           (?'mlcfooter'
               (?-i:=end\b)
           )
       )
   )

Classes_and_Methods=

   http://docs.ruby-lang.org/en/2.2.0/syntax/modules_and_classes_rdoc.html

   Class definition
       The class names are identifiers and begin with an uppercase character.

       class identifier [`<' superclass ]
           expr..
       end

   Singleton-class definition

       class `<<' expr
           expr..
       end

   Method definitions
       Method_name should be either an identifier or a re-definable operator (e.g. ==, +, -, etc.).
       The method definitions can not be nested.
       Some methods are marked as `private', and must be called in the function form.
       When the method is defined outside of the class definition, the method is
       marked as private by default. On the other hand, the methods defined in the
       class definition are marked as public by default. The default visibility and
       the `private' mark of the methods can be changed by public or private of
       the Module.
       In addition, the methods named initialize are always defined as private methods.

       def method_name [`(' [arg ['=' default]]...[`,' `*' arg ]`)']
           expr..
       end

   Singleton-method definitions
       The singleton-method definitions can be nested.

       def expr `.' identifier [`(' [arg [`=' default]]...[`,' `*' arg ]`)']
           expr..
       end

   Alias
       Aliases can not be defined within the method body.

       alias method-name method-name
       alias global-variable-name global-variable-name


       http://docs.ruby-lang.org/en/2.2.0/syntax/miscellaneous_rdoc.html
       The alias keyword is most frequently used to alias methods. When
       aliasing a method you can use either its name or a symbol:

           alias new_name old_name
           alias :new_name :old_name

   ~~~~~

     (?-i:\balias)                     # "alias" definition
     (?:
       [\t ]+                          # one separator required
       \b(?!(?-i:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b)
       (?'ID'[A-Za-z_]\w*)             # a valid alias identifier
     ){2}
     [^\r\n]*                          # consume remainder of line
     (?:
       \r?\n|\r                        # until EOL
     |
       $                               # until EOF
     )
   |
     (?-i:\bdef)                       # method and operator "def"initions
     [\t ]+                            # one separator required
     (?:
       \b(?!(?-i:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b)
       [A-Za-z_]\w*                    # a valid method identifier, keywords are invalid
       [?!=]?                          # none or one of ?, ! and =
       (?:[\t ]*\([^)]*\))?            # optional arguments
     |
       (?:                             # operator (re-)definitions
         :{2}                          # matches ::
       | \*{1,2}                       # matches * and **
       | ![=~]?                        # matches !, != and !~
       | =(?:~|={1,2})?                # matches =, =~, == and ===
       | [~+\-/%&|\^]                  # matches ~, +, -, /, %, &, | and ^
       | <(?:<|=>?)?                   # matches <, <<, <= and <=>
       | >[>=]?                        # matches >, >> and >=
       | \[]=?                         # matches [] and []=
       )
       [\t ]*\([^)]*\)                 # arguments
     )
     .+?                               # consume method body
     (?-i:end)                         # end of method

   ~~~~~

   (?'CLASS'
       (?'CLASSHEADER'
           (?'OPTBLANK'[\t ]*)
           (?-i:\bclass\b)                                 (?# class keyword)
           (?'REQBLANK'[\t ]+)
           (?'CLASSID'
               \b
               \b(?!(?-i:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b)
               [A-Za-z_]\w*
               \b
           )
           (?'NOLINEBREAK'[^\r\n]*)
           (?'LINEBREAK'\r?\n|\r)
       )
       (?'CLASSBODY'
           (?'SLC'                                         (?# single line comment )
               [\t ]*
              
               (?'NOLINEBREAK'[^\r\n]*)
               (?'LINEBREAK'\r?\n|\r)
           )
       |
           (?'MLC'                                         (?# multi line comment )
               (?'MLCHEADER'
                   (?-i:=begin\b)
                   (?:
                       (?'REQBLANK'[\t ]+)
                       (?'NOLINEBREAK'[^\r\n]+)
                   )?
                   (?'LINEBREAK'\r?\n|\r)
               )
               (?'MLCBODY'
                   (?'NOLINEBREAK'[^\r\n]*)
                   (?'LINEBREAK'\r?\n|\r)
               )*?
               (?'MLCFOOTER'
                   (?-i:=end\b)
               )
           )
       |
           (?'BLANKLINE'
               (?'OPTBLANK'[\t ]*)
               (?'LINEBREAK'\r?\n|\r)
           )
       |
           (?'VARIABLELINE'
               (?'OPTBLANK'[\t ]*)
               \b
               (?'VARID'
                   \$
                   (?:
                       \b(?!(?-i:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b)
                       [A-Za-z_]\w*
                   |
                       -.
                   |
                       .
                   )
               |
                   @{0,2}
                   \b(?!(?-i:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b)
                   [A-Za-z_]\w*
               )
               \b
               (?'NOLINEBREAK'[^\r\n]*)
               (?'LINEBREAK'\r?\n|\r)
           )
       |
           (?'METHOD'
               (?'METHODHEADER'
                   (?'OPTBLANK'[\t ]*)
                   (?-i:\bdef\b)                           (?# method keyword)
                   (?'REQBLANK'[\t ]+)
                   (?'METHODID'
                       \b(?!(?-i:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b)
                       [A-Za-z_]\w*[?!=]?|:{2}|\*{1,2}|![=~]?|=(?:~|={1,2})?|[~+\-/%&|\^]|<(?:<|=>?)?|>[>=]?|\[]=?
                   )
                   (?'NOLINEBREAK'[^\r\n]*)
                   (?'LINEBREAK'\r?\n|\r)
               )
               (?'METHODBODY'
                   (?'LINE'
                       (?'NOLINEBREAK'[^\r\n]*)
                       (?'LINEBREAK'\r?\n|\r)
                   )*?
               )
               (?'METHODFOOTER'
                   (?'OPTBLANK'[\t ]*)
                   (?-i:\bend\b)
                   (?'NOLINEBREAK'[^\r\n]*)
                   (?'LINEBREAK'\r?\n|\r)
               )
           )
       )*?
       (?'CLASSFOOTER'
           (?'OPTBLANK'[\t ]*)
           (?-i:\bend\b)
           (?'NOLINEBREAK'[^\r\n]*)
           (?:
               (?'LINEBREAK'\r?\n|\r)
           |
               $
           )
       )
   )

   ~~~~~

   [\t ]*(?-i:\bclass\b)[\t ]+
   \b
   (?'clid'
       \b(?!(?-i:(?:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b))
       [A-Za-z_]\w*
   )
   \b
   [^\r\n]*(?:\r?\n|\r)
   (?:
       (?'sl'[\t ]*#[^\r\n]*(?:\r?\n|\r))
   |
       (?'ml'(?-i:=begin\b)(?:[\t ][^\r\n]+)?(?:\r?\n|\r)(?:[^\r\n]*(?:\r?\n|\r))*?(?-i:=end\b))
   |
       (?'bl'[\t ]*(?:\r?\n|\r))
   |
       (?'vl'
           [\t ]*
           \b
           (?'vid'
               \$
               (?:
                   \b(?!(?-i:(?:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b))
                   [A-Za-z_]\w*
               |-.|.
               )
           |
               @{0,2}
               \b(?!(?-i:(?:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b))
               [A-Za-z_]\w*
           )
           \b
           [^\r\n]*(?:\r?\n|\r)
       )
   |
       (?'mt'
           [\t ]*(?-i:\bdef\b)[\t ]+
           (?'mtid'
               \b(?!(?-i:(?:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b))
               [A-Za-z_]\w*[?!=]?|:{2}|\*{1,2}|![=~]?|=(?:~|={1,2})?|[~+\-/%&|\^]|<(?:<|=>?)?|>[>=]?|\[]=?
           )
           (?:[^\r\n]*(?:\r?\n|\r))+?
           [\t ]*(?-i:\bend\b)[^\r\n]*(?:\r?\n|\r)
       )
   )*?
   [\t ]*(?-i:\bend\b)[^\r\n]*(?:\r?\n|\r|$)

Function=

   (?'function'
       [\t ]*(?-i:\balias\b)
       (?:
           [\t ]+
           \b(?!(?-i:(?:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b))
           (?:[A-Za-z_]\w*)
       ){2}
       [^\r\n]*(?:\r?\n|\r|$)
   |
       [\t ]*(?-i:\bdef\b)[\t ]+
       \b(?!(?-i:(?:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b))
       (?:[A-Za-z_]\w*[?!=]?(?:[\t ]*\([^)]*\))?|(?::{2}|\*{1,2}|![=~]?|=(?:~|={1,2})?|[~+\-/%&amp;|\^]|&lt;(?:&lt;|=&gt;?)?|&gt;[&gt;=]?|\[]=?)[\t ]*\([^)]*\))
       (?:[^\r\n]*(?:\r?\n|\r))+?
       [\t ]*(?-i:\bend\b)
       [^\r\n]*(?:\r?\n|\r|$)
   )

   (?'function'[\t ]*(?-i:\balias\b)(?:[\t ]+\b(?!(?-i:(?:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b))(?:[A-Za-z_]\w*)){2}[^\r\n]*(?:\r?\n|\r|$)|[\t ]*(?-i:\bdef\b)[\t ]+\b(?!(?-i:(?:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)\b))(?:[A-Za-z_]\w*[?!=]?(?:[\t ]*\([^)]*\))?|(?::{2}|\*{1,2}|![=~]?|=(?:~|={1,2})?|[~+\-/%&amp;|\^]|&lt;(?:&lt;|=&gt;?)?|&gt;[&gt;=]?|\[]=?)[\t ]*\([^)]*\))(?:[^\r\n]*(?:\r?\n|\r))+?[\t ]*(?-i:\bend\b)[^\r\n]*(?:\r?\n|\r|$))

       <nameExpr expr="(?&lt;=alias)(?:[\t ]+[A-Za-z_]\w*)|(?&lt;=def)[\t ]+(?:[A-Za-z_]\w*[?!=]?(?:[\t ]*\()?|(?::{2}|\*{1,2}|![=~]?|=(?:~|={1,2})?|[~+\-/%&amp;|\^]|&lt;(?:&lt;|=&gt;?)?|&gt;[&gt;=]?|\[]=?)[\t ]*\()" />
       <nameExpr expr="(?:[A-Za-z_]\w*[?!=]?|(?::{2}|\*{1,2}|![=~]?|=(?:~|={1,2})?|[~+\-/%&amp;|\^]|&lt;(?:&lt;|=&gt;?)?|&gt;[&gt;=]?|\[]=?))" />

Grammar=

   Pseudo BNF Syntax of Ruby

   For more detail, see parse.y in Ruby distribution.

   PROGRAM                 : COMPOSITE_STATEMENT

   COMPOSITE_STATEMENT     : STATEMENT (TERMINATOR EXPRESSION)* [TERMINATOR]

   STATEMENT               : CALL do [`|' [BLOCK_VARIABLE] `|'] COMPOSITE_STATEMENT end
                           | undef FUNCTION_NAME
                           | alias FUNCTION_NAME FUNCTION_NAME
                           | STATEMENT if EXPRESSION
                           | STATEMENT while EXPRESSION
                           | STATEMENT unless EXPRESSION
                           | STATEMENT until EXPRESSION
                           | `BEGIN' `{' COMPOSITE_STATEMENT `}'
                           | `END' `{' COMPOSITE_STATEMENT `}'
                           | LHS `=' COMMAND [do [`|' [BLOCK_VARIABLE] `|'] COMPOSITE_STATEMENT end]
                           | EXPRESSION

   EXPRESSION              : MLHS `=' MRHS
                           | return CALL_ARGUMENTS
                           | yield CALL_ARGUMENTS
                           | EXPRESSION and EXPRESSION
                           | EXPRESSION or EXPRESSION
                           | not EXPRESSION
                           | COMMAND
                           | `!' COMMAND
                           | ARGUMENT

   CALL                    : FUNCTION
                           | COMMAND

   COMMAND                 : OPERATION CALL_ARGUMENTS
                           | PRIMARY `.' OPERATION CALL_ARGUMENTS
                           | PRIMARY `::' OPERATION CALL_ARGUMENTS
                           | super CALL_ARGUMENTS

   FUNCTION                : OPERATION [`(' [CALL_ARGUMENTS] `)']
                           | PRIMARY `.' OPERATION `(' [CALL_ARGUMENTS] `)'
                           | PRIMARY `::' OPERATION `(' [CALL_ARGUMENTS] `)'
                           | PRIMARY `.' OPERATION
                           | PRIMARY `::' OPERATION
                           | super `(' [CALL_ARGUMENTS] `)'
                           | super

   ARGUMENT                : LHS `=' ARGUMENT
                           | LHS ASSIGNMENT_OPERATOR ARGUMENT
                           | ARGUMENT `..' ARGUMENT
                           | ARGUMENT `...' ARGUMENT
                           | ARGUMENT `+' ARGUMENT
                           | ARGUMENT `-' ARGUMENT
                           | ARGUMENT `*' ARGUMENT
                           | ARGUMENT `/' ARGUMENT
                           | ARGUMENT `%' ARGUMENT
                           | ARGUMENT `**' ARGUMENT
                           | `+' ARGUMENT
                           | `-' ARGUMENT
                           | ARGUMENT `|' ARGUMENT
                           | ARGUMENT `^' ARGUMENT
                           | ARGUMENT `&' ARGUMENT
                           | ARGUMENT `<=>' ARGUMENT
                           | ARGUMENT `>' ARGUMENT
                           | ARGUMENT `>=' ARGUMENT
                           | ARGUMENT `<' ARGUMENT
                           | ARGUMENT `<=' ARGUMENT
                           | ARGUMENT `==' ARGUMENT
                           | ARGUMENT `===' ARGUMENT
                           | ARGUMENT `!=' ARGUMENT
                           | ARGUMENT `=~' ARGUMENT
                           | ARGUMENT `!~' ARGUMENT
                           | `!' ARGUMENT
                           | `~' ARGUMENT
                           | ARGUMENT `<<' ARGUMENT
                           | ARGUMENT `>>' ARGUMENT
                           | ARGUMENT `&&' ARGUMENT
                           | ARGUMENT `||' ARGUMENT
                           | defined? ARGUMENT
                           | PRIMARY

   PRIMARY                 : `(' COMPOSITE_STATEMENT `)'
                           | LITERAL
                           | VARIABLE
                           | PRIMARY `::' IDENTIFIER
                           | `::' IDENTIFIER
                           | PRIMARY `[' [ARGUMENTS] `]'
                           | `[' [ARGUMENTS [`,']] `]'
                           | `{' [(ARGUMENTS|ASSOCIATIONS) [`,']] `}'
                           | return [`(' [CALL_ARGUMENTS] `)']
                           | yield [`(' [CALL_ARGUMENTS] `)']
                           | defined? `(' ARGUMENT `)'
                           | FUNCTION
                           | FUNCTION `{' [`|' [BLOCK_VARIABLE] `|'] COMPOSITE_STATEMENT `}'
                           | if EXPRESSION THEN
                             COMPOSITE_STATEMENT
                             (elsif EXPRESSION THEN COMPOSITE_STATEMENT)*
                             [else COMPOSITE_STATEMENT]
                             end
                           | unless EXPRESSION THEN
                             COMPOSITE_STATEMENT
                             [else COMPOSITE_STATEMENT]
                             end
                           | while EXPRESSION DO COMPOSITE_STATEMENT end
                           | until EXPRESSION DO COMPOSITE_STATEMENT end
                           | case COMPOSITE_STATEMENT
                             (when WHEN_ARGUMENTS THEN COMPOSITE_STATEMENT)+
                             [else COMPOSITE_STATEMENT]
                             end
                           | for BLOCK_VARIABLE in EXPRESSION DO
                             COMPOSITE_STATEMENT
                             end
                           | begin
                             COMPOSITE_STATEMENT
                             [rescue [ARGUMENTS] DO COMPOSITE_STATEMENT]+
                             [else COMPOSITE_STATEMENT]
                             [ensure COMPOSITE_STATEMENT]
                             end
                           | class IDENTIFIER [`<' IDENTIFIER]
                             COMPOSITE_STATEMENT
                             end
                           | module IDENTIFIER
                             COMPOSITE_STATEMENT
                             end
                           | def FUNCTION_NAME ARGUMENT_DECLARATION
                             COMPOSITE_STATEMENT
                             end
                           | def SINGLETON (`.'|`::') FUNCTION_NAME ARGUMENT_DECLARATION
                             COMPOSITE_STATEMENT
                             end

   WHEN_ARGUMENTS          : ARGUMENTS [`,' `*' ARGUMENT]
                           | `*' ARGUMENT

   THEN                    : TERMINATOR
                           | then
                           | TERMINATOR then

   DO                      : TERMINATOR
                           | do
                           | TERMINATOR do

   BLOCK_VARIABLE          : LHS
                           | MLHS

   MLHS                    : MLHS_ITEM `,' [MLHS_ITEM (`,' MLHS_ITEM)*] [`*' [LHS]]
                           | `*' LHS

   MLHS_ITEM               : LHS
                           | '(' MLHS ')'

   LHS                     : VARIABLE
                           | PRIMARY `[' [ARGUMENTS] `]'
                           | PRIMARY `.' IDENTIFIER

   MRHS                    : ARGUMENTS [`,' `*' ARGUMENT]
                           | `*' ARGUMENT

   CALL_ARGUMENTS          : ARGUMENTS
                           | ARGUMENTS [`,' ASSOCIATIONS] [`,' `*' ARGUMENT] [`,' `&' ARGUMENT]
                           | ASSOCIATIONS [`,' `*' ARGUMENT] [`,' `&' ARGUMENT]
                           | `*' ARGUMENT [`,' `&' ARGUMENT]
                           | `&' ARGUMENT
                           | COMMAND

   ARGUMENTS               : ARGUMENT (`,' ARGUMENT)*

   ARGUMENT_DECLARATION    : `(' ARGUMENT_LIST `)'
                           | ARGUMENT_LIST TERMINATOR

   ARGUMENT_LIST           : IDENTIFIER (`,' IDENTIFIER)* [`,' `*'[IDENTIFIER] ] [`,' `&'IDENTIFIER]
                           | `*'IDENTIFIER [`,' `&'IDENTIFIER]
                           | [`&'IDENTIFIER]

   SINGLETON               : VARIABLE
                           | `(' EXPRESSION `)'

   ASSOCIATIONS            : ASSOCIATION (`,' ASSOCIATION)*

   ASSOCIATION             : ARGUMENT `=>' ARGUMENT

   VARIABLE                : VARIABLE_NAME
                           | nil
                           | self

   LITERAL                 : numeric
                           | SYMBOL
                           | STRING
                           | STRING2
                           | HERE_DOC
                           | REGEXP

   TERMINATOR              : `;'
                           | `\n'

   The following are recognized by the lexical analizer.


   ASSIGNMENT_OPERATOR     : `+=' | `-=' | `*=' | `/=' | `%=' | `**='
                           | `&=' | `|=' | `^=' | `<<=' | `>>='
                           | `&&=' | `||='

   SYMBOL                  : `:'FUNCTION_NAME
                           | `:'VARIABLE_NAME

   FUNCTION_NAME           : IDENTIFIER | `..' | `|' | `^' | `&'
                           | `<=>' | `==' | `===' | `=~'
                           | `>' | `>=' | `<' | `<='
                           | `+' | `-' | `*' | `/' | `%' | `**'
                           | `<<' | `>>' | `~'
                           | `+@' | `-@' | `[]' | `[]='

   OPERATION               : IDENTIFIER
                           | IDENTIFIER'!'
                           | IDENTIFIER'?'

   VARIABLE_NAME           : GLOBAL
                           | `@'IDENTIFIER
                           | IDENTIFIER

   GLOBAL                  : `$'IDENTIFIER
                           | `$'any_char
                           | `$''-'any_char

   STRING                  : `"' any_char* `"'
                           | `'' any_char* `''
                           | ``' any_char* ``'

   STRING2                 : `%'(`Q'|`q'|`x')char any_char* char

   HERE_DOC                : `<<'(IDENTIFIER|STRING)
                             any_char*
                             IDENTIFIER

   REGEXP                  : `/' any_char* `/'[`i'|`o'|`p']
                           | `%'`r' char any_char* char

   IDENTIFIER is the sequence of characters in the pattern of /[a-zA-Z_][a-zA-Z0-9_]*/.

