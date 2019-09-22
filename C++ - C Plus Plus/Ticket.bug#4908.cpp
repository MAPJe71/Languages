/*

#4908 Function list doesn't count all class functions in c++ 

    https://sourceforge.net/p/notepad-plus/bugs/4908/

    
Please find the attached C++ file, and open it wiht Np++.

Then click on the button "Function list" to see the list of functions.
The file contains 4 functions, but only 2 are shown in Function list because 
of a space before the operator ::
The same would be if instead of spaces we would have TABs.
If one is sure that all the functions are listed, this bug hides some causing 
energy and time wasting. The C++ compilers allow spaces before operator ::

*/

void MyClass::f1(){;}
void MyClass :: f2(){;}
void MyClass ::f3(){;}
void MyClass:: f4(){;}

MyClass::MyClass(int a):abc(d) {;}

