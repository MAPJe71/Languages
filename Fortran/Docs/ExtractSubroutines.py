import re
from collections import defaultdict

def processsubroutine( line ):
    if ')' in line:
        return line.split("(")[1].split(')')[0].split(',')

def collectsubroutines( fname ):
    procnam = defaultdict()
    fortran_proc_def = re.compile( r'\s*(RECURSIVE)?\s*(SUBROUTINE|FUNCTION)\s+\S+\(*', re.IGNORECASE)
    fp = open( fname, "r")
    datalines = fp.readlines()
    fp.close()
    for i,line in enumerate( datalines ):
        if fortran_proc_def.match( line ):
            procnam[(line.split()[1].split('(')[0])] = processsubroutine( line )
    return procnam

def main():
    for key,item in procnam.items():
        print key,item
