
# http://perldoc.perl.org/perlsub.html

# Assigning to a list of private variables to name your arguments:

sub maybeset {
    my($key, $value) = @_;
    $Foo{$key} = $value unless $Foo{$key};
}

# Because the assignment copies the values, this also has the effect of turning 
# call-by-reference into call-by-value. Otherwise a function is free to do 
# in-place modifications of @_ and change its caller's values.

upcase_in($v1, $v2);  # this changes $v1 and $v2
sub upcase_in {
    for (@_) { tr/a-z/A-Z/ }
}

# You aren't allowed to modify constants in this way, of course. If an argument 
# were actually literal and you tried to change it, you'd take a (presumably 
# fatal) exception. For example, this won't work:

upcase_in("frederick");

# It would be much safer if the upcase_in() function were written to return a 
# copy of its parameters instead of changing them in place:

($v3, $v4) = upcase($v1, $v2);  # this doesn't change $v1 and $v2
sub upcase {
    return unless defined wantarray;  # void context, do nothing
    my @parms = @_;
    for (@parms) { tr/a-z/A-Z/ }
    return wantarray ? @parms : $parms[0];
}

# Notice how this (unprototyped) function doesn't care whether it was passed 
# real scalars or arrays. Perl sees all arguments as one big, long, flat 
# parameter list in @_ . This is one area where Perl's simple argument-passing 
# style shines. The upcase() function would work perfectly well without changing 
# the upcase() definition even if we fed it things like this:

@newlist   = upcase(@list1, @list2);
@newlist   = upcase( split /:/, $var );

# Do not, however, be tempted to do this:

(@a, @b)   = upcase(@list1, @list2);


# Positional parameters are handled by simply naming scalar variables in the 
# signature. For example,

sub foo1 ($left, $right) {
    return $left + $right;
}

# takes two positional parameters, which must be filled at runtime by two 
# arguments. By default the parameters are mandatory, and it is not permitted 
# to pass more arguments than expected. So the above is equivalent to

sub foo2 {
    die "Too many arguments for subroutine" unless @_ <= 2;
    die "Too few arguments for subroutine" unless @_ >= 2;
    my $left = $_[0];
    my $right = $_[1];
    return $left + $right;
}

# An argument can be ignored by omitting the main part of the name from a 
# parameter declaration, leaving just a bare $ sigil. For example,

sub foo3 ($first, $, $third) {
    return "first=$first, third=$third";
}

# Although the ignored argument doesn't go into a variable, it is still 
# mandatory for the caller to pass it.

# A positional parameter is made optional by giving a default value, separated 
# from the parameter name by = :

sub foo4 ($left, $right = 0) {
    return $left + $right;
}

# The above subroutine may be called with either one or two arguments. The 
# default value expression is evaluated when the subroutine is called, so it 
# may provide different default values for different calls. It is only evaluated 
# if the argument was actually omitted from the call. For example,

my $auto_id = 0;
sub foo5 ($thing, $id = $auto_id++) {
    print "$thing has ID $id";
}

# automatically assigns distinct sequential IDs to things for which no ID was 
# supplied by the caller. A default value expression may also refer to 
# parameters earlier in the signature, making the default for one parameter 
# vary according to the earlier parameters. For example,

sub foo6 ($first_name, $surname, $nickname = $first_name) {
    print "$first_name $surname is known as \"$nickname\"";
}

# An optional parameter can be nameless just like a mandatory parameter. 
# For example,

sub foo7 ($thing, $ = 1) {
    print $thing;
}

# The parameter's default value will still be evaluated if the corresponding 
# argument isn't supplied, even though the value won't be stored anywhere. This 
# is in case evaluating it has important side effects. However, it will be 
# evaluated in void context, so if it doesn't have side effects and is not 
# trivial it will generate a warning if the "void" warning category is enabled. 
# If a nameless optional parameter's default value is not important, it may be 
# omitted just as the parameter's name was:

sub foo8 ($thing, $=) {
    print $thing;
}

# Optional positional parameters must come after all mandatory positional 
# parameters. (If there are no mandatory positional parameters then an optional 
# positional parameters can be the first thing in the signature.) If there are 
# multiple optional positional parameters and not enough arguments are supplied 
# to fill them all, they will be filled from left to right.

# After positional parameters, additional arguments may be captured in a slurpy 
# parameter. The simplest form of this is just an array variable:

sub foo9 ($filter, @inputs) {
    print $filter->($_) foreach @inputs;
}

# With a slurpy parameter in the signature, there is no upper limit on how many 
# arguments may be passed. A slurpy array parameter may be nameless just like a 
# positional parameter, in which case its only effect is to turn off the 
# argument limit that would otherwise apply:

sub foo10 ($thing, @) {
    print $thing;
}

# A slurpy parameter may instead be a hash, in which case the arguments 
# available to it are interpreted as alternating keys and values. There must be 
# as many keys as values: if there is an odd argument then an exception will be 
# thrown. Keys will be stringified, and if there are duplicates then the later 
# instance takes precedence over the earlier, as with standard hash 
# construction.

sub foo11 ($filter, %inputs) {
    print $filter->($_, $inputs{$_}) foreach sort keys %inputs;
}

# A slurpy hash parameter may be nameless just like other kinds of parameter. 
# It still insists that the number of arguments available to it be even, even 
# though they're not being put into a variable.

sub foo12 ($thing, %) {
    print $thing;
}

# A slurpy parameter, either array or hash, must be the last thing in the 
# signature. It may follow mandatory and optional positional parameters; it may 
# also be the only thing in the signature. Slurpy parameters cannot have default 
# values: if no arguments are supplied for them then you get an empty array or 
# empty hash.

# A signature may be entirely empty, in which case all it does is check that the 
# caller passed no arguments:

sub foo13 () {
    return 123;
}

# When using a signature, the arguments are still available in the special array 
# variable @_ , in addition to the lexical variables of the signature. There is 
# a difference between the two ways of accessing the arguments: @_ aliases the 
# arguments, but the signature variables get copies of the arguments. So writing 
# to a signature variable only changes that variable, and has no effect on the 
# caller's variables, but writing to an element of @_ modifies whatever the 
# caller used to supply that argument.

# There is a potential syntactic ambiguity between signatures and prototypes 
# (see Prototypes), because both start with an opening parenthesis and both can 
# appear in some of the same places, such as just after the name in a subroutine 
# declaration. For historical reasons, when signatures are not enabled, any 
# opening parenthesis in such a context will trigger very forgiving prototype 
# parsing. Most signatures will be interpreted as prototypes in those 
# circumstances, but won't be valid prototypes. (A valid prototype cannot 
# contain any alphabetic character.) This will lead to somewhat confusing error 
# messages.

# To avoid ambiguity, when signatures are enabled the special syntax for 
# prototypes is disabled. There is no attempt to guess whether a parenthesised 
# group was intended to be a prototype or a signature. To give a subroutine a 
# prototype under these circumstances, use a prototype attribute. For example,

sub foo14 :prototype($) { $_[0] }

# It is entirely possible for a subroutine to have both a prototype and a 
# signature. They do different jobs: the prototype affects compilation of calls 
# to the subroutine, and the signature puts argument values into lexical 
# variables at runtime. You can therefore write

sub foo15 ($left, $right) : prototype($$) {
    return $left + $right;
}

# The prototype attribute, and any other attributes, come after the signature.