
=begin

def MethodName1( arg1, arg2, arg3, ... )
   return value
end

=end

# comment
def multiply (val1, val2 )
     result = val1 * val2
     return result
end

alias docalc multiply # line comment

class ClassName

   def ClassMethodName
        @@classVariable = 0.2               # class variable
   end
   
   def GetterMethodName                     # getter method
        @instanceVariable = "12345"         # instance variable
   end
   
   def SetterMethodName=( value )           # setter method
        @instanceVariable = value
   end
   
   def initialize ()
   end
   
   def InstanceMethodName ( argument )      # instance method
       puts argument * classVariable
   end
   
   def InstanceMethodName_NoArgs            # method
        puts "The class is working"
        puts instanceVariable
   end
   
end

class SubClassName < SuperClassName         # class inheritance

   def SetterMethodName
        @instanceVariable
   end

   def GetterMethodName=( value )
        @instanceVariable = value
   end
   
end

class Person

    attr_reader :name, :age

    def initialize(name, age)
        @name, @age = name, age
    end

    # "the comparison "operator for sorting"
    def <=>(person)
        age <=> person.age
    end

    def <=>(person) # "the comparison "operator for sorting"
        age <=> person.age
    end

    def to_s
        # the next line should not be interpreted as comment!
        "#{name} (#{age})"
    end

end
