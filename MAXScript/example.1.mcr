/*
    Expected Function List tree:
        example.1.mcr
        \-- macroscriptName
            +-- macroscriptMethod1
            \-- macroscriptMethod2

    macroScript     ThisShouldNotBeVisibleInFunctionListTree ()
    macroScript     ThisShouldNotBeVisibleInFunctionListTree
    (
        fn          ThisShouldNotBeVisibleInFunctionListTree = ()
        function    ThisShouldNotBeVisibleInFunctionListTree = ()
    )
    fn              ThisShouldNotBeVisibleInFunctionListTree = ()
    function        ThisShouldNotBeVisibleInFunctionListTree = ()
    struct          ThisShouldNotBeVisibleInFunctionListTree
    (
        fn          ThisShouldNotBeVisibleInFunctionListTree = ()
        function    ThisShouldNotBeVisibleInFunctionListTree = ()
    )
*/

macroscript macroscriptName category:"WerwacKScripts" internalCategory:"WerwacKScripts" tooltip:"Wk3DTexturer" buttonText:"Wk3DTexturer" Icon:#("Wk3DTexturer",1)
(
    fn       macroscriptMethod1
    = ()
    fn       macroscriptMethod2 optionalParam1: optionalParam2:"my default value"      = ()
    function macroscriptMethod3 optionalParam1: optionalParam2:"my default value" = ()
    function macroscriptMethod4 arrayParam1: #("", 1)       = ()
)
