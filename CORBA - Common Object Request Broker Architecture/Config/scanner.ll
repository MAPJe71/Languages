/*
 *  MICO --- a free CORBA implementation
 *  Copyright (C) 1997-98 Kay Roemer & Arno Puder
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Send comments and/or bug reports to:
 *                 mico@informatik.uni-frankfurt.de
 */

%{


%}

%option noyywrap

/*--------------------------------------------------------------------------*/

Digits                  [0-9]+
Oct_Digit               [0-7]
Hex_Digit               [a-fA-F0-9]
Int_Literal		[1-9][0-9]*
Oct_Literal		0{Oct_Digit}*
Hex_Literal		(0x|0X){Hex_Digit}*
Esc_Sequence1           "\\"[ntvbrfa\\\?\'\"]
Esc_Sequence2           "\\"{Oct_Digit}{1,3}
Esc_Sequence3           "\\"(x|X){Hex_Digit}{1,2}
Esc_Sequence            ({Esc_Sequence1}|{Esc_Sequence2}|{Esc_Sequence3})
Char                    ([^\n\t\"\'\\]|{Esc_Sequence})
Char_Literal            "'"({Char}|\")"'"
String_Literal		\"({Char}|"'")*\"
Float_Literal1		{Digits}"."{Digits}?(e|E)("+"|"-")?{Digits}  
Float_Literal2		{Digits}(e|E)("+"|"-")?{Digits}
Float_Literal3          {Digits}"."{Digits}
Float_Literal4          {Digits}"."
Float_Literal5		"."{Digits} 
Float_Literal6		"."{Digits}(e|E)("+"|"-")?{Digits}  
Fixed_Literal1          {Digits}(d|D)
Fixed_Literal2          {Digits}"."(d|D)
Fixed_Literal3          "."{Digits}(d|D)
Fixed_Literal4          {Digits}"."{Digits}(d|D)

/*--------------------------------------------------------------------------*/

CORBA_Identifier	[a-zA-Z_][a-zA-Z0-9_]*

/*--------------------------------------------------------------------------*/



%%

[ \t]			;
[\n]			;
"//"[^\n]*		;
"#pragma"[^\n]*\n       {
                          return T_PRAGMA;
                        }
"#"[^\n]*\n             {
                            preprocessor_directive( yytext );
                        }
"{"			return T_LEFT_CURLY_BRACKET;
"}"			return T_RIGHT_CURLY_BRACKET;
"["		 	return T_LEFT_SQUARE_BRACKET;
"]"			return T_RIGHT_SQUARE_BRACKET;
"("			return T_LEFT_PARANTHESIS;
")"			return T_RIGHT_PARANTHESIS;
":"			return T_COLON;
","			return T_COMMA;
";"			return T_SEMICOLON;
"="			return T_EQUAL;
">>"			return T_SHIFTRIGHT;
"<<"			return T_SHIFTLEFT;
"+"			return T_PLUS_SIGN;
"-"			return T_MINUS_SIGN;
"*"			return T_ASTERISK;
"/"			return T_SOLIDUS;
"%"			return T_PERCENT_SIGN;
"~"			return T_TILDE;
"|"			return T_VERTICAL_LINE;
"^"			return T_CIRCUMFLEX;
"&"			return T_AMPERSAND;
"<"			return T_LESS_THAN_SIGN;
">"			return T_GREATER_THAN_SIGN;

const			return T_CONST;
typedef			return T_TYPEDEF;
float			return T_FLOAT;
double			return T_DOUBLE;
char			return T_CHAR;
wchar			return T_WCHAR;
fixed                   return T_FIXED;
boolean			return T_BOOLEAN;
string			return T_STRING;
wstring			return T_WSTRING;
void			return T_VOID;
unsigned		return T_UNSIGNED;
long 			return T_LONG;
short			return T_SHORT;
FALSE			return T_FALSE;
TRUE			return T_TRUE;
struct			return T_STRUCT;
union			return T_UNION;
switch			return T_SWITCH;
case			return T_CASE;
default			return T_DEFAULT;
enum			return T_ENUM;
in			return T_IN;
out			return T_OUT;
interface		return T_INTERFACE;
abstract		return T_ABSTRACT;
valuetype		return T_VALUETYPE;
truncatable		return T_TRUNCATABLE;
supports		return T_SUPPORTS;
custom			return T_CUSTOM;
public			return T_PUBLIC;
private			return T_PRIVATE;
factory			return T_FACTORY;
native			return T_NATIVE;
ValueBase		return T_VALUEBASE;

"::"			return T_SCOPE; 

module			return T_MODULE;
octet			return T_OCTET;
any			return T_ANY;
sequence		return T_SEQUENCE;
readonly		return T_READONLY;
attribute		return T_ATTRIBUTE;
exception		return T_EXCEPTION;
oneway			return T_ONEWAY;
inout			return T_INOUT;
raises			return T_RAISES;
context			return T_CONTEXT;

Object                  return T_OBJECT;
Principal               return T_PRINCIPAL;


{CORBA_Identifier}	return T_IDENTIFIER;
{Float_Literal1}	|
{Float_Literal2}	|
{Float_Literal3}	|
{Float_Literal4}	|
{Float_Literal5}	|
{Float_Literal6}	return T_FLOATING_PT_LITERAL;
{Fixed_Literal1}	|
{Fixed_Literal2}	|
{Fixed_Literal3}	|
{Fixed_Literal4}	return T_FIXED_PT_LITERAL;
{Int_Literal}		return T_INTEGER_LITERAL;
{Oct_Literal}		return T_INTEGER_LITERAL;
{Hex_Literal}		return T_INTEGER_LITERAL;
{Char_Literal}		return T_CHARACTER_LITERAL;
{String_Literal}	return T_STRING_LITERAL;
.                       {
                          return T_UNKNOWN;
                        }

%%

