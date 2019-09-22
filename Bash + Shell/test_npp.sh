#!/bin/ksh
# Procedure de switch de code SCMV5
# ------------------------------------------------------------------------------
[ ! -z "$_DEBUG" ] && set -x


# Verification de l initialisation  obligatoire de certaines variables pour toutes les commandes
VerifVarEnv()
{
	RCTMP=0
	if [ -z "$SCR_PATH" ]
	then
		echo "`date +%y/%m/%d-%H:%M:%S` The parameter  SCR_PATH   must be set"
		RCTMP=5
	fi

	if [ -z "$ORACLE_CONNECT" ]
    then
		echo "`date +%y/%m/%d-%H:%M:%S` The parameter  ORACLE_CONNECT   must be set"

		RCTMP=5
    fi
	
	if [ $RCTMP -ne 0 ]
	then
		exit $RCTMP
	fi

}


HelpMessage()
{
echo " $(basename $0) [-h|-?|-help] -source_unix pathtosourceunix -source_windows pathtosourcewindows 
        -source_unix: The unix path that contains the files to handle
        -source_windows: The windows path that contains the files to handle
 
Example:        

    $(basename $0) -source_unix /home/data/incoming -source_windows //dfsroot/data/incoming
"
}


# =====================================================================
# Out function
# =====================================================================
function Out
{
	[ ! -z "$_DEBUG" ] && set -x
	trap ' ' HUP INT QUIT TERM
	ExitCode=$1
	if [ -n "$ExitCode" ]
	then
		if [ $ExitCode -ne 0 ]
		then
			print "\n${MSG9999}"
		else
			print "\n${MSG0000}"
		fi
		shift
	fi
	if [ -z "$_DEBUG" ] 
	then
		 \rm -fr "$TMP"/*_$$ "$TMP"/*_$$.* "$TMP"/*_$$_*.* "$TMP"/*_$$_*
	fi
	exit $ExitCode
}

trap 'Out 9999' HUP INT QUIT TERM

VerifVarEnv

OS=$(uname -s)

UUID=`mk_uuid`

while [ $# -ge 1 ]
do
	case "$1" in
		-h|-help|-? )
			HelpMessage
			Out 0
			shift
			;;
		-source_unix)
			_PATHSOURCE_UNIX=$2
			shift 2
			;;
		-source_windows)
			_PATHSOURCE_WIN=$2
			shift 2
			;;
		*)
         echo "The option $1 is unknown"
         HelpMessage  
         Out 5
         ;;
	esac
done 

RCTEMP=0

if [ -z "$_PATHSOURCE_UNIX" ]
then
	awk -F\| -v var1="$_PATHSOURCE_UNIX"/_wrong_host_$$.txt 'BEGIN {
				file_num=0;
			}
			{
				if (FNR==1)
					file_num++;
			}
			{
				if(file_num==1) {
					# initialize index with xfr id 
					xfrs[$0]="";
					next;
				}
			}
			{
				if(file_num==2) {
					# look for index in array. Associate ls_transfer line to index if transfer is known.
					if($20 in xfrs) {
						xfrs[$20]=$0;
					}
					# check if host matches credentials.
					if(tolower($13)!="_host" || $14!="_port") printf("%s\n", $20) > var1
					next;
				}
			}
			END {
				for (i in xfrs) {
					if (xfrs[i] != "") {
						printf("%s\n",i);
					}
				}
			}
	' $_PATHSOURCE_UNIX/xfrs.txt "$_PATHSOURCE_UNIX"/ls_transfer_$$.txt > "$_PATHSOURCE_UNIX"/ok_xfrs_$$.txt
	# if some of the given xfrs do not correspond to given transfer manager, exit with error.
	if [ -s "$_PATHSOURCE_UNIX"/_wrong_host_$$.txt ]
	then
		print "$MSG1520 $_XFR_MGR_OPTION"
		Out 5 
	fi

fi

###
Out $RCTEMP

cat $FICRESULT | $AWK '{ if (length($0)>0) {print $0}}'
