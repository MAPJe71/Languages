
# KAREL

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
[KAREL] ------------------------------------------------------------------------
@=KAREL - Robot Programming Language by FANUC (Fuji Automatic NUmerical Control)

_WWW_=http://www.fanuc.com/
http://www.fanuc.eu/uk/en?srb=1

_Wiki_=

Keywords=

   ABORT           CONST           GO              NOT         STRING
   ABOUT           CONTINUE        GOTO            NOWAIT      STRUCTURE
   ABS             COORDINATED     GROUP           OF          THEN
   AFTER           CR              GROUP_ASSOC     OPEN        TIME
   ALONG           DELAY           HAND            OR          TIMER
   ALSO            DISABLE         HOLD            PATH        TO
   AND             DISCONNECT      IF              PATHHEADER  TPENABLE
   ARRAY           DIV             IN              PAUSE       TYPE
   ARRAY_LEN       DO              INDEPENDENT     POSITION    UNHOLD
   AT              DOWNTO          INTEGER         POWERUP     UNINIT
   ATTACH          DRAM            JOINTPOS        PROGRAM     UNPAUSE
   AWAY            ELSE            JOINTPOS1       PULSE       UNTIL
   AXIS            ENABLE          JOINTPOS2       PURGE       USING
   BEFORE          END             JOINTPOS3       READ        VAR
   BEGIN           ENDCONDITION    JOINTPOS4       REAL        VECTOR
   BOOLEAN         ENDFOR          JOINTPOS5       RELATIVE    VIA
   BY              ENDIF           JOINTPOS6       RELAX       VIS_PROCESS
   BYNAME          ENDMOVE         JOINTPOS7       RELEASE     WAIT
   BYTE            ENDSELECT       JOINTPOS8       REPEAT      WHEN
   CAM_SETUP       ENDSTRUCTURE    JOINTPOS9       RESTORE     WHILE
   CANCEL          ENDUSING        MOD             RESUME      WITH
   CASE            ENDWHILE        MODEL           RETURN      WRITE
   CLOSE           ERROR           MOVE            ROUTINE     XYZWPR
   CMOS            EVAL            NEAR            SELECT      XYZWPREXT
   COMMAND         EVENT           NOABORT         SEMAPHORE
   COMMON_ASSOC    FILE            NODE            SET_VAR
   CONDITION       FOR             NODEDATA        SHORT
   CONFIG          FROM            NOMESSAGE       SIGNAL
   CONNECT         GET_VAR         NOPAUSE         STOP

   A RegEx to find them all:

       \b(?!(?-i:
       	A(?:B(?:O[RU]T|S)|FTER|L(?:ONG|SO)|ND|RRAY(?:_LEN)?|T(?:TACH)?|WAY|XIS)
       |	B(?:E(?:FORE|GIN)|OOLEAN|Y(?:NAME|TE)?)
       |	C(?:A(?:M_SETUP|NCEL|SE)|LOSE|MOS|O(?:MM(?:AND|ON_ASSOC)|N(?:DITION|FIG|NECT|ST|TINUE)|ORDINATED)|R)
       |	D(?:ELAY|I(?:S(?:ABLE|CONNECT)|V)|O(?:WNTO)?|RAM)
       |	E(?:LSE|N(?:ABLE|D(?:CONDITION|FOR|IF|MOVE|S(?:ELECT|TRUCTURE)|USING|WHILE)?)|RROR|V(?:AL|ENT))
       |	F(?:ILE|OR|ROM)
       |	G(?:ET_VAR|O(?:TO)?|ROUP(?:_ASSOC)?)
       |	H(?:AN|OL)D
       |	I(?:F|N(?:DEPENDENT|TEGER)?)
       |	JOINTPOS[1-9]?
       |	MO(?:D(?:EL)?|VE)
       |	N(?:EAR|O(?:ABORT|DE(?:DATA)?|MESSAGE|PAUSE|T|WAIT))
       |	O(?:[FR]|PEN)
       |	P(?:A(?:TH(?:HEADER)?|USE)|O(?:SITION|WERUP)|ROGRAM|U(?:LS|RG)E)
       |	R(?:E(?:A[DL]|L(?:A(?:TIVE|X)|EASE)|PEAT|S(?:TOR|UM)E|TURN)|OUTINE)
       |	S(?:E(?:LECT|MAPHORE|T_VAR)|HORT|IGNAL|T(?:OP|R(?:ING|UCTURE)))
       |	T(?:HEN|IMER?|O|PENABLE|YPE)
       |	U(?:N(?:HOLD|INIT|PAUSE|TIL)|SING)
       |	V(?:AR|ECTOR|I(?:A|S_PROCESS))
       |	W(?:AIT|H(?:EN|ILE)|ITH|RITE)
       |	XYZWPR(?:EXT)?
       )\b)

Identifiers=

   User-defined identifiers represent constants, data types, statement labels,
   variables, routine names, and program names. Identifiers
   • Start with a letter
   • Can include letters, digits, and underscores
   • Can have a maximum of 12 characters
   • Can have only one meaning within a particular scope. Refer to Section 5.1.4.
   • Cannot be reserved words

   [A-Za-z]\w{0,11}

StringLiterals=

Comment=

   Comments are lines of text within a program used to make the program easier
   for you or another programmer to understand. For example, "Comments From
   Within a Program" contains some comments from %INCLUDE Directive in a KAREL
   Program and Include File mover_decs for a KAREL Program.

   Comments From Within a Program

       --This program, called mover, picks up 10 objects
       --from an original POSITION and puts them down
       --at a destination POSITION.
       original    : POSITION   --POSITION of objects
       destination : POSITION   --Destination of objects
       count       : INTEGER    --Number of objects moved

   A comment is marked by a pair of consecutive hyphens (--). On a program
   line, anything to the right of these hyphens is treated as a comment.

   Comments can be inserted on lines by themselves or at the ends of lines
   containing any program statement. They are ignored by the translator and
   have absolutely no effect on a running program.

Classes_and_Methods=

Function=

Labels are special identifiers that mark places in the program to which program control can be
transferred using the GOTO Statement.
• Are immediately followed by two colons (::). Executable statements are permitted on the same
line and subsequent lines following the two colons.
• Cannot be used to transfer control into or out of a routine.


Grammar=

