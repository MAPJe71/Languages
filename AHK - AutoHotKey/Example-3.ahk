; This example requires the FunctionObject class in order to work.
blue := new Color(0x0000ff)
MsgBox % blue.R "," blue.G "," blue.B

class Properties extends FunctionObject
{
    Call(aTarget, aName, aParams*)
    {
        ; If this Properties object contains a definition for this half-property, call it.
        if ObjHasKey(this, aName)
            return this[aName].Call(aTarget, aParams*)
    }
}

class Color
{
    __New(aRGB)
    {
        this.RGB := aRGB
    }

    class __Get extends Properties
    {
        R() {
            return (this.RGB >> 16) & 255
        }
        G() {
            return (this.RGB >> 8) & 255
        }
        B() {
            return this.RGB & 255
        }
    }

    ;...
}
