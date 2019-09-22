
# Octave

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
[OCTAVE] -----------------------------------------------------------------------
@=Octave is one of the major free alternatives to Matlab, others being Scilab and FreeMat

_WWW_=https://www.gnu.org/software/octave/

_Wiki_=https://en.wikipedia.org/wiki/GNU_Octave

Keywords=

    __FILE__            __LINE__                break
    case                catch                   classdef
    continue            do                      else
    elseif              end                     end_try_catch
    end_unwind_protect  endclassdef             endenumeration
    endevents           endfor                  endfunction
    endif               endmethods              endparfor
    endproperties       endswitch               endwhile
    enumeration         events                  for
    function            global                  if
    methods             otherwise               parfor
    persistent          properties              return
    switch              try                     until
    unwind_protect      unwind_protect_cleanup  while


   A RegEx to find them all:

        \b(?!(?-i:
            	__(?:FIL|LIN)E__
            |	break
            |	c(?:a(?:se|tch)|lassdef|ontinue)
            |	do
            |	e(?:lse(?:if)?|nd(?:_(?:try_catch|unwind_protect)|classdef|e(?:numeration|vents)|f(?:or|unction)|if|methods|p(?:arfor|roperties)|switch|while)?|numeration|vents)
            |	f(?:or|unction)
            |	global
            |	if
            |	methods
            |	otherwise
            |	p(?:arfor|ersistent|roperties)
            |	return
            |	switch
            |	try
            |	un(?:til|wind_protect(?:_cleanup)?)
            |	while
        )\b)

Identifiers=

StringLiterals=

A string constant consists of a sequence of characters enclosed in either double-quote or
single-quote marks. For example, both of the following expressions
    "parrot"
    ’parrot’
represent the string whose contents are ‘parrot’. Strings in Octave can be of any length.

Escape Sequences in String Constants

In double-quoted strings, the backslash character is used to introduce escape sequences that
represent other characters. For example, ‘\n’ embeds a newline character in a double-quoted
string and ‘\"’ embeds a double quote character. In single-quoted strings, backslash is not
a special character. Here is an example showing the difference:

    toascii ("\n")
        => 10
    toascii (’\n’)
        => [ 92 110 ]

In a single-quoted string there is only one escape sequence: you may insert a single quote
character using two single quote characters in succession. For example,

    ’I can’’t escape’
        => I can’t escape


Comment=

Single Line Comments

In the Octave language, a comment starts with either the sharp sign character, ‘#’, or the
percent symbol ‘%’ and continues to the end of the line. Any text following the sharp sign
or percent symbol is ignored by the Octave interpreter and not executed. The following
example shows whole line and partial line comments.

    function countdown
      # Count down for main rocket engines
      disp (3);
      disp (2);
      disp (1);
      disp ("Blast Off!"); # Rocket leaves pad
    endfunction

Block Comments

Entire blocks of code can be commented by enclosing the code between matching ‘#{’ and
‘#}’ or ‘%{’ and ‘%}’ markers. For example,

    function quick_countdown
      # Count down for main rocket engines
      disp (3);
     #{
      disp (2);
      disp (1);
     #}
      disp ("Blast Off!"); # Rocket leaves pad
    endfunction

will produce a very quick countdown from ’3’ to "Blast Off" as the lines "disp (2);"
and "disp (1);" won’t be executed.

The block comment markers must appear alone as the only characters on a line (excepting
whitespace) in order to be parsed correctly.


Classes_and_Methods=

    classdef some_class
        properties
        endproperties

        methods
        endmethods
    endclassdef


Function=

Grammar=

