
# Groovy

## Description

## Filename (extensions)

\*.groovy
\*.groovy.inc
\*.gvy
\*.gy
\*.gsh
\*.gradle
Jenkinsfile*


## Links

WWW

https://www.groovy-lang.org/
https://groovy-lang.org/syntax.html
https://groovy-lang.org/groovyconsole.html

https://groovy-playground.appspot.com/

Wiki

https://en.wikipedia.org/wiki/Apache_Groovy


## Keywords

as  assert
break
case  catch  class  const  continue
def  default  do
else  enum  extends
false  finally  for
goto
if  implements  import  in  instanceof  interface
new  null
package
return
super  switch
this  throw  throws  trait  true  try
while


abstract  as  assert
break
case  catch  continue
def  default  do
else  extends
false  final  finally  for
if  implements  import  in  instanceof  it
mixin
native  new  null
package  private  property  protected  public
return
static  strictfp  super switch  synchronized
test  this  throw  throws  transient  true  try
using
volatile
while

~~~
   A RegEx to find them all:

        \b(?!(?-i:
            as(?:sert)?
        |   break
        |   c(?:a(?:se|tch)|lass|on(?:st|tinue)?)
        |   d(?:ef(?:ault)?|o)
        |   e(?:lse|num|xtends)
        |   f(?:alse|inally|or)
        |   goto
        |   i(?:f|mp(?:lements|ort)|n(?:stanceof|terface)?)
        |   n(?:ew|ull)
        |   package
        |   return
        |   s(?:uper|witch)
        |   t(?:h(?:is|rows?)|r(?:ait|ue|y))
        |   while
        )\b)
~~~


## Identifiers

### Normal identifiers

Identifiers start with a letter, a dollar or an underscore. They cannot start
with a number.

A letter can be in the following ranges:

    'a' to 'z' (lowercase ascii letter)
    'A' to 'Z' (uppercase ascii letter)
    '\u00C0' to '\u00D6'
    '\u00D8' to '\u00F6'
    '\u00F8' to '\u00FF'
    '\u0100' to '\uFFFE'

Then following characters can contain letters and numbers.

Here are a few examples of valid identifiers (here, variable names):

def name
def item3
def with_underscore
def $dollarStart

But the following ones are invalid identifiers:

def 3tier
def a+b
def a#b

All keywords are also valid identifiers when following a dot:

foo.as
foo.assert
foo.break
foo.case
foo.catch

### Quoted identifiers

Quoted identifiers appear after the dot of a dotted expression. For instance,
the name part of the person.name expression can be quoted with person."name" or
person.'name'. This is particularly interesting when certain identifiers contain
illegal characters that are forbidden by the Java Language Specification, but
which are allowed by Groovy when quoted. For example, characters like a dash,
a space, an exclamation mark, etc.

def map = [:]

map."an identifier with a space and double quotes" = "ALLOWED"
map.'with-dash-signs-and-single-quotes' = "ALLOWED"

assert map."an identifier with a space and double quotes" == "ALLOWED"
assert map.'with-dash-signs-and-single-quotes' == "ALLOWED"

As we shall see in the following section on strings, Groovy provides different
string literals. All kind of strings are actually allowed after the dot:

map.'single quote'
map."double quote"
map.'''triple single quote'''
map."""triple double quote"""
map./slashy string/
map.$/dollar slashy string/$

There’s a difference between plain character strings and Groovy’s GStrings
(interpolated strings), as in that the latter case, the interpolated values are
inserted in the final string for evaluating the whole identifier:

def firstname = "Homer"
map."Simpson-${firstname}" = "Homer Simpson"

assert map.'Simpson-Homer' == "Homer Simpson"


## String Literals

### Single Quoted String

'a single-quoted string'

### Triple Single Quoted string

'''a triple-single-quoted string'''


def aMultilineString = '''line one
line two
line three'''


def startingAndEndingWithANewline = '''
line one
line two
line three
'''


def strippedFirstNewline = '''\
line one
line two
line three
'''

assert !strippedFirstNewline.startsWith('\n')


### Double Quoted string

"a double-quoted string"

### Triple Double Quoted string

def name = 'Groovy'
def template = """
    Dear Mr ${name},

    You're the winner of the lottery!

    Yours sincerly,

Dave
"""

assert template.toString().contains('Groovy')

### Slashy string

Beyond the usual quoted strings, Groovy offers slashy strings, which use / as
the opening and closing delimiter. Slashy strings are particularly useful for
defining regular expressions and patterns, as there is no need to escape
backslashes.

Example of a slashy string:

def fooPattern = /.*foo.*/
assert fooPattern == '.*foo.*'

Only forward slashes need to be escaped with a backslash:

def escapeSlash = /The character \/ is a forward slash/
assert escapeSlash == 'The character / is a forward slash'

Slashy strings are multiline:

def multilineSlashy = /one
    two
    three/

assert multilineSlashy.contains('\n')

Slashy strings can be thought of as just another way to define a GString but
with different escaping rules. They hence support interpolation:

def color = 'blue'
def interpolatedSlashy = /a ${color} car/

assert interpolatedSlashy == 'a blue car'

### Dollar slashy string

Dollar slashy strings are multiline GStrings delimited with an opening $/ and
a closing /$. The escaping character is the dollar sign, and it can escape
another dollar, or a forward slash. But both dollar and forward slashes don’t
need to be escaped, except to escape the dollar of a string subsequence that
would start like a GString placeholder sequence, or if you need to escape a
sequence that would start like a closing dollar slashy string delimiter.

Here’s an example:

def name = "Guillaume"
def date = "April, 1st"

def dollarSlashy = $/
    Hello $name,
    today we're ${date}.

$ dollar sign
    $$ escaped dollar sign
    \ backslash
    / forward slash
    $/ escaped forward slash
    $$$/ escaped opening dollar slashy
    $/$$ escaped closing dollar slashy
/$

assert [
    'Guillaume',
    'April, 1st',
    '$ dollar sign',
    '$ escaped dollar sign',
    '\\ backslash',
    '/ forward slash',
'/ escaped forward slash',
    '$/ escaped opening dollar slashy',
    '/$ escaped closing dollar slashy'
].every { dollarSlashy.contains(it) }



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

