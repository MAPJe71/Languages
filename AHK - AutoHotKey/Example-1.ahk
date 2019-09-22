class ClassName1 extends BaseClassName
{
    InstanceVar := Expression
    static ClassVar := Expression

    class NestedClassName
    {
        ...
    }

    MethodName()
    {
        ...
    }

    PropertyName[]  ; Brackets are optional
    {
        get {
            return ...
        }
        set {
            return ... := value
        }
    }
}

; Method syntax:
class ClassName2 {
    __Get([Key, Key2, ...])
    __Set([Key, Key2, ...], Value)
    __Call(Name [, Params...])
}

; Function syntax:
MyGet(this [, Key, Key2, ...])
MySet(this [, Key, Key2, ...], Value)
MyCall(this, Name [, Params...])
ClassName3 := { 
    __Get: Func("MyGet"), 
    __Set: Func("MySet"), 
    __Call: Func("MyCall") 
}
