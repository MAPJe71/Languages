%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        class_with_keyword_in_string.m
        \-- class_with_keyword_in_string
            \-- no_return( this )

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

classdef    class_with_keyword_in_string
    methods
        function    no_return( this )
            str = 'string with keyword: while';
            a = 17;
        end
    end
end
