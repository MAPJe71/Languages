#include "precompiledHeaders.h"
#include <vector>
using namespace std;

// These first two functions show up in the function list just fine:

int works(int x){
    
    return(++x);
}

int also_works(int x)
{
    
    return(++x);
}

bool ifStartWithKeywordAllowed()
{
}

// The next couple of functions don't:

int doesnt_work(int x) // comment
{
    
    return(++x);
}

int also_doesnt_work(int x) /* comment */
{
    
    return(++x);
}

int // I would never put a comment here but just illustrating the point
nope(int x){
    
    return(++x);
}

    int Function1()
    {
        return 0;
    }
    
    int Function2 ( Argint1 ArgName1, Argint2 ArgName2, ... )
    {
        return 0;
    }

    int /* test */ Function3() /* test */ { return 0; }
    const int Function4() { return 0; }
    int const Function5() { return 0; }
    
const /* comment */ int /* comment */ * /* comment */ & /* comment */ const /* comment */ Function6 /* comment */ ( /* comment */ ) /* comment */ { return 0; }

int Function7()
{ 
    return 0; 
}
    
    volatile int Function8() // test

	/* test */

    { return 0; }


volatile int Function9()
{
    return 0;
}

volatile int Function10(
      int Arg1
    , int Arg2
    , ...
    )
{
    return 0;
}

volatile /* comment */ int /* comment */ * /* comment */ & /* comment */ const /* comment */ Function11 /* comment */ ( /* comment */ 
      /* comment */int/* comment */Arg1              /* comment */
                                /* comment */
    , int Arg2
    , ...                       /* comment */
    ) /* comment */ { return 0; }

volatile                                /* comment */ 
int                                     /* comment */ 
*                                       /* comment */ 
&                                       /* comment */ 
const                                   /* comment */ 
Function12                              /* comment */ 
    (                                   /* comment */ 
      /* comment */int/* comment */Arg1 /* comment */
                                        /* comment */
    , int Arg2                          /* comment */
    , ...                               /* comment */
    )                                   /* comment */ 
{
    return 0; 
}

volatile                                // comment 
int                                     // comment 
*                                       // comment 
&                                       // comment 
const                                   // comment 
Function13                              // comment 
    (                                   // comment 
      /* comment */int/* comment */Arg1 // comment 
                                        // comment 
    , int Arg2                          // comment 
    , ...                               // comment 
    )                                   // comment 
{
    return 0; 
}

extern static int function14() { return 0; };
static extern int function15() { return 0; };

int 
static 
function16() { return 0; };
int 
extern 
function17() { return 0; };

extern int function18() { return 0; };
static int function19() { return 0; };

static static static int function20() { return 0; };

// Pointer-int Return
int*Function100_1_PointerReturnint() { return(0); }
int* Function100_2_PointerReturnint() { return(0); }
int *Function100_3_PointerReturnint() { return(0); }
int * Function100_4_PointerReturnint() { return(0); }

// Reference-int Return
int&Function101_1_ReferenceReturnint() { int* p(0); return(*p); }
int& Function101_2_ReferenceReturnint() { int* p(0); return(*p); }
int &Function101_3_ReferenceReturnint() { int* p(0); return(*p); }
int & Function101_4_ReferenceReturnint() { int* p(0); return(*p); }

// Pointer-to-Pointer-int Return
int**Function102_1_PointerToPointerReturnint() { return(0); }
int** Function102_2_PointerToPointerReturnint() { return(0); }
int* *Function102_3_PointerToPointerReturnint() { return(0); }
int* * Function102_4_PointerToPointerReturnint() { return(0); }
int **Function102_5_PointerToPointerReturnint() { return(0); }
int ** Function102_6_PointerToPointerReturnint() { return(0); }
int * *Function102_7_PointerToPointerReturnint() { return(0); }
int * * Function102_8_PointerToPointerReturnint() { return(0); }

int***************Function102_9_PointerToPointerReturnint() { return(0); }

// Reference-to-Pointer-int Return
int*&Function103_1_ReferenceToPointerReturnint() { static int* p(0); return(p); }
int*& Function103_2_ReferenceToPointerReturnint() { static int* p(0); return(p); }
int* &Function103_3_ReferenceToPointerReturnint() { static int* p(0); return(p); }
int* & Function103_4_ReferenceToPointerReturnint() { static int* p(0); return(p); }
int *&Function103_5_ReferenceToPointerReturnint() { static int* p(0); return(p); }
int *& Function103_6_ReferenceToPointerReturnint() { static int* p(0); return(p); }
int * &Function103_7_ReferenceToPointerReturnint() { static int* p(0); return(p); }
int * & Function103_8_ReferenceToPointerReturnint() { static int* p(0); return(p); }

// Pointer-to-Const-int return
const int*Function104_1_PointerToConstReturnint() { return(0); }
const int* Function104_2_PointerToConstReturnint() { return(0); }
const int *Function104_3_PointerToConstReturnint() { return(0); }
const int * Function104_4_PointerToConstReturnint() { return(0); }
int const* Function104_5_PointerToConstReturnint() { return(0); }
int const *Function104_6_PointerToConstReturnint() { return(0); }
int const * Function104_7_PointerToConstReturnint() { return(0); }

// Const-Pointer-int return
int*const Function105_1_ConstPointerReturnint() { return(0); }
int* const Function105_2_ConstPointerReturnint() { return(0); }
int *const Function105_3_ConstPointerReturnint() { return(0); }
int * const Function105_4_ConstPointerReturnint() { return(0); }

// Const-Pointer-to-Const-int return
const int*const Function106_1_ConstPointerToConstReturnint() { return(0); }
const int* const Function106_2_ConstPointerToConstReturnint() { return(0); }
const int *const Function106_3_ConstPointerToConstReturnint() { return(0); }
const int * const Function106_4_ConstPointerToConstReturnint() { return(0); }
int const* const Function106_5_ConstPointerToConstReturnint() { return(0); }
int const *const Function106_6_ConstPointerToConstReturnint() { return(0); }
int const * const Function106_7_ConstPointerToConstReturnint() { return(0); }

vector<int> Function107_1() 
{ 
    vector<int> aContainer;
    aContainer.push_back(1);
    aContainer.push_back(2);
    return(aContainer); 
}

vector<pair<int, int> > Function107_2() 
{ 
    vector<pair<int, int> > aContainer;
    aContainer.push_back(pair<int, int>(1,1));
    aContainer.push_back(pair<int, int>(2,2));
    return(aContainer); 
}
