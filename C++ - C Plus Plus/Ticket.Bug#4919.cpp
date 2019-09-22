/*

#4919 Notepad++ 6.6.7 - Function list with C files with functions returning unsigned *

    https://sourceforge.net/p/notepad-plus/bugs/4919/


Function list does show functions returning unsigned int or unsigned char.
Example:

*/

unsigned int module ( int x ) { ... }

/*
    is not showed in the function list
*/