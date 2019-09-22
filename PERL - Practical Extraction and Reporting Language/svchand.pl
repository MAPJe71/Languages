#!/usr/bin/perl

#拡張SVCハンドラ自動作成ツール ver0.8.5
#2004/8/31 yamaguchi
#変更履歴
#2004/8/31 関数プロトタイプのパラメータがない場合の不具合修正
##################################################################

$usage = 'usage: perl svchand.pl <CPU> <INFILE> <OUTFILE>';

#
# analyze command line parameter
#
$cpu = $ARGV[0];
$sourcefile = $ARGV[1];
$outfile = $ARGV[2];

if ( $cpu eq "" ) {
	print STDERR "Error: $usage\n";
	exit(1);
}
if ( $sourcefile eq "" ) {
	print STDERR "Error: $usage\n";
	exit(1);
}
if ( $outfile eq "" ) {
	print STDERR "Error: $usage\n";
	exit(1);
}
if ( $ARGV[3] ne "" ) {
	print STDERR "Too few arguments\n";
	exit(1);
}

#
# get the filename with suffix
#
$sourcefile_base = $sourcefile;
$sourcefile_base =~ s/.*\/+(.*)$/$1/;


# parse definition file
open (FILE1, $sourcefile) or die "can not open $sourcefile!\n";

# parse function file
$fnfile = "include/sysdepend/$cpu/fn${sourcefile_base}";
open (FILE2, $fnfile) or die "can not open $fnfile!\n";

# parse interface file
$iffile = "include/sysdepend/$cpu/if${sourcefile_base}";
open (FILE3, $iffile) or die "can not open $iffile!\n";

# create sub system handler
open(OUT, ">$outfile") or die "can not create or write to $outfile!\n";

##################################################################


#一行読み出す。単語に分割し配列に格納する。
#$count1 : str
#$count2 : data_type
#$count3 : str eq data_type
#$count4 : define
#$count8 : 

#miflibに読み込むファイルからプロトタイプ検索
$commcount = 0;
$linecount = 0;
$inp = "";

