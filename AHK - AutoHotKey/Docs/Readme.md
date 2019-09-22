
# AutoHotkey

## Description


## Links

_WWW_

https://autohotkey.com/

_Wiki_

https://en.wikipedia.org/wiki/AutoHotkey

## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~


## Identifiers

```
identifier          =  < "a..z, $, _, 0..9, Windows-ANSI character over 00C0" > .
```

## String Literals

```
string              =  '"' < character > '"' .
character           =  "based on the Windows-ANSI character set" .
```

To include an actual quote character inside a quoted string, specify two 
consecutive quotes as shown twice in this example: 
```
    "She said, ""An apple a day."""
```
Quoted strings can contain escape sequences such as \`t (tab), \`n (linefeed), 
and \`r (carriage return). Unlike unquoted text, it is not necessary to escape
commas or percent signs, as quoted strings cannot contain variables. The use 
of the \`" escape sequence to produce a literal quote-character is currently 
not supported; instead, use two consecutive quotes as shown above.

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

Scripts can be commented by using a semicolon at the beginning of a line. 
For example:
```
    ; This entire line is a comment.
```
Comments may also be added to the end of a command, in which case the semicolon 
must have at least one space or tab to its left. For example:
```
    Run Notepad  ; This is a comment on the same line as a command.
```
In addition, the `/*` and `*/` symbols can be used to comment out an entire 
section, but only if the symbols appear at the beginning of a line as in this 
example:
```
    /*
    MsgBox, This line is commented out (disabled).
    MsgBox, This one too.
    */
```
Since comments are ignored when a script is launched, they do not impact 
performance or memory utilization.

The default comment character (semicolon) can be changed to some other character 
or string via `#CommentFlag`.

```
comment             = newline "/*" < character > newline "*/" newline
                    | < space > comment_identifier < character > newline .

comment_identifier  = ";" | "#commentflag" comment_string .

comment_string      = < character > .

character           =  "based on the Windows-ANSI character set" .

newline             = ( "\r" )? "\n" .

space               = " " | "\t" .
```

### Single line comment

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function

```
function            = identifier "(" expression < "," expression > ")"
                      "{" < statement > "}"

expression          = ( numeric_expression
                      | testing_expression
                      | logical_expression
                      | string_expression
                      | bit_expression
                      | literal_expression
                      | cont_sect_expressn
                      | identifier "(" expression < "," expression > ")" ) .

statement           = ( variable_declaration
                      | expression
                      | "{" < statement > "}"
                      | if_statement
                      | while_statement
                      | loop_statement
                      | "return" [ expression ]
                      | label statement
                      | command_statement ) newline .
```

## Grammar

.\Grammar\ahk.bnf

BNF | ABNF | EBNF | XBNF

```
hotkey              =                    identifier "::"                       ( statement | "{" < statement > "}" ) newline .

hotstring           = ":" identifier ":" identifier "::"                       ( statement | "{" < statement > "}" ) newline .

function            =     identifier "(" expression < "," expression > ")"                   "{" < statement > "}"

directive_statement = "#" identifier parameter

label               =     identifier ":" newline .
```

## HOTKEYS

