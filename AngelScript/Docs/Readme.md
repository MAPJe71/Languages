
# Swift

## Description


## Links

_WWW_

https://swift.org/
https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/index.html#//apple_ref/doc/uid/TP40014097-CH3-ID0

_Wiki_

https://en.wikipedia.org/wiki/Swift_(programming_language)


## Keywords

   The following keywords are reserved and can’t be used as identifiers,
   unless they’re escaped with backticks, as described above in Identifiers.
   Keywords other than inout, var, and let can be used as parameter names in a
   function declaration or function call without being escaped with backticks.
   When a member has the same name as a keyword, references to that member
   don’t need to be escaped with backticks, except when there is ambiguity
   between referring to the member and using the keyword—for example, self,
   Type, and Protocol have special meaning in an explicit member expression,
   so they must be escaped with backticks in that context.

   Keywords used in declarations: associatedtype, class, deinit, enum,
   extension, fileprivate, func, import, init, inout, internal, let, open,
   operator, private, protocol, public, static, struct, subscript, typealias,
   and var.

   Keywords used in statements: break, case, continue, default, defer, do,
   else, fallthrough, for, guard, if, in, repeat, return, switch, where, and
   while.

   Keywords used in expressions and types: as, Any, catch, false, is, nil,
   rethrows, super, self, Self, throw, throws, true, and try.

   Keywords used in patterns: _.

   Keywords that begin with a number sign (#): #available, #colorLiteral,
   #column, #else, #elseif, #endif, #file, #fileLiteral, #function, #if,
   #imageLiteral, #line, #selector. and #sourceLocation.

   Keywords reserved in particular contexts: associativity, convenience,
   dynamic, didSet, final, get, infix, indirect, lazy, left, mutating, none,
   nonmutating, optional, override, postfix, precedence, prefix, Protocol,
   required, right, set, Type, unowned, weak, and willSet. Outside the context
   in which they appear in the grammar, they can be used as identifiers.

~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~


## Identifiers

   Identifiers begin with an uppercase or lowercase letter A through Z, an
   underscore (_), a noncombining alphanumeric Unicode character in the Basic
   Multilingual Plane, or a character outside the Basic Multilingual Plane
   that isn’t in a Private Use Area. After the first character, digits and
   combining Unicode characters are also allowed.

   To use a reserved word as an identifier, put a backtick (`) before and
   after it. For example, class is not a valid identifier, but `class` is
   valid. The backticks are not considered part of the identifier; `x` and x
   have the same meaning.

## String Literals

   A string literal is a sequence of characters surrounded by double quotes,
   with the following form:

       "characters"

   String literals cannot contain an unescaped double quote ("), an unescaped
   backslash (\), a carriage return, or a line feed.

   Special characters can be included in string literals using the following
   escape sequences:

       Null Character (\0)
       Backslash (\\)
       Horizontal Tab (\t)
       Line Feed (\n)
       Carriage Return (\r)
       Double Quote (\")
       Single Quote (\')

   Unicode scalar (\u{n}), where n is between one and eight hexadecimal digits

   The value of an expression can be inserted into a string literal by placing
   the expression in parentheses after a backslash (\). The interpolated
   expression can contain a string literal, but can’t contain an unescaped
   backslash (\), a carriage return, or a line feed.

   For example, all the following string literals have the same value:

       "1 2 3"
       "1 2 \("3")"
       "1 2 \(3)"
       "1 2 \(1 + 2)"
       let x = 3; "1 2 \(x)"

   The default inferred type of a string literal is String. For more
   information about the String type, see Strings and Characters and String
   Structure Reference.

   String literals that are concatenated by the + operator are concatenated at
   compile time. For example, the values of textA and textB in the example
   below are identical—no runtime concatenation is performed.

       let textA = "Hello " + "world"
       let textB = "Hello world"

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

   Single line comments begin with // and continue until a line feed (U+000A)
   or carriage return (U+000D). Multiline comments begin with /* and end with
   */. Nesting multiline comments is allowed, but the comment markers must be
   balanced.

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

https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/zzSummaryOfTheGrammar.html#//apple_ref/doc/uid/TP40014097-CH38-ID458