while(<FILE1>){
    $linecount++;
	$count1 = 0 ;

	# input data type
	if ( /^(\/\*\s+)*\[/ ) {
		( $inp ) = /\[(.*)\]/;
	}
	# scan data
	if ( $inp =~ /^(PREFIX)$/i ) {
        if ( /^$/ ) {
            $inp = "";
            next;
        }
		( $prefix = $_ ) =~ tr/0-9a-zA-Z_//cd;
	}

    $_ =~ s/^\s+//;
    
	#関数名の抽出
    if(!( $_ =~ /^IMPORT/ )) {
        $commcount++ if ( $_ =~ /\/\*/ );
        $commcount-- if ( $_ =~ /\*\// );
        if (( $commcount < 0 ) or ( $commcount > 1 )) {
            print STDERR "Error in line $linecount: ";
            print STDERR "File $sourcefile has a COMMAND error!\n";
            goto end;
        }
        next;
    }
    
    if( $commcount eq 0 ){
        ( $ret, $func ) = ( $_ =~ /IMPORT\s+([\w\*]+)\s+(\w+).*/ );
        
        if ($ret eq "void") {
            push @void, "void";
        }else{
            push @void, "no_void";
        }
        
        push @func_name, $func;
	}
}


#fnファイルから_FNを検索する
while(<FILE2>){
	@str = split(/(\t| )/, $_);
	$count4 = 0 ;
	foreach (@str){
		if(@str[$count4] =~ /_FN$/){
			push @func_FN, @str[$count4];
			last ;
		}
		$count4 ++;
	}
}

#SVCハンドラフォーマット
print OUT "/*\n";
print OUT " *  subsystem sample program\n";
print OUT " *    SVC handler\n";
print OUT " *  Copyright (C) 2002 by Personal Media Corporation\n";
print OUT "*/\n\n";

print OUT "#include <basic.h>\n";
print OUT "#include <tk/tkernel.h>\n";
print OUT "#include \"if$sourcefile_base\"" . "\n";
print OUT "#include <stdio.h>\n\n";

print OUT "INT " . $prefix . "_svc_handler( VP para, FN fncd, VP caller_gp )\n";
print OUT "{\n";
print OUT "    /* handle by extended SVC function code fncd */\n";
print OUT "    switch ( fncd >> 16 )\n";
print OUT "    {\n";

#ファイル名カウント
$count8 = 0 ;
$func_count = @func_name ;
@func_member = ();
$flag = 0;
#ifファイルから_PARAと変数名を抽出
while(<FILE3>){
	@str = split(/(\t| )/, $_);
	$count4 = 0 ;

	if((@str[$count4] eq "typedef")){
		$flag = 1 ;
	}
	
	if($flag == 1){
        
        foreach (@str){
            if(@str[$count4] =~ /_PARA/){
                @str[$count4] =~ tr/0-9a-zA-Z_//cd;
    
####################################################
                $flag2 = 0;
                while($flag2 == 0){
                    $temp1 = @str[$count4];
                    $temp1 =~ s/_PARA$//g;
                    $temp2 = @func_FN[$count8];
                    $temp2 =~ s/_FN$//g;
                    if($temp1 eq $temp2){
                        $flag2 = 1 ;
                    }else{
                        #APIごとにファイル出力
                        print OUT "        case " . @func_FN[$count8] . " >> 16:\n";
                        print OUT "        \{\n";			
                        
                        #関数名
						if(@void[$count8] ne "void"){
							print OUT "            return $func_name[$count8]();\n";
						}else{
                            print OUT "            @func_name[$count8]();\n";
                            print OUT "            return 0;\n";
                        }
                        print OUT "        \}\n";
                        $count8++;
                    }
                }
###################################################
    
#                $count5 = 0 ;
#                $moji1 = '\(';
#                foreach ( @func_member ){
#                    push @moji2, "pk -> " . @func_member[$count5];
#                    $count5++;
#                }
    
#                $moji3 = " \)";
                $memcount = @func_member ;
                
                #APIごとにファイル出力
                print OUT "        case " . @func_FN[$count8] . " >> 16:\n";
                print OUT "        \{\n";			
                #パラメータの型名
                print OUT "            @str[$count4] *pk = para;\n";
                #関数名
                if(@void[$count8] ne "void"){
                    print OUT "            return @func_name[$count8]";
                }else{
                    print OUT "            @func_name[$count8]";
                }
                
                print OUT "\( ";
                for($count7 = 0 ; $count7 < $memcount ; $count7++){
                    print OUT "pk -> ". "@func_member[$count7]" ;
                    if(($count7 + 1) != $memcount){
                        print OUT ", ";
                    }
                }
                print OUT " \);\n";
                if(@void[$count8] eq "void"){
                    print OUT "            return 0;\n";
                }
                
                print OUT "        \}\n";
                @func_member = ();
                $count8++;
            }elsif ( @str[$count4] =~ /;/ ){
                # it is a param if no function is found
                @str[$count4] =~ tr/0-9a-zA-Z_//cd;
                push @func_member, @str[$count4];
            }
            
            $count4 ++;
        }
    }
}

$count4 = @func_FN;
while ($count8 < $count4){
    #APIごとにファイル出力
    print OUT "        case " . @func_FN[$count8] . ":\n";
    print OUT "        \{\n";

    #関数名
    if(@void[$count8] eq "no_void"){
        print OUT "            return @func_name[$count8]();\n";
    }else{
        print OUT "            @func_name[$count8]();\n";
        print OUT "            return 0;\n";
    }
    print OUT "        \}\n";
    $count8++;
}


print OUT "        default:\n";
print OUT "        {\n";
print OUT "            printf(\"Unknown SVC fncd: 0x%x\", fncd);\n";
print OUT "        }\n";
print OUT "    }\n";
print OUT "    return 0;\n";
print OUT "}\n";

end:
close (FILE1);
close (FILE2);
close (FILE3);
close (OUT);
