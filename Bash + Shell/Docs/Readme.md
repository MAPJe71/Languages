
# Bash / Shell

## Description

Bourne-Again SHell

   bashing together the features of Bourne shell (.sh), C shell (.csh), and Korn shell (.ksh)

Unix Shells

    Bourne                      .sh
    Bourne Again Shell - Bash   .bsh
    Korn Shell                  .ksh
    C Shell                     .csh
    Remote Shell                .rsh
    Secure Shell                .ssh
    Tenex C Shell               .tcsh
    Perl-like shell             .psh


## Links

_WWW_
https://www.gnu.org/software/bash/manual/

_Wiki_
https://en.wikipedia.org/wiki/Bash_(Unix_shell)


## Keywords

    do  done  elif  else  esac  fi  for  function
    if  in  select  then  time  until  while

Special built-ins:
    : . break continue eval exec exit export readonly return
    set shift trap unset

~~~
   A RegEx to find them all:

       \b(?!(?-i:
           do(?:ne)?
       |   el(?:if|se)|esac
       |   f(?:i|or|unction)
       |   i[fn]
       |   select
       |   t(?:hen|ime)
       |   until
       |   while
       )\b)
~~~


## Identifiers
A word consisting solely of letters, numbers, and underscores, and beginning
with a letter or underscore. Names are used as shell variable and function
names. Also referred to as an identifier.

[A-Za-z_]\w*


## String Literals

### Single quoted
Enclosing characters in single quotes (‘'’) preserves the literal value
of each character within the quotes. A single quote may not occur
between single quotes, even when preceded by a backslash.

(?'STRLIT_SQ'(?s)&apos;[^&apos;]*&apos;)

### Double quoted
Enclosing characters in double quotes (‘"’) preserves the literal value
of all characters within the quotes, with the exception of ‘$’, ‘`’,
‘\’, and, when history expansion is enabled, ‘!’. The characters ‘$’ and
‘`’ retain their special meaning within double quotes (see Shell
Expansions). The backslash retains its special meaning only when
followed by one of the following characters: ‘$’, ‘`’, ‘"’, ‘\’, or
newline. Within double quotes, backslashes that are followed by one of
these characters are removed. Backslashes preceding characters without a
special meaning are left unmodified. A double quote may be quoted within
double quotes by preceding it with a backslash. If enabled, history
expansion will be performed unless an ‘!’ appearing in double quotes is
escaped using a backslash. The backslash preceding the ‘!’ is not
removed.

The special parameters ‘*’ and ‘@’ have special meaning when in double
quotes (see Shell Parameter Expansion).

(?'STRLIT_DQ'(?s)&quot;(?:[^&quot;\\]|\\.)*&quot;)

### Document String - Double or Single Triple-Quoted

### Backslash quoted

### Here String

   echo <<<HERESTR
           some
           text
   HERESTR

(?'HERESTR'
   &lt;{3}(?'ID'[A-Za-z_\x7f-\xff][\w\x7f-\xff]*\b)[^\r\n]*\R
   (?s:.*?)
   \R\k'ID'                        # close with exactly same identifier in the first column
)


## Comment
Certain pattern matching operations also use the


### Single line comment
Lines beginning with a # (with the exception of #!) are comments and will not be executed.

    # This line is a comment.

Comments may also occur following the end of a command.

    echo "A comment will follow." # Comment here.
    #                            ^ Note whitespace before

Comments may also follow whitespace at the beginning of a line.

    # A tab precedes this comment.

Comments may even be embedded within a pipe.

    initial=( `cat "$startfile" | sed -e '/#/d' | tr -d '\n' |\
    # Delete lines containing '#' comment character.
              sed -e 's/\./\. /g' -e 's/_/_ /g'` )

(?'SLC'(?-s)(?:^#[^!]|^[\t\x20]*#|[\t\x20]+#).*$)

Of course, a quoted or an escaped # in an echo statement does not begin a
comment. Likewise, a # appears in certain parameter-substitution constructs
and in numerical constant expressions.

   echo "The # here does not begin a comment."         --> covered by STRLIT_DQ
   echo 'The # here does not begin a comment.'         --> covered by STRLIT_SQ
   echo The \# here does not begin a comment.
   echo The # here begins a comment.                   --> covered by SLC

   echo ${PATH#*:}       # Parameter substitution, not a comment.
   echo $(( 2#101011 ))  # Base conversion, not a comment.

The standard quoting and escape characters (" ' \) escape the #.


### Multi line comment

### Block comment

### Java Doc

### Here Doc
   echo <<HEREDOC1
       some
       text
   HEREDOC1

   echo <<-HEREDOC2
           some
           text
       HEREDOC2

(?'HEREDOC'
   &lt;{2}(?'ID'[A-Za-z_\x7f-\xff][\w\x7f-\xff]*\b)[^\r\n]*\R
   (?s:.*?)
   \R\k'ID'                        # close with exactly same identifier in the first column
|
   &lt;{2}-(?'ID'[A-Za-z_\x7f-\xff][\w\x7f-\xff]*\b)[^\r\n]*\R
   (?s:.*?)
   \R[\t\x20]*\k'ID'               # close with exactly same identifier
)

### Now Doc


## Classes & Methods


## Function

Functions are declared using this syntax:

   name () compound-command [ redirections ]

or

   function name [()] compound-command [ redirections ]

                mainExpr="(?mx)
                        ^
                        [\t\x20]*
                        (?-i:function\s+)
                        (?'VALID_ID'
                            \b(?!(?-i:(do(ne)?)|(el(if|se)|esac)|(f(i|or|unction))|(if|in)|(select)|(t(hen|ime))|(until)|(while))\b)
                            [A-Za-z_]\w*                # valid identifier
                        )
                        (?:\s*\([^)]*?\))?              # parentheses and arguments optional
                        [^{}]*?\{                       # start of body
                    |
                        (?&amp;VALID_ID)
                        (?:\s*\([^)]*?\))               # parentheses required, arguments optional
                        [^{}]*?\{                       # start of body
					"

## Grammar

BNF | ABNF | EBNF | XBNF
