%{
    https://notepad-plus-plus.org/community/topic/13505/trouble-making-a-functionlist-parser-for-matlab

    Expected Function List tree:
        class_complete_with_function.m
        +-- aCompleteClassWithFunction
        |   +-- obj = aCompleteClassWithFunction(x)
        |   \-- d = myMethod(obj)
        \-- myUtilityFcn

    function ThisShouldNotBeVisibleInFunctionListTree
    end
%}

classdef (Sealed) aCompleteClassWithFunction < handle
   properties (Access = private)
      Prop1 = datenum(date)
   end
   properties
      Prop2
   end
   events (ListenAccess = protected)
      StateChanged
   end
   methods
      function obj = aCompleteClassWithFunction(x)
         obj.Prop2 = x;
      end
   end
   methods (Access = {?MyOtherClass})
      function d = myMethod(obj)
         d = obj.Prop1 + x;
      end
   end
end
function myUtilityFcn
    A = 17;
end
