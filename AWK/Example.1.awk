# **************************************************************************
# AWK script to replace all occurences of FindStr with RepStrNNN.
# Output files are the same name as the input files with ".ed" appended.
#
# Run it like this:  gawk -f .\thisScript.awk <files to be edited>
#
# If this file is saved as repAll.awk in the current directory, and the
# files to be edited are in directory c:\fileDir, then:
#
#    gawk -f .\repAll.awk c:\fileDir\*
#
# **************************************************************************

BEGIN {
    # If FindStr contains any characters that have special regex meaning,
    # they must be prefaced with "\". For example: "Needed\* Here".
    FindStr   = "replaceMe"
    RepStr    = "ID"
    NumDigits = 3                   # Number of digits to append to RepStr.
                                    # Controls leading zeroes, but does not
                                    # limit the total number (i.e. if there
                                    # are 10000+ replaces, then ID10134, for
                                    # example, will be generated).
    Number    = 0                   # Initial number to append.
    BatchFile = ".\\CopyAndDel.bat" # Name of batch file used to clean up.
}

FNR == 1 {
    print("@copy " FILENAME ".ed " FILENAME " /y >nul") > BatchFile
    print("@del  " FILENAME ".ed >nul") > BatchFile
}

{
    while (match($0, FindStr)) {
        sub(FindStr, sprintf("%s%0*d", RepStr, NumDigits, Number++))
    }
    print > (FILENAME ".ed")
}

END {
    print "If the '.ed' files look good, execute " BatchFile " to copy them over"
    print "the original files and then delete them."
}