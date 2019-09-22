#! /usr/bin/perl
#
# ----------------------------------------------------------------------
#     T-Kernel
#
#     Copyright (C) 2004 by Ken Sakamura. All rights reserved.
#     T-Kernel is distributed under the T-License.
# ----------------------------------------------------------------------
#
#     Version:   1.01.00
#     Released by T-Engine Forum(http://www.t-engine.org) at 2004/6/28.
#
# ----------------------------------------------------------------------
#

#	mkiflib
#
#	Extended SVC
#	interface library generation script
#
#

$usage = 'usage: mkiflib cpu infile';

$infile = "";	# input file

#
# analyze command line parameter
#
$cpu = $ARGV[0];
$infile = $ARGV[1];
if ( $cpu eq "" ) {
	print STDERR "$usage\n";
	exit(1);
}
if ( $infile eq "" ) {
	print STDERR "Too few arguments\n";
	exit(1);
}
if ( $ARGV[2] ne "" ) {
	print STDERR "Too few arguments\n";
	exit(1);
}


#
# get the filename only
#
$infile_base = $infile;
$infile_base =~ s/.*\/+(.*)$/$1/;

#
# parse definition file
#
open(IN, "$infile") || die "can not open $infile\n";



$ignore = 1;
$if_h = "if${infile_base}";
$fn_h = "fn${infile_base}";
$incfile = "<$infile_base>";

$linecount = 0;
$commcount = 0;

