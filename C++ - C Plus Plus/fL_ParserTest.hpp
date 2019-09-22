/*

classRange
mainExpr="
    (?:^|(?<=[\r\n]))
    \s*
    (?:class|struct)
    \s+
    (?'classname'
        [A-Za-z_][\w]*
    )
    (?'basetypes'
        \s*
        :
        \s*
        (?:public|protected|private)
        \s+
        [A-Za-z_][\w]*
        (?'multi'
            \s*
            ,
            \s*
            (?:public|protected|private)
            \s+
            [A-Za-z_][\w]*
        )*
    )?
    \s*
    \{
    "

class-range function
mainExpr="
    (?:^|(?<=[\r\n]))
    \s*
    (
        (?:static|const|virtual)
        \s+
    )?
    (?'returntype'
        [A-Za-z_][\w]*
        (
            \s+
            [A-Za-z_][\w]*
        )?
        (
            \s+
            (?:const\s+)?
        |
            [*&]
            \s+
            (?:const\s+)?
        |
            \s+
            (?:const\s+)?
            [*&]
        |
            \s+
            (?:const\s+)?
            [*&]
            \s+
            (?:const\s+)?
        )
    )?
    (?'functionname'
        (?!
            (if|while|for|switch)
        )
        [A-Za-z_~][\w]*
    )
    (?'arguments'
        \s*
        \(
        [^()]*
        \)
    )
    (?'base'
        (?'first'
            \s*
            :
            (?'firstname'
                \s*
                [A-Za-z_][\w]*
            )
            (?'firstargs'
                \s*
                \(
                [^()]*
                \)
            )
        )
        (?'consecutive'
            \s*
            ,
            (?'consecname'
                \s*
                [A-Za-z_][\w]*
            )
            (?'consecargs'
                \s*
                \(
                [^()]*
                \)
            )
        )*
    )?
    (?'suffix'
        \s+
        (?:const|throw)
    )?
    \s*
    \{
    " >

function
    mainExpr="
    (?:^|(?<=[\r\n]))
    \s*
    (
        (?:static|const|virtual)
        \s+
    )?
    (?'returntype'
        [A-Za-z_][\w]*
        (
            \s+
            [A-Za-z_][\w]*
        )?
        (
            \s+
            (?:const\s+)?
        |
            [*&]
            \s+
            (?:const\s+)?
        |
            \s+
            (?:const\s+)?
            [*&]
        |
            \s+
            (?:const\s+)?
            [*&]
            \s+
            (?:const\s+)?
        )
    )?
    (?'classname'
        [A-Za-z_][\w]*
        \s*
        ::
    )?
    (?'functionname'
        (?!
            (if|while|for|switch)
        )
        [A-Za-z_~][\w]*
    )
    (?'arguments'
        \s*
        \(
        [^()]*
        \)
    )
    (?'suffix'
        \s+
        (?:const|throw)
    )?
    \s*
    \{
    "
*/

/*  Skips over characters following the parameter list. This will be either
 *  non-ANSI style function declarations or C++ stuff. Our choices:
 *
 *  C (K&R):
 *    int func ();
 *    int func (one, two) int one; float two; {...}
 *  C (ANSI):
 *    int func (int one, float two);
 *    int func (int one, float two) {...}
 *  C++:
 *    int foo (...) [const|volatile] [throw (...)];
 *    int foo (...) [const|volatile] [throw (...)] [ctor-initializer] {...}
 *    int foo (...) [const|volatile] [throw (...)] try [ctor-initializer] {...}
 *        catch (...) {...}
 */

/*  Skips over a the mem-initializer-list of a ctor-initializer, defined as:
 *
 *  mem-initializer-list:
 *    mem-initializer, mem-initializer-list
 *
 *  mem-initializer:
 *    [::] [nested-name-spec] class-name (...)
 *    identifier
 */

char *sstr = "\
  void InsideString1() {\
  }\
";

char *sstr = "\
  void InsideString2()\
  {\
  }\
";


