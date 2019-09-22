
/// https://sourceforge.net/p/notepad-plus/bugs/4938/

void FunctionName1()
{}

void FunctionName2() // comment
{}

void FunctionName3()
// comment
{}

void FunctionName4() /* comment */
{}

void FunctionName5()
/* comment */
{}

char  *sstr = "\
  void FunctionInsideString_ShouldNOTShow1() {\
  }\
";

char  *sstr = "                                 \
  void FunctionInsideString_ShouldNOTShow2() {  \
  }                                             \
";

TCHAR *sstr = TEXT("\
  void FunctionInsideString_ShouldNOTShow3() {\
  }\
");

char  *sstr = "void FunctionInsideString_ShouldNOTShow4() { }";
TCHAR *sstr = TEXT("void FunctionInsideString_ShouldNOTShow5() { }");