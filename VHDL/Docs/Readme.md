
# VHDL

## Description


## Links

_WWW_

https://tams.informatik.uni-hamburg.de/vhdl/tools/grammar/vhdl93-bnf.html#basic_graphic_character
https://www.hdlworks.com/hdl_corner/vhdl_ref/index.html

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
[VHDL] -------------------------------------------------------------------------
@=VHSIC (Very High Speed Integrated Circuit) Hardware Description Language

_WWW_=

_Wiki_=

Keywords=

   A RegEx to find them all:

       \b(?!(?-i:
       	a(?:bs|ccess|fter|l(?:ias|l)|nd|r(?:chitecture|ray)|ssert|ttribute)
       |	b(?:egin|lock|ody|u(?:ffer|s))
       |	c(?:ase|o(?:mponent|n(?:figuration|stant)))
       |	d(?:isconnect|ownto)
       |	e(?:ls(?:e|if)|n(?:d|tity)|xit)
       |	f(?:ile|or|unction)
       |	g(?:ener(?:ate|ic)|roup|uarded)
       |	i(?:[fs]|mpure|n(?:ertial|out)?)
       |	l(?:abel|i(?:brary|nkage|teral)|oop)
       |	m(?:ap|od)
       |	n(?:and|e(?:w|xt)|o[rt]|ull)
       |	o(?:[fnr]|pen|thers|ut)
       |	p(?:ackage|o(?:rt|stponed)|roce(?:dure|ss)|ure)
       |	r(?:ange|e(?:cord|gister|ject|m|port|turn)|o[lr])
       |	s(?:e(?:lect|verity)|hared|ignal|[lr][al]|ubtype)
       |	t(?:hen|o|ransport|ype)
       |	u(?:n(?:affected|its|til)|se)
       |	variable
       |	w(?:ait|h(?:en|ile)|ith)
       |	xn?or
       )

Identifiers=

Comment="(?'SLC'(?m-s)--.*?$)"

   -- Single Line Comment

Classes_and_Methods=

Function=

Grammar=

   <parser
       id="vhdl_syntax" displayName="VHDL" version="1.0.0.0"
       commentExpr="(?'SLC'(?m-s)--.*?$)" >
     <function
         mainExpr="^[\t ]*\w+\s*:\s*(entity\s+)?(\w+\.)?\w+\s+(\w+\s+)?(generic|port)\s+map"
         displayMode="$functionName" >
       <functionName>
         <nameExpr expr="\w+" />
       </functionName>
     </function>
   </parser>

