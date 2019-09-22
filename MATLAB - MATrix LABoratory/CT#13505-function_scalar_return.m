%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        function_scalar_return.m
        \-- [ out, val ] = function_scalar_return( val )

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

function    [ out, val ] = function_scalar_return( val )
    out = 17;
end