|Symbol | Description |
|:----- |:-------------------------------------------------------------------- |
|`#`    | Win (Windows logo key). In v1.0.48.01+, for Windows Vista and later, |
|       | hotkeys that include the Windows key (e.g. `#a`) will wait for the   |
|       | Windows key to be released before sending any text containing an "L" |
|       | keystroke. This prevents usages of `Send` within such a hotkey from  |
|       | locking the PC. This behavior applies to all sending modes except    |
|       | `SendPlay` (which doesn't need it) and blind mode.                   |
|       ||
|`!`    | Alt                                                                  |
|       ||
|`^`    | Control                                                              |
|       ||
|`+`    | Shift                                                                |
|       ||
|`&`    | An ampersand may be used between any two keys or mouse buttons to    |
|       | combine them into a custom hotkey. See below for details.            |
|       ||
|`<`    | Use the left key of the pair. e.g. `<!a `is the same as `!a` except  |
|       | that only the left Alt key will trigger it.                          |
|       ||
|`>`    | Use the right key of the pair.                                       |
|       ||
|`<^>!` | AltGr (alternate graving). If your keyboard layout has an AltGr key  |
|       | instead of a right-Alt key, this series of symbols can usually be    |
|       | used to stand for AltGr. For example:                                |
|       | `<^>!m::MsgBox You pressed AltGr+m.`                                 |
|       | `<^<!m::MsgBox You pressed LeftControl+LeftAlt+m.`                   |
|       | Alternatively, to make AltGr itself into a hotkey, use the following |
|       | hotkey (without any hotkeys like the above present):                 |
|       | `LControl & RAlt::MsgBox You pressed AltGr itself.`                  |
|       ||
|`*`    | Wildcard: Fire the hotkey even if extra modifiers are being held     |
|       | down. This is often used in conjunction with remapping keys or       |
|       | buttons. For example:                                                |
|       | `*#c::Run Calc.exe  ; Win+C, Shift+Win+C, Ctrl+Win+C, etc. will all trigger this hotkey.`|
|       | `*ScrollLock::Run Notepad  ; Pressing ScrollLock will trigger this hotkey even when modifier key(s) are down.`|
|       | Wildcard hotkeys always use the keyboard hook, as do any hotkeys     |
|       | eclipsed by a wildcard hotkey. For example, the presence of `*a::`   |
|       | would cause `^a::` to always use the hook.                           |
|       ||
|`~`    | When the hotkey fires, its key's native function will not be blocked |
|       | (hidden from the system). In both of the below examples, the user's  |
|       | click of the mouse button will be sent to the active window:         |
|       | `~RButton::MsgBox You clicked the right mouse button.`               |
|       | `~RButton & C::MsgBox You pressed C while holding down the right mouse button.`|
|       | Unlike the other prefix symbols, the tilde prefix is allowed to be   |
|       | present on some of a hotkey's variants but absent on others. However,|
|       | if a tilde is applied to the prefix key of any custom combination    |
|       | which has not been turned off or suspended, it affects the behavior  |
|       | of that prefix key for all combinations.                             |
|       | Special hotkeys that are substitutes for alt-tab always ignore the   |
|       | tilde prefix.                                                        |
|       ||
|       | [v1.1.14+]: If the tilde prefix is applied to a custom modifier key  |
|       | (prefix key) which is also used as its own hotkey, that hotkey will  |
|       | fire when the key is pressed instead of being delayed until the key  |
|       | is released. For example, the `~RButton` hotkey above is fired as    |
|       | soon as the button is pressed. Prior to v1.1.14 (or without the      |
|       | tilde prefix), it was fired when the button was released, but only   |
|       | if the `RButton` & `C` combination was not activated.                |
|       ||
|       | If the tilde prefix is applied only to the custom combination and    |
|       | not the non-combination hotkey, the key's native function will still |
|       | be blocked. For example, in the script below, holding AppsKey will   |
|       | show the ToolTip and will not trigger a context menu:                |
|       | `AppsKey::ToolTip Press < or > to cycle through windows.`            |
|       | `AppsKey Up::ToolTip`                                                |
|       | `~AppsKey & <::Send !+{Esc}`                                         |
|       | `~AppsKey & >::Send !{Esc}`                                          |
|       | If at least one variant of a keyboard hotkey has the tilde modifier, |
|       | that hotkey always uses the keyboard hook.                           |
|       ||
|`$`    | This is usually only necessary if the script uses the Send command   |
|       | to send the keys that comprise the hotkey itself, which might        |
|       | otherwise cause it to trigger itself. The `$` prefix forces the      |
|       | keyboard hook to be used to implement this hotkey, which as a side-  |
|       | effect prevents the Send command from triggering it. The `$` prefix  |
|       | is equivalent to having specified `#UseHook` somewhere above the     |
|       | definition of this hotkey.                                           |
|       ||
|       | The `$` prefix has no effect for mouse hotkeys, since they always    |
|       | use the mouse hook. It also has no effect for hotkeys which already  |
|       | require the keyboard hook, including any keyboard hotkeys with the   |
|       | tilde (`~`) or wildcard (`*`) modifiers, key-up hotkeys and custom   |
|       | combinations. To determine whether a particular hotkey uses the      |
|       | keyboard hook, use ListHotkeys.                                      |
|       | |
|       | [v1.1.06+]: `#InputLevel` and `SendLevel` provide additional control |
|       | over which hotkeys and hotstrings are triggered by the `Send`        |
|       | command.                                                             |
|       ||
|`UP`   | The word `UP` may follow the name of a hotkey to cause the hotkey to |
|       | fire upon release of the key rather than when the key is pressed     |
|       | down. The following example remaps LWin to become `LControl`:        |
|       | `*LWin::Send {LControl Down}`                                        |
|       | `*LWin Up::Send {LControl Up}`                                       |
|       | "Up" can also be used with normal hotkeys as in this example:        |
|       | `^!r Up::MsgBox You pressed and released Ctrl+Alt+R.`                |
|       | It also works with combination hotkeys (e.g. `F1` & `e Up::`)        |
|       ||
|       | Limitations:                                                         |
|       | 1) "Up" does not work with joystick buttons; and                     |
|       | 2) An "Up" hotkey without a normal/down counterpart hotkey will      |
|       | completely take over that key to prevent it from getting stuck down. |
|       | One way to prevent this is to add a tilde prefix (e.g.               |
|       | `~LControl up::`) "Up" hotkeys and their key-down counterparts (if   |
|       | any) always use the keyboard hook.                                   |
|       ||
|       | On a related note, a technique similar to the above is to make a     |
|       | hotkey into a prefix key. The advantage is that although the hotkey  |
|       | will fire upon release, it will do so only if you did not press any  |
|       | other key while it was held down.                                    |
|       | For example:                                                         |
|       | `LControl & F1::return  ; Make left-control a prefix by using it in front of "&" at least once.` |
|       | `LControl::MsgBox You released LControl without having used it to modify any other key.` |


