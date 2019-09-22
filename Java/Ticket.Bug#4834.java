/*

#4834 Function List don't display java source files with javadoc comments 

    https://sourceforge.net/p/notepad-plus/bugs/4834/


Hello,

I noticed that the Function List is not working, if a java source file has 
javadoc comments.

As an example:
*/

class Test
{
    /**
    * Comment
    */
    public void myMethod()
    {}
}

/*
This will not listed as function in the Function List. Tested with all versions 
since introducing the official Function List, including 6.6.3.
*/
