#! /usr/bin/perl
#
# ----------------------------------------------------------------------
#     TRT - Modify for TTFis
#
#     by Jens Lorenz. All rights reserved.
# ----------------------------------------------------------------------



# ----------------------------------------------------------------------
$usage = '
        usage : perl trt_modify.pl <source.H> <target.TRT>
        help  : perl --h';

$help = '
    This script parses a header file which includes enums for Trace/TTFis
    .trt files. It changes the appendant .trt file. Therefore, this script
    includes eponymous arrays in a predefined section. These arrays are
    builded from enumeration fields in a header section.

    The enumeration section have to look like the following example:

            /* BEGIN ARRAY_DEFINE SECTIONNAME */
            
            typedef enum {
                NUM1= 5,        // could be also hexadezimal
                NUM2,
                NUM3
            } ARRAY_NAME;

            ...

            /* END ARRAY_DEFINE */


    The SECTIONNAME as you see in the upper example set a dependency
    to the target section in the appendant .trt file.

    The following lines declares a section in the target .trt file:

            ; BEGIN_ARRAY SECTIONNAME
                this is the target section
            ; END_ARRAY';
# ----------------------------------------------------------------------

#
# analyze command line parameter
#
$sourcefile = $ARGV[0];
$targetfile = $ARGV[1];


if ( $sourcefile eq "" ) {
	print STDERR "Error: $usage\n";
	exit(1);
} 
if ( $ARGV[2] ne "" ) {
	print STDERR "Too few arguments\n";
	print STDERR "Error: $usage\n";
	exit(1);
}
if (( $sourcefile eq "--h" ) and ( $targetfile eq "" )) {
	print "$help\n";
	exit(1);
}

# mofify packageconf file
open (IN, $targetfile) or die "can not modify $targetfile!\n";
@modify = <IN>;
close (IN);
open (OUT, ">$targetfile") or die "can not modify $targetfile!\n";

# parse definition file
open (IN, $sourcefile) or die "can not open $sourcefile!\n";


#
# parse input file
#
$commcount  = 0;
$linecount  = 0;
$arraysec   = 0;
$modify_pos = 0;
$enumsec    = 0;
$arrayname  = 0;
@array      = ();
while (<IN>)
{
    chomp;
    $linecount++;
    
    # On/Off arraysec ########################################################
    if (( $arraysec eq 0 ) and ( ( $arrayname ) = ($_ =~ /^\/\* BEGIN ARRAY_DEFINE (.*) \*\/$/ ))) {
        if ( ($modify_pos) = get_modify_pos($arrayname) ) {
            print "Array section \"${arrayname}\" modified.\n";
            $arraysec = 1;
        }else{
            print "Array section \"${arrayname}\" is found, but nothing is done!\n";
        }
        next;
    }elsif (( $arraysec eq 1 ) and ( $_ =~ /^\/\* END ARRAY_DEFINE \*\/$/ )) {
        $arraysec = 0;
    }

    # break if is not the array define section
    next if ( $arraysec eq 0 );
    
    # is it commented out?
    $commcount += ( $_ =~ s,/\*,/\*,g );
    if ( $commcount > 1 ) {
        print STDERR "Error in line $linecount: ";
        print STDERR "File $targetfile has a COMMAND error!\n";
        goto end;
    }
    $commcount -= ( $_ =~ s,\*/,\*/,g );
    if ( $commcount < 0 ) {
        print STDERR "Error in line $linecount: ";
        print STDERR "File $targetfile has a COMMAND error!\n";
        goto end;
    }

    if ( $commcount eq 0 ) {
        # On/Off enumsec ####################################################
        if ( $_ =~ /^typedef\s*enum\s*\{/ ) {
            $enumsec = 1;
            next;
        }elsif( $_ =~ /^\}\s*.*\s*;/ ) {
            # find end of enumeration
            $modify_pos = modify_target( ( $modify_pos, $_ =~ /\}\s*(.*)\s*;/ ), @array );
            @array = ();
            $enumsec = 0;
        } 
        
        # break if is not the an enumaration field
        next if ( $enumsec eq 0 );
    
        ($line) = ( $_ =~ /^\s*([a-zA-Z0-9_ \t=]*,?)/ );
        push @array, $line if ( $line ) ;
    }
}

end:
print OUT @modify;
close (IN);
close (OUT);
exit (0);


#
# Clears the array fild and returns the position for inserting the first array
#
sub get_modify_pos
{
    local($arrayname) = @_;
    local($pos, $posBegin);
    
    $pos      = 0;
    $posBegin = 0;
    foreach ( @modify ) {
        if ( ($posBegin eq 0) and ($_ =~ /^; BEGIN_ARRAY ${arrayname}\n/) ) {
            # selects the first line
            $posBegin = $pos+1;
        }elsif ( ($posBegin ne 0) and ($_ =~ /^; END_ARRAY\n/) ) {
            # clears all lines in the section
            splice ( @modify, $posBegin, $pos-$posBegin, "\n" );
            $posBegin++;
        }
        $pos++;
    }
    return $posBegin;
}


#
# insterting the array in on the given position
#
sub modify_target
{
    local($pos, $enumname, @source) = @_;
    local($i, $varible, $hex, $value, @array);
    
    $i = 0;
    # set the array name with the start value ################################
    if ( ( $variable, $hex ) = (@source[0] =~ /\s*(.*)\s*=\s*([0-9x]*)/) ) {
        if ( $hex =~ /x/ ) {
            push @array, "ARRAY ${enumname} = ${hex}: \\\n";
        }else{
            push @array, sprintf("ARRAY ${enumname} = 0x%02x: \\\n", $hex);
        }
        push @array, "\t\t\t\t\t\t${variable},\\\n";
        $i++;
    }else{
        push @array, "ARRAY ${enumname} = 0x00: \\\n";
    }
    
    # here will be the 'outfile' modificated ##################################
    for ( ; $i < $#source; $i++ ) {
        push @array, "\t\t\t\t\t\t@{source[$i]}\\\n";
    }
    push @array, "\t\t\t\t\t\t@{source[$i]}\n\n";
    
    splice ( @modify, $pos, 0, @array );
    return $pos + $#array + 1;
}
