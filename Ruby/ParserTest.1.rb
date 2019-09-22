#!/usr/bin/ruby

# A comment hides a line, part of a line, or several lines from the Ruby
# interpreter. You can use the hash character (#) at the beginning of a line:

# I am a comment. Just ignore me.

# Or, a comment may be on the same line after a statement or expression:

name = "Madisetti"          # This is again comment

# You can comment multiple lines as follows:

# This is a comment.
# This is a comment, too.
# This is a comment, too.
# I said that already.

# Here is another form. This block comment conceals several lines from the
# interpreter with =begin/=end:

=begin
This is a comment.
This is a comment, too.
This is a comment, too.
I said that already.
=end

# The syntax of a Ruby method is as follows:
def name( arg1, arg2, arg3, ... )
#  .. ruby code ..
   return value
end

# Ruby allows a method to be aliased, thereby creating a copy of a method with
# a different name (although invoking the method with either name ultimately
# calls the same object). For example:
#
def multiply(val1, val2 )
     result = val1 * val2
     return result
end
alias docalc multiply
#
# docalc( 10, 20 )
# => 200
#
# multiply( 10, 20 )
# => 200

# Classes are defined using the class keyword followed by the end keyword and
# must be given a name by which they can be referenced. This name is a constant
# so must begin with a capital letter.
#
# With these rules in mind we can begin work on our class definition:
#
class BankAccount

   def interest_rate
        @@interest_rate = 0.2               # class variable
   end

   def accountNumber                        # getter method
        @accountNumber = "12345"            # instance variable
   end

   def accountNumber=( value )              # setter method
        @accountNumber = value
   end

   def accountName                          # getter method
        @accountName = "John Smith"         # instance variable
   end

   def accountName=( value )                # setter method
        @accountName = value
   end

   def initialize ()
   end

   def calc_interest ( balance )            # instance method
       puts balance * interest_rate
   end

   def test_method                          # method
        puts "The class is working"
        puts accountNumber
   end
end

# require 'BankAccount'

class NewBankAccount < BankAccount          # class inheritance

   def customerPhone
        @customerPhone
   end

   def customerPhone=( value )
        @customerPhone = value
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

=begin
This will produce following result:

Initializing Ruby Program
This is main Ruby Program
Terminating Ruby Program
=end

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
    "#{name} (#{age})"
  end
end

print <<EOF
    This is the first way of creating
    here document ie. multiple line string.
EOF

print <<"EOF";                # same as above
    This is the second way of creating
    here document ie. multiple line string.
EOF

print <<`EOC`                 # execute commands
	echo hi there
	echo lo there
EOC

print <<"foo", <<"bar"  # you can stack them
	I said foo.
foo
	I said bar.
bar

=begin
#
# def
# [\t ]+
# (
#  	:{2}                        (?# matches ::                              )
# |	\*{1,2}                     (?# matches * and **                        )
# |	![=~]?                      (?# matches !, != and !~                    )
# |	=(?:~|={1,2})               (?# matches =, =~, == and ===               )
# |	[~+\-/%&|\^]                (?# matches ~, +, -, /, %, &, | and ^       )
# |	<(?:<|=>?)?                 (?# matches <, <<, <= and <=>               )
# |	>[>=]?                      (?# matches >, >> and >=                    )
# |	\[[ ]\]=?                   (?# matches [ ] and [ ]=                    )
# )
# [\s(]
#
# (?# should match)
# def ::
# def [ ]
# def [ ]=
# def **
# def !
# def ~
# def +
# def -
# def *
# def /
# def %
# def >>
# def <<
# def &
# def ^
# def |
# def <=
# def <
# def >
# def >=
# def <=>
# def ==
# def ===
# def !=
# def =~
# def !~
#
# (?# should NOT match)
# def =<
# def =>
# def >>>
# def <>
# def <<>
#
=end

=begin
################################################################################

An identifier is a name used to identify a variable, method, or class.

As with most languages, valid identifiers consist of alphanumeric characters
(A-Za-z0-9) and underscores (_), but may not begin with a digit (0-9).
Additionally, identifiers that are method names may end with a question mark (?),
exclamation point (!), or equals sign (=).

    [A-Za-z_][\w]+[?!=]?

There are no arbitrary restrictions to the length of an identifier (i.e. it may
be as long as you like, limited only by your computer's memory). Finally, there
are reserved words which may not be used as identifiers.

The following words are reserved in Ruby:

    __FILE__  and    def       end     in      or      self   unless
    __LINE__  begin  defined?  ensure  module  redo    super  until
    BEGIN     break  do        false   next    rescue  then   when
    END       case   else      for     nil     retry   true   while
    alias     class  elsif     if      not     return  undef  yield

(?-i:alias|and|BEGIN|begin|break|case|class|def|defined\?|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield|__FILE__|__LINE__)


Arithmetic Operators:
    +    -    *    /    %    **

Comparison Operators:
    ==    !=    >    <    >=    <=    <=>    ===    .eql?    equal?

Assignment Operators:
    =    +=    -=    *=    /=    %=    **=

Bitwise Operators:
    &    |    ^    ~    <<    >>

Logical Operators:
    and    or    &&    ||    !    not

Ternary Operator:
    ? :

Range Operators:
    ..    ...

dot "." and double Colon "::" Operators:
    You call a module method by preceding its name with the module's name and a
    period, and you reference a constant using the module name and two colons.

    The :: is a unary operator that allows: constants, instance methods and class
    methods defined within a class or module, to be accessed from anywhere outside
    the class or module.


Operators Precedence

    Method      Operator                                        Description

    Yes         ::                                              Constant resolution operator
    Yes         [ ] [ ]=                                        Element reference, element set
    Yes         **                                              Exponentiation (raise to the power)
    Yes         ! ~ + -                                         Not, complement, unary plus and minus (method names for the last two are +@ and -@)
    Yes         * / %                                           Multiply, divide, and modulo
    Yes         + -                                             Addition and subtraction
    Yes         >> <<                                           Right and left bitwise shift
    Yes         &                                               Bitwise 'AND'
    Yes         ^ |                                             Bitwise exclusive `OR' and regular `OR'
    Yes         <= < > >=                                       Comparison operators
    Yes         <=> == === != =~ !~                             Equality and pattern match operators (!= and !~ may not be defined as methods)
                &&                                              Logical 'AND'
                ||                                              Logical 'OR'
                .. ...                                          Range (inclusive and exclusive)
                ? :                                             Ternary if-then-else
                = %= { /= -= += |= &= >>= <<= *= &&= ||= **=    Assignment
                defined?                                        Check if specified symbol defined
                not                                             Logical negation
                or and                                          Logical composition

    NOTE: Operators with a Yes in the method column are actually methods, and as such may be overridden.

#-------

Classes are defined using the class keyword followed by the end keyword and
must be given a name by which they can be referenced. This name is a constant
so must begin with a capital letter.

#-------

Ruby provides six types of 'variables':

1.  Local Variables:

    Local variables are the variables that are defined in a method.
    Local variables are not available outside the method. You will see more
    detail about method in subsequent chapter. Local variables begin with
    a lowercase letter or _.

2.  Instance Variables:

    Instance variables are available across methods for any particular instance
    or object. That means that instance variables change from object to object.
    Instance variables are preceded by the at sign (@) followed by the variable
    name.

3.  Class Variables:

    Class variables are available across different objects. A class variable
    belongs to the class and is a characteristic of a class. They are preceded
    by the sign @@ and are followed by the variable name.

4.  Global Variables:

    Class variables are not available across classes. If you want to have a
    single variable, which is available across classes, you need to define a
    global variable. The global variables are always preceded by the dollar
    sign ($).

5.  Constants:

    Constants begin with an uppercase letter. Constants defined within a class
    or module can be accessed from within that class or module, and those
    defined outside a class or module can be accessed globally.

    Constants may not be defined within methods. Referencing an uninitialized
    constant produces an error. Making an assignment to a constant that is
    already initialized produces a warning.

6.  Pseudo-Variables:

    They are special variables that have the appearance of local variables but
    behave like constants. You can not assign any value to these variables.

    self    : The receiver object of the current method.
    true    : Value representing true.
    false   : Value representing false.
    nil     : Value representing undefined.
    __FILE__: The name of the current source file.
    __LINE__: The current line number in the source file.

#-------

In Ruby, functions are called methods. Each method in a class starts with the
keyword def followed by the method name. The method name is always preferred
to start with a lowercase letter. If you begin a method name with an uppercase
letter, Ruby might think that it is a constant and hence can parse the call
incorrectly.

    def method_name [( [arg [= default]]...[, * arg [, &expr ]])]
       expr..
    end

So you can define a simple method as follows:

    def method_name
       expr..
    end

You can represent a method that accepts parameters like this:

    def method_name (var1, var2)
       expr..
    end

You can set default values for the parameters which will be used if method is called without passing required parameters:

    def method_name (var1=value1, var2=value2)
       expr..
    end

#-------

Return Values from Methods:

Every method in Ruby returns a value by default. This returned value will be
the value of the last statement. The return statement in ruby is used to return
one or more values from a Ruby Method.

Syntax:

    return [expr[`,' expr...]]

If more than two expressions are given, the array contains these values will be
the return value. If no expression given, nil will be the return value.

#-------

The 'alias' Statement:

Ruby allows a method to be aliased, thereby creating a copy of a method with
a different name (although invoking the method with either name ultimately
calls the same object).

This gives alias to methods or global variables. Aliases can not be defined within
the method body. The alias of the method keep the current definition of the
method, even when methods are overridden.

Making aliases for the numbered global variables ($1, $2,...) is prohibited.
Overriding the builtin global variables may cause serious problems.

Syntax:

    alias method-name method-name
    alias global-variable-name global-variable-name

#-------

The 'undef' Statement:

This cancels the method definition. An undef can not appear in the method body.

By using undef and alias, the interface of the class can be modified independently
from the superclass, but notice it may be broke programs by the internal method
call to self.

Syntax:

    undef method-name

################################################################################
=end

