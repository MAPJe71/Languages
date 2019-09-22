! Open_seq_files.zpl by Nam Hyong Kim (08/24/2006)
! This code opens series of Monte Carlo files named sequentially from MC_T0001.zmx to
! MC_T0020.zmx, if the PRINT command is replaced with LOADLENS command


path$ = "C:\Program Files\ZEMAX\Samples\Sequential\Objectives\"
prefix$ = "MC_T"		
number_of_files = 20 

IF (number_of_files > 9999) THEN number_of_files = 9999

FORMAT "%#04i" LIT  # Use the C language format %#041 (4-digit integers 0000, 0001 to 9999)

FOR index, 1, number_of_files, 1
 
	suffix$ = $STR(index)

	myfile_name$ = path$ + prefix$ + suffix$ + ".zmx"
	PRINT myfile_name$  # To load the lens files, replace this line with "LOADLENS myfile_name$"
	
NEXT

END