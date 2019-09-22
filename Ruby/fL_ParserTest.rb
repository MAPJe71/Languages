#!/usr/bin/ruby

# I am a comment. Just ignore me.

# You can comment multiple lines as follows:

# This is a comment.
# This is a comment, too.
# This is a comment, too.
# I said that already.

# Here is another form. This block comment conceals several lines from the
# interpreter with =begin/=end:

=begin
    __FILE__  and    def       end     in      or      self   unless
    alias  class
This is a comment.
This is a comment, too.
This is a comment, too.
Not again.
=end

# The syntax of a Ruby method is as follows:
def MethodName1( arg1, arg2, arg3, ... )
#  .. ruby code ..
   return value
end

def  MethodName2( arg1, arg2, arg3, ... )
#  .. ruby code ..
   return value
end

def	MethodName3 ( arg1, arg2, arg3, ... )
#  .. ruby code ..
   return value
end

def			MethodName4	( arg1, arg2, arg3, ... )
#  .. ruby code ..
   return value
end

def multiply(val1, val2 )
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

# Declares code to be called at the end of the program.
END {
   puts "Terminating Ruby Program"
}
# Declares code to be called before the program is run.
BEGIN {
   puts "Initializing Ruby Program"
}

# { name }
# " text " text "

   # { name }
   # " text " text "

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

# should match
def ::( arg )
    # statements
end
def []( arg )
    # statements
end
def []=( arg )
    # statements
end
def **( arg )
    # statements
end
def !( arg )
    # statements
end
def ~( arg )
    # statements
end
def +( arg )
    # statements
end
def -( arg )
    # statements
end
def *( arg )
    # statements
end
def /( arg )
    # statements
end
def % ( arg )
    # statements
end
def >>( arg )
    # statements
end
def <<( arg )
    # statements
end
def &( arg )
    # statements
end
def ^( arg )
    # statements
end
def |( arg )
    # statements
end
def <=( arg )
    # statements
end
def <( arg )
    # statements
end
def >( arg )
    # statements
end
def >=( arg )
    # statements
end
def <=>( arg )
    # statements
end
def ==( arg )
    # statements
end
def ===( arg )
    # statements
end
def !=( arg )
    # statements
end
def =~( arg )
    # statements
end
def !~( arg )
    # statements
end

# should NOT match
def =<( arg )
    # statements
end
def =>( arg )
    # statements
end
def >>>( arg )
    # statements
end
def <>( arg )
    # statements
end
def <<>( arg )
    # statements
end

=begin

The following words are reserved in Ruby:

    __FILE__  and    def       end     in      or      self   unless
    __LINE__  begin  defined?  ensure  module  redo    super  until
    BEGIN     break  do        false   next    rescue  then   when
    END       case   else      for     nil     retry   true   while
    alias     class  elsif     if      not     return  undef  yield

(?-i:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)

=end
