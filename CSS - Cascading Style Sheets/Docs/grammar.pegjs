// Adapted from https://github.com/pegjs/pegjs/blob/master/examples/css.pegjs
// under the MIT Licence (https://github.com/pegjs/pegjs/blob/master/LICENSE)

// CSS Grammar
// ===========
//
// Based on grammar from CSS 2.1 specification [1] (including the errata [2]).
// Generated parser builds a syntax tree composed of nested JavaScript objects,
// vaguely inspired by CSS DOM [3]. The CSS DOM itself wasn't used as it is not
// expressive enough (e.g. selectors are reflected as text, not structured
// objects) and somewhat cumbersome.
//
// Limitations:
//
//   * Many errors which should be recovered from according to the specification
//     (e.g. malformed declarations or unexpected end of stylesheet) are fatal.
//     This is a result of straightforward rewrite of the CSS grammar to PEG.js.
//
// [1] http://www.w3.org/TR/2011/REC-CSS2-20110607
// [2] http://www.w3.org/Style/css2-updates/REC-CSS2-20110607-errata.html
// [3] http://www.w3.org/TR/DOM-Level-2-Style/css.html

{
  function extractOptional(optional, index) {
    return optional ? optional[index] : null;
  }

  function extractList(list, index) {
    return list.map(function(element) { return element[index]; });
  }

  function buildList(head, tail, index) {
    return [head].concat(extractList(tail, index))
      .filter(function(element) { return element !== null; });
  }

  function buildExpression(head, tail) {
    return tail.reduce(function(result, element) {
      return {
        type: "Expression",
        operator: element[0],
        left: result,
        right: element[1]
      };
    }, head);
  }

  function concat ( head, tail ) {
    return tail ? [ head ].concat( tail ) : [ head ];
  }

  function locate ( obj, location ) {
    obj.start = location.start.offset;
    obj.end = location.end.offset;
    return obj;
  }
}

start
  = stylesheet:stylesheet comment* { return stylesheet; }

// ----- G.1 Grammar -----

stylesheet
  = charset:(CHARSET_SYM STRING ";")? (S / CDO / CDC)*
    imports:(import (CDO S* / CDC S*)*)*
    rules:((atrule / ruleset) (CDO S* / CDC S*)*)*
    {
      return {
        type: "StyleSheet",
        charset: extractOptional(charset, 1),
        imports: extractList(imports, 0),
        rules: extractList(rules, 0),
        start: location().start.offset,
        end: location().end.offset
      };
    }

import
  = IMPORT_SYM S* href:(STRING / URI) S* media:media_query_list? ";" S* {
      return {
        type: "ImportRule",
        href: href,
        media: media !== null ? media : []
      };
    }

atrule
  = ( media / page )

media
  = comment* "@media" S+ media:media_query_list S* "{" S* rules:ruleset* "}" S* {
      return {
        type: "MediaRule",
        media: media,
        rules: rules,
        start: location().start.offset,
        end: location().end.offset
      };
    }

media_query_list
  = head:media_query tail:("," S* media_query)* { return buildList(head, tail, 2); }

media_query
  = qualifier:( ONLY / NOT )? S* type:IDENT_WITH_LOCATION expressions:and_expression_list? {
      return {
        not: qualifier === 'not',
        type: type,
        expressions: expressions
      };
    }
  / head:expression tail:and_expression_list? {
    return {
      not: false,
      type: null,
      expressions: concat(head, tail)
    };
  }

and_expression_list
  = S+ AND S* head:expression tail:and_expression_list? {
    return concat(head, tail);
  }

ONLY
  = O N L Y {
    return "only";
  }

NOT
  = N O T {
    return "not";
  }

AND
  = A N D

expression
  = '(' S* feature:IDENT_WITH_LOCATION S* expr:( ':' S* expr:expr { return expr; } )? ')' {
    return {
      type: 'MediaExpression',
      feature: feature,
      expression: expr,
      start: location().start.offset,
      end: location().end.offset
    };
  }

page
  = PAGE_SYM S* selector:pseudo_page?
    "{" S*
    declarationsHead:declaration?
    declarationsTail:(";" S* declaration?)*
    "}" S*
    {
      return {
        type: "PageRule",
        selector: selector,
        declarations: buildList(declarationsHead, declarationsTail, 2)
      };
    }

