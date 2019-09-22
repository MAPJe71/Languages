<?php
/*

#4886 Npp function list can't recognize php file without php end tag

    https://sourceforge.net/p/notepad-plus/bugs/4886/

*/

class TestClass2
{
public function TestFunc1() {} /* Doesn't show */
    public function TestFunc2() {} /* Does show */
}

/*
    Conclusion:
        Not related to PHP end tag but to method indent
*/
