; https://notepad-plus-plus.org/community/topic/17529/function-list-does-not-ignore-commented-class-opening-and-closing-symbols

class myClass {
/*
    myMethod() {
    }
*/
    myOtherMethod() {
    }
}

myFunction1() {
}

/*
myFunction2() {
}
myFunction22() {
}
*/

myFunction3() {
}

class myClass2 {

    myClass2Method1() {
    }

/*
    myClass2Method2() {
    }
*/

    /*  ; as the start-of-comment indicator is not at the beginning of the line 
        ; it is not regarded as such and thus the method will be shown in the
        ; functionlist tree.
    myClass2Method3() {
    }
    */
}

