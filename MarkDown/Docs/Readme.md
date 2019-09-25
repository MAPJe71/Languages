
# MarkDown

## Description

https://spec.commonmark.org/0.29/


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

---

## ATX-style headings

An ATX heading consists of a string of characters, parsed as inline content, 
between an opening sequence of 1–6 unescaped `#` characters and an optional 
closing sequence of any number of unescaped `#` characters. The opening 
sequence of `#` characters must be followed by a space or by the end of 
line. The optional closing sequence of `#`s must be preceded by a space and 
may be followed by spaces only. The opening `#` character may be indented 0-3 
spaces. The raw contents of the heading are stripped of leading and trailing 
spaces before being parsed as inline content. The heading level is equal to 
the number of `#` characters in the opening sequence.

Simple headings:

# ATX-style heading level 1 (ATX1)
## ATX-style heading level 2 (ATX2)
### ATX-style heading level 3 (ATX3)
#### ATX-style heading level 4 (ATX4)
##### ATX-style heading level 5 (ATX5)
###### ATX-style heading level 6 (ATX6)

At least one space is required between the `#` characters and the heading's 
contents, unless the heading is empty (this is followed by an empty heading).

###

This is not a heading, because the first `#` is escaped:

\## first hash escaped, not a heading

Contents are parsed as inlines:

#### ATX4: foo *bar* \*baz\*

Leading and trailing whitespace is ignored in parsing inline content:

####                  ATX4: foo bar                     

One to three spaces indentation are allowed:

 ### ATX3: 1 space indent
  ## ATX2: 2 space indent
   # ATX1: 3 space indent

A closing sequence of `#` characters is optional:

#### ATX4: closing sequence is optional
#### ATX4: closing sequence is optional ####
  #####   ATX4: closing sequence is optional   
  #####   ATX4: closing sequence is optional ####   

It need not be the same length as the opening sequence:

#### ATX4: opening and closing sequence can have differnet length ###
##### ATX5: opening and closing sequence can have differnet length #

Spaces are allowed after the closing sequence:

### ATX3: spaces allowed after closing sequence ###     

A sequence of `#` characters with anything but spaces following it is not a 
closing sequence, but counts as part of the contents of the heading:

### ATX3: not followed by closing-sequence ### b

The closing sequence must be preceded by a space:

### ATX3: space must preceed closing sequence#

Backslash-escaped `#` characters do not count as part of the closing sequence:

### ATX3: backslash-escaped hashes are not closing-sequence \###
### ATX3: foo #\##
### ATX3: backslash-escaped hashes are not closing-sequence \#

---

## Setext-style headings

A setext heading consists of one or more lines of text, each containing at least
one non-whitespace character, with no more than 3 spaces indentation, followed 
by a setext heading underline. The lines of text must be such that, were they 
not followed by the setext heading underline, they would be interpreted as a 
paragraph: they cannot be interpretable as a code fence, ATX heading, block 
quote, thematic break, list item, or HTML block.

A setext heading underline is a sequence of `=` characters or a sequence of `-` 
characters, with no more than 3 spaces indentation and any number of trailing 
spaces. If a line containing a single - can be interpreted as an empty list 
items, it should be interpreted this way and not as a setext heading underline.

The heading is a level 1 heading if `=` characters are used in the setext 
heading underline, and a level 2 heading if `-` characters are used. The 
contents of the heading are the result of parsing the preceding lines of text 
as CommonMark inline content.

In general, a setext heading need not be preceded or followed by a blank line. 
However, it cannot interrupt a paragraph, so when a setext heading comes after 
a paragraph, a blank line is needed between them.

Setext-style heading level 1
============================

Setext-style heading level 2
----------------------------

---


Grammar=

```
	public static $rules = array (
		'/(#+)(.*)/' => 'self::header',                           // headers
		'/\[([^\[]+)\]\(([^\)]+)\)/' => '<a href=\'\2\'>\1</a>',  // links
		'/(\*\*|__)(.*?)\1/' => '<strong>\2</strong>',            // bold
		'/(\*|_)(.*?)\1/' => '<em>\2</em>',                       // emphasis
		'/\~\~(.*?)\~\~/' => '<del>\1</del>',                     // del
		'/\:\"(.*?)\"\:/' => '<q>\1</q>',                         // quote
		'/`(.*?)`/' => '<code>\1</code>',                         // inline code
		'/\n\*(.*)/' => 'self::ul_list',                          // ul lists
		'/\n[0-9]+\.(.*)/' => 'self::ol_list',                    // ol lists
		'/\n(&gt;|\>)(.*)/' => 'self::blockquote ',               // blockquotes
		'/\n-{5,}/' => "\n<hr />",                                // horizontal rule
		'/\n([^\n]+)\n/' => 'self::para',                         // add paragraphs
		'/<\/ul>\s?<ul>/' => '',                                  // fix extra ul
		'/<\/ol>\s?<ol>/' => '',                                  // fix extra ol
		'/<\/blockquote><blockquote>/' => "\n"                    // fix extra blockquote
	);



^\x20*(#{1,6})\x20*([^\n]+?)\x20*#*\x20*(?:\n+|$)


^
(
    \x23{1,6}
)
\s+
(?|
    ([^\x23]+)
    \x23*
    $
|
    (.*)
)


Fenced code
/```[a-z]*\n[\s\S]*?\n```/g
/^[ \t]*(?:`{3,}(?!.*`)|^~{3,})/


--langdef=markdown
--langmap=markdown:.md
--regex-markdown=/^(.+)[[:cntrl:]]{1,3}^(===+)/\1/h,Heading_L1/{_multiline=1}
--regex-markdown=/^(.+)[[:cntrl:]]{1,3}^(---+)/\1/i,Heading_L2/{_multiline=1}
--regex-markdown=/^###[ \t]+(.*)/\1/k,Heading_L3/
--excmd=number

```