
# Python

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
[Python] -----------------------------------------------------------------------
@=Python

_WWW_=https://www.python.org/

.py, .pyc, .pyd, .pyo (prior to 3.5), .pyw, .pyz (since 3.5)



_Wiki_=https://en.wikipedia.org/wiki/Python_(programming_language)

Keywords=

   and       as        assert    break     class     continue  def       del
   elif      else      except    exec      finally   for       from      global
   if        import    in        is        lambda    not       or        pass
   print     raise     return    try       while     with      yield

   A RegEx to find them all:

       \b(?!(?-i:
           a(?:nd|s(?:sert)?)
       |   break
       |   c(?:lass|ontinue)
       |   de[fl]
       |   el(?:if|se)|ex(?:cept|ec)
       |   f(?:inally|or|rom)
       |   global
       |   i(?:[fns]|mport)
       |   lambda
       |   not
       |   or
       |   p(?:ass|rint)
       |   r(?:aise|eturn)
       |   try
       |   w(?:hile|ith)
       |   yield
       )\b)

Identifiers=

   Identifiers (also referred to as names) are described by the following lexical definitions:

   identifier ::=  (letter|"_") (letter | digit | "_")*
   letter     ::=  lowercase | uppercase
   lowercase  ::=  "a"..."z"
   uppercase  ::=  "A"..."Z"
   digit      ::=  "0"..."9"

   Identifiers are unlimited in length. Case is significant.

StringLiterals=

