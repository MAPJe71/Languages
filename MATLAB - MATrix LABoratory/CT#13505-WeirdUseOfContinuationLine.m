%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        WeirdUseOfContinuationLine.m
        \-- WeirdUseOfContinuationLine ( ...\r\n    str )

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

function ...
    WeirdUseOfContinuationLine ( ...
    str )
    disp( str )
    % This runs as expected.
end
