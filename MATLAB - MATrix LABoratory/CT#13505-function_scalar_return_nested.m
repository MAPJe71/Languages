%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        function_scalar_return_nested.m
        \-- out = function_scalar_return_nested( val )
            \-- nested

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

function    out = function_scalar_return_nested( val )
    out = 17;
    function nested
    end
end
