%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        class_basic_no_return2.m
        +-- class_basic_no_return
        |   \-- no_return( this )
        \-- class_basic_no_return2
            \-- no_return2( this )

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

classdef    class_basic_no_return
    methods
        function    no_return( this )
            % body
        end
    end
end

classdef    class_basic_no_return2
    methods
        function    no_return2( this )
            % body
        end
    end
end
