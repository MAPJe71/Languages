{

    continue break return goto default 
    for do while switch case 
    if else 
    throw throws try catch finally 
    package import 

    assert def new 

    void 
    boolean 
    byte char short int long 
    float double 
    class interface trait 

    this super 

    as in instanceof extends implements 

    private protected public 
    const static final abstract volatile 
    native synchronized threadsafe transient 

    false null true 

    abs any append asList asWritable
    call collect compareTo count
    div dump
    each eachByte eachFile eachLine every
    find findAll flatten
    getAt getErr getIn getOut getText grep
    immutable inject inspect intersect invokeMethods isCase
    join
    leftShift
    minus multiply
    newInputStream newOutputStream newPrintWriter newReader newWriter next
    plus pop power previous print println push putAt
    read readBytes readLines reverse reverseEach round
    size sort splitEachLine step subMap
    times toInteger toList tokenize
    upto
    waitForOrKill withPrintWriter withReader withStream withWriter withWriterAppend write writeLine

    % += ++ + -= -- -> - /= / **= *= *: ** * === ==~ == =~ != ! <= < >= > && & || | ?. ?: ? : .. . ^
    as in instanceof extends implements

}

// Normal arithmetic operators
//      + - * / % **

assert  1  + 2 == 3
assert  4  - 3 == 1
assert  3  * 5 == 15
assert  3  / 2 == 1.5
assert 10  % 3 == 1
assert  2 ** 3 == 8


// Unary operators
//      + -

assert +3 == 3
assert -4 == 0 - 4

assert -(-1) == 1

def a = 2
def b = a++ * 3

assert a == 3 && b == 6

def c = 3
def d = c-- * 2

assert c == 2 && d == 6

def e = 1
def f = ++e + 3

assert e == 2 && f == 5

def g = 4
def h = --g + 1

assert g == 3 && h == 4


// Assignment arithmetic operators
//      += -= *= /= %= **=

def a = 4
a += 3

assert a == 7

def b = 5
b -= 3

assert b == 2

def c = 5
c *= 3

assert c == 15

def d = 10
d /= 2

assert d == 5

def e = 10
e %= 3

assert e == 1

def f = 3
f **= 2

assert f == 9


// Relational operators
//      == != < <= > >=

assert 1 + 2 == 3
assert 3 != 4

assert -2 < 3
assert 2 <= 2
assert 3 <= 4

assert 5 > 1
assert 5 >= -2


// Logical operators
//      && || !

assert !false
assert true && true
assert true || false


// Bitwise operators
//      & | ^ ~

int a = 0b00101010
assert a == 42
int b = 0b00001000
assert b == 8
assert (a & a) == a
assert (a & b) == b
assert (a | a) == a
assert (a | b) == a

int mask = 0b11111111
assert ((a ^ a) & mask) == 0b00000000
assert ((a ^ b) & mask) == 0b00100010
assert ((~a) & mask)    == 0b11010101


// Ternary operator
//      ? :

result = (string!=null && string.length()>0) ? 'Found' : 'Not found'

result = string ? 'Found' : 'Not found'


// Elvis operator
//      ?:

displayName = user.name ? user.name : 'Anonymous'   // Ternary operator
displayName = user.name ?: 'Anonymous'              // Elvis   operator

'single-quoted string'

// test

"double-quoted string"

// test

'''triple-single-quoted
string'''

// test

"""
triple-double-quoted
string
"""

// ## Identifiers
//
// ### Normal identifiers
//
// Identifiers start with a letter, a dollar or an underscore. They cannot start
// with a number.
//
// A letter can be in the following ranges:
//
//     'a' to 'z' (lowercase ascii letter)
//     'A' to 'Z' (uppercase ascii letter)
//     '\u00C0' to '\u00D6'
//     '\u00D8' to '\u00F6'
//     '\u00F8' to '\u00FF'
//     '\u0100' to '\uFFFE'
//
// Then following characters can contain letters and numbers.
//
// Here are a few examples of valid identifiers (here, variable names):

def name
def item3
def with_underscore
def $dollarStart

// But the following ones are invalid identifiers:

def 3tier
def a+b
def a#b

// All keywords are also valid identifiers when following a dot:

foo.as
foo.assert
foo.break
foo.case
foo.catch

// ### Quoted identifiers
//
// Quoted identifiers appear after the dot of a dotted expression. For instance,
// the name part of the person.name expression can be quoted with person."name" or
// person.'name'. This is particularly interesting when certain identifiers contain
// illegal characters that are forbidden by the Java Language Specification, but
// which are allowed by Groovy when quoted. For example, characters like a dash,
// a space, an exclamation mark, etc.

def map = [:]

map."an identifier with a space and double quotes" = "ALLOWED"
map.'with-dash-signs-and-single-quotes' = "ALLOWED"

assert map."an identifier with a space and double quotes" == "ALLOWED"
assert map.'with-dash-signs-and-single-quotes' == "ALLOWED"

// As we shall see in the following section on strings, Groovy provides different
// string literals. All kind of strings are actually allowed after the dot:

map.'single quote'
map."double quote"
map.'''triple single quote'''
map."""triple double quote"""
map./slashy string/
map.$/dollar slashy string/$

// There’s a difference between plain character strings and Groovy’s GStrings
// (interpolated strings), as in that the latter case, the interpolated values are
// inserted in the final string for evaluating the whole identifier:

def firstname = "Homer"
map."Simpson-${firstname}" = "Homer Simpson"

assert map.'Simpson-Homer' == "Homer Simpson"


// ## String Literals
//
// ### Single Quoted String

'a single-quoted string'

// ### Triple Single Quoted string

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


// ### Double Quoted string

"a double-quoted string"

// ### Triple Double Quoted string

def name = 'Groovy'
def template = """
    Dear Mr ${name},

    You're the winner of the lottery!

    Yours sincerly,

Dave
"""

assert template.toString().contains('Groovy')

// ### Slashy string
//
// Beyond the usual quoted strings, Groovy offers slashy strings, which use / as
// the opening and closing delimiter. Slashy strings are particularly useful for
// defining regular expressions and patterns, as there is no need to escape
// backslashes.
//
// Example of a slashy string:

def fooPattern = /.*foo.*/
assert fooPattern == '.*foo.*'

// Only forward slashes need to be escaped with a backslash:

def escapeSlash = /The character \/ is a forward slash/
assert escapeSlash == 'The character / is a forward slash'

// Slashy strings are multiline:

def multilineSlashy = /one
    two
    three/

assert multilineSlashy.contains('\n')

// Slashy strings can be thought of as just another way to define a GString but
// with different escaping rules. They hence support interpolation:

def color = 'blue'
def interpolatedSlashy = /a ${color} car/

assert interpolatedSlashy == 'a blue car'

// ### Dollar slashy string
//
// Dollar slashy strings are multiline GStrings delimited with an opening $/ and
// a closing /$. The escaping character is the dollar sign, and it can escape
// another dollar, or a forward slash. But both dollar and forward slashes don’t
// need to be escaped, except to escape the dollar of a string subsequence that
// would start like a GString placeholder sequence, or if you need to escape a
// sequence that would start like a closing dollar slashy string delimiter.
//
// Here’s an example:

def name = "Guillaume"
def date = "April, 1st"

def dollarSlashy = $/
    Hello $name,
    today we're ${date}
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



