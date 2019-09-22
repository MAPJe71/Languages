
/**
**  #4689 Function list ist not able to parse c-files correctly
**  https://sourceforge.net/p/notepad-plus/bugs/4689/
*/

void TestFunction(int parameter)/* My comment */
{
}

void TestFunction(int parameter/* My comment */)
{
}