## Mouse

### General
|||
|:--------- |:---------------------------- |
| `LButton` | Left mouse button            |
| `RButton` | Right mouse button           |
| `MButton` | Middle or wheel mouse button |
   
### Advanced
|||
|:---------- |:--------------------------------------------------------------- |
| `XButton1` | 4th mouse button. Typically performs the same function as       |
|            | `Browser_Back`.                                                 |
| `XButton2` | 5th mouse button. Typically performs the same function as       |
|            | `Browser_Forward`.                                              |
   
### Wheel      
|||
|:---------- |:-------------------------------------- |
|`WheelDown` | Turn the wheel downward (toward you).  |
|`WheelUp`   | Turn the wheel upward (away from you). |
|`WheelLeft` ||
|`WheelRight`||

[v1.0.48+]: Scroll to the left or right.

Requires Windows Vista or later. These can be used as hotkeys with some (but
not all) mice which have a second wheel or support tilting the wheel to 
either side. In some cases, software bundled with the mouse must instead be 
used to control this feature. Regardless of the particular mouse, Send and 
Click can be used to scroll horizontally in programs which support it.


## Keyboard

***Note***:
The names of the letter and number keys are the same as that single letter or 
digit. For example: `b` is the "b" key and `5` is the "5" key.

### General
|||
|:---------------- |:-------------- |
|`CapsLock`        | Caps lock      |
|`Space`           | Space bar      |
|`Tab`             | Tab key        |
|`Enter`, `Return` | Enter key      |
|`Escape`, `Esc`   | Esc key        |
|`Backspace`, `BS` | Backspace      |

### Cursor Control
|                |                   |
|:-------------- |:----------------- |
|`ScrollLock`    | Scroll lock       |
|`Delete`, `Del` | Delete key        |
|`Insert`, `Ins` | Insert key        |
|`Home`          | Home key          |
|`End`           | End key           |
|`PgUp`          | Page Up key       |
|`PgDn`          | Page Down key     |
|`Up`            | Up arrow key      |
|`Down`          | Down arrow key    |
|`Left`          | Left arrow key    |
|`Right`         | Right arrow key   |

### Numpad
Due to system behavior, the following keys are identified differently depending 
on whether `NumLock` is ON or OFF. If NumLock is OFF but Shift is pressed, the 
system temporarily releases Shift and acts as though NumLock is ON.