class /* comment_01 */ ClassName /* comment_02 */
    : /* comment_03 */ public    /* comment_04 */ BaseClassName1 /* comment_05 */
    , /* comment_06 */ protected /* comment_07 */ BaseClassName2 // comment_08
    , /* comment_09 */ private   /* comment_10 */ BaseClassName3 // comment_11
{
    // Constructors
    Constructor1();
    Constructor2() {};
    Constructor3() : BaseClassName1(), BaseClassName2(), BaseClassName3() {};

    // Destructors
    ~Destructor() {};
    virtual ~VirtualDestructor();

    // Methods
    Type Method1() {};
    Type Method2_ImplicitInline1();
    Type Method3_ImplicitInline2 ( ArgType1 ArgName1, ArgType2 ArgName2, ... );

    Type Method4_ExplicitInline1()
    {
        Type aValue(SomeValueData);
        //  :
        // (ab)use aValue
        //  :
        return aValue;
    };
    Type Method5_ExplicitInline2 ( ArgType1 ArgName1, ArgType2 ArgName2, ... )
    {
        Type aValue(SomeValueData);
        //  :
        // (ab)use aValue
        //  :
        return aValue;
    };

    Type /* test */ Method6_Const() /* test */ const /* test */ {};
    const Type Method7_Const_ConstReturnType1() const {};
    Type const Method8_Const_ConstReturnType2() const {};
    Type /* test */ const /* test */ * /* test */ const /* test */ Method9_Const_ConstPointerToConstReturnType() /* test */ const /* test */ {};

    static void Method10_Static() /* test */
    {};
    virtual void Method11_Virtual() // test
    {};
    virtual void Method12_PureVirtual() = 0; // Class is abstract when at least one pure-virtual-method is defined


    Type Method13_Throw() throw {};

    // Pointer-Type Return
    Type* Method14_PointerReturnType1() {};
    Type *Method15_PointerReturnType2() {};
    Type * Method16_PointerReturnType3() {};

    // Reference-Type Return
    Type& Method17_ReferenceReturnType1() {};
    Type &Method18_ReferenceReturnType2() {};
    Type & Method19_ReferenceReturnType3() {};

    // Pointer-to-Pointer-Type Return
    Type** Method20_PointerToPointerReturnType1() {};
    Type* *Method21_PointerToPointerReturnType2() {};
    Type* * Method22_PointerToPointerReturnType3() {};
    Type **Method23_PointerToPointerReturnType4() {};
    Type ** Method24_PointerToPointerReturnType5() {};
    Type * *Method25_PointerToPointerReturnType6() {};
    Type * * Method26_PointerToPointerReturnType7() {};

    // Reference-to-Pointer-Type Return
    Type*& Method27_ReferenceToPointerReturnType1() {};
    Type* &Method28_ReferenceToPointerReturnType2() {};
    Type* & Method29_ReferenceToPointerReturnType3() {};
    Type *&Method30_ReferenceToPointerReturnType4() {};
    Type *& Method31_ReferenceToPointerReturnType5() {};
    Type * &Method32_ReferenceToPointerReturnType6() {};
    Type * & Method33_ReferenceToPointerReturnType7() {};

    // Pointer-to-Reference-Type Return
    Type&* Method34_PointerToReferenceReturnType1() {};
    Type& *Method35_PointerToReferenceReturnType2() {};
    Type& * Method36_PointerToReferenceReturnType3() {};
    Type &*Method37_PointerToReferenceReturnType4() {};
    Type &* Method38_PointerToReferenceReturnType5() {};
    Type & *Method39_PointerToReferenceReturnType6() {};
    Type & * Method40_PointerToReferenceReturnType7() {};

    // Pointer-to-Const-Type return
    const Type* Method41_PointerToConstReturnType1() {};
    const Type *Method42_PointerToConstReturnType2() {};
    const Type * Method43_PointerToConstReturnType3() {};
    Type const* Method44_PointerToConstReturnType4() {};
    Type const *Method45_PointerToConstReturnType5() {};
    Type const * Method46_PointerToConstReturnType6() {};

    // Const-Pointer-Type return
    Type* const Method47_ConstPointerReturnType1() {};
    Type *const Method48_ConstPointerReturnType2() {};
    Type * const Method49_ConstPointerReturnType3() {};

    // Const-Pointer-to-Const-Type return
    const Type* const Method50_ConstPointerToConstReturnType1() {};
    const Type *const Method51_ConstPointerToConstReturnType2() {};
    const Type * const Method52_ConstPointerToConstReturnType3() {};
    Type const* const Method53_ConstPointerToConstReturnType4() {};
    Type const *const Method54_ConstPointerToConstReturnType5() {};
    Type const * const Method55_ConstPointerToConstReturnType6() {};

    // etc.

public:
    void         Method_PublicInline() {};
    PropertyType Member_Public;

protected:
    void         Method_ProtectedInline() {};
    PropertyType Member_Protected;

private:
    void         Method_PrivateInline() {};
    PropertyType Member_Private;

}

inline Type ClassName::MethodName_ImplicitInline1()
{
    Type aValue(SomeValueData);
    //  :
    // (ab)use aValue
    //  :
    return aValue;
}

inline Type ClassName::MethodName_ImplicitInline2(
      ArgType1 ArgName1
    , ArgType2 ArgName2
    , ...
    )
{
    Type aValue(SomeValueData);
    //  :
    // (ab)use aValue
    //  :
    return aValue;
}

