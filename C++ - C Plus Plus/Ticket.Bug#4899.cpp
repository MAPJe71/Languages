/*

#4899 FunctionList Parser Stumbles on Unmatched *Opened* Curly Braces Enclosed in Quotes

    https://sourceforge.net/p/notepad-plus/bugs/4899/

The functionList parser stumbles on unmatched opening curly braces enclosed in
quotes (but not on closing curly braces) and in consequence fails to recognize
classes and methods.

I hope that someone is deeper in the parsing code than I am and can fix this
much quicker than I could.

Example for PHP:

<!-- Parsed incorrectly -->
<?php
class MyClass {
    function __construct(){}

    private function myFunc()
    {
        $a = "{";
    }
};
?>

<!-- Parsed incorrectly -->
<?php
class InstallApp1 {
    public function myFunc()
    {
        $s = "/*";
    }
    /* *
    ** Comment
    ** /
};
?>

<!-- Parsed correctly -->
<?php
class InstallApp2 {
    public function myFunc()
    {
        $s = "/*";
        $s = "*/";
    }
    /* *
    ** Comment
    ** /
};
?>

/*
    Example for C++:
*/

class MyClass1 {
    void myFunc() {
        char a = '{';
    };
};

/*
    Funnily, as mentioned, this is not a Problem:
*/

class MyClass2 {
    void myFunc() {
        char a = '}';
    };
};

/*
    Neither are opening curly braces in comments.
*/
