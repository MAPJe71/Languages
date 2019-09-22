
# ABAP -Advanced Business Application Programming

## Description

SAP Advanced Business Application Programming, originally Allgemeiner Berichts-Aufbereitungs-Prozessor

## Links

WWW

https://go.sap.com/community/topic/abap.html

Wiki

https://en.wikipedia.org/wiki/ABAP

## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~


## Identifiers

The following conventions apply to the names of all definable objects within
ABAP programs, such as data types, data objects, classes, macros, or
procedures:
- A name can be up to 30 characters in length.
- Permitted characters are letters from "A" to "Z", digits from "0" to "9",
    and underscores (_).
- The name must start with a letter or an underscore (_). Only outside of
    ABAP objects can the name also start with a different character.
- The name can have a namespace prefix. A namespace prefix consists of at
    least three characters that are enclosed by two forward slashes (/.../).
    The entire length of prefix and name cannot exceed 30 characters.
- The names of predefined ABAP types or predefined data objects cannot be
    used for data types or data objects.
- The use of IDs that are reserved for ABAP words and so on for custom
    definitions is not actually forbidden, but is strongly advised against.
- Field symbols are special because their names have to be enclosed in angle
    brackets (<...>). The angle brackets are a part of the name, which means
    that a field symbol could potentially be called <> (but this is not
    recommended).

## String Literals

Character literals are sequences of alphanumeric characters in the source
code of an ABAP program enclosed in single quotation marks or backquotes.
Character literals enclosed in quotation marks have the predefined ABAP
type c and are described as text field literals. Literals enclosed in
backquotes have the ABAP type string and are described as string literals.
The field length is defined by the number of characters. With text field
literals trailing blanks are ignored while in string literals they are taken
into account.

Examples of text field literals:
~~~
    'Antony Smith'
    '69190 Walldorf'
~~~
Examples of string literals:
~~~
    `Antony Smith  `
    `69190 Walldorf  `
~~~

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

ABAP has 2 ways of defining text as a comment:

1.  An asterisk (*) in the leftmost column of a line makes the entire line a comment
2.  A double quotation mark (") anywhere on a line makes the rest of that line a comment

Example:
~~~
    ***************************************
    ** Program: BOOKINGS                 **
    ** Author: Joe Byte, 07-Jul-2007     **
    ***************************************

    REPORT BOOKINGS.

    * Read flight bookings from the database
    SELECT * FROM FLIGHTINFO
      WHERE CLASS = 'Y'       "Y = economy
      OR    CLASS = 'C'.      "C = business
    (...)
~~~

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

