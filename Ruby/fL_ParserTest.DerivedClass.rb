
class ClassName
   def ClassMethodName
        @@classVariable = 0.2
   end
   def GetterMethodName
        @instanceVariable = "12345"
   end
   def SetterMethodName=( value )
        @instanceVariable = value
   end
   def initialize ()
   end
   def InstanceMethodName ( argument )
       puts argument * classVariable
   end
   def InstanceMethodName_NoArgs
        puts "The class is working"
        puts instanceVariable
   end
end

class SubClassName < SuperClassName
   def SetterMethodName
        @instanceVariable
   end
   def GetterMethodName=( value )
        @instanceVariable = value
   end
end
