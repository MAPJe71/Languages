! This macro is used to define a configuration in a lens system (new or existing) in which a number of 
! surfaces will be ignored. The surface range must be continuous, e.g. you can't use this macro to
! specify that surfaces 2-4 and surface 6 should be ignored, but you can use the macro to specify that
! surfaces 2-6 should be ignored. The surfaces are ignored using the IGNR multi-configuration operand.
!
! Written by S. Gangadhara, 01/07/2010
!

! Determine the configuration in which surfaces should be ignored

x = NCON()		# Find the number of configurations currently defined in the system
in_flag = 0		# Flag to determine whether a new configuration will be defined
IF (x == 1)		# If the system only has one config, then surfaces will be ignored in config 2
	conf_num = 2
	INSERTCONFIG conf_num
	in_flag = 1
ELSE			# If the system already has multiple configs, determine which config to use
	INPUT "Which configuration should have surfaces ignored?", y
	IF (y <= 0)
		PRINT "Not a valid configuration number. Exiting program."
		GOTO 10
	ENDIF
	IF (y > x)	# Ignore the surfaces in a new config
		conf_num = x + 1
		INSERTCONFIG conf_num
		in_flag = 1
	ELSE		# Ignore the surfaces in an existing config
		conf_num = y
	ENDIF
ENDIF

! Determine the surfaces to be ignored

x = NSUR()		# Find the number of surfaces in the system
INPUT "What is the start surface number?", surf_start
IF ((surf_start <= 0) | (surf_start >= x))
	PRINT "Not a valid starting surface. Exiting program."
	GOTO 10
ENDIF
INPUT "What is the end surface number?", surf_end
IF ((surf_end <= 0) | (surf_end >= x) | (surf_end <= surf_start))
	PRINT "Not a valid end surface. Exiting program."
	GOTO 10
ENDIF
n_surface = surf_end - surf_start + 1

! Define the rows in the MC editor for the IGNR operands

z = MCON(0,0,0)		# Find the number of operands currently in the MC editor
row_start = z + 1
row_end = z + n_surface
FOR i, row_start, row_end, 1
	INSERTMCO i
NEXT i

! Insert IGNR operands into the MC editor

n = 0
FOR i, row_start, row_end, 1
	surf_set = surf_start + n
	SETMCOPERAND i, 0, "IGNR", 0
	SETMCOPERAND i, 0, surf_set, 1
	n = n + 1
NEXT i

! Set the values for the desired IGNR operands, and copy over other operand 
! values if necessary

FOR i, row_start, row_end, 1
	SETMCOPERAND i, conf_num, 1, 0
NEXT i

IF (in_flag == 1)
	FOR i, 1, z, 1
		x = MCOP(i,1)	# Existing data copied from config 1
		SETMCOPERAND i, conf_num, x, 0
	NEXT i
ENDIF

! End program

LABEL 10
END