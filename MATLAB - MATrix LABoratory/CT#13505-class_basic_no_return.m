%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        class_basic_no_return.m
        \-- class_basic_no_return
            +-- method1( this )
            \-- method4( this )

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

classdef    class_basic_no_return
    methods
        function    method1( this )
%{
                body
%}
        end
%{
        function    method2_ShouldNotBeVisibleInFunctionListTree( this )
            % body
        end
%}

%{
        function    method3_ShouldNotBeVisibleInFunctionListTree( this )
%{
                body
%}
        end
%}

%%{
        function    method4( this )
            % body
        end
%}
    end
end