while ( <IN> ) {
    $linecount++;

	# skip to definition line
	if ( $ignore != 0 ) {
		$ignore = 0 if ( /^(#|\/\*\*).*\bDEFINE_IFLIB\b/ );
		next;
	}

	chop;
	s/^\s//;	# trim space code

	next if ( /^$/ );	# skip empty line
	next if ( /^#/ );	# skip comment line

	# input data type
	if ( /^(\/\*\s+)*\[/ ) {
		( $inp ) = /\[(.*)\]/;
		next;
	}

	# clear input data type
	if ( /^\*\*/ ) {
		$inp = "";
		next;
	}

	# scan data
	if ( $inp =~ /^(LIBRARY HEADER FILE)$/i ) {
		$if_h = $_;
	}
	if ( $inp =~ /^(FNUMBER HEADER FILE)$/i ) {
		$fn_h = $_;
	}
	if ( $inp =~ /^(INCLUDE FILE)$/i ) {
		$incfile = $_;
	}
	if ( $inp =~ /^(PREFIX)$/i ) {
		$prefix = $_;
	}
	if ( $inp =~ /^(SVC NO)$/i ) {
		$svcno = $_;
	}
	if ( $inp =~ /^(BEGIN SYSCALLS)$/i ) {
		s/\s+/ /g;	# delete extra space code
        
# ADIT
#       $syscalls[$#syscalls+1] = $_ if ( /^IMPORT/ );
        
# ADIT
        # search for commend operators
        @str = split( /(\t| )/, $_ );
        $count = 0;
        foreach ( @str ){
            $commcount++ if ( @str[$count] =~ /\/\*/ );
            $commcount-- if ( @str[$count] =~ /\*\// );
            $count++;
            if (($commcount < 0) or ($commcount > 1)) {
                print STDERR "Error in line $linecount: ";
                print STDERR "File $sourcefile has a COMMAND error!\n";
                close (IN);
                exit(1);
            }
        }
        
# ADIT
        # get function if it is not comment out
        if (( /^IMPORT/ ) and ( $commcount eq 0 )) {
            $syscalls[$#syscalls+1] = $_;
            
            # concatenates function if it is a multiline function
            if (!( $_ =~ /\);/ )) {
                while ( <IN> ) {
                  	$_ =~ s/\s*$//;
                    $syscalls[$#syscalls] .= $_;
                    last if ( $_ =~ /\);/ )
                }
            }
        }
        
		$syscalls[$#syscalls+1] = "" if ( /RESERVE_NO/ );
        
		if ( ( $no ) = /ALIGN_NO (0x[0-9a-zA-Z]+|[0-9]+)\b/ ) {
			$no = oct($no) if ( $no =~ /^0/ );
			if ( $no > 0 ) {
				$i = $no - ($#syscalls + 1) % $no;
				if ( $i > 1 && $i < $no ) {
					$syscalls[$#syscalls+$i-1] = "";
				} elsif ( $no > 1 && $#syscalls < 0 ) {
					$syscalls[$no-2] = "";
				}
			}
		}
		if ( ( $no ) = /ORIGIN_NO (0x[0-9a-zA-Z]+|[0-9]+)\b/ ) {
			$no = oct($no) if ( $no =~ /^0/ );
			if ( $no > $#syscalls + 2 ) {
				$syscalls[$no-2] = "";
			}
		}
	}
}

close(IN);

if ( $#syscalls < 0 ) {
	print stderr "There is no definition of a system call.\n";
	exit(1);
}

#
# create all neccessary folders
#
$folder = mkdir( "src" );
if ($folder) {
    printf "'/src' created.\n";
}
$folder = mkdir( "src/sysdepend" );
if ($folder) {
    printf "'/src/sysdepend' created.\n";
}
$folder = mkdir( "include" );
if ($folder) {
    printf "'/include' created.\n";
}
$folder = mkdir( "include/sysdepend" );
if ($folder) {
    printf "'/include/sysdepend' created.\n";
}

# ----------------------------------------------------------------------------
#
# generate function code definition file
#
$folder = mkdir( "include/sysdepend/$cpu" );
if ($folder) {
    printf "'/include/sysdepend/$cpu' created.\n";
}

open(FN_H, ">include/sysdepend/$cpu/$fn_h") || die "can not open /include/sysdepend/$cpu/$fn_h\n";

### create header part ###
print FN_H <<EndOfFnHeader;
/*
 *	Extended SVC function code
 *
 *	   created from $infile
 */

#include <sys/ssid.h>

EndOfFnHeader

### generate extended SVC number ###
$svc = "${prefix}_SVC";
if ( $svcno ne "" ) {

	print FN_H <<EndOfSVCNo;
/*
 * Extended SVC number
 */
#ifndef ${svc}
#define	${svc}	$svcno
#endif

EndOfSVCNo
}

### generate function number ###
for ( $i = 0; $i <= $#syscalls; $i++ ) {
	next if ( $syscalls[$i] eq "" );

	( $Func, $func, $ret, @para ) = &split_func($syscalls[$i]);
	$fno = (($i + 1) << 16) + (($#para + 1) << 8);
	printf FN_H "#define ${prefix}_${Func}_FN\t(0x%08x | ${svc})\n", $fno;
}
print FN_H "\n";

close(FN_H);

# ----------------------------------------------------------------------------
#
# create header file (if*.h)
#
open(IF_H, ">include/sysdepend/$cpu/$if_h") || die "can not open /include/sysdepend/$cpu/$if_h\n";

### generate header part ###
print IF_H <<EndOfIfHeader;
/*
 *	Extended SVC parameter packet
 *
 *	   created from $infile
 */

#include <basic.h>
#include $incfile
#include <sys/str_align.h>
#include <${fn_h}>

EndOfIfHeader

### generate parameter packet ###
for ( $i = 0; $i <= $#syscalls; $i++ ) {
	next if ( $syscalls[$i] eq "" );

	( $Func, $func, $ret, @para ) = &split_func($syscalls[$i]);

	# expect for void parameter
	next if ( $#para < 0 );

	print IF_H "typedef struct {\n";
	for ( $j = 0; $j <= $#para; $j++ ) {
		( $type, $vname, $pad ) = &stack_packet($para[$j]);
		print IF_H "    _pad_b($pad)\n" if ( $pad > 0 );
		print IF_H "    $type $vname;\t_align64\n";
		print IF_H "    _pad_l($pad)\n" if ( $pad > 0 );
	}
	print IF_H "} ${prefix}_${Func}_PARA;\n\n";
}

close(IF_H);

# ----------------------------------------------------------------------------
#
# create extended SVC interface function
#
$folder = mkdir( "src/sysdepend/$cpu" );
if ($folder) {
    printf "'/src/sysdepend/$cpu' created.\n";
}

for ( $i = 0; $i <= $#syscalls; $i++ ) {
	next if ( $syscalls[$i] eq "" );

	$syscall = $syscalls[$i];
	( $Func, $func, $ret, @para ) = &split_func($syscall);

	$fname = $func;
	$fname =~ tr/A-Z/a-z/;	# to lower case

	# open library source file
	open(LIB, ">src/sysdepend/$cpu/$fname.S") || die "can not open /src/sysdepend/$cpu/$fname.S\n";

	print LIB <<EndOfIfLibHeader;
/*
 *	T-Kernel extended SVC interface library ($cpu)
 *
 *	   created from $infile_base
 */

EndOfIfLibHeader

	# system dependencies
	require("cpu_scripts/$cpu/makeifex.pl");
	&makelibex();

	close(LIB);
}

exit(0);

# ============================================================================

#
# split definition of function
#
sub split_func
{
	local($syscall) = @_;
	local($Func, $func, $ret, @para, $p);

	( $ret, $func, $p ) =
		( $syscall =~ /IMPORT\s+([\w\*]+)\s+(\w+)\s*\((.*)\)\s*;/ );

	$p =~ s/^\s*//;		# trim space code
	$p =~ s/\s*$//;

# ADIT    
#	@para = split(/\s*,\s*/, $p);	# split parameters

# ADIT
    # split parameters but no functions
    # e.g. IMPORT void test( void (*tkseFunc( int, int )), int );
    @str = split( /(\t| )/, $p );
    @para = "";
    $#para = 0;
    $count = 0;
    $comcount = 0;
    foreach ( @str ){
        $comcount += ( @str[$count] =~ tr/\(/\(/ );
        $comcount -= ( @str[$count] =~ tr/\)/\)/ );
        if (( @str[$count] =~ /,/ ) and ( $comcount eq 0 )) {
            @str[$count] =~ s/,//;
            @para[$#para] .= @str[$count];
            $#para++;
        }else{
            @para[$#para] .= @str[$count];
        }
        @para[$#para] =~ s/^\s*//;
        $count++;
    }
    
	if ( $#para == 0 && $para[0] =~ /^void$/i ) {
		# no params (void)
		@para = ();
	}

	if ( $ret =~ /^void$/i ) {
		# return type is "void"
		$ret = "";
	}

	$Func = $func;
	$Func =~ s/^b_//;	# delete "b_"
	$Func =~ tr/a-z/A-Z/;	# to upper case

	return ( $Func, $func, $ret, @para );
}

#
# split parameter
#
sub split_para
{
	local($para) = @_;
	local($type, $vname, @token);

	# get variable name
	$vname = $para;
	$vname =~ s/\[[^\]]*\]//g;
	if ( $vname =~ /\(/ ) {
		$vname =~ s/^[^\(]*\(/\(/;
		$vname =~ y/()*/ /s;
		$vname =~ s/^\s*//;
		@token = split(/(\t| )/, $vname);
		$vname = $token[0];
	} else {
		$vname =~ y/*/ /s;
		@token = split(/(\t| )/, $vname);
		$vname = $token[$#token];
	}

	# get variable type
    $type = $para;
    $type =~ s/(^.*?[\t+| +]+\*{0,}).*$/$1/;
    ( $type .= "*" ) if ( $para =~ /\(/ );
    $type =~ s/[ |\t]//g;

	# convert variable type from array to pointer
	if ( $para =~ s/\[[^\]]*\]// ) {
		$para =~ s/\b($vname)\b/(*\1)/;
	} else {
		if ( &isMatrix($type) ) {
			$para =~ s/\b($vname)\b/*\1/;
		}
	}

	return ( $type, $vname, $para );
}

#
# create parameter packet members
#
sub stack_packet
{
	local($para) = @_;
	local($type, $vname, $pad);

	( $type, $vname, $para ) = &split_para($para);

	# padding size to INT
	$pad = &isShort($type);

	return ( $type, $vname, $pad );
}

#
# return TRUE if variable is array
#
sub isMatrix
{
	local($type) = @_;

	return ( $type =~ /^(KeyMap)$/ );
}

#
# return sizeof(INT) - sizeof(variable type)
#
sub isShort
{
	local($type) = @_;

	return 24 if ( $type =~ /^(B|UB|CHAR)$/ );
	return 16 if ( $type =~ /^(H|UH|TC|CH|TLANG|SCRIPT)$/ );

	return 0;
}
