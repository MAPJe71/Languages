
# AVS - AviSynth

## Description


## Links

_WWW_
http://avisynth.nl/

_Wiki_
http://avisynth.nl/index.php/Main_Page


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~
http://avisynth.nl/index.php/The_full_AviSynth_grammar#Keywords


## Identifiers
http://avisynth.nl/index.php/The_full_AviSynth_grammar#Identifiers

A variable name can be a character string of practically any length (more
than 4000 characters in Avisynth 2.56 and later) that contains (English)
letters, digits, and underscores (_), but no other characters. The name
cannot start with a digit.

You may use characters from your language system codepage (locale) in
strings and file names (ANSI 8 bit only, not Unicode).


## String Literals
http://avisynth.nl/index.php/The_full_AviSynth_grammar#Literals

a_string = "this is a string literal"
another_string = """this is a multiline
  string literal. Note that the 2nd line has leading spaces (which are included)
while this line has not. Also newlines are included in this type
  of strings"""

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment
http://avisynth.nl/index.php/The_full_AviSynth_grammar#Comments

Avisynth ignores anything from a '#' character to the end of that line. This
can be used to add comments to a script.

   # this is a comment

It is possible to add block and nested block comments in the following way:

   /*
   this is a
   block comment
   */

   /* this is a
       block comment
     [* this is
        a nested comment
        [* and another one *]
     *]
   */

Avisynth ignores anything from the __END__ keyword (with double underscores)
to the end of the script file.

   Version()
   __END__
   ReduceBy2()
   Result is not reduced and we can write any text here

### Single line comment

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function
An example of a simple user defined script function (here a custom filter,
ie a function returning a clip) immediately follows:

   function MuteRange(clip c, int fstart, int fend)
   {
       before = c.Trim(0, -fstart)
       current = c.Trim(fstart, fend)
       after = c.Trim(fend + 1, 0)
       audio = Dissolve(before, current.BlankClip, after, 3)
       return AudioDub(c, audio)
   }

User defined script functions start with the keyword function, followed by
the function name. The name of a script function follows the same naming
rules as script variables.

Immediately after the name, the function's argument list follows. The list
(which can be empty) consists of (expected argument's type - argument's
name) pairs. Argument type may be any of those supported by the scripting
language.

   function MuteRange(clip c, int fstart, int fend)

Then comes the function body, ie the code that is executed each time the
function is called. The arguments are accessed within the function body by
their names. The function body is contained within an opening and closing
brace pair { ... }.

   {
       before = c.Trim(0, -fstart)
       current = c.Trim(fstart, fend)
       after = c.Trim(fend + 1, 0)
       audio = Dissolve(before, current.BlankClip, after, 3)
       return AudioDub(c, audio)
   }


## Grammar

BNF | ABNF | EBNF | XBNF

http://avisynth.nl/index.php/The_full_AviSynth_grammar#Keywords

