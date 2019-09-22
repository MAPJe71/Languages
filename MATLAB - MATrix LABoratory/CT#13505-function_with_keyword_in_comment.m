%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        function_with_keyword_in_comment.m
        \-- [ out, val ] = function_with_keyword_in_comment( val )

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

function [ out, val ] = function_with_keyword_in_comment( val )
    out = 17;
    % comment with keyword: while
end
