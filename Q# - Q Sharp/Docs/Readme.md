
# Q# - Q Sharp

## Description

.qs


## Links

WWW

https://docs.microsoft.com/en-us/quantum/?view=qsharp-preview
https://docs.microsoft.com/en-us/quantum/language/?view=qsharp-preview

Wiki

https://en.wikipedia.org/wiki/Q_Sharp



## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~


## Identifiers


## String Literals

Q# allows strings to be used in the fail statement and the Log standard function.

Strings in Q# are either literals or interpolated strings. String literals are similar to simple string literals in most languages: a sequence of Unicode characters enclosed in double quotes, ". Inside of a string, the back-slash character \ may be used to escape a double quote character, and to insert a new-line as \n, a carriage return as \r, and a tab as \t. For instance:
Q#

"\"Hello world!\", she said.\n"

The Q# syntax for string interpolations is a subset of the C# 7.0 syntax; Q# does not support verbatim (multi-line) interpolated strings. See Interpolated Strings for the C# syntax.

Expressions inside of an interpolated string follow Q# syntax, not C# syntax. Any valid Q# expression may appear in an interpolated string.

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment


Comments begin with two forward slashes, //, and continue until the end of line. A comment may appear anywhere in a Q# source file.
Documentation Comments

Comments that begin with three forward slashes, ///, are treated specially by the compiler when they appear immediately before a namespace, operation, specialization, function, or type definition. In that case, their contents are taken as documentation for the defined callable or user-defined type, as for other .NET languages.

Within /// comments, text to appear as a part of API documentation is formatted as Markdown, with different parts of the documentation being indicated by specially-named headers. As an extension to Markdown, cross references to operations, functions and user-defined types in Q# can be included using the @"<ref target>", where <ref target> is replaced by the fully qualified name of the code object being referenced. Optionally, a documentation engine may also support additional Markdown extensions.

For example:
Q#

/// # Summary
/// Given an operation and a target for that operation,
/// applies the given operation twice.
///
/// # Input
/// ## op
/// The operation to be applied.
/// ## target
/// The target to which the operation is to be applied.
///
/// # Type Parameters
/// ## 'T
/// The type expected by the given operation as its input.
///
/// # Example
/// ```Q#
/// // Should be equivalent to the identity.
/// ApplyTwice(H, qubit);
/// ```
///
/// # See Also
/// - Microsoft.Quantum.Intrinsic.H
operation ApplyTwice<'T>(op : ('T => Unit), target : 'T) : Unit
{
    op(target);
    op(target);
}

The following names are recognized as documentation comment headers.

    Summary: A short summary of the behavior of a function or operation, or of the purpose of a type. The first paragraph of the summary is used for hover information. It should be plain text.
    Description: A description of the behavior of a function or operation, or of the purpose of a type. The summary and description are concatenated to form the generated documentation file for the function, operation, or type. The description may contain in-line LaTeX-formatted symbols and equations.
    Input: A description of the input tuple for an operation or function. May contain additional Markdown subsections indicating each individual element of the input tuple.
    Output: A description of the tuple returned by an operation or function.
    Type Parameters: An empty section which contains one additional subsection for each generic type parameter.
    Example: A short example of the operation, function or type in use.
    Remarks: Miscellaneous prose describing some aspect of the operation, function, or type.
    See Also: A list of fully qualified names indicating related functions, operations, or user-defined types.
    References: A list of references and citations for the item being documented.


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

