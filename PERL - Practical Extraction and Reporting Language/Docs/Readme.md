
# PERL

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
[PERL] -------------------------------------------------------------------------
@=Practical Extraction and Reporting Language

_WWW_=https://www.perl.org/

_Wiki_=https://en.wikipedia.org/wiki/Perl

Keywords=

   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

StringLiterals=

   https://en.wikipedia.org/wiki/Here_document

   Here Document

       print <<HEREDOC;
           some
           text
       HEREDOC

       print <<"HEREDOC";
           some
           text
       HEREDOC

       print <<"    HEREDOC";
           some
           text
           HEREDOC

       print <<'HEREDOC';
           some
           text
       HEREDOC

       print <<'    HEREDOC';
           some
           text
           HEREDOC

       And an example with backticks (may not be portable):

       print <<`HEREDOC`;
           some
           text
       HEREDOC

       It is possible to start multiple heredocs on the same line:

       say(<<BEGIN . "this is the middle\n" . <<END);
       This is the beginning:
       BEGIN
       And now it is over!
       END

       # this is equivalent to:
       say("This is the beginning:\nthis is the middle\nAnd now it is over!\n");


   Here String


Comment=

   Perl 5.x

       Single line comment

           # this is commented

       Multi-line comments for inline documentation (Plain Old Documentation, or
       POD in Perl parlance) follow the format:

           =pod

           Here are my comments
           this is multi-line

           =cut

       Note that technically, both of the lines beginning with the equals sign must
       be surrounded on either side for compatibility with all "POD" parsers.

       Note also that any string beginning with an equals sign, and that appears in
       the initial column of a line, begins a multi-line comment. It does not have
       to be a POD "command:".

   Perl 6

       my $x = 2; # Single-line comment.

       #`(
           Comments beginning with a backtick and one or more
           opening bracketing characters are embedded comments.
           They can span more than one line…
       )

       my $y = #`{ …or only part of a line. } 3;

       #`{{
           Using more than one bracketing character lets you include
           an unmatched close bracket, like this: }
       }}

       #`? Synopsis 2: "Bracketing characters are defined as any
           Unicode characters with either bidirectional mirrorings or
           Ps/Pe/Pi/Pf properties." ?

       =comment

       =begin comment

       Pod is the successor to Perl 5's POD. This is the simplest way
       to use it for multi-line comments. For more about Pod, see
       Synopsis 26:

       http://perlcabal.org/syn/S26.html

       =end comment


       Inline Comments

       The Z<> formatting code indicates that its contents constitute a
       zero-width comment, which should not be rendered by any renderer.
       For example:

           The "exeunt" command Z<Think about renaming this command?> is used
           to quit all applications.

       In Perl 5 POD, the Z<> code was widely used to break up text that
       would otherwise be considered mark-up:

           In Perl 5 POD, the ZZ<><> code was widely used to break up text
           that would otherwise be considered mark-up.

       That technique still works, but it's now easier to accomplish the
       same goal using a verbatim formatting code:

           In Perl 5 POD, the V<V<Z<>>> code was widely used to break up text
           that would otherwise be considered mark-up.

       Moreover, the C<> code automatically treats its contents as being
       verbatim, which often eliminates the need for the V<> as well:

           In Perl 5 POD, the V<C<Z<>>> code was widely used to break up text
           that would otherwise be considered mark-up.


   Multiline Comments

   Pod sections may be used reliably as multiline comments in Perl 6. Unlike in
   Perl 5, Pod syntax now lets you use =begin comment and =end comment to
   delimit a Pod block correctly without the need for =cut. (In fact, =cut is
   now gone.) The format name does not have to be comment -- any unrecognized
   format name will do to make it a comment. (However, bare =begin and =end
   probably aren't good enough, because all comments in them will show up in
   the formatted output.)

   We have single paragraph comments with =for comment as well. That lets =for
   keep its meaning as the equivalent of a =begin and =end combined. As with
   =begin and =end, a comment started in code reverts to code afterwards.

   Since there is a newline before the first =, the Pod form of comment counts
   as whitespace equivalent to a newline. See S26 for more on embedded
   documentation.


   Single-line Comments

   Except within a quote literal, a # character always introduces a comment in
   Perl 6. There are two forms of comment based on #. Embedded comments require
   the # to be followed by a backtick (`) plus one or more opening bracketing
   characters.

   All other uses of # are interpreted as single-line comments that work just
   as in Perl 5, starting with a # character and ending at the subsequent
   newline. They count as whitespace equivalent to newline for purposes of
   separation. Unlike in Perl 5, # may not be used as the delimiter in quoting
   constructs.


   Embedded Comments

   Embedded comments are supported as a variant on quoting syntax, introduced
   by #` plus any user-selected bracket characters (as defined in "Bracketing
   Characters" above):

       say #`( embedded comment ) "hello, world!";

       $object\#`{ embedded comments }.say;

       $object\ #`?
           embedded comments
       ?.say;

   Brackets may be nested, following the same policy as ordinary quote brackets.

   There must be no space between the #` and the opening bracket character.
   (There may be the visual appearance of space for some double-wide
   characters, however, such as the corner quotes above.)

   For multiline comments it is recommended (but not required) to use two or
   more brackets both for visual clarity and to avoid relying too much on
   internal bracket counting heuristics when commenting code that may
   accidentally miscount single brackets:

       #`{{
           say "here is an unmatched } character";
       }}

   However, it's sometimes better to use Pod comments because they are
   implicitly line-oriented.


   User-selected Brackets

   For all quoting constructs that use user-selected brackets, you can open
   with multiple identical bracket characters, which must be closed by the same
   number of closing brackets. Counting of nested brackets applies only to
   pairs of brackets of the same length as the opening brackets:

       say #`{{
           This comment contains unmatched } and { { { {   (ignored)
           Plus a nested {{ ... }} pair                    (counted)
       }} q<< <<woot>> >>   # says " <<woot>> "

   Note however that bare circumfix or postcircumfix <<...>> is not a user-
   selected bracket, but the ASCII variant of the «...» interpolating word
   list. Only #` and the q-style quoters (including m, s, tr, and rx) enable
   subsequent user-selected brackets.


Classes_and_Methods=

Function=

   <function
       mainExpr    = "^[\s]*(?<!#)[\s]*sub[\s]+[\w]+[\s]*\(?[^\)\(]*?\)?[\n\s]*\{"
       displayMode = "$className->$functionName"
       >

   The most basic form:

       sub multiply { return $_[0] * $_[1] }

   or simply:

       sub multiply { $_[0] * $_[1] }

   Arguments in Perl subroutines are passed in the @_ array, and they can be
   accessed directly, first one as $_[0], second one as $_[1], etc. When the above
   function is called with only one or no arguments then the missing ones have an
   undefined value which is converted to 0 in multiplication.

   This is an example using subroutine prototypes:

       sub multiply( $$ )
       {
          my ($a, $b) = @_;
          return $a * $b;
       }

   The above subroutine can only be called with exactly two scalar values (two
   dollar signs in the signature) but those values may be not numbers or not even
   defined. The @_ array is unpacked into $a and $b lexical variables, which are
   used later.

   The arguments can be automatically unpacked into lexical variables using the
   signatures module:

       use signatures;
       sub multiply ($x, $y) {
           return $x * $y;
       }

   Perl 6

   Without a signature:

       sub multiply { return @_[0] * @_[1]; }

   The return is optional on the final statement, since the last expression would
   return its value anyway. The final semicolon in a block is also optional.
   (Beware that a subroutine without an explicit signature, like this one,
   magically becomes variadic (rather than nullary) only if @_ or %_ appear in the
   body.) In fact, we can define the variadic version explicitly, which still works
   for two arguments:

       sub multiply { [*] @_ }

   With formal parameters and a return type:

       sub multiply (Rat $a, Rat $b --> Rat) { $a * $b }

   Same thing:

       sub multiply (Rat $a, Rat $b) returns Rat { $a * $b }
       my Rat sub multiply (Rat $a, Rat $b) { $a * $b }

   It is possible to define a function in "lambda" notation and then bind that into
   a scope, in which case it works like any function:

       my &multiply := -> $a, $b { $a * $b };

   Another way to write a lambda is with internal placeholder parameters:

       my &multiply := { $^a * $^b };

   (And, in fact, our original @_ above is just a variadic self-declaring
   placeholder argument. And the famous Perl "topic", $_, is just a self-declared
   parameter to a unary block.)

   You may also curry both built-in and user-defined operators by supplying a *
   (known as "whatever") in place of the argument that is not to be curried:

       my &multiply := * * *;

   This is not terribly readable in this case due to the visual confusion between
   the whatever star and the multiplication operator, but Perl knows when it's
   expecting terms instead of infixes, so only the middle star is multiplication.
   It tends to work out much better with other operators. In particular, you may
   curry a cascade of methods with only the original invocant missing:

       @list.grep( *.substr(0,1).lc.match(/<[0..9 a..f]>/) )

   This is equivalent to:

       @list.grep( -> $obj { $obj.substr(0,1).lc.match(/<[0..9 a..f]>/) )

Grammar=


http://perldoc.perl.org/perlsub.html

    To declare subroutines:

        sub NAME;                       # A "forward" declaration.
        sub NAME(PROTO);                #  ditto, but with prototypes
        sub NAME : ATTRS;               #  with attributes
        sub NAME(PROTO) : ATTRS;        #  with attributes and prototypes
        sub NAME BLOCK                  # A declaration and a definition.
        sub NAME(PROTO) BLOCK           #  ditto, but with prototypes
        sub NAME(SIG) BLOCK             #  with a signature instead
        sub NAME : ATTRS BLOCK          #  with attributes
        sub NAME(PROTO) : ATTRS BLOCK   #  with prototypes and attributes
        sub NAME(SIG) : ATTRS BLOCK     #  with a signature and attributes

    To define an anonymous subroutine at runtime:

        $subref = sub BLOCK;                    # no proto
        $subref = sub (PROTO) BLOCK;            # with proto
        $subref = sub (SIG) BLOCK;              # with signature
        $subref = sub : ATTRS BLOCK;            # with attributes
        $subref = sub (PROTO) : ATTRS BLOCK;    # with proto and attributes
        $subref = sub (SIG) : ATTRS BLOCK;      # with signature and attributes

    To import subroutines:

        use MODULE qw(NAME1 NAME2 NAME3);

    To call subroutines:

        NAME(LIST);     # & is optional with parentheses.
        NAME LIST;      # Parentheses optional if predeclared/imported.
        &NAME(LIST);    # Circumvent prototypes.
        &NAME;          # Makes current @_ visible to called subroutine.

