
# Rust

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
[Rust] -------------------------------------------------------------------------
@=Rust

_WWW_=https://www.rust-lang.org/en-US/

_Wiki_=https://en.wikipedia.org/wiki/Rust_(programming_language)

Keywords=

   A RegEx to find them all:

       \b(?!(?-i:
           a(?:bstract|lignof|s)
       |   b(?:ecome|ox|reak)
       |   c(?:on(?:st|tinue)|rate)
       |   do
       |   e(?:lse|num|xtern)
       |   f(?:alse|inal|n|or)
       |   i(?:[fn]|mpl)
       |   l(?:et|oop)
       |   m(?:a(?:cro|tch)|o(?:d|ve)|ut)
       |   o(?:ffsetof|verride)
       |   pr(?:iv|oc)|pu(?:b|re)
       |   re(?:f|turn)
       |   s(?:izeof|t(?:atic|ruct)|uper)|[Ss]elf
       |   t(?:rait|rue|ype(?:of)?)
       |   u(?:ns(?:afe|ized)|se)
       |   v(?:irtual)
       |   wh(?:ere|ile)
       |   yield
       )\b)

Identifiers=

StringLiterals=

Comment=

   //      : line comment.
   //!     : inner line doc comment.
   ///     : outer line doc comment.
   /*…*/   : block comment.
   /*!…*/  : inner block doc comment.
   /**…*/  : outer block doc comment.

Classes_and_Methods=

Function=

