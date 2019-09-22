
# Baan-C

## Description
BaanC is case insensitive and space insensitive.

Any number of SPACE and TAB can be used everywhere.


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
| This is a BaanC comment.
| A comment starts with a pipe and ends at any EOL (Unix/Win/Mac)
| Comments can be placed anywhere.

### Single line comment

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function
 Function definition:
 * Should start with the keyword "function" (preceding spaces/TABs allowed)
 * followed by simple return type (if any) and function name.
 * Simple returns are [string|boolean|long|double|void]. void is optional.
 * for complex return types keyword "domain <domainName>" is used.
 * '()' are used for function parameters
 * '{}' are used to indicate function open/close.
 * External functions are defined with two keywords "function extern" + all above conditions.


## Grammar

BNF | ABNF | EBNF | XBNF

List of Main Sections:

    Main Sections                                   Has SubSections?

    after.<charsDigitsPeriods>.<digitsOnly>:        Atleast one Sub-Section, can have multiple SubSections

    after.form.read:                                No Subsection
    after.program:                                  No Subsection
    after.receive.data:                             No Subsection

    after.report.<digitsOnly>:                      Atleast one Sub-Section, can have multiple SubSections

    after.update.db.commit:                         No Subsection

    before.<charsDigitsPeriods>.<digitsOnly>:       Atleast one Sub-Section, can have multiple SubSections

    before.display.object:                          No Subsection
    before.new.object:                              No Subsection
    before.program:                                 No Subsection

    before.report.<digitsOnly>:                     Atleast one Sub-Section, can have multiple SubSections
    choice.<charsDigitsPeriods>:                    Atleast one Sub-Section, can have multiple SubSections

    declaration:                                    No Subsection

    detail.<digitsOnly>:                            Atleast one Sub-Section, can have multiple SubSections
    field.<charsDigitsPeriods>:                     Atleast one Sub-Section, can have multiple SubSections
    field.all:                                      Atleast one Sub-Section, can have multiple SubSections
    field.other:                                    Atleast one Sub-Section, can have multiple SubSections
    footer.<digitsOnly>:                            Atleast one Sub-Section, can have multiple SubSections
    form.<digitsOnly>:                              Atleast one Sub-Section, can have multiple SubSections
    form.all:                                       Atleast one Sub-Section, can have multiple SubSections
    form.other:                                     Atleast one Sub-Section, can have multiple SubSections

    functions:                                      No Subsection, but functions are present

    group.<digitsOnly>:                             Atleast one Sub-Section, can have multiple SubSections
    header.<digitsOnly>:                            Atleast one Sub-Section, can have multiple SubSections
    main.table.io:                                  Atleast one Sub-Section, can have multiple SubSections

    on.display.total.line:                          No Subsection
    on.error:                                       No Subsection

    zoom.from.<charsDigitsPeriods>:                 Atleast one Sub-Section, can have multiple SubSections
    zoom.from.all:                                  Atleast one Sub-Section, can have multiple SubSections
    zoom.from.other:                                Atleast one Sub-Section, can have multiple SubSections


List of Sub Sections

    Sub Sections

    after.choice:
    after.delete:
    after.display:
    after.field:
    after.form:
    after.group:
    after.input:
    after.layout:
    after.read:
    after.rewrite:
    after.skip.delete:
    after.skip.rewrite:
    after.skip.write:
    after.write:
    after.zoom:

    before.checks:
    before.choice:
    before.delete:
    before.display:
    before.field:
    before.form:
    before.group:
    before.input:
    before.layout:
    before.print:
    before.read:
    before.rewrite:
    before.write:
    before.zoom:

    check.input:

    domain.error:

    init.field:
    init.form:
    init.group:

    on.choice:
    on.entry:
    on.exit:
    on.input:

    read.view:

    ref.display:
    ref.input:

    selection.filter:

    when.field.changes:
