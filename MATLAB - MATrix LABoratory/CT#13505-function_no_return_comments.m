%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        function_no_return_comments.m
        +-- function2( val )
        +-- function4( val )
        \-- function5( val )

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

%{
function    function1_ShouldNotBeVisibleInFunctionListTree( val )
    [~]=17;
end
%}

function    function2( val )
    [~]=17;
end

% function    function3_ShouldNotBeVisibleInFunctionListTree( val )
%     [~]=17;
% end

%%{
function    function4( val )
%{
    [~]=17;
%}
end
%}

%%{
function    function5( val )
%%{
    [~]=17;
%}
end
%}

%{
function    function6_ShouldNotBeVisibleInFunctionListTree( val )
    [~]=17;
end
%}

