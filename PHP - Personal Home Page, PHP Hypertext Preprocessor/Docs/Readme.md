
# PHP

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
[PHP] --------------------------------------------------------------------------
@=Personal Home Page | PHP: Hypertext Preprocessor

_WWW_=https://php.net/

_Wiki_=https://en.wikipedia.org/wiki/PHP

Keywords=

   In PHP, all keywords (e.g. if, else, while, echo, etc.), classes, functions,
   and user-defined functions are NOT case-sensitive.

   PHP Keywords

       __halt_compiler()
       abstract  and  array()  as
       break
       callable  case  catch  class  clone  const  continue
       declare  default  die()  do
       echo  else  elseif  empty()  enddeclare  endfor  endforeach  endif  endswitch  endwhile  eval()  exit()  extends
       final  finally  for  foreach  function
       global  goto
       if  implements  include  include_once  instanceof  insteadof  interface  isset()
       list()
       namespace  new
       or
       print  private  protected  public
       require  require_once  return
       static  switch
       throw  trait  try
       unset()  use
       var
       while
       xor
       yield

   Compile-time constants:

       __CLASS__  __DIR__  __FILE__  __FUNCTION__  __LINE__  __METHOD__  __NAMESPACE__  __TRAIT__

   Other reserved words (as of PHP 7)

       bool  false  float  int  null  string  true

   Soft reserved words resource (as of PHP 7)

       mixed  numeric  object


   A RegEx to find them all:

       \b(?!(?-i:
           a(?:bstract|nd|rray|s)
       |   b(?:ool|reak)
       |   c(?:a(?:llable|se|tch)|l(?:ass|one)|on(?:st|tinue))
       |   d(?:e(?:clare|fault)|ie|o)
       |   e(?:cho|lse(?:if)?|mpty|nd(?:declare|for(?:each)?|if|switch|while)|val|x(?:it|tends))
       |   f(?:alse|loat|inal|or(?:each)?|unction)
       |   g(?:lobal|oto)
       |   i(?:f|mplements|n(?:clude(?:_once)?|st(?:anceof|eadof)|t(?:erface)?)|sset)
       |   list
       |   mixed
       |   n(?:amespace|ew|u(?:ll|meric))
       |   o(?:r|bject)
       |   p(?:r(?:i?:(nt|vate)|otected)|ublic)
       |   re(?:quire(?:_once)?|turn)
       |   s(?:t(?:atic|ring)|witch)
       |   t(?:hrow|r(?:ait|ue|y))
       |   u(?:nset|se)
       |   var
       |   while
       |   xor
       |   __(?:halt_compiler|(?:CLASS|DIR|F(?:ILE|UNCTION)|LINE|METHOD|NAMESPACE|TRAIT)__)
       )\b)

