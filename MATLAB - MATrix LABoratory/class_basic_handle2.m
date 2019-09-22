%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        class_basic_handle2.m
        +-- class_basic_handle
        |   +-- this = basic_handle( val )
        |   +-- no_return( this )
        |   \-- out = scalar_return( this )
        \-- class_basic_no_return2
            \-- no_return2( this )

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

classdef    class_basic_handle <  handle
    properties
        prop
    end
    methods
        function this = basic_handle( val )
            this.prop = val;
        end
        function    no_return( this )
            % body
        end
        function    out = scalar_return( this )
            out = 17;
        end
    end
end

classdef    class_basic_no_return2
    methods
        function    no_return2( this )
            if
                % body
            end
            for
                % body
            end
            while
                % body
            end
        end
    end
end