pseudo_page
  = ":" value:IDENT S* { return { type: "PseudoSelector", value: value }; }

operator
  = "/" S* { return "/"; }
  / "," S* { return ","; }

combinator
  = "+" S* { return "+"; }
  / ">" S* { return ">"; }

ruleset
  = selectorsHead:selector
    selectorsTail:("," S* selector)*
    "{" S*
    declarationsHead:declaration?
    declarationsTail:(";" S* declaration?)*
    "}" S*
    {
      return {
        type: "RuleSet",
        selectors: buildList(selectorsHead, selectorsTail, 2),
        declarations: buildList(declarationsHead, declarationsTail, 2),
        start: location().start.offset,
        end: location().end.offset
      };
    }

selector
  = left:simple_selector S* combinator:combinator right:selector {
      return locate({
        type: "Selector",
        combinator: combinator,
        left: left,
        right: right
      }, location() );
    }
  / left:simple_selector S+ right:selector {
      return locate({
        type: "Selector",
        combinator: " ",
        left: left,
        right: right
      }, location() );
    }
  / selector:simple_selector S* { return selector; }

simple_selector
  = element:element_name qualifiers:(id / class / attrib / pseudo)* {
      return locate({
        type: "SimpleSelector",
        element: element,
        qualifiers: qualifiers
    }, location() );
    }
  / qualifiers:(id / class / attrib / pseudo)+ {
      return locate({
        type: "SimpleSelector",
        element: "*",
        qualifiers: qualifiers
    }, location() );
    }

id
  = id:HASH { return locate({ type: "IDSelector", id: id }, location() ); }

class
  = "." class_:IDENT { return locate({ type: "ClassSelector", "class": class_ }, location() ); }

element_name
  = IDENT
  / "*"

attrib
  = "[" S*
    attribute:IDENT_WITH_LOCATION S*
    operatorAndValue:(comment* ("=" / "^=" / "*=" / "~=" / "|=" / "$=") S* (IDENT_WITH_LOCATION / STRING_WITH_LOCATION) S* ("i" / "I")?)?
    "]"
    {
      return locate({
        type: "AttributeSelector",
        attribute: attribute,
        operator: extractOptional(operatorAndValue, 1),
        value: extractOptional(operatorAndValue, 3),
        casesensitive: !extractOptional(operatorAndValue, 5)
      }, location() );
    }

pseudo
  = pseudo_element / pseudo_class

pseudo_element
  = ":" name:pseudo_element_type {
    return locate({
      type: 'PseudoElement',
      name: name
    }, location() );
  }
  / "::"
    name:IDENT {
      return locate({
        type: 'PseudoElement',
        name: name
      }, location() );
    }

pseudo_element_type
  = ( "first-letter" / "first-line" / "before" / "after" )

pseudo_class
  = ":"
    value:(
        name:FUNCTION S* param:[^\)]+ ")" {
          return {
            type: "Function",
            name: name,
            param: param.join( '' )
          };
        }
      / IDENT
    )
    { return locate({ type: "PseudoSelector", value: value }, location() ); }

declaration
  = name:IDENT_WITH_LOCATION S* ':' S* value:expr prio:prio? {
      return locate({
        type: "Declaration",
        name: name,
        value: value,
        important: prio !== null
      }, location() );
    }

prio
  = IMPORTANT_SYM S*

expr
  = head:term tail:(operator? term)* { return buildExpression(head, tail); }

term
  = quantity:(PERCENTAGE / LENGTH / EMS / EXS / ANGLE / TIME / FREQ / NUMBER)
    S*
    {
      return locate({
        type: "Quantity",
        value: quantity.value,
        unit: quantity.unit
      }, location() );
    }
  / value:STRING_WITH_LOCATION S* { return value; }
  / value:URI_WITH_LOCATION S*    { return value; }
  / function
  / hexcolor
  / value:IDENT_WITH_LOCATION S*  { return value; }

function
  = name:FUNCTION S* params:expr ")" S* {
      return locate({
        type: "Function",
        name: name,
        params: params
      }, location() );
    }

