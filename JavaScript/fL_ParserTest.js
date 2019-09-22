
function abc() {  // will show
}

function abc2 () {
// will show
}

function def() {// will not show: at least two chars before comment
}

function ghi() { // will not show: at least two chars before comment
}

function jkl() {  /* will show */
}

function jkl2 () {
/* will show */
}

function mno () {/* will not show: at least two chars before comment */
}

function pqr () { /* will not show: at least two chars before comment */
}

function foo(a, /*optional*/ b) {
    // will not show: comment embedded in header not supported
}

function bar(/*arbitrary number of args*/) {
    // will not show: comment embedded in header not supported
}

