
# C++
`
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
[C++] --------------------------------------------------------------------------
@=C++

_WWW_=

_Wiki_=https://en.wikipedia.org/wiki/C%2B%2B

Keywords=

   C++11
       alignas alignof and and_eq asm auto bitand bitor bool break case catch char char16_t char32_t class compl const constexpr const_cast continue decltype default delete do double dynamic_cast else enum explicit export extern false float for friend goto if inline int long mutable namespace new noexcept not not_eq nullptr operator or or_eq private protected public register reinterpret_cast return short signed sizeof static static_assert static_cast struct switch template this thread_local throw true try typedef typeid typename union unsigned using virtual void volatile wchar_t while xor xor_eq

   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

StringLiterals=

   "   "

Comment=

   //
   /* */

Classes_and_Methods=

   Class-Range

   mainExpr="
       (?:^|(?<=[\r\n]))
       \s*
       (?-i:class|struct)
       \s+
       (?'classname'
           [A-Za-z_]\w*
       )
       (?'basetypes'
           \s*
           :
           \s*
           (?-i:public|protected|private)
           \s+
           [A-Za-z_]\w*
           (?'multi'
               \s*
               ,
               \s*
               (?-i:public|protected|private)
               \s+
               [A-Za-z_]\w*
           )*
       )?
       \s*
       \{
       "
   mainExpr="(?:^|(?<=[\r\n]))\s*(?:class|struct)\s+[A-Za-z_]\w*(?:\s*:\s*(?:public|protected|private)\s+[A-Za-z_]\w*(?:\s*,\s*(?:public|protected|private)\s+[A-Za-z_]\w*)*)?\s*\{"

   Class-Range Function

   mainExpr="
       (?:^|(?<=[\r\n]))
       \s*
       (
           (?-i:static|const|virtual)
           \s+
       )?
       (?'returntype'
           [A-Za-z_]\w*
           (
               \s+
               [A-Za-z_]\w*
           )?
           (
               \s+
               (?-i:const\s+)?
           |
               [*&]
               \s+
               (?-i:const\s+)?
           |
               \s+
               (?-i:const\s+)?
               [*&]
           |
               \s+
               (?-i:const\s+)?
               [*&]
               \s+
               (?-i:const\s+)?
           )
       )?
       (?'functionname'
           (?!
               (?-i:if|while|for|switch)
           )
           ~?[A-Za-z_]\w*
       )
       (?'arguments'
           \s*
           \(
           [^()]*
           \)
       )
       (?'base'
           (?'first'
               \s*
               :
               (?'firstname'
                   \s*
                   [A-Za-z_]\w*
               )
               (?'firstargs'
                   \s*
                   \(
                   [^()]*
                   \)
               )
           )
           (?'consecutive'
               \s*
               ,
               (?'consecname'
                   \s*
                   [A-Za-z_]\w*
               )
               (?'consecargs'
                   \s*
                   \(
                   [^()]*
                   \)
               )
           )*
       )?
       (?'suffix'
           \s+
           (?-i:const|throw)
       )?
       \s*
       \{
       "

Function=

   mainExpr="
       (?m)
       ^\h*
       (?:
           (?-i:static|const|virtual)
           \s+
       )?
       (?'returntype'
           [A-Za-z_]\w*
           (?:
               \s+
               [A-Za-z_]\w*
           )?
           (?:
               \s+
               (?:const\s+)?
           |
               [*&]
               \s+
               (?:const\s+)?
           |
               \s+
               (?:const\s+)?
               [*&]
           |
               \s+
               (?:const\s+)?
               [*&]
               \s+
               (?:const\s+)?
           )
       )?
       (?'classname'
           [A-Za-z_]\w*
           \s*
           :{2}
       )?
       (?'functionname'
           (?!
               (?-i:if|while|for|switch)\b
           )
           ~?[A-Za-z_]\w*
       )
       (?'arguments'
           \s*
           \(
           [^()]*
           \)
       )
       (?'suffix'
           \s+
           (?:const|throw)
       )?
       [^{;]*\{
       "

Grammar=

