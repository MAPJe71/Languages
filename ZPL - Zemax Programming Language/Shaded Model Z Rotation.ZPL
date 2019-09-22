! This macro demonstrates the process of changing the Z rotation
! parameter in the settings of the Shaded Model Layout in ZEMAX.
! The MODIFYSETTINGS keyword is used to change the settings of the LSH.CFG
! file, which holds the "global" Shaded Model settings.

! NOTE:  This macro is designed to work on the Double Gauss sample file
! provided by ZEMAX.  The macro may be modified accordingly to accomodate 
! another lens file.

! Author: Daniel Hill - ZEMAX DEVELOPMENT CORPORATION
! Date: March 27, 2007

start_z = 0
end_z = 360
step_size = 15
prefix$ = "C:\Program Files\ZEMAX\"
ext$ = "DEG.WMF"
settingsfilename$ = prefix$ + "LSH.CFG"


FOR z, start_z, end_z, step_size
	IF (z < 10) THEN z$ = "00" + $STR(z)
	IF (z < 100) & (z > 9) THEN z$ = "0" + $STR(z)
	IF (z > 99) THEN z$ = $STR(z)
	filename$ = prefix$ + "Z Rotation_" + z$ + ext$
	MODIFYSETTINGS settingsfilename$, SHA_ROTZ, z
	LOADLENS "C:\Program Files\ZEMAX\Samples\Sequential\Objectives\Double Gauss 28 degree field.ZMX"
	UPDATE 4
	EXPORTBMP 4, filename$
NEXT
PRINT "All Done!"
END