Comment=

   Python uses the "#" symbol to mark it's comments. After placing a "#",
   everything to the right of it in that line will be ignored.

       # This is a comment
       foo = 5 # You can also append comments to statements

   Certain 'do nothing' expressions resemble comments

       """Un-assigned strings in triple-quotes might be used
          as multi-line comments
       """

       '''
          "triple quoted strings" can be delimited by either 'single' or "double" quote
          marks; and they can contain mixtures of other quote marks without any need to
          \escape\ them using any special characters.  They also may span multiple
          lines without special escape characters.
       '''

   Note that strings inserted among program statements in Python are treated as
   expressions (which, in void context, do nothing). Thus it's possible to "comment
   out" a section of code by simply wrapping the lines in "triple quotes" (three
   consecutive instances of quotation marks, or of apostrophes, and terminated with
   a matching set of the same).

   Documentation Strings

   Python makes pervasive use of strings which immediately follow class and
   function definition statements, and those which appear as the first non-blank,
   non-comment line in any module or program file. These are called "documentation"
   strings or "docstrings" for short; and they are automatically associated with
   the __doc__ attribute of the class, function, or module objects in which they
   are defined. Thus a fragment of code such as:

       #!/usr/bin/env python
       # Example of using doc strings
       """My Doc-string example"""

       class Foo:
            '''Some documentation for the Foo class'''
            def __init__(self):
               "Foo's initialization method's documentation"

       def bar():
           """documentation for the bar function"""

       if __name__ == "__main__":
           print (__doc__)
           print (Foo.__doc__)
           print (Foo.__init__.__doc__)
           print (bar.__doc__)

   ... would print each of the various documentation strings in this example. (In
   this particular example it would print two copies of the first doc string which
   because __doc__ in the "current" name space is the same as __main__.__doc__ when
   our program is running as a script). If some other script were to import this
   file (under the name "example" perhaps) then "My Doc-string example" would be
   the value of example.__doc__

   Python "docstrings" are used by a number of tools to automatically generate
   documentation (for most of the Python standard libraries, classes, functions,
   etc, as well as for user programs which define docstrings). They are also used
   by tools such as doctest to automatically derive test suites from properly
   formatted examples of class instantiations, function invocations and other usage
   samples. The standard pydoc utility can search through Python source trees
   generating documentation and can function as a local web server allowing a
   programmer to browse "live" hyperlinked documentation of their project.

   (As noted above extraneous strings interspersed throughout a Python source file
   can be used as comments, though this is rarely done in practice; only those
   strings which lexically follow the definition of a class, function, module or
   package are assigned to __doc__ attributes in their respective name spaces).


   (?'SLC'(?m)#[^\r\n]*(?:\r?\n|\r|$))

   (?'MLC'(?'TRIQUOTE'(?:'{3}|"{3})).*?\k'TRIQUOTE')

Classes_and_Methods=

   The simplest form of class definition looks like this:

       class ClassName:
           <statement-1>
           .
           .
           .
           <statement-N>

   The syntax for a derived class definition looks like this:

       class DerivedClassName(BaseClassName):
           <statement-1>
           .
           .
           .
           <statement-N>

   The name BaseClassName must be defined in a scope containing the derived class
   definition. In place of a base class name, other arbitrary expressions are also
   allowed. This can be useful, for example, when the base class is defined in
   another module:

       class DerivedClassName(modname.BaseClassName):

   Python supports a limited form of multiple inheritance as well.
   A class definition with multiple base classes looks like this:

       class DerivedClassName(Base1, Base2, Base3):
           <statement-1>
           .
           .
           .
           <statement-N>

   (?:^|(?&lt;=[\r\n]))
   (?'INDENT'
       \h*
   )
   (?-i:class)
   \h+
   (?'VALID_ID'                                    # ClassName
       [A-Za-z_]\w*
   )
   (?'BaseClasses'
       \(
       (?'FirstBaseClass'
           \h*
           (?:
               (?&VALID_ID)                        # FirstBaseClassModuleName
               \.
           )?
           (?&VALID_ID)                            # FirstBaseClassName
       )
       (?'ConsecutiveBaseClass
           \h*
           ,
           \h*
           (?:
               (?&VALID_ID)                        # ConsecutiveBaseClassModuleName
               \.
           )?
           (?&VALID_ID)                            # ConsecutiveBaseClassName
       )*
       \)
   )?
   \h*
   :
   [^\r\n]*
   \R
   (?'SUITE'
       \k'INDENT'
       \R
   |
       \k'INDENT'
       (?'DOC_COMMENT'
           (?'TQT'\x22{3}|\x27{3}).*?\k'TQT'
       )
       [^\r\n]*
       \R
   |
       \k'INDENT'
       [^\r\n]*
       \R
   )*

Function=

   The keyword def introduces a function definition. It must be followed by the
   function name and the parenthesized list of formal parameters. The statements
   that form the body of the function start at the next line, and must be indented.

       def multiply(a, b):
           return a * b

   Lambda function definition:

       multiply = lambda a, b: a * b

   A callable class definition allows functions and classes to use the same interface:

       class Multiply:
           def __init__(self):
               pass
           def __call__(self, a, b):
               return a * b

       multiply = Multiply()
       print multiply(2, 4)    # prints 8


<parser
    id          = "py_function"
    displayName = "Python class"
    commentExpr = "(#.*?$|'''.*?('''|\Z))"
    author      = "Artfunkel"
    >

    <classRange
        mainExpr="(?<=^class ).*?(?=\n\S|\Z)"
        >
        <className>
            <nameExpr expr="\w+(?=[\(|:])"/>
        </className>
        <function
            mainExpr="(?<=def ).+?(?=:)"
            >
            <functionName>
                <funcNameExpr expr=".*"/>
            </functionName>
        </function>
    </classRange>

    <function
        mainExpr="(?<=def ).+?(?=:)"
        >
        <functionName>
            <funcNameExpr expr=".*"/>
        </functionName>
    </function>

</parser>

<parser
    id          = "python_function"
    displayName = "Python class"
    commentExpr = "(#.*?$|'''.*?('''|\Z))"
    author      = "James (modified Artfunkel)"
    >

    <classRange
        mainExpr="(?<=^class ).*?(?=\n\S|\Z)"
        >
        <className>
            <nameExpr expr="\w+(?=[\(|:])"/>
        </className>
        <function
            mainExpr="(?<=def ).+?(?=:)"
            >
            <functionName>
                <funcNameExpr expr=".*"/>
            </functionName>
        </function>
    </classRange>

    <function
        mainExpr="(?<=def ).+?(?=:)"
        >
        <functionName>
            <funcNameExpr expr=".*"/>
        </functionName>
    </function>

</parser>

Known caveats:

    it does not do nested classes (noted in Artfunkel's original post)
    it does not show classes that do not have at least defined function,
       which isn't uncommon in Django where a model inherits functionality
       from a superclass and simply provides attributes and no functions of
       its own. It would be good if the functionlist would support showing
       and navigating to classes that have no functions

Grammar=
   classdef        : 'class' NAME ['(' [testlist] ')'] ':' suite
   funcdef         : 'def' NAME '(' [varargslist] ')' ':' suite

   suite           : simple_stmt | NEWLINE INDENT stmt+ DEDENT
   test            : or_test ['if' or_test 'else' test] | lambdef
   testlist        : test (',' test)* [',']

   varargslist     : ( (funcpardef ['=' test]  ',')* ('*' NAME [',' '**' NAME] | '**' NAME)
                     |  funcpardef ['=' test] (',' funcpardef ['=' test])* [',']            )
   funcpardef      : NAME | '(' funcparlist ')'
   funcparlist     : funcpardef (',' funcpardef)* [',']


