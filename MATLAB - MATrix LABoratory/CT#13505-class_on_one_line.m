%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        class_on_one_line.m
        \-- class_on_one_line
            +-- OneLineMethod(~,str)
            \-- [q]=OneLineMethod(str)

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

classdef class_on_one_line,methods,function OneLineMethod(~,str),disp(str),end,function [q]=OneLineMethod(str),disp(str),end,end,end