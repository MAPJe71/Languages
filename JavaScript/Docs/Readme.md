
# JavaScript

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
[JavaScript] -------------------------------------------------------------------
@=J(?:ava)?Script

_WWW_=

_Wiki_=https://en.wikipedia.org/wiki/JavaScript

Keywords=

   http://www.w3schools.com/js/js_reserved.asp

   In JavaScript you cannot use these reserved words as variables, labels, or
   function names:

       abstract    arguments   boolean     break       byte
       case        catch       char        class*      const
       continue    debugger    default     delete      do
       double      else        enum*       eval        export*
       extends*    false       final       finally     float
       for         function    goto        if          implements
       import*     in          instanceof  int         interface
       let         long        native      new         null
       package     private     protected   public      return
       short       static      super*      switch      synchronized
       this        throw       throws      transient   true
       try         typeof      var         void        volatile
       while       with        yield

   Words marked with* are new in ECMAScript5

   ECMAScript 2018

       await
       break
       case catch class const continue
       debugger default delete do
       else enum export extends
       false finally for function
       if implements import in instanceof interface
       new null
       package private protected public
       return
       super switch
       this throw true try typeof
       var void
       while with
       yield

   JavaScript Objects, Properties, and Methods

   You should also avoid using the name of JavaScript built-in objects,
   properties, and methods:

       Array       Date        eval        function        hasOwnProperty
       Infinity    isFinite    isNaN       isPrototypeOf   length
       Math        NaN         name        Number          Object
       prototype   String      toString    undefined       valueOf


   Java Reserved Words

   JavaScript is often used together with Java. You should avoid using some
   Java objects and properties as JavaScript identifiers:

       getClass    java    JavaArray   javaClass   JavaObject  JavaPackage


   Windows Reserved Words

   JavaScript can be used outside HTML. It can be used as the programming
   language in many other applications.

   In HTML you must (for portability you should) avoid using the name of HTML
   and Windows objects and properties:

       alert           all                 anchor          anchors             area
       assign          blur                button          checkbox            clearInterval
       clearTimeout    clientInformation   close           closed              confirm
       constructor     crypto              decodeURI       decodeURIComponent  defaultStatus
       document        element             elements        embed               embeds
       encodeURI       encodeURIComponent  escape          event               fileUpload
       focus           form                forms           frame               innerHeight
       innerWidth      layer               layers          link                location
       mimeTypes       navigate            navigator       frames              frameRate
       hidden          history             image           images              offscreenBuffering
       open            opener              option          outerHeight         outerWidth
       packages        pageXOffset         pageYOffset     parent              parseFloat
       parseInt        password            pkcs11          plugin              prompt
       propertyIsEnum  radio               reset           screenX             screenY
       scroll          secure              select          self                setInterval
       setTimeout      status              submit          taint               text
       textarea        top                 unescape        untaint             window


   HTML Event Handlers

   In addition you should avoid using the name of all HTML event handlers.

   Examples:
       onblur     onclick     onerror      onfocus
       onkeydown  onkeypress  onkeyup      onmouseover
       onload     onmouseup   onmousedown  onsubmit


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

   JavaScript is case sensitive.

   Each identifier must start with a letter, the dollar sign ($) or the
   underscore character (_) and must never start with a digit (such as 0-1) or
   some of the other characters such as punctuation signs and a few others

StringLiterals=

   A string can be any text inside quotes. You can use single or double quotes
       var carname = "Volvo XC60";
       var carname = 'Volvo XC60';

   You can use quotes inside a string, as long as they don't match the quotes surrounding the string:
   Example
       var answer = "It's alright";
       var answer = "He is called 'Johnny'";
       var answer = 'He is called "Johnny"';

   The backslash escape character turns special characters into string characters:
   Example
       var x = 'It\'s alright';
       var y = "We are the so-called \"Vikings\" from the north."

Comment=

   Single Line Comments

       Single line comments start with //.
       Any text between // and the end of the line will be ignored by JavaScript (will not be executed).

   Multi-line Comments

       Multi-line comments start with /* and end with */.
       Any text between /* and */ will be ignored by JavaScript.

Classes_and_Methods=

Function=

   Objects are just data, with properties and methods.

   Properties are values associated with objects.

   Methods are actions that objects can perform.

   There are 2 different ways to create a new object:

       1. Define and create a direct instance of an object.
       2. Use a function to define an object, then create new object instances.

   Methods are just functions attached to objects.

   Defining methods to an object is done inside the constructor function:

   function person(firstname,lastname,age,eyecolor)
   {
       this.firstname=firstname;
       this.lastname=lastname;
       this.age=age;
       this.eyecolor=eyecolor;

       this.changeName=changeName;
       function changeName(name)
       {
           this.lastname=name;
       }
   }

   A function is written as a code block (inside curly { } braces), preceded by
   the function keyword:

       function functionname()
       {
       some code to be executed
       }

   When you call a function, you can pass along some values to it, these values
   are called arguments or parameters.

   These arguments can be used inside the function.

   You can send as many arguments as you like, separated by commas (,)

       function myFunction(var1,var2)
       {
       some code
       }

   Using a function declaration.

       function multiply(a,b) { return a*b }

   The same function can be defined using a function expression where you express
   a function as a value of a variable.

       var multiply = function (a, b) {
           return a * b;
       };

~~~~~~~~~~~~~~

   ----------
   Function Declaration

       function functionName(parameters) {
         code to be executed
       }

   Example:
       function myFunction(a, b) {
           return a * b;
       }

   ----------
   Function Expression

   Example:
       var x = function (a, b) {return a * b};
       var z = x(4, 3);

   ----------
   The Function() Constructor

   Example:
       var myFunction = new Function("a", "b", "return a * b");
       var x = myFunction(4, 3);

Grammar=