#### NumLock 
|ON|OFF||
|:---------- |:------------- |:-------------------------------- |
|`Numpad0`   | `NumpadIns`   | 0 / Insert key                   |
|`Numpad1`   | `NumpadEnd`   | 1 / End key                      |
|`Numpad2`   | `NumpadDown`  | 2 / Down arrow key               |
|`Numpad3`   | `NumpadPgDn`  | 3 / Page Down key                |
|`Numpad4`   | `NumpadLeft`  | 4 / Left arrow key               |
|`Numpad5`   | `NumpadClear` | 5 / typically does nothing       |
|`Numpad6`   | `NumpadRight` | 6 / Right arrow key              |
|`Numpad7`   | `NumpadHome`  | 7 / Home key                     |
|`Numpad8`   | `NumpadUp`    | 8 / Up arrow key                 |
|`Numpad9`   | `NumpadPgUp`  | 9 / Page Up key                  |
|`NumpadDot` | `NumpadDel`   | Decimal separation / Delete key  |

#### Not affected by NumLock
|||
|:------------ |:-------------- |
|`NumLock`     | Number lock    |
|`NumpadDiv`   | Divide         |
|`NumpadMult`  | Multiply       |
|`NumpadAdd`   | Add            |
|`NumpadSub`   | Subtract       |
|`NumpadEnter` | Enter key      |

### Function
|||
|:----------- |:---------------------------------------------------------- |
|`F1` - `F24` | The 12 or more function keys at the top of most keyboards. |

### Modifier
|||
|:---------------- |:------------------------------------------------------- |
|LWin              | Left Windows logo key. Corresponds to the <# hotkey     |
|                  | prefix.                                                 |
|RWin              | Right Windows logo key. Corresponds to the ># hotkey    |
|                  | prefix.                                                 |
|                  | Note: Unlike Control/Alt/Shift, there is no generic/    |
|                  |       neutral "Win" key because the OS does not         |
|                  |       support it. However, hotkeys with the # modifier  |
|                  |       can be triggered by either Win key.               |
|Control, Ctrl     | Control key. As a hotkey (Control::) it fires upon      |
|                  | release unless it has the tilde prefix. Corresponds to  |
|                  | the ^ hotkey prefix.                                    |
|Alt               | Alt key. As a hotkey (Alt::) it fires upon release      |
|                  | unless it has the tilde prefix. Corresponds to the !    |
|                  | hotkey prefix.                                          |
|Shift             | Shift key. As a hotkey (Shift::) it fires upon release  |
|                  | unless it has the tilde prefix. Corresponds to the +    |
|                  | hotkey prefix.                                          |
|LControl, LCtrl   | Left Control key. Corresponds to the <^ hotkey prefix.  |
|RControl, RCtrl   | Right Control key. Corresponds to the >^ hotkey prefix. |
|LShift            | Left Shift key. Corresponds to the <+ hotkey prefix.    |
|RShift            | Right Shift key. Corresponds to the >+ hotkey prefix.   |
|LAlt              | Left Alt key. Corresponds to the <! hotkey prefix.      |
|RAlt              | Right Alt key. Corresponds to the >! hotkey prefix.     |
|                  | Note: If your keyboard layout has AltGr instead of      |
|                  |       RAlt, you can probably use it as a hotkey prefix  |
|                  |       via <^>! as described here. In addition,          |
|                  |       LControl & RAlt:: would make AltGr itself into    |
|                  |       a hotkey.                                         |

### Multimedia
|||
|:---------------- |:---------------------------------- |
|Browser_Back      | Back                               |
|Browser_Forward   | Forward                            |
|Browser_Refresh   | Refresh                            |
|Browser_Stop      | Stop                               |
|Browser_Search    | Search                             |
|Browser_Favorites | Favorites                          |
|Browser_Home      | Homepage                           |
|Volume_Mute       | Mute the volume                    |
|Volume_Down       | Lower the volume                   |
|Volume_Up         | Increase the volume                |
|Media_Next        | Next Track                         |
|Media_Prev        | Previous Track                     |
|Media_Stop        | Stop                               |
|Media_Play_Pause  | Play/Pause                         |
|Launch_Mail       | Launch default e-mail program      |
|Launch_Media      | Launch default media player        |
|Launch_App1       | Launch My Computer                 |
|Launch_App2       | Launch Calculator                  |

