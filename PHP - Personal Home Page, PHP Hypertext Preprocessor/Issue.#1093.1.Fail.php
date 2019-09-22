<?php
/*
    In functionList.xml the commentExpr ((/\*.*?\*)/|(//.*?$)) breaks function listing under some circumstances.

    1.
    Example PHP code:
*/

class Foo
{
    private function test1($var) {
        // Here comes the problem
        if ('//' === 'bar') {
        }
    }

    // this function will not be listed
    private function test2($var) {
    }
}

?>
