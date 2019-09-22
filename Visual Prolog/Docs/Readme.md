
# Visual Prolog

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
[Visual Prolog] ----------------------------------------------------------------
@=

_WWW_=http://www.visual-prolog.com/default.htm

_Wiki_=

Keywords=

   align and anyflow as
   bitsize
   catch class clauses constants constructors
   delegate determ digits div do domains
   else elseif end erroneous externally
   facts failure finally foreach from
   goal guard
   if implement in inherits interface
   language
   mod monitor multi
   namespace nondeterm
   open or orelse
   predicates procedure properties
   quot
   rem resolve
   single supports
   then to try


   A RegEx to find them all:

       \b(?!(?-i:
       	a(?:lign|n(?:d|yflow)|s)
       |	bitsize
       |	c(?:atch|la(?:s|use)s|onst(?:ant|ructor)s)
       |	d(?:e(?:legate|term)|i(?:gits|v)|o(?:mains)?)
       |	e(?:lse(?:if)?|nd|rroneous|xternally)
       |	f(?:a(?:cts|ilure)|inally|oreach|rom)
       |	g(?:oal|uard)
       |	i(?:f|mplement|n(?:herits|terface)?)
       |	language
       |	m(?:o(?:d|nitor)|ulti)
       |	n(?:amespace|ondeterm)
       |	o(?:pen|r(?:else)?)
       |	pr(?:edicates|ocedure|operties)
       |	quot
       |	re(?:m|solve)
       |	s(?:ingle|upports)
       |	t(?:hen|o|ry)
       )\b)

Identifiers=http://wiki.visual-prolog.com/index.php?title=Language_Reference/Lexical_Elements#Identifiers

<Identifier> = <Prefix> <WordGroups> <Suffix>
<WordGroups> = <WordGroup> { ‘_’ <WordGroup> }*
<WordGroup> = <Word>+


http://wiki.visual-prolog.com/index.php?title=Language_Reference/Lexical_Elements#CommentsStringLiterals=http://wiki.visual-prolog.com/index.php?title=Language_Reference/Lexical_Elements#String_Literals

Comment=http://wiki.visual-prolog.com/index.php?title=Language_Reference/Lexical_Elements#Comments

A Visual Prolog comment is written in one of the following ways:

    The /* (slash, asterisk) characters, followed by any sequence of characters (including new lines), terminated by the */ (asterisk, slash) characters. These comments can be multi-lined. They can also be nested.
    The % (percent sign) character, followed by any sequence of characters. Comments that begin with character % (percent sign) continue until the end of the line. Therefore, they are commonly called single-line comments.

Notice the following comment example:

/* Begin of Comment1
   % Nested Comment2 */ Comment 1 is not terminated (single-line comment)
   This is the real termination of Comment1 */



String Literals

    StringLiteral:
       StringLiteralPart-list

    StringLiteralPart:
       ' <CharacterValue>-list-opt '
       " <CharacterValue>-list-opt "
       @AtOpenChar AnyCharacter-list-opt AtCloseChar

    A string literal consists of one or more StringLiteralPart's, which are concatenated.

    The first two forms (the ' and " forms) uses escape sequences to express certain characters

        \\ representing \
        \t representing Tab character
        \n representing New Line character
        \r representing carriage return
        \" representing double quote
        \' representing single quote
        \uXXXX, here XXXX should be exactly four HexadecimalDigit's representing the Unicode character corresponding to the digits.

    In single quoted strings it is optional to escape double quotes, and likewise it is optional to escape single quotes in double quoted strings.

    Single quoted strings must contain at least two characters otherwise they will be assumed to be a character literal.

    The @-literals can be used to avoid obscuring the string literals with escape characters. The literals starts with @ followed by some non-letter character AtOpenChar. And it terminates when the close character AtCloseChar is met. For most characters the close character is the same as the opening character, but for diverse paranthesis charactes the close character is the corresponding opposite paranthesis.
    Open 	Close 	Open 	Close
    @( 	) 	@) 	(
    @[ 	] 	@] 	[
    @{ 	} 	@} 	{
    @< 	> 	@> 	<

    For all non-paranthesis opening character the close character is the same as the open character, for example @" is closed by ".

    For all @-strings it is the case the twice the closing character does not close the string, but means one occurence of the closing character in the string.
    Example

    This example uses @[ as opening and ] as closing, inside the string literal both " and ' can be used unescaped: AtString.png


Classes_and_Methods=

Function=

Grammar=

