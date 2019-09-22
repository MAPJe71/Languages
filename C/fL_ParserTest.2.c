
int works(int x){

    return(++x);
}

int /* test */ Function3() /* test */ { return 0; }

const /* comment */ int /* comment */ * /* comment */ & /* comment */ const /* comment */ Function6 /* comment */ ( /* comment */ ) /* comment */ { return 0; }

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

int also_works(int x)
{

    return(++x);
}

