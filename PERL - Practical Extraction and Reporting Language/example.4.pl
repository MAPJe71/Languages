
# http://perldoc.perl.org/perlsub.html

# get a line, combining continuation lines
#  that start with whitespace
sub get_line {
    $thisline = $lookahead;  # global variables!
    LINE: while (defined($lookahead = <STDIN>)) {
        if ($lookahead =~ /^[ \t]/) {
        $thisline .= $lookahead;
        }
        else {
        last LINE;
        }
    }
    return $thisline;
}
$lookahead = <STDIN>; # get first line
while (defined($line = get_line())) {
    ...
}