Grammar=

   Most of Rust's grammar is confined to the ASCII range of Unicode, and is
   described in this document by a dialect of Extended Backus-Naur Form (EBNF),
   specifically a dialect of EBNF supported by common automated LL(k) parsing
   tools such as llgen, rather than the dialect given in ISO 14977. The dialect
   can be defined self-referentially as follows:

       grammar     : rule + ;
       rule        : nonterminal ':' productionrule ';' ;
       productionrule
                   : production [ '|' production ] * ;
       production  : term * ;
       term        : element repeats ;
       element     : LITERAL | IDENTIFIER | '[' productionrule ']' ;
       repeats     : [ '*' | '+' ] NUMBER ? | NUMBER ? | '?' ;

   Where:

   - Whitespace in the grammar is ignored.
   - Square brackets are used to group rules.
   - LITERAL is a single printable ASCII character, or an escaped hexadecimal
     ASCII code of the form \xQQ, in single quotes, denoting the corresponding
     Unicode codepoint U+00QQ.
   - IDENTIFIER is a nonempty string of ASCII letters and underscores.
   - The repeat forms apply to the adjacent element, and are as follows:
       ? means zero or one repetition
       * means zero or more repetitions
       + means one or more repetitions
       NUMBER trailing a repeat symbol gives a maximum repetition count
       NUMBER on its own gives an exact repetition count


   whitespace_char : '\x20' | '\x09' | '\x0a' | '\x0d' ;

   whitespace      : [ whitespace_char | comment ] + ;

   comment         : block_comment | line_comment ;

   block_comment   : "/*" block_comment_body * "*/" ;

   block_comment_body
                   : [ block_comment | character ] * ;

   line_comment    : "//" non_eol * ;

   lit_suffix      : ident;

   literal         : [ string_lit | char_lit | byte_string_lit | byte_lit | num_lit | bool_lit ] lit_suffix ? ;

   char_lit        : '\x27' char_body '\x27' ;

   string_lit      : '"' string_body * '"'
                   | 'r' raw_string ;

   char_body       : non_single_quote
                   | '\x5c' [ '\x27' | common_escape | unicode_escape ] ;

   string_body     : non_double_quote
                   | '\x5c' [ '\x22' | common_escape | unicode_escape ] ;

   raw_string      : '"' raw_string_body '"' | '#' raw_string '#' ;

   common_escape   : '\x5c' | 'n' | 'r' | 't' | '0' | 'x' hex_digit 2

   unicode_escape  : 'u' '{' hex_digit+ 6 '}';

   hex_digit       : 'a' | 'b' | 'c' | 'd' | 'e' | 'f'
                   | 'A' | 'B' | 'C' | 'D' | 'E' | 'F'
                   | dec_digit ;

   oct_digit       : '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' ;

   dec_digit       : '0' | nonzero_dec ;

   nonzero_dec     : '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' ;

   byte_lit        : "b\x27" byte_body '\x27' ;

   byte_string_lit : "b\x22" string_body * '\x22'
                   | "br" raw_byte_string ;

   byte_body       : ascii_non_single_quote
                   | '\x5c' [ '\x27' | common_escape ] ;

   byte_string_body: ascii_non_double_quote
                   | '\x5c' [ '\x22' | common_escape ] ;

   raw_byte_string : '"' raw_byte_string_body '"'
                   | '#' raw_byte_string '#' ;

   num_lit         : nonzero_dec [ dec_digit | '_' ] * float_suffix ?
                   | '0' [       [ dec_digit | '_' ] * float_suffix ?
                         | 'b'   [ '1' | '0' | '_' ] +
                         | 'o'   [ oct_digit | '_' ] +
                         | 'x'   [ hex_digit | '_' ] +  ] ;

   float_suffix    : [ exponent | '.' dec_lit exponent ? ] ? ;

   exponent        : ['E' | 'e'] ['-' | '+' ] ? dec_lit ;

   dec_lit         : [ dec_digit | '_' ] + ;

   bool_lit        : [ "true" | "false" ] ;

   symbol          : "::"
                   | "->"
                   | '#'
                   | '[' | ']'
                   | '(' | ')'
                   | '{' | '}'
                   | ','
                   | ';' ;

   expr_path       : [ "::" ] ident [ "::" expr_path_tail ] + ;

   expr_path_tail  : '<' type_expr [ ',' type_expr ] + '>'
                   | expr_path ;

   type_path       : ident [ type_path_tail ] + ;

   type_path_tail  : '<' type_expr [ ',' type_expr ] + '>'
                   | "::" type_path ;

   expr_macro_rules: "macro_rules" '!' ident '(' macro_rule * ')' ';'
                   | "macro_rules" '!' ident '{' macro_rule * '}' ;

   macro_rule      : '(' matcher * ')' "=>" '(' transcriber * ')' ';' ;

   matcher         : '(' matcher * ')'
                   | '[' matcher * ']'
                   | '{' matcher * '}'
                   | '$' ident ':' ident
                   | '$' '(' matcher * ')' sep_token? [ '*' | '+' ]
                   | non_special_token ;

   transcriber     : '(' transcriber * ')'
                   | '[' transcriber * ']'
                   | '{' transcriber * '}'
                   | '$' ident
                   | '$' '(' transcriber * ')' sep_token? [ '*' | '+' ]
                   | non_special_token ;

   item            : vis ? mod_item
                   | fn_item
                   | type_item
                   | struct_item
                   | enum_item
                   | const_item
                   | static_item
                   | trait_item
                   | impl_item
                   | extern_block_item ;

   mod_item        : "mod" ident ( ';' | '{' mod '}' );

   mod             : [ view_item | item ] * ;

   view_item       : extern_crate_decl
                   | use_decl ';' ;

   extern_crate_decl
                   : "extern" "crate" crate_name ;

   crate_name      : ident
                   | ( ident "as" ident )

   use_decl        : vis ? "use" [ path "as" ident | path_glob ] ;

   path_glob       : ident [ "::" [ path_glob | '*' ] ] ?
                   | '{' path_item [ ',' path_item ] * '}' ;

   path_item       : ident
                   | "self" ;

   const_item      : "const" ident ':' type '=' expr ';' ;

   static_item     : "static" ident ':' type '=' expr ';' ;

   extern_block_item
                   : "extern" '{' extern_block '}' ;

   extern_block    : [ foreign_fn ] * ;

   vis             : "pub" ;

   attribute       : '#' '!' ? '[' meta_item ']' ;

   meta_item       : ident [ '=' literal | '(' meta_seq ')' ] ? ;

   meta_seq        : meta_item [ ',' meta_seq ] ? ;

   stmt            : decl_stmt
                   | expr_stmt
                   | ';' ;

   decl_stmt       : item
                   | let_decl ;

   let_decl        : "let" pat [':' type ] ? [ init ] ? ';' ;

   init            : [ '=' ] expr ;

   expr_stmt       : expr ';' ;

   expr            : literal
                   | path
                   | tuple_expr
                   | unit_expr
                   | struct_expr
                   | block_expr
                   | method_call_expr
                   | field_expr
                   | array_expr
                   | idx_expr
                   | range_expr
                   | unop_expr
                   | binop_expr
                   | paren_expr
                   | call_expr
                   | lambda_expr
                   | while_expr
                   | loop_expr
                   | break_expr
                   | continue_expr
                   | for_expr
                   | if_expr
                   | match_expr
                   | if_let_expr
                   | while_let_expr
                   | return_expr ;

   tuple_expr      : '(' [ expr [ ',' expr ] * | expr ',' ] ? ')' ;

   unit_expr       : "()" ;

   struct_expr     : expr_path '{' ident ':' expr [ ',' ident ':' expr ] * [ ".." expr ] '}'
                   | expr_path '(' expr [ ',' expr ] * ')'
                   | expr_path ;

   block_expr      : '{' [ stmt | item ] * [ expr ] '}' ;

   method_call_expr: expr '.' ident paren_expr_list ;

   field_expr      : expr '.' ident ;

   array_expr      : '[' "mut" ? array_elems? ']' ;

   array_elems     : [ expr [ ',' expr ] * ]
                   | [ expr   ';' expr ] ;

   idx_expr        : expr '[' expr ']' ;

   range_expr      : expr ".." expr
                   | expr ".."
                   |      ".." expr
                   |      ".." ;

   unop_expr       : unop expr ;

   unop            : '-' | '*' | '!' ;

   binop_expr      : expr binop expr
                   | type_cast_expr
                   | assignment_expr
                   | compound_assignment_expr ;

   binop           : arith_op
                   | bitwise_op
                   | lazy_bool_op
                   | comp_op ;

   arith_op        : '+' | '-' | '*' | '/' | '%' ;

   bitwise_op      : '&' | '|' | '^' | "<<" | ">>" ;

   lazy_bool_op    : "&&" | "||" ;

   comp_op         : "==" | "!=" | '<' | '>' | "<=" | ">=" ;

   type_cast_expr  : value "as" type ;

   assignment_expr : expr '=' expr ;

   compound_assignment_expr
                   : expr [ arith_op | bitwise_op ] '=' expr ;

   paren_expr      : '(' expr ')' ;

   expr_list       : [ expr [ ',' expr ]* ] ? ;

   paren_expr_list : '(' expr_list ')' ;

   call_expr       : expr paren_expr_list ;

   ident_list      : [ ident [ ',' ident ]* ] ? ;

   lambda_expr     : '|' ident_list '|' expr ;

   while_expr      : [ lifetime ':' ] ? "while" no_struct_literal_expr '{' block '}' ;

   loop_expr       : [ lifetime ':' ] ? "loop" '{' block '}';

   break_expr      : "break" [ lifetime ] ? ;

   continue_expr   : "continue" [ lifetime ] ? ;

   for_expr        : [ lifetime ':' ] ? "for" pat "in" no_struct_literal_expr '{' block '}' ;

   if_expr         : "if" no_struct_literal_expr '{' block '}' else_tail ? ;

   else_tail       : "else" [ if_expr | if_let_expr | '{' block '}' ] ;

   match_expr      : "match" no_struct_literal_expr '{' match_arm * '}' ;

   match_arm       : attribute * match_pat "=>" [ expr "," | '{' block '}' ] ;

   match_pat       : pat [ '|' pat ] * [ "if" expr ] ? ;

   if_let_expr     : "if" "let" pat '=' expr '{' block '}'
                      else_tail ? ;

   while_let_expr  : [ lifetime ':' ] ? "while" "let" pat '=' expr '{' block '}' ;

   return_expr     : "return" expr ? ;

   closure_type    : [ 'unsafe' ] [ '<' lifetime-list '>' ] '|' arg-list '|' [ ':' bound-list ] [ '->' type ] ;

   lifetime-list   : lifetime
                   | lifetime ',' lifetime-list ;

   arg-list        : ident ':' type
                   | ident ':' type ',' arg-list ;

   bound-list      : bound
                   | bound '+' bound-list ;

   bound           : path
                   | lifetime ;