***Note***:
The function assigned to each of the keys listed above can be overridden by 
modifying the Windows registry. This table shows the default function of each 
key on most versions of Windows.

### Special
|||
|:------------|:-------------------------------------------------------------- |
|`AppsKey`    | Menu key. This is the key that invokes the right-click         |
|             | context menu.                                                  |
|`PrintScreen`| Print screen                                                   |
|`CtrlBreak`  |                                                                |
|`Pause`      | Pause key                                                      |
|`Break`      | Break key. Since this is synonymous with Pause, use            |
|             | `^CtrlBreak` in hotkeys instead of `^Pause` or `^Break`.       |
|`Help`       | Help key. This probably doesn't exist on most keyboards. It's  |
|             | usually not the same as F1.                                    |
|`Sleep`      | Sleep key. Note that the sleep key on some keyboards might     |
|             | not work with this.                                            |
|`SCnnn`      | Specify for nnn the scan code of a key. Recognizes unusual     |
|             | keys not mentioned above. See Special Keys for details.        |
|`VKnn`       | Specify for nn the hexadecimal virtual key code of a  key.     |
|             | This rarely-used method also prevents certain types of         |
|             | hotkeys from requiring the keyboard hook. For example, the     |
|             | following hotkey does not use the keyboard hook, but as a      |
|             | side-effect it is triggered by pressing either `Home` or       |
|             | `NumpadHome`:                                                  |
|             |     `^VK24::MsgBox You pressed Home or NumpadHome while holding down Control.`|
|             | Known limitation: VK hotkeys that are forced to use the        |
|             | keyboard hook, such as `*VK24` or `~VK24`, will fire for only  |
|             | one of the keys, not both (e.g. `NumpadHome` but not `Home`).  |
|             | For more information about the `VKnn` method, see Special      |
|             | Keys.                                                          |


## Joystick
|||
|:---------------- |:--------------------------------------------------------- |
|`Joy1` - `Joy32`  | The buttons of the joystick. To help determine the button |
|                  | numbers for your joystick, use this test script.          |
|                  | Note that hotkey prefix symbols such as `^` (control) and |
|                  | `+` (shift) are not supported (though `GetKeyState` can   |
|                  | be used as a substitute). Also note that the pressing of  |
|                  | joystick buttons always "passes through" to the active    |
|                  | window if that window is designed to detect the pressing  |
|                  | of joystick buttons.                                      |

Although the following Joystick control names cannot be used as hotkeys,
they can be used with `GetKeyState`:

|||
|:--------------------- |:---------------------------------------------------- |
|`JoyX`, `JoyY`, `JoyZ` | The X (horizontal), Y (vertical), and Z (altitude/   |
|                       | depth) axes of the joystick.                         |
|`JoyR`                 | The rudder or 4th axis of the joystick.              |
|`JoyU`, `JoyV`         | The 5th and 6th axes of the joystick.                |
|`JoyPOV`               | The point-of-view (hat) control.                     |
|`JoyName`              | The name of the joystick or its driver.              |
|`JoyButtons`           | The number of buttons supported by the joystick (not |
|                       | always accurate).                                    |
|`JoyAxes`              | The number of axes supported by the joystick.        |
|`JoyInfo`              | Provides a string consisting of zero or more of the  |
|                       | following letters to indicate the joystick's         |
|                       | capabilities: Z (has Z axis), R (has R axis), U (has |
|                       | U axis), V (has V axis), P (has POV control), D (the |
|                       | POV control has a limited number of discrete/        |
|                       | distinct settings), C (the POV control is continous/ |
|                       | fine). Example string: `ZRUVPD`                      |

Multiple Joysticks: If the computer has more than one joystick and you want
to use one beyond the first, include the joystick number (max 16) in front
of the control name. For example, `2joy1` is the second joystick's first
button.

***Note***:
If you have trouble getting a script to recognize your joystick, one person 
reported needing to specify a joystick number other than 1 even though only a 
single joystick was present. It is unclear how this situation arises or whether 
it is normal, but experimenting with the joystick number in the joystick test 
script can help determine if this applies to your system.