hexcolor
  = value:HASH S* {
    return {
      type: "Hexcolor",
      start: location().start.offset,
      end: location().end.offset,
      value: value
    };
  }

// ----- G.2 Lexical scanner -----

// Macros

h
  = [0-9a-f]i

nonascii
  = [\x80-\uFFFF]

unicode
  = "\\" digits:$(h h? h? h? h? h?) ("\r\n" / [ \t\r\n\f])? {
      return String.fromCharCode(parseInt(digits, 16));
    }

escape
  = unicode
  / "\\" ch:[^\r\n\f0-9a-f]i { return ch; }

nmstart
  = [_a-z]i
  / nonascii
  / escape

nmchar
  = [_a-z0-9-]i
  / nonascii
  / escape

string1
  = '"' chars:([^\n\r\f\\"] / "\\" nl:nl { return ""; } / escape)* '"' {
      return chars.join("");
    }

string2
  = "'" chars:([^\n\r\f\\'] / "\\" nl:nl { return ""; } / escape)* "'" {
      return chars.join("");
    }

comment
  = "/*" [^*]* "*"+ ([^/*] [^*]* "*"+)* "/"

ident
  = prefix:$"-"? start:nmstart chars:nmchar* {
      return prefix + start + chars.join("");
    }

name
  = chars:nmchar+ { return chars.join(""); }

num
  = [+-]? ([0-9]+ / [0-9]* "." [0-9]+) ("e" [+-]? [0-9]+)? {
      return parseFloat(text());
    }

string
  = string1
  / string2

url
  = chars:([!#$%&*-\[\]-~] / nonascii / escape)* { return chars.join(""); }

s
  = [ \t\r\n\f]+

w
  = s?

nl
  = "\n"
  / "\r\n"
  / "\r"
  / "\f"

A  = "a"i / "\\" "0"? "0"? "0"? "0"? [\x41\x61] ("\r\n" / [ \t\r\n\f])? { return "a"; }
C  = "c"i / "\\" "0"? "0"? "0"? "0"? [\x43\x63] ("\r\n" / [ \t\r\n\f])? { return "c"; }
D  = "d"i / "\\" "0"? "0"? "0"? "0"? [\x44\x64] ("\r\n" / [ \t\r\n\f])? { return "d"; }
E  = "e"i / "\\" "0"? "0"? "0"? "0"? [\x45\x65] ("\r\n" / [ \t\r\n\f])? { return "e"; }
G  = "g"i / "\\" "0"? "0"? "0"? "0"? [\x47\x67] ("\r\n" / [ \t\r\n\f])? / "\\g"i { return "g"; }
H  = "h"i / "\\" "0"? "0"? "0"? "0"? [\x48\x68] ("\r\n" / [ \t\r\n\f])? / "\\h"i { return "h"; }
I  = "i"i / "\\" "0"? "0"? "0"? "0"? [\x49\x69] ("\r\n" / [ \t\r\n\f])? / "\\i"i { return "i"; }
K  = "k"i / "\\" "0"? "0"? "0"? "0"? [\x4b\x6b] ("\r\n" / [ \t\r\n\f])? / "\\k"i { return "k"; }
L  = "l"i / "\\" "0"? "0"? "0"? "0"? [\x4c\x6c] ("\r\n" / [ \t\r\n\f])? / "\\l"i { return "l"; }
M  = "m"i / "\\" "0"? "0"? "0"? "0"? [\x4d\x6d] ("\r\n" / [ \t\r\n\f])? / "\\m"i { return "m"; }
N  = "n"i / "\\" "0"? "0"? "0"? "0"? [\x4e\x6e] ("\r\n" / [ \t\r\n\f])? / "\\n"i { return "n"; }
O  = "o"i / "\\" "0"? "0"? "0"? "0"? [\x4f\x6f] ("\r\n" / [ \t\r\n\f])? / "\\o"i { return "o"; }
P  = "p"i / "\\" "0"? "0"? "0"? "0"? [\x50\x70] ("\r\n" / [ \t\r\n\f])? / "\\p"i { return "p"; }
R  = "r"i / "\\" "0"? "0"? "0"? "0"? [\x52\x72] ("\r\n" / [ \t\r\n\f])? / "\\r"i { return "r"; }
S_ = "s"i / "\\" "0"? "0"? "0"? "0"? [\x53\x73] ("\r\n" / [ \t\r\n\f])? / "\\s"i { return "s"; }
T  = "t"i / "\\" "0"? "0"? "0"? "0"? [\x54\x74] ("\r\n" / [ \t\r\n\f])? / "\\t"i { return "t"; }
U  = "u"i / "\\" "0"? "0"? "0"? "0"? [\x55\x75] ("\r\n" / [ \t\r\n\f])? / "\\u"i { return "u"; }
X  = "x"i / "\\" "0"? "0"? "0"? "0"? [\x58\x78] ("\r\n" / [ \t\r\n\f])? / "\\x"i { return "x"; }
Y  = "y"i / "\\" "0"? "0"? "0"? "0"? [\x59\x79] ("\r\n" / [ \t\r\n\f])? / "\\y"i { return "y"; }
Z  = "z"i / "\\" "0"? "0"? "0"? "0"? [\x5a\x7a] ("\r\n" / [ \t\r\n\f])? / "\\z"i { return "z"; }

// Tokens

S "whitespace"
  = comment* s

CDO "<!--"
  = comment* "<!--"

CDC "-->"
  = comment* "-->"

BEGINS_WITH "^="
  = comment* "^="

CONTAINS "*="
  = comment* "*="

INCLUDES "~="
  = comment* "~="

DASHMATCH "|="
  = comment* "|="

STRING "string"
  = comment* string:string { return string; }

STRING_WITH_LOCATION
  = string:string {
    return {
      type: "Literal",
      start: location().start.offset,
      end: location().end.offset,
      value: string
    }
  }

IDENT "identifier"
  = comment* ident:ident { return ident; }

IDENT_WITH_LOCATION
  = ident:ident {
    return {
      type: "Identifier",
      start: location().start.offset,
      end: location().end.offset,
      name: ident
    }
  }

HASH "hash"
  = comment* "#" name:name { return "#" + name; }

IMPORT_SYM "@import"
  = comment* "@" I M P O R T

PAGE_SYM "@page"
  = comment* "@" P A G E

CHARSET_SYM "@charset"
  = comment* "@charset "

// We use |s| instead of |w| here to avoid infinite recursion.
IMPORTANT_SYM "!important"
  = comment* "!" (s / comment)* I M P O R T A N T

EMS "length"
  = comment* value:num E M { return { value: value, unit: "em" }; }

EXS "length"
  = comment* value:num E X { return { value: value, unit: "ex" }; }

LENGTH "length"
  = comment* value:num P X { return { value: value, unit: "px" }; }
  / comment* value:num C M { return { value: value, unit: "cm" }; }
  / comment* value:num M M { return { value: value, unit: "mm" }; }
  / comment* value:num I N { return { value: value, unit: "in" }; }
  / comment* value:num P T { return { value: value, unit: "pt" }; }
  / comment* value:num P C { return { value: value, unit: "pc" }; }

ANGLE "angle"
  = comment* value:num D E G   { return { value: value, unit: "deg"  }; }
  / comment* value:num R A D   { return { value: value, unit: "rad"  }; }
  / comment* value:num G R A D { return { value: value, unit: "grad" }; }

TIME "time"
  = comment* value:num M S_ { return { value: value, unit: "ms" }; }
  / comment* value:num S_   { return { value: value, unit: "s"  }; }

FREQ "frequency"
  = comment* value:num H Z   { return { value: value, unit: "hz" }; }
  / comment* value:num K H Z { return { value: value, unit: "kh" }; }

PERCENTAGE "percentage"
  = comment* value:num "%" { return { value: value, unit: "%" }; }

NUMBER "number"
  = comment* value:num { return { value: value, unit: null }; }

URI "uri"
  = comment* U R L "("i w url:string w ")" { return url; }
  / comment* U R L "("i w url:url w ")"    { return url; }

URI_WITH_LOCATION
  = URI:URI {
    return {
      type: "URI",
      start: location().start.offset,
      end: location().end.offset,
      value: URI
    };
  }

FUNCTION "function"
  = comment* name:ident "(" { return name; }
