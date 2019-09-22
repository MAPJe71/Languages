
# ASP - Active Server Pages

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

Notepad++ FunctionList plugin 2.x
```xml
<Language name="ASP" imagelistpath="">
    <CommList param1="&apos;" param2="" />
    <CommList param1="//"     param2="" />
    <Group 
        name       = "FUNCTION" 
        subgroup   = "" 
        icon       = "0" 
        child      = "0" 
        autoexp    = "0" 
        matchcase  = "0" 
        fendtobbeg = "" 
        bbegtobend = "" 
        keywords   = ""
    >
        <Rules 
            regexbeg  = "&lt;function\s+" 
            regexfunc = "\w+" 
            regexend  = "\s*\(.*\)" 
            bodybegin = "" 
            bodyend   = "&lt;end\s+function&gt;" 
            sep       = "" 
        />
        <Rules 
            regexbeg  = "&lt;sub\s+" 
            regexfunc = "\w+" 
            regexend  = "\s*\(.*\)" 
            bodybegin = "" 
            bodyend   = "&lt;end\s+sub&gt;" 
            sep       = "" 
        />
    </Group>
</Language>
```