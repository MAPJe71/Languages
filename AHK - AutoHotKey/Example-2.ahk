red  := new Color(0xff0000), red.R -= 5
cyan := new Color(0), cyan.G := 255, cyan.B := 255

MsgBox % "red: " red.R "," red.G "," red.B " = " red.RGB
MsgBox % "cyan: " cyan.R "," cyan.G "," cyan.B " = " cyan.RGB

class Color
{
    __New(aRGB)
    {
        this.RGB := aRGB
    }

    static Shift := {R:16, G:8, B:0}

    __Get(aName)
    {
        ; NOTE: Using this.Shift here would cause an infinite loop!
        shift := Color.Shift[aName]  ; Get the number of bits to shift.
        if (shift != "")  ; Is it a known property?
            return (this.RGB >> shift) & 0xff
        ; NOTE: Using 'return' here would break this.RGB.
    }

    __Set(aName, aValue)
    {
        if ((shift := Color.Shift[aName]) != "")
        {
            aValue &= 255  ; Truncate it to the proper range.

            ; Calculate and store the new RGB value.
            this.RGB := (aValue << shift) | (this.RGB & ~(0xff << shift))

            ; 'Return' must be used to indicate a new key-value pair should not be created.
            ; This also defines what will be stored in the 'x' in 'x := clr[name] := val':
            return aValue
        }
        ; NOTE: Using 'return' here would break this.stored_RGB and this.RGB.
    }

    ; Meta-functions can be mixed with properties:
    RGB {
        get {
            ; Return it in hex format:
            return format("0x{:06x}", this.stored_RGB)
        }
        set {
            return this.stored_RGB := value
        }
    }
}