Identifiers=

   [a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*
   [a-zA-Z_\x7f-\xff][\w\x7f-\xff]*

StringLiterals=

   Single quoted

       To specify a literal single quote, escape it with a backslash (\). To
       specify a literal backslash, double it (\\). All other instances of
       backslash will be treated as a literal backslash: this means that
       the other escape sequences you might be used to, such as \r or \n,
       will be output literally as specified rather than having any special
       meaning.

       (?'SLSQ'(?s)&apos;(?:[^&apos;\\]|\\.)*&apos;)

   Double quoted

       If the string is enclosed in double-quotes ("), PHP will interpret
       the following escape sequences for special characters:

       Escaped characters Sequence     Meaning
       \n                              linefeed (LF or 0x0A (10) in ASCII)
       \r                              carriage return (CR or 0x0D (13) in ASCII)
       \t                              horizontal tab (HT or 0x09 (9) in ASCII)
       \v                              vertical tab (VT or 0x0B (11) in ASCII) (since PHP 5.2.5)
       \e                              escape (ESC or 0x1B (27) in ASCII) (since PHP 5.4.4)
       \f                              form feed (FF or 0x0C (12) in ASCII) (since PHP 5.2.5)
       \\                              backslash
       \$                              dollar sign
       \"                              double-quote
       \[0-7]{1,3}                     the sequence of characters matching the regular expression
                                           is a character in octal notation, which silently
                                           overflows to fit in a byte (e.g. "\400" === "\000")
       \x[0-9A-Fa-f]{1,2}              the sequence of characters matching the regular expression
                                           is a character in hexadecimal notation
       \u{[0-9A-Fa-f]+}                the sequence of characters matching the regular expression
                                           is a Unicode codepoint, which will be output to
                                           the string as that codepoint's UTF-8 representation
                                           (added in PHP 7.0.0)

       As in single quoted strings, escaping any other character will result
       in the backslash being printed too.

       (?'SLDQ'(?s)&quot;(?:[^&quot;\\]|\\.)*&quot;)


   https://en.wikipedia.org/wiki/Here_document

   HereDoc syntax

       A third way to delimit strings is the heredoc syntax: <<<. After this
       operator, an identifier is provided, then a newline. The string itself
       follows, and then the same identifier again to close the quotation.

       The closing identifier must begin in the first column of the line.
       Also, the identifier must follow the same naming rules as any other
       label in PHP: it must contain only alphanumeric characters and
       underscores, and must start with a non-digit character or underscore.

       Heredoc text behaves just like a double-quoted string, without
       the double quotes. This means that quotes in a heredoc do not need to
       be escaped, but the escape codes listed above can still be used.

       (?'HEREDOC'
           &lt;{3}(?'HDID'[A-Za-z_\x7f-\xff][\w\x7f-\xff]*)[^\r\n]*\R
           (?s:.*?)
           \R\k'HDID'               # close with exactly same identifier in the first column
       )

   NowDoc syntax

       Nowdocs are to single-quoted strings what heredocs are to double-quoted
       strings. A nowdoc is specified similarly to a heredoc, but no parsing is
       done inside a nowdoc.

       A nowdoc is identified with the same <<< sequence used for heredocs,
       but the identifier which follows is enclosed in single quotes,
       e.g. <<<'EOT'. All the rules for heredoc identifiers also apply to
       nowdoc identifiers, especially those regarding the appearance of
       the closing identifier.

       (?'NOWDOC'
           &lt;{3}&apos;(?'NDID'[A-Za-z_\x7f-\xff][\w\x7f-\xff]*)&apos;[^\r\n]*\R
           (?s:.*?)
           \R\k'NDID'               # close with exactly same identifier in the first column
       )

Comment=

   Single line comment:

       # This is a one-line shell-style (Perl style) comment
       // This is a one-line c++ style comment

       (?'SLC'(?m-s)(?:#|/{2}).*$)

   Basic syntax for multi-line comments:

       /*
       Here are my comments
       this is multi-line
       */

       Note that; it is more common to see phpDocumentor styled multi-lined
       comments:

       /**
        * phpdoc Comments
        * @todo this is a todo stub
        */

       (?'MLC'(?s-m)/\*.*?\*/)

Classes_and_Methods=

   Basic class definitions begin with the keyword class, followed by a class
   name, followed by a pair of curly braces which enclose the definitions of
   the properties and methods belonging to the class.

   The class name can be any valid label, provided it is not a PHP reserved
   word. A valid class name starts with a letter or underscore, followed by
   any number of letters, numbers, or underscores. As a regular expression,
   it would be expressed thus: ^[a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*$

       class Foo

   A class can inherit the methods and properties of another class by using
   the keyword extends in the class declaration. It is not possible to extend
   multiple classes; a class can only inherit from one base class.

       class ExtendClass extends SimpleClass

       abstract class AbstractClass

       public function PublicMethod()
       protected function ProtectedMethod()
       private function PrivateMethod()

       abstract public function AbstractPublicMethod()
       abstract protected function AbstractProtectedMethod()
       abstract private function AbstractPrivateMethod()

       interface iTemplate
       class Template implements iTemplate

       interface iA
       interface iB extends iA
       interface iC extends iA, iB
       class cD implements iB
       class cE implements iC

Function=

   A function name can start with a letter or underscore (not a number).

       function functionName()
       {
           code to be executed;
       }

   In the example below, we create a function named "writeMsg()". The opening curly
   brace ( { ) indicates the beginning of the function code and the closing curly
   brace ( } ) indicates the end of the function. The function outputs
   "Hello world!". To call the function, just write its name:

       function writeMsg()
       {
           echo "Hello world!";
       }

       function familyName($fname)
       {
           echo "$fname Refsnes.<br>";
       }

       function familyName($fname,$year)
       {
           echo "$fname Refsnes. Born in $year <br>";
       }

       function setHeight($minheight=50)
       {
           echo "The height is : $minheight <br>";
       }

       function foo($arg_1, $arg_2, /* ..., */ $arg_n)
       {
           echo "Example function.\n";
           return $retval;
       }


   Information may be passed to functions via the argument list, which is
   a comma-delimited list of expressions. The arguments are evaluated from
   left to right.

   PHP supports passing arguments by value (the default), passing by reference,
   and default argument values. Variable-length argument lists are also supported

   To have an argument to a function always passed by reference, prepend
   an ampersand (&) to the argument name in the function definition.

       function add_some_extra(&$string)

   A function may define C++-style default values for scalar arguments.
   PHP also allows the use of arrays and the special type NULL as default values.
   The default value must be a constant expression, not (for example)
   a variable, a class member or a function call.

       function makecoffee($types = array("cappuccino"), $coffeeMaker = NULL)

   Note that when using default arguments, any defaults should be on the right
   side of any non-default arguments; otherwise, things will not work as expected.

       function makeyogurt($type = "acidophilus", $flavour)    // incorrect
       function makeyogurt($flavour, $type = "acidophilus")    // correct

   In PHP 5.6 and later, argument lists may include the ... token to denote
   that the function accepts a variable number of arguments. The arguments
   will be passed into the given variable as an array.

       function sum(...$numbers)

   You may specify normal positional arguments before the ... token. In this
   case, only the trailing arguments that don't match a positional argument
   will be added to the array generated by ....
   It is also possible to add a type hint before the ... token. If this is
   present, then all arguments captured by ... must be objects of the hinted class.

       function total_intervals($unit, DateInterval ...$intervals)

   PHP 7

       function functionName ( argumentType argumentName ) : returnType

Grammar=

