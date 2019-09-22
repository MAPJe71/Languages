! This macro is intended to calculate the surface sag of an object in non-sequential ZEMAX 
! using the NSRA operand. It assumes that there is a source ray in the NSC editor, with a
! single analysis ray, and that the object whose surface sag is to be determined immediately
! follows the source ray in the NSC editor (with no other sources or objects present).
!
! Written by S. Gangadhara, 10/30/07
!

num_obj = NOBJ(1)		# determine the number of objects in the system
IF (num_obj > 2)
	PRINT "This macro is not intended for systems with multiple sources or objects."
	END
ENDIF

! Have the user specify the x- and y-range for the calculation (assume symmetry)

INPUT "ENTER THE X-RANGE FOR THE CALCULATION", x_tot
INPUT "ENTER THE Y-RANGE FOR THE CALCULATION", y_tot
INPUT "ENTER THE NUMBER OF DIVISIONS", n_step

! Calculate the necessary input values

x_min = -1.0*x_tot/2.0
y_min = -1.0*y_tot/2.0
x_max = x_tot/2.0
y_max = y_tot/2.0

delta_x = x_tot/n_step
delta_y = y_tot/n_step
n_step = n_step + 1.0

! Print input values to the text window

PRINT "X-range for calculations: ", x_min, " to ", x_max
PRINT "Y-range for calculations: ", y_min, " to ", y_max
PRINT "X step size: ", delta_x
PRINT "Y step size: ", delta_y

! Loop over all steps

x_init = NPOS(1,1,1) 	# save initial values for x, y of source ray
y_init = NPOS(1,1,2)

PRINT "x, y, z values:"
PRINT
FORMAT 8.4

FOR i, 1, n_step, 1
	FOR j, 1, n_step, 1
		x_val = x_min + (delta_x*(i-1.0))
		y_val = y_min + (delta_y*(j-1.0))
		SETNSCPOSITION 1, 1, 1, x_val
		SETNSCPOSITION 1, 1, 2, y_val
		UPDATE
		C = OCOD("NSRA")
		E = OPEV(C, 1, 1, 0, 0, 1, 3)
		PRINT x_val, y_val, E
	NEXT j
NEXT i

! Set source ray position back to its initial value

SETNSCPOSITION 1, 1, 1, x_init
SETNSCPOSITION 1, 1, 2, y_init
UPDATE

! End program

PRINT "End of program."

END