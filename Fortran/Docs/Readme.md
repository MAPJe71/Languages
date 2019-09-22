
# Fortran

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
```
[Fortran] ----------------------------------------------------------------------
@=Fortran - Formula Translation

_WWW_=

_Wiki_=

http://fortranwiki.org/fortran/show/HomePage
http://fortranwiki.org/fortran/show/Continuation+lines

Filename suffixes=

Use ‘.f’ for all Fortran source formats. Traditionally, Fortran source always
had the ‘.f’ suffix. With Fortran90, ‘.f90’ became the convention, Fortran95
still used ‘.f90’. The ‘.f90’ is really more to indicate free-format source
rather than the appropriate language version. Fixed-format should no longer be
used for new code. Rather than complicate the suffix issue further by including
‘.f03’ and ‘.f08’, Fortran should revert to the single common suffix, as is the
convention in most languages. For example, C99 code still uses the ‘.c’ suffix.

On the other hand, compilers use the suffix to detect whether the source is
fixed-form or free-form. If you are using only free-form source, then the above
convention is appropriate, and a compiler option must be used to tell the
compiler to interpret all files as free-form. If you are mixing fixed and free
source, then the most practical solution, until compilers can detect it
automatically, is to use ‘.f’ for all fixed-form source and ‘.f90’ for all
free-form, regardless of which language specification is being used, thus
avoiding the proliferation of version-specific suffixes.


Keywords=

Fotran 77               :   assign,
                            backspace, block data,
                            call, close, common, continue,
                            data, dimension, do,
                            else, else if, end, endfile, endif, entry, equivalence, external,
                            format, function,
                            goto,
                            if, implicit, inquire, intrinsic,
                            open,
                            parameter, pause, print, program,
                            read, return, rewind, rewrite,
                            save, stop, subroutine,
                            then, write.

added in Fortran 90     :   allocatable, allocate,
                            case, contains, cycle,
                            deallocate,
                            elsewhere, exit,
                            include, interface, intent,
                            module,
                            namelist, nullify,
                            only, operator, optional,
                            pointer, private, procedure, public,
                            recursive, result,
                            select, sequence,
                            target,
                            use,
                            while, where.

added in Fortran 95     :   elemental,
                            forall,
                            pure.

added in Fortran 2003   :   abstract, associate, asynchronous,
                            bind,
                            class,
                            deferred,
                            enum, enumerator, extends,
                            final, flush,
                            generic,
                            import,
                            non_overridable, nopass,
                            pass, protected,
                            value, volatile,
                            wait.

added in Fortran 2008   :   block,
                            codimension, do concurrent, contiguous, critical,
                            error stop,
                            submodule,
                            sync all,
                            sync images,
                            sync memory,
                            lock, unlock.

from Fortran 2015 "16-007"

Table 3.2: Adjacent keywords where separating blanks are optional
BLOCK DATA END ENUM END SELECT
DOUBLE PRECISION END FILE END SUBMODULE
ELSE IF END FORALL END SUBROUTINE
ELSE WHERE END FUNCTION END TYPE
END ASSOCIATE END IF END WHERE
END BLOCK END INTERFACE GO TO
END BLOCK DATA END MODULE IN OUT
END CRITICAL END PROCEDURE SELECT CASE
END DO END PROGRAM SELECT TYPE


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

StringLiterals=

Comment=

Classes_and_Methods=

Function=

Grammar=

from Fortran 2015 "16-007"

program                         is program-unit
                                    [ program-unit ] ...

program-unit                    is main-program
                                or external-subprogram
                                or module
                                or submodule
                                or block-data

main-program                    is [ program-stmt ]
                                    [ specification-part ]
                                    [ execution-part ]
                                    [ internal-subprogram-part ]
                                    end-program-stmt

external-subprogram             is function-subprogram
                                or subroutine-subprogram

function-subprogram             is function-stmt
                                    [ specification-part ]
                                    [ execution-part ]
                                    [ internal-subprogram-part ]
                                    end-function-stmt

subroutine-subprogram           is subroutine-stmt
                                    [ specification-part ]
                                    [ execution-part ]
                                    [ internal-subprogram-part ]
                                    end-subroutine-stmt

module                          is module-stmt
                                    [ specification-part ]
                                    [ module-subprogram-part ]
                                    end-module-stmt

submodule                       is submodule-stmt
                                    [ specification-part ]
                                    [ module-subprogram-part ]
                                    end-submodule-stmt

block-data                      is block-data-stmt
                                    [ specification-part ]
                                    end-block-data-stmt

specification-part              is [ use-stmt ] ...
                                    [ import-stmt ] ...
                                    [ implicit-part ]
                                    [ declaration-construct ] ...

implicit-part                   is [ implicit-part-stmt ] ...
                                    implicit-stmt

implicit-part-stmt              is implicit-stmt
                                or parameter-stmt
                                or format-stmt
                                or entry-stmt

declaration-construct           is specification-construct
                                or data-stmt
                                or format-stmt
                                or entry-stmt
                                or stmt-function-stmt

specification-construct         is derived-type-def
                                or enum-def
                                or generic-stmt
                                or interface-block
                                or parameter-stmt
                                or procedure-declaration-stmt
                                or other-specification-stmt
                                or type-declaration-stmt

execution-part                  is executable-construct
                                    [ execution-part-construct ] ...

execution-part-construct        is executable-construct
                                or format-stmt
                                or entry-stmt
                                or data-stmt

internal-subprogram-part        is contains-stmt
                                    [ internal-subprogram ] ...

internal-subprogram             is function-subprogram
                                or subroutine-subprogram

module-subprogram-part          is contains-stmt
                                    [ module-subprogram ] ...

module-subprogram               is function-subprogram
                                or subroutine-subprogram
                                or separate-module-subprogram

separate-module-subprogram      is mp-subprogram-stmt
                                    [ specification-part ]
                                    [ execution-part ]
                                    [ internal-subprogram-part ]
                                    end-mp-subprogram-stmt

other-specification-stmt        is access-stmt
                                or allocatable-stmt
                                or asynchronous-stmt
                                or bind-stmt
                                or codimension-stmt
                                or contiguous-stmt
                                or dimension-stmt
                                or external-stmt
                                or intent-stmt
                                or intrinsic-stmt
                                or namelist-stmt
                                or optional-stmt
                                or pointer-stmt
                                or protected-stmt
                                or save-stmt
                                or target-stmt
                                or volatile-stmt
                                or value-stmt
                                or common-stmt
                                or equivalence-stmt

executable-construct            is action-stmt
                                or associate-construct
                                or block-construct
                                or case-construct
                                or critical-construct
                                or do-construct
                                or if-construct
                                or select-rank-construct
                                or select-type-construct
                                or where-construct
                                or forall-construct

action-stmt                     is allocate-stmt
                                or assignment-stmt
                                or backspace-stmt
                                or call-stmt
                                or close-stmt
                                or continue-stmt
                                or cycle-stmt
                                or deallocate-stmt
                                or end-function-stmt
                                or end-mp-subprogram-stmt
                                or end-program-stmt
                                or end-subroutine-stmt
                                or endfile-stmt
                                or error-stop-stmt
                                or event-post-stmt
                                or event-wait-stmt
                                or exit-stmt
                                or flush-stmt
                                or goto-stmt
                                or if-stmt
                                or inquire-stmt
                                or lock-stmt
                                or nullify-stmt
                                or open-stmt
                                or pointer-assignment-stmt
                                or print-stmt
                                or read-stmt
                                or return-stmt
                                or rewind-stmt
                                or stop-stmt
                                or sync-all-stmt
                                or sync-images-stmt
                                or sync-memory-stmt
                                or unlock-stmt
                                or wait-stmt
                                or where-stmt
                                or write-stmt
                                or computed-goto-stmt
                                or forall-stmt

alphanumeric-character          is letter
                                or digit
                                or underscore

letter                          is A
                                or B
                                or C
                                or D
                                or E
                                or F
                                or G
                                or H
                                or I
                                or J
                                or K
                                or L
                                or M
                                or N
                                or O
                                or P
                                or Q
                                or R
                                or S
                                or T
                                or U
                                or V
                                or W
                                or X
                                or Y
                                or Z

digit                           is 0
                                or 1
                                or 2
                                or 3
                                or 4
                                or 5
                                or 6
                                or 7
                                or 8
                                or 9

underscore                      is _

name                            is letter [ alphanumeric-character ] ...

constant                        is literal-constant
                                or named-constant

literal-constant                is int-literal-constant
                                or real-literal-constant
                                or complex-literal-constant
                                or logical-literal-constant
                                or char-literal-constant
                                or boz-literal-constant

named-constant                  is name

int-constant                    is constant

intrinsic-operator              is power-op
                                or mult-op
                                or add-op
                                or concat-op
                                or rel-op
                                or not-op
                                or and-op
                                or or-op
                                or equiv-op

power-op                        is **

mult-op                         is *
                                or /

add-op                          is +
                                or –

concat-op                       is //

rel-op                          is .EQ.
                                or .NE.
                                or .LT.
                                or .LE.
                                or .GT.
                                or .GE.
                                or ==
                                or /=
                                or <
                                or <=
                                or >
                                or >=

not-op                          is .NOT.

and-op                          is .AND.

or-op                           is .OR.

equiv-op                        is .EQV.
                                or .NEQV.

defined-operator                is defined-unary-op
                                or defined-binary-op
                                or extended-intrinsic-op

defined-unary-op                is . letter [ letter ] ... .

defined-binary-op               is . letter [ letter ] ... .

extended-intrinsic-op           is intrinsic-operator

label                           is digit [ digit [ digit [ digit [ digit ] ] ] ]

type-param-value                is scalar-int-expr
                                or *
                                or :

type-spec                       is intrinsic-type-spec
                                or derived-type-spec

declaration-type-spec           is intrinsic-type-spec
                                or TYPE ( intrinsic-type-spec )
                                or TYPE ( derived-type-spec )
                                or CLASS ( derived-type-spec )
                                or CLASS ( * )
                                or TYPE ( * )

intrinsic-type-spec             is integer-type-spec
                                or REAL [ kind-selector ]
                                or DOUBLE PRECISION
                                or COMPLEX [ kind-selector ]
                                or CHARACTER [ char-selector ]
                                or LOGICAL [ kind-selector ]

integer-type-spec               is INTEGER [ kind-selector ]

kind-selector                   is ( [ KIND = ] scalar-int-constant-expr )

signed-int-literal-constant     is [ sign ] int-literal-constant

int-literal-constant            is digit-string [ _ kind-param ]

kind-param                      is digit-string
                                or scalar-int-constant-name

signed-digit-string             is [ sign ] digit-string

digit-string                    is digit [ digit ] ...

sign                            is +
                                or ...

signed-real-literal-constant    is [ sign ] real-literal-constant

real-literal-constant           is significand [ exponent-letter exponent ] [ _ kind-param ]
                                or digit-string exponent-letter exponent [ _ kind-param ]

significand                     is digit-string . [ digit-string ]
                                or . digit-string

exponent-letter                 is E
                                or D

exponent                        is signed-digit-string

complex-literal-constant        is ( real-part , imag-part )

real-part                       is signed-int-literal-constant
                                or signed-real-literal-constant
                                or named-constant

imag-part                       is signed-int-literal-constant
                                or signed-real-literal-constant
                                or named-constant

char-selector                   is length-selector
                                or ( LEN = type-param-value ,
                                    KIND = scalar-int-constant-expr )
                                or ( type-param-value ,
                                    [ KIND = ] scalar-int-constant-expr )
                                or ( KIND = scalar-int-constant-expr
                                    [ , LEN =type-param-value ] )

length-selector                 is ( [ LEN = ] type-param-value )
                                or * char-length [ , ]

char-length                     is ( type-param-value )
                                or int-literal-constant

char-literal-constant           is [ kind-param _ ] ’ [ rep-char ] ... ’
                                or [ kind-param _ ] " [ rep-char ] ... "

logical-literal-constant        is .TRUE. [ _ kind-param ]
                                or .FALSE. [ _ kind-param ]

derived-type-def                is derived-type-stmt
                                    [ type-param-def-stmt ] ...
                                    [ private-or-sequence ] ...
                                    [ component-part ]
                                    [ type-bound-procedure-part ]
                                    end-type-stmt

derived-type-stmt               is TYPE [ [ , type-attr-spec-list ] :: ] type-name
                                    [ ( type-param-name-list ) ]

type-attr-spec                  is ABSTRACT
                                or access-spec
                                or BIND (C)
                                or EXTENDS ( parent-type-name )

private-or-sequence             is private-components-stmt
                                or sequence-stmt

end-type-stmt                   is END TYPE [ type-name ]

sequence-stmt                   is SEQUENCE

type-param-def-stmt             is integer-type-spec, type-param-attr-spec ::
                                    type-param-decl-list

type-param-decl                 is type-param-name [ = scalar-int-constant-expr ]

type-param-attr-spec            is KIND
                                or LEN

component-part                  is [ component-def-stmt ] ...

component-def-stmt              is data-component-def-stmt
                                or proc-component-def-stmt

data-component-def-stmt         is declaration-type-spec [ [ , component-attr-spec-list ] :: ]
                                    component-decl-list

component-attr-spec             is access-spec
                                or ALLOCATABLE
                                or CODIMENSION lbracket coarray-spec rbracket
                                or CONTIGUOUS
                                or DIMENSION ( component-array-spec )
                                or POINTER

component-decl                  is component-name [ ( component-array-spec ) ]
                                    [ lbracket coarray-spec rbracket ]
                                    [ * char-length ] [ component-initialization ]

component-array-spec            is explicit-shape-spec-list
                                or deferred-shape-spec-list

proc-component-def-stmt         is PROCEDURE ( [ proc-interface ] ) ,
                                    proc-component-attr-spec-list :: proc-decl-list

proc-component-attr-spec        is POINTER
                                or PASS [ (arg-name) ]
                                or NOPASS
                                or access-spec

component-initialization        is = constant-expr
                                or => null-init
                                or => initial-data-target

initial-data-target             is designator

private-components-stmt         is PRIVATE

type-bound-procedure-part       is contains-stmt
                                    [ binding-private-stmt ]
                                    [ type-bound-proc-binding ] ...

binding-private-stmt            is PRIVATE

type-bound-proc-binding         is type-bound-procedure-stmt
                                or type-bound-generic-stmt
                                or final-procedure-stmt

type-bound-procedure-stmt       is PROCEDURE [ [ , binding-attr-list ] :: ] type-bound-proc-decl-list
                                or PROCEDURE (interface-name), binding-attr-list :: binding-name-list

type-bound-proc-decl            is binding-name [ => procedure-name ]

type-bound-generic-stmt         is GENERIC [ , access-spec ] :: generic-spec => binding-name-list

binding-attr                    is PASS [ (arg-name) ]
                                or NOPASS
                                or NON_OVERRIDABLE
                                or DEFERRED
                                or access-spec

final-procedure-stmt            is FINAL [ :: ] final-subroutine-name-list

derived-type-spec               is type-name [ ( type-param-spec-list ) ]

type-param-spec                 is [ keyword = ] type-param-value

structure-constructor           is derived-type-spec ( [ component-spec-list ] )

component-spec                  is [ keyword = ] component-data-source

component-data-source           is expr
                                or data-target
                                or proc-target

enum-def                        is enum-def-stmt
                                    enumerator-def-stmt
                                    [ enumerator-def-stmt ] ...
                                    end-enum-stmt

enum-def-stmt                   is ENUM, BIND(C)

enumerator-def-stmt             is ENUMERATOR [ :: ] enumerator-list

enumerator                      is named-constant [ = scalar-int-constant-expr ]

end-enum-stmt                   is END ENUM

boz-literal-constant            is binary-constant
                                or octal-constant
                                or hex-constant

binary-constant                 is B ’ digit [ digit ] ... ’
                                or B " digit [ digit ] ... "

octal-constant                  is O ’ digit [ digit ] ... ’
                                or O " digit [ digit ] ... "

hex-constant                    is Z ’ hex-digit [ hex-digit ] ... ’
                                or Z " hex-digit [ hex-digit ] ... "

hex-digit                       is digit
                                or A
                                or B
                                or C
                                or D
                                or E
                                or F

array-constructor               is (/ ac-spec /)
                                or lbracket ac-spec rbracket

ac-spec                         is type-spec ::
                                or [type-spec ::] ac-value-list

lbracket                        is [

rbracket                        is ]

ac-value                        is expr
                                or ac-implied-do

ac-implied-do                   is ( ac-value-list , ac-implied-do-control )

ac-implied-do-control           is [ integer-type-spec :: ] ac-do-variable = scalar-int-expr ,
                                    scalar-int-expr [ , scalar-int-expr ]

ac-do-variable                  is do-variable

attr-spec                       is access-spec
                                or ALLOCATABLE
                                or ASYNCHRONOUS
                                or CODIMENSION lbracket coarray-spec rbracket
                                or CONTIGUOUS
                                or DIMENSION ( array-spec )
                                or EXTERNAL
                                or INTENT ( intent-spec )
                                or INTRINSIC
                                or language-binding-spec
                                or OPTIONAL
                                or PARAMETER
                                or POINTER
                                or PROTECTED
                                or SAVE
                                or TARGET
                                or VALUE
                                or VOLATILE

entity-decl                     is object-name [( array-spec )]
                                    [ lbracket coarray-spec rbracket ]
                                    [ * char-length ] [ initialization ]
                                or function-name [ * char-length ]

object-name                     is name

initialization                  is = constant-expr
                                or => null-init
                                or => initial-data-target

null-init                       is function-reference

access-spec                     is PUBLIC
                                or PRIVATE

language-binding-spec           is BIND (C [, NAME = scalar-default-char-constant-expr ])

coarray-spec                    is deferred-coshape-spec-list
                                or explicit-coshape-spec

deferred-coshape-spec           is :

explicit-coshape-spec           is [ [ lower-cobound : ] upper-cobound, ]...
                                    [ lower-cobound : ] *

lower-cobound                   is specification-expr

upper-cobound                   is specification-expr

dimension-spec                  is DIMENSION ( array-spec )

array-spec                      is explicit-shape-spec-list
                                or assumed-shape-spec-list
                                or deferred-shape-spec-list
                                or assumed-size-spec
                                or implied-shape-spec
                                or implied-shape-or-assumed-size-spec
                                or assumed-rank-spec

explicit-shape-spec             is [ lower-bound : ] upper-bound

lower-bound                     is specification-expr

upper-bound                     is specification-expr

assumed-shape-spec              is [ lower-bound ] :

deferred-shape-spec             is :

assumed-implied-spec            is [ lower-bound : ] *

assumed-size-spec               is explicit-shape-spec-list, assumed-implied-spec

implied-shape-or-assumed-size-spec
                                is assumed-implied-spec

implied-shape-spec              is assumed-implied-spec, assumed-implied-spec-list

assumed-rank-spec               is ..

intent-spec                     is IN
                                or OUT
                                or INOUT

access-stmt                     is access-spec [ [ :: ] access-id-list ]

access-id                       is access-name
                                or generic-spec

allocatable-stmt                is ALLOCATABLE [ :: ] allocatable-decl-list

allocatable-decl                is object-name [ ( array-spec ) ]
                                    [ lbracket coarray-spec rbracket ]

asynchronous-stmt               is ASYNCHRONOUS [ :: ] object-name-list

bind-stmt                       is language-binding-spec [ :: ] bind-entity-list

bind-entity                     is entity-name
                                or / common-block-name /

codimension-stmt                is CODIMENSION [ :: ] codimension-decl-list

codimension-decl                is coarray-name lbracket coarray-spec rbracket

contiguous-stmt                 is CONTIGUOUS [ :: ] object-name-list

data-stmt                       is DATA data-stmt-set [ [ , ] data-stmt-set ] ...

data-stmt-set                   is data-stmt-object-list / data-stmt-value-list /

data-stmt-object                is variable
                                or data-implied-do

data-implied-do                 is ( data-i-do-object-list , [ integer-type-spec :: ] data-i-do-variable =
                                    scalar-int-constant-expr ,
                                    scalar-int-constant-expr
                                    [ , scalar-int-constant-expr ] )

data-i-do-object                is array-element
                                or scalar-structure-component
                                or data-implied-do

data-i-do-variable              is do-variable

data-stmt-value                 is [ data-stmt-repeat * ] data-stmt-constant

data-stmt-repeat                is scalar-int-constant
                                or scalar-int-constant-subobject

data-stmt-constant              is scalar-constant
                                or scalar-constant-subobject
                                or signed-int-literal-constant
                                or signed-real-literal-constant
                                or null-init
                                or initial-data-target
                                or structure-constructor

int-constant-subobject          is constant-subobject

constant-subobject              is designator

dimension-stmt                  is DIMENSION [ :: ] array-name ( array-spec )
                                    [ , array-name ( array-spec ) ] ...

intent-stmt                     is INTENT ( intent-spec ) [ :: ] dummy-arg-name-list

optional-stmt                   is OPTIONAL [ :: ] dummy-arg-name-list

parameter-stmt                  is PARAMETER ( named-constant-def -list )

named-constant-def              is named-constant = constant-expr

pointer-stmt                    is POINTER [ :: ] pointer-decl-list

pointer-decl                    is object-name [ ( deferred-shape-spec-list ) ]
                                or proc-entity-name

protected-stmt                  is PROTECTED [ :: ] entity-name-list

save-stmt                       is SAVE [ [ :: ] saved-entity-list ]

saved-entity                    is object-name
                                or proc-pointer-name
                                or / common-block-name /

proc-pointer-name               is name

target-stmt                     is TARGET [ :: ] target-decl-list

target-decl                     is object-name [ ( array-spec ) ]
                                    [ lbracket coarray-spec rbracket ]

value-stmt                      is VALUE [ :: ] dummy-arg-name-list

volatile-stmt                   is VOLATILE [ :: ] object-name-list

implicit-stmt                   is IMPLICIT implicit-spec-list
                                or IMPLICIT NONE [ ( [ implicit-none-spec-list ] ) ]

implicit-spec                   is declaration-type-spec ( letter-spec-list )

letter-spec                     is letter [ – letter ]

implicit-none-spec              is EXTERNAL
                                or TYPE

namelist-stmt                   is NAMELIST
                                    / namelist-group-name / namelist-group-object-list
                                    [ [ , ] / namelist-group-name /
                                    namelist-group-object-list ] . . .

namelist-group-object           is variable-name

equivalence-stmt                is EQUIVALENCE equivalence-set-list

equivalence-set                 is ( equivalence-object , equivalence-object-list )

equivalence-object              is variable-name
                                or array-element
                                or substring

common-stmt                     is COMMON
                                    [ / [ common-block-name ] / ] common-block-object-list
                                    [ [ , ] / [ common-block-name ] /
                                    common-block-object-list ] ...

common-block-object             is variable-name [ ( array-spec ) ]

designator                      is object-name
                                or array-element
                                or array-section
                                or coindexed-named-object
                                or complex-part-designator
                                or structure-component
                                or substring

variable                        is designator
                                or function-reference

variable-name                   is name

logical-variable                is variable

char-variable                   is variable

default-char-variable           is variable

int-variable                    is variable

substring                       is parent-string ( substring-range )

parent-string                   is scalar-variable-name
                                or array-element
                                or coindexed-named-object
                                or scalar-structure-component
                                or scalar-constant

substring-range                 is [ scalar-int-expr ] : [ scalar-int-expr ]

data-ref                        is part-ref [ % part-ref ] ...

part-ref                        is part-name [ ( section-subscript-list ) ] [ image-selector ]

structure-component             is data-ref

coindexed-named-object          is data-ref

complex-part-designator         is designator % RE
                                or designator % IM

type-param-inquiry              is designator % type-param-name

array-element                   is data-ref

array-section                   is data-ref [ ( substring-range ) ]
                                or complex-part-designator

subscript                       is scalar-int-expr

section-subscript               is subscript
                                or subscript-tripletor
                                or vector-subscript

subscript-triplet               is [ subscript ] : [ subscript ] [ : stride ]

stride                          is scalar-int-expr

vector-subscript                is int-expr

image-selector                  is lbracket cosubscript-list rbracket

cosubscript                     is scalar-int-expr

allocate-stmt                   is ALLOCATE ( [ type-spec :: ] allocation-list
                                    [, alloc-opt-list ] )

alloc-opt                       is ERRMSG = errmsg-variable
                                or MOLD = source-expr
                                or SOURCE = source-expr
                                or STAT = stat-variable

stat-variable                   is scalar-int-variable

errmsg-variable                 is scalar-default-char-variable

source-expr                     is expr

allocation                      is allocate-object [ ( allocate-shape-spec-list ) ]
                                    [ lbracket allocate-coarray-spec rbracket ]

allocate-object                 is variable-name
                                or structure-component

allocate-shape-spec             is [ lower-bound-expr : ] upper-bound-expr

lower-bound-expr                is scalar-int-expr

upper-bound-expr                is scalar-int-expr

allocate-coarray-spec           is [ allocate-coshape-spec-list , ] [ lower-bound-expr : ] *

allocate-coshape-spec           is [ lower-bound-expr : ] upper-bound-expr

nullify-stmt                    is NULLIFY ( pointer-object-list )

pointer-object                  is variable-name
                                or structure-component
                                or proc-pointer-name

deallocate-stmt                 is DEALLOCATE ( allocate-object-list [ , dealloc-opt-list ] )

dealloc-opt                     is STAT = stat-variable
                                or ERRMSG = errmsg-variable

primary                         is constant
                                or designator
                                or array-constructor
                                or structure-constructor
                                or function-reference
                                or type-param-inquiry
                                or type-param-name
                                or ( expr )

level-1-expr                    is [ defined-unary-op ] primary

defined-unary-op                is . letter [ letter ] ... .

mult-operand                    is level-1-expr [ power-op mult-operand ]

add-operand                     is [ add-operand mult-op ] mult-operand

level-2-expr                    is [ [ level-2-expr ] add-op ] add-operand

power-op                        is **

mult-op                         is *
                                or /

add-op                          is +
                                or ...

level-3-expr                    is [ level-3-expr concat-op ] level-2-expr

concat-op                       is //

level-4-expr                    is [ level-3-expr rel-op ] level-3-expr

rel-op                          is .EQ.
                                or .NE.
                                or .LT.
                                or .LE.
                                or .GT.
                                or .GE.
                                or ==
                                or /=
                                or <
                                or <=
                                or >
                                or >=

and-operand                     is [ not-op ] level-4-expr

or-operand                      is [ or-operand and-op ] and-operand

equiv-operand                   is [ equiv-operand or-op ] or-operand

level-5-expr                    is [ level-5-expr equiv-op ] equiv-operand

not-op                          is .NOT.

and-op                          is .AND.

or-op                           is .OR.

equiv-op                        is .EQV.
                                or .NEQV.

expr                            is [ expr defined-binary-op ] level-5-expr

defined-binary-op               is . letter [ letter ] ... .

logical-expr                    is expr

default-char-expr               is expr

int-expr                        is expr

numeric-expr                    is expr

specification-expr              is scalar-int-expr

constant-expr                   is expr

default-char-constant-expr      is default-char-expr

int-constant-expr               is int-expr

assignment-stmt                 is variable = expr

pointer-assignment-stmt         is data-pointer-object [ (bounds-spec-list) ] => data-target
                                or data-pointer-object (bounds-remapping-list ) => data-target
                                or proc-pointer-object => proc-target

data-pointer-object             is variable-name
                                or scalar-variable % data-pointer-component-name

bounds-spec                     is lower-bound-expr :

bounds-remapping                is lower-bound-expr : upper-bound-expr

data-target                     is expr

proc-pointer-object             is proc-pointer-name
                                or proc-component-ref

proc-component-ref              is scalar-variable % procedure-component-name

proc-target                     is expr
                                or procedure-name
                                or proc-component-ref

where-stmt                      is WHERE ( mask-expr ) where-assignment-stmt

where-construct                 is where-construct-stmt
                                    [ where-body-construct ] ...
                                    [ masked-elsewhere-stmt
                                    [ where-body-construct ] ... ] ...
                                    [ elsewhere-stmt
                                    [ where-body-construct ] ... ]
                                    end-where-stmt

where-construct-stmt            is [where-construct-name:] WHERE ( mask-expr )

where-body-construct            is where-assignment-stmt
                                or where-stmt
                                or where-construct

where-assignment-stmt           is assignment-stmt

mask-expr                       is logical-expr

masked-elsewhere-stmt           is ELSEWHERE (mask-expr) [where-construct-name]

elsewhere-stmt                  is ELSEWHERE [where-construct-name]

end-where-stmt                  is END WHERE [where-construct-name]

forall-construct                is forall-construct-stmt
                                    [forall-body-construct ] ...
                                    end-forall-stmt

forall-construct-stmt           is [forall-construct-name :] FORALL concurrent-header

forall-body-construct           is forall-assignment-stmt
                                or where-stmt
                                or where-construct
                                or forall-construct
                                or forall-stmt

forall-assignment-stmt          is assignment-stmt
                                or pointer-assignment-stmt

end-forall-stmt                 is END FORALL [forall-construct-name ]

forall-stmt                     is FORALL concurrent-header forall-assignment-stmt

associate-construct             is associate-stmt
                                    block
                                    end-associate-stmt

associate-stmt                  is [ associate-construct-name : ] ASSOCIATE
                                    (association-list )

association                     is associate-name => selector

selector                        is expr
                                or variable

end-associate-stmt              is END ASSOCIATE [ associate-construct-name ]

block-construct                 is block-stmt
                                    [ block-specification-part ]
                                    block
                                    end-block-stmt

block-stmt                      is [ block-construct-name : ] BLOCK

block-specification-part        is [ use-stmt ]...
                                    [ import-stmt ] ...
                                    [ implicit-part ]
                                    [ [ declaration-construct ] ...
                                    specification-construct ]

end-block-stmt                  is END BLOCK [ block-construct-name ]

critical-construct              is critical-stmt
                                    block
                                    end-critical-stmt

critical-stmt                   is [ critical-construct-name : ] CRITICAL

end-critical-stmt               is END CRITICAL [ critical-construct-name ]

do-construct                    is do-stmt
                                    block
                                    end-do

do-stmt                         is nonlabel-do-stmt
                                or label-do-stmt

label-do-stmt                   is [ do-construct-name : ] DO label [ loop-control ]

nonlabel-do-stmt                is [ do-construct-name : ] DO [ loop-control ]

loop-control                    is [ , ] do-variable = scalar-int-expr, scalar-int-expr
                                    [ , scalar-int-expr ]
                                or [ , ] WHILE ( scalar-logical-expr )
                                or [ , ] CONCURRENT concurrent-header concurrent-locality

do-variable                     is scalar-int-variable-name

concurrent-header               is ( [ integer-type-spec :: ] concurrent-control-list [, scalar-mask-expr ] )

concurrent-control              is index-name = concurrent-limit : concurrent-limit [ : concurrent-step ]

concurrent-limit                is scalar-int-expr

concurrent-step                 is scalar-int-expr

concurrent-locality             is [ locality-spec ]...

locality-spec                   is LOCAL ( variable-name-list )
                                or LOCAL_INIT ( variable-name-list )
                                or SHARED ( variable-name-list )
                                or DEFAULT ( NONE )

end-do                          is end-do-stmt
                                or continue-stmt

end-do-stmt                     is END DO [ do-construct-name ]

cycle-stmt                      is CYCLE [ do-construct-name ]

if-construct                    is if-then-stmt
                                    block
                                    [ else-if-stmt
                                    block ] ...
                                    [ else-stmt
                                    block ]
                                    end-if-stmt

if-then-stmt                    is [ if-construct-name : ] IF ( scalar-logical-expr ) THEN

else-if-stmt                    is ELSE IF ( scalar-logical-expr ) THEN [ if-construct-name ]

else-stmt                       is ELSE [ if-construct-name ]

end-if-stmt                     is END IF [ if-construct-name ]

if-stmt                         is IF ( scalar-logical-expr ) action-stmt

case-construct                  is select-case-stmt
                                    [ case-stmt
                                    block ] ...
                                    end-select-stmt

select-case-stmt                is [ case-construct-name : ] SELECT CASE ( case-expr )

case-stmt                       is CASE case-selector [case-construct-name]

end-select-stmt                 is END SELECT [ case-construct-name ]

case-expr                       is scalar-expr

case-selector                   is ( case-value-range-list )
                                or DEFAULT

case-value-range                is case-value
                                or case-value :
                                or : case-value
                                or case-value : case-value

case-value                      is scalar-constant-expr

select-rank-construct           is select-rank-stmt
                                    [ select-rank-case-stmt
                                    block ]...
                                    end-select-rank-stmt

select-rank-stmt                is [ select-construct-name : ] SELECT RANK
                                    ( [ associate-name => ] selector )

select-rank-case-stmt           is RANK ( scalar-int-constant-expr ) [ select-construct-name ]
                                or RANK ( * ) [ select-construct-name ]
                                or RANK DEFAULT [ select-construct-name ]

end-select-rank-stmt            is END SELECT [ select-construct-name ]

select-type-construct           is select-type-stmt
                                    [ type-guard-stmt
                                    block ] ...
                                    end-select-type-stmt

select-type-stmt                is [ select-construct-name : ] SELECT TYPE
                                    ( [ associate-name => ] selector )

type-guard-stmt                 is TYPE IS ( type-spec ) [ select-construct-name ]
                                or CLASS IS ( derived-type-spec ) [ select-construct-name ]
                                or CLASS DEFAULT [ select-construct-name ]

end-select-type-stmt            is END SELECT [ select-construct-name ]

exit-stmt                       is EXIT [ construct-name ]

goto-stmt                       is GO TO label

computed-goto-stmt              is GO TO ( label-list ) [ , ] scalar-int-expr

continue-stmt                   is CONTINUE

stop-stmt                       is STOP [ stop-code ] [, QUIET = scalar-logical-expr]

error-stop-stmt                 is ERROR STOP [ stop-code ] [, QUIET = scalar-logical-expr]

stop-code                       is scalar-default-char-expr
                                or scalar-int-expr

sync-all-stmt                   is SYNC ALL [ ( [ sync-stat-list ] ) ]

sync-stat                       is STAT = stat-variable
                                or ERRMSG = errmsg-variable

sync-images-stmt                is SYNC IMAGES ( image-set [ , sync-stat-list ] )

image-set                       is int-expr
                                or *

sync-memory-stmt                is SYNC MEMORY [ ( [ sync-stat-list ] ) ]

event-post-stmt                 is EVENT POST ( event-variable [ , sync-stat-list ] )

event-variable                  is scalar-variable

event-wait-stmt                 is EVENT WAIT ( event-variable [ , event-wait-spec-list ] )

event-wait-spec                 is until-spec
                                or sync-stat

until-spec                      is UNTIL_COUNT = scalar-int-expr

lock-stmt                       is LOCK ( lock-variable [ , lock-stat-list ] )

lock-stat                       is ACQUIRED_LOCK = scalar-logical-variable
                                or sync-stat

unlock-stmt                     is UNLOCK ( lock-variable [ , sync-stat-list ] )

lock-variable                   is scalar-variable

io-unit                         is file-unit-number
                                or *
                                or internal-file-variable

file-unit-number                is scalar-int-expr

internal-file-variable          is char-variable

open-stmt                       is OPEN ( connect-spec-list )

connect-spec                    is [ UNIT = ] file-unit-number
                                or ACCESS = scalar-default-char-expr
                                or ACTION = scalar-default-char-expr
                                or ASYNCHRONOUS = scalar-default-char-
                                or BLANK = scalar-default-char-expr
                                or DECIMAL = scalar-default-char-expr
                                or DELIM = scalar-default-char-expr
                                or ENCODING = scalar-default-char-expr
                                or ERR = label
                                or FILE = file-name-expr
                                or FORM = scalar-default-char-expr
                                or IOMSG = iomsg-variable
                                or IOSTAT = scalar-int-variable
                                or NEWUNIT = scalar-int-variable
                                or PAD = scalar-default-char-expr
                                or POSITION = scalar-default-char-expr
                                or RECL = scalar-int-expr
                                or ROUND = scalar-default-char-expr
                                or SIGN = scalar-default-char-expr
                                or STATUS = scalar-default-char-expr

file-name-expr                  is scalar-default-char-expr

iomsg-variable                  is scalar-default-char-variable

close-stmt                      is CLOSE ( close-spec-list )

close-spec                      is [ UNIT = ] file-unit-number
                                or IOSTAT = scalar-int-variable
                                or IOMSG = iomsg-variable
                                or ERR = label
                                or STATUS = scalar-default-char-expr

read-stmt                       is READ ( io-control-spec-list ) [ input-item-list ]
                                or READ format [ , input-item-list ]

write-stmt                      is WRITE ( io-control-spec-list ) [ output-item-list ]

print-stmt                      is PRINT format [ , output-item-list ]

io-control-spec                 is [ UNIT = ] io-unit
                                or [ FMT = ] format
                                or [ NML = ] namelist-group-name
                                or ADVANCE = scalar-default-char-expr
                                or ASYNCHRONOUS = scalar-default-char-constant-expr
                                or BLANK = scalar-default-char-expr
                                or DECIMAL = scalar-default-char-expr
                                or DELIM = scalar-default-char-expr
                                or END = label
                                or EOR = label
                                or ERR = label
                                or ID = id-variable
                                or IOMSG = iomsg-variable
                                or IOSTAT = scalar-int-variable
                                or PAD = scalar-default-char-expr
                                or POS = scalar-int-expr
                                or REC = scalar-int-expr
                                or ROUND = scalar-default-char-expr
                                or SIGN = scalar-default-char-expr
                                or SIZE = scalar-int-variable

id-variable                     is scalar-int-variable

format                          is default-char-expr
                                or label
                                or *

input-item                      is variable
                                or io-implied-do

output-item                     is expr
                                or io-implied-do

io-implied-do                   is ( io-implied-do-object-list , io-implied-do-control )

io-implied-do-object            is input-item
                                or output-item

io-implied-do-control           is do-variable = scalar-int-expr ,
                                    scalar-int-expr [ , scalar-int-expr ]

dtv-type-spec                   is TYPE( derived-type-spec )
                                or CLASS( derived-type-spec )

wait-stmt                       is WAIT (wait-spec-list)

wait-spec                       is [ UNIT = ] file-unit-number
                                or END = label
                                or EOR = label
                                or ERR = label
                                or ID = scalar-int-expr
                                or IOMSG = iomsg-variable
                                or IOSTAT = scalar-int-variable

backspace-stmt                  is BACKSPACE file-unit-number
                                or BACKSPACE ( position-spec-list )

endfile-stmt                    is ENDFILE file-unit-number
                                or ENDFILE ( position-spec-list )

rewind-stmt                     is REWIND file-unit-number
                                or REWIND ( position-spec-list )

position-spec                   is [ UNIT = ] file-unit-number
                                or IOMSG = iomsg-variable
                                or IOSTAT = scalar-int-variable
                                or ERR = label

flush-stmt                      is FLUSH file-unit-number
                                or FLUSH ( flush-spec-list )

flush-spec                      is [UNIT =] file-unit-number
                                or IOSTAT = scalar-int-variable
                                or IOMSG = iomsg-variable
                                or ERR = label

inquire-stmt                    is INQUIRE ( inquire-spec-list )
                                or INQUIRE ( IOLENGTH = scalar-int-variable )
                                    output-item-list

inquire-spec                    is [ UNIT = ] file-unit-number
                                or FILE = file-name-expr
                                or ACCESS = scalar-default-char-variable
                                or ACTION = scalar-default-char-variable
                                or ASYNCHRONOUS = scalar-default-char-variable
                                or BLANK = scalar-default-char-variable
                                or DECIMAL = scalar-default-char-variable
                                or DELIM = scalar-default-char-variable
                                or DIRECT = scalar-default-char-variable
                                or ENCODING = scalar-default-char-variable
                                or ERR = label
                                or EXIST = scalar-logical-variable
                                or FORM = scalar-default-char-variable
                                or FORMATTED = scalar-default-char-variable
                                or ID = scalar-int-expr
                                or IOMSG = iomsg-variable
                                or IOSTAT = scalar-int-variable
                                or NAME = scalar-default-char-variable
                                or NAMED = scalar-logical-variable
                                or NEXTREC = scalar-int-variable
                                or NUMBER = scalar-int-variable
                                or OPENED = scalar-logical-variable
                                or PAD = scalar-default-char-variable
                                or PENDING = scalar-logical-variable
                                or POS = scalar-int-variable
                                or POSITION = scalar-default-char-variable
                                or READ = scalar-default-char-variable
                                or READWRITE = scalar-default-char-variable
                                or RECL = scalar-int-variable
                                or ROUND = scalar-default-char-variable
                                or SEQUENTIAL = scalar-default-char-variable
                                or SIGN = scalar-default-char-variable
                                or SIZE = scalar-int-variable
                                or STREAM = scalar-default-char-variable
                                or UNFORMATTED = scalar-default-char-variable
                                or WRITE = scalar-default-char-variable

format-stmt                     is FORMAT format-specification

format-specification            is ( [ format-items ] )
                                or ( [ format-items, ] unlimited-format-item )

format-items                    is format-item [ [ , ] format-item ] ...

format-item                     is [ r ] data-edit-desc
                                or control-edit-desc
                                or char-string-edit-desc
                                or [ r ] ( format-items )

unlimited-format-item           is * ( format-items )

r                               is int-literal-constant

data-edit-desc                  is I w [ . m ]
                                or B w [ . m ]
                                or O w [ . m ]
                                or Z w [ . m ]
                                or F w . d
                                or E w . d [ E e ]
                                or EN w . d [ E e ]
                                or ES w . d [ E e ]
                                or EX w . d [ E e ]
                                or G w [ . d [ E e ] ]
                                or L w
                                or A [ w ]
                                or D w . d
                                or DT [ char-literal-constant ] [ ( v-list ) ]

w                               is int-literal-constant

m                               is int-literal-constant

d                               is int-literal-constant

e                               is int-literal-constant

v                               is signed-int-literal-constant

control-edit-desc               is position-edit-desc
                                or [ r ] /
                                or :
                                or sign-edit-desc
                                or k P
                                or blank-interp-edit-desc
                                or round-edit-desc
                                or decimal-edit-desc

k                               is signed-int-literal-constant

position-edit-desc              is T n
                                or TL n
                                or TR n
                                or n X

n                               is int-literal-constant

sign-edit-desc                  is SS
                                or SP
                                or S

blank-interp-edit-desc          is BN
                                or BZ

round-edit-desc                 is RU
                                or RD
                                or RZ
                                or RN
                                or RC
                                or RP

decimal-edit-desc               is DC
                                or DP

char-string-edit-desc           is char-literal-constant

main-program                    is [ program-stmt ]
                                    [ specification-part ]
                                    [ execution-part ]
                                    [ internal-subprogram-part ]
                                    end-program-stmt

program-stmt                    is PROGRAM program-name

end-program-stmt                is END [ PROGRAM [ program-name ] ]

module                          is module-stmt
                                    [ specification-part ]
                                    [ module-subprogram-part ]
                                    end-module-stmt

module-stmt                     is MODULE module-name

end-module-stmt                 is END [ MODULE [ module-name ] ]

module-subprogram-part          is contains-stmt
                                    [ module-subprogram ] ...

module-subprogram               is function-subprogram
                                or subroutine-subprogram
                                or separate-module-subprogram

use-stmt                        is USE [ [ , module-nature ] :: ] module-name [ , rename-list ]
                                or USE [ [ , module-nature ] :: ] module-name ,
                                    ONLY : [ only-list ]

module-nature                   is INTRINSIC
                                or NON_INTRINSIC

rename                          is local-name => use-name
                                or OPERATOR (local-defined-operator) =>
                                    OPERATOR (use-defined-operator)

only                            is generic-spec
                                or only-use-name
                                or rename

only-use-name                   is use-name

local-defined-operator          is defined-unary-op
                                or defined-binary-op

use-defined-operator            is defined-unary-op
                                or defined-binary-op

submodule                       is submodule-stmt
                                    [ specification-part ]
                                    [ module-subprogram-part ]
                                    end-submodule-stmt

submodule-stmt                  is SUBMODULE ( parent-identifier ) submodule-name

parent-identifier               is ancestor-module-name [ : parent-submodule-name ]

end-submodule-stmt              is END [ SUBMODULE [ submodule-name ] ]

block-data                      is block-data-stmt
                                    [ specification-part ]
                                    end-block-data-stmt

block-data-stmt                 is BLOCK DATA [ block-data-name ]

end-block-data-stmt             is END [ BLOCK DATA [ block-data-name ] ]

interface-block                 is interface-stmt
                                    [ interface-specification ] ...
                                    end-interface-stmt

interface-specification         is interface-body
                                or procedure-stmt

interface-stmt                  is INTERFACE [ generic-spec ]
                                or ABSTRACT INTERFACE

end-interface-stmt              is END INTERFACE [ generic-spec ]

interface-body                  is function-stmt
                                    [ specification-part ]
                                    end-function-stmt
                                or subroutine-stmt
                                    [ specification-part ]
                                    end-subroutine-stmt

procedure-stmt                  is [ MODULE ] PROCEDURE [ :: ] specific-procedure-list

specific-procedure              is procedure-name

generic-spec                    is generic-name
                                or OPERATOR ( defined-operator )
                                or ASSIGNMENT ( = )
                                or defined-io-generic-spec

defined-io-generic-spec         is READ (FORMATTED)
                                or READ (UNFORMATTED)
                                or WRITE (FORMATTED)
                                or WRITE (UNFORMATTED)

generic-stmt                    is GENERIC [ , access-spec ] :: generic-spec => specific-procedure-list

import-stmt                     is IMPORT [[ :: ] import-name-list ]
                                or IMPORT, ONLY : import-name-list
                                or IMPORT, NONE
                                or IMPORT, ALL

external-stmt                   is EXTERNAL [ :: ] external-name-list

procedure-declaration-stmt      is PROCEDURE ( [ proc-interface ] )
                                    [ [ , proc-attr-spec ] ... :: ] proc-decl-list

proc-interface                  is interface-name
                                or declaration-type-spec

proc-attr-spec                  is access-spec
                                or proc-language-binding-spec
                                or INTENT ( intent-spec )
                                or OPTIONAL
                                or POINTER
                                or PROTECTED
                                or SAVE

proc-decl                       is procedure-entity-name [ => proc-pointer-init ]

interface-name                  is name

proc-pointer-init               is null-init
                                or initial-proc-target

initial-proc-target             is procedure-name

intrinsic-stmt                  is INTRINSIC [ :: ] intrinsic-procedure-name-list

function-reference              is procedure-designator ( [ actual-arg-spec-list ] )

call-stmt                       is CALL procedure-designator [ ( [ actual-arg-spec-list ] ) ]

procedure-designator            is procedure-name
                                or proc-component-ref
                                or data-ref % binding-name

actual-arg-spec                 is [ keyword = ] actual-arg

actual-arg                      is expr
                                or variable
                                or procedure-name
                                or proc-component-ref
                                or alt-return-spec

alt-return-spec                 is * label

prefix                          is prefix-spec [ prefix-spec ] ...

prefix-spec                     is declaration-type-spec
                                or ELEMENTAL
                                or IMPURE
                                or MODULE
                                or NON_RECURSIVE
                                or PURE
                                or RECURSIVE

function-subprogram             is function-stmt
                                    [ specification-part ]
                                    [ execution-part ]
                                    [ internal-subprogram-part ]
                                    end-function-stmt

function-stmt                   is [ prefix ] FUNCTION function-name
                                    ( [ dummy-arg-name-list ] ) [ suffix ]

proc-language-binding-spec      is language-binding-spec

dummy-arg-name                  is name

suffix                          is proc-language-binding-spec [ RESULT ( result-name ) ]
                                or RESULT ( result-name ) [ proc-language-binding-spec ]

end-function-stmt               is END [ FUNCTION [ function-name ] ]

subroutine-subprogram           is subroutine-stmt
                                    [ specification-part ]
                                    [ execution-part ]
                                    [ internal-subprogram-part ]
                                    end-subroutine-stmt

subroutine-stmt                 is [ prefix ] SUBROUTINE subroutine-name
                                    [ ( [ dummy-arg-list ] ) [ proc-language-binding-spec ] ]

dummy-arg                       is dummy-arg-name
                                or *

end-subroutine-stmt             is END [ SUBROUTINE [ subroutine-name ] ]

separate-module-subprogram      is mp-subprogram-stmt
                                    [ specification-part ]
                                    [ execution-part ]
                                    [ internal-subprogram-part ]
                                    end-mp-subprogram-stmt

mp-subprogram-stmt              is MODULE PROCEDURE procedure-name

end-mp-subprogram-stmt          is END [PROCEDURE [procedure-name]]

entry-stmt                      is ENTRY entry-name [ ( [ dummy-arg-list ] ) [ suffix ] ]

return-stmt                     is RETURN [ scalar-int-expr ]

contains-stmt                   is CONTAINS

stmt-function-stmt              is function-name ( [ dummy-arg-name-list ] ) = scalar-expr

```