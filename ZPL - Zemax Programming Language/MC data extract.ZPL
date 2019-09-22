! This macro is used to extract individual perturbation data from Monte Carlo tolerance runs,
! and print those results. This file is customized to work with the sample file Cooke 40 degree
! field.zmx.
!
! Written by S. Gangadhara, 06/07/10
!

! Define number of MC runs

n_files = 100

! Define arrays to hold perturbation data
! Number of arrays = number of tolerances (+ arrays for criterion, irregularity angle)

DECLARE tcrit_per, DOUBLE, 1, n_files

DECLARE trad1_per, DOUBLE, 1, n_files
DECLARE trad2_per, DOUBLE, 1, n_files
DECLARE trad3_per, DOUBLE, 1, n_files
DECLARE trad4_per, DOUBLE, 1, n_files
DECLARE trad5_per, DOUBLE, 1, n_files
DECLARE trad6_per, DOUBLE, 1, n_files

DECLARE tthi1_per, DOUBLE, 1, n_files
DECLARE tthi2_per, DOUBLE, 1, n_files
DECLARE tthi3_per, DOUBLE, 1, n_files
DECLARE tthi4_per, DOUBLE, 1, n_files
DECLARE tthi5_per, DOUBLE, 1, n_files

DECLARE tedx12_per, DOUBLE, 1, n_files
DECLARE tedy12_per, DOUBLE, 1, n_files
DECLARE tetx12_per, DOUBLE, 1, n_files
DECLARE tety12_per, DOUBLE, 1, n_files

DECLARE tedx34_per, DOUBLE, 1, n_files
DECLARE tedy34_per, DOUBLE, 1, n_files
DECLARE tetx34_per, DOUBLE, 1, n_files
DECLARE tety34_per, DOUBLE, 1, n_files

DECLARE tedx56_per, DOUBLE, 1, n_files
DECLARE tedy56_per, DOUBLE, 1, n_files
DECLARE tetx56_per, DOUBLE, 1, n_files
DECLARE tety56_per, DOUBLE, 1, n_files

DECLARE tsdx1_per, DOUBLE, 1, n_files
DECLARE tsdx3_per, DOUBLE, 1, n_files
DECLARE tsdx5_per, DOUBLE, 1, n_files

DECLARE tsdy1_per, DOUBLE, 1, n_files
DECLARE tsdy3_per, DOUBLE, 1, n_files
DECLARE tsdy5_per, DOUBLE, 1, n_files

DECLARE tirrm1_per, DOUBLE, 1, n_files
DECLARE tirrm2_per, DOUBLE, 1, n_files
DECLARE tirrm3_per, DOUBLE, 1, n_files
DECLARE tirrm4_per, DOUBLE, 1, n_files
DECLARE tirrm5_per, DOUBLE, 1, n_files
DECLARE tirrm6_per, DOUBLE, 1, n_files

DECLARE tirra1_per, DOUBLE, 1, n_files
DECLARE tirra2_per, DOUBLE, 1, n_files
DECLARE tirra3_per, DOUBLE, 1, n_files
DECLARE tirra4_per, DOUBLE, 1, n_files
DECLARE tirra5_per, DOUBLE, 1, n_files
DECLARE tirra6_per, DOUBLE, 1, n_files

DECLARE tind1_per, DOUBLE, 1, n_files
DECLARE tind3_per, DOUBLE, 1, n_files
DECLARE tind5_per, DOUBLE, 1, n_files

DECLARE tabb1_per, DOUBLE, 1, n_files
DECLARE tabb3_per, DOUBLE, 1, n_files
DECLARE tabb5_per, DOUBLE, 1, n_files

! Get nominal values for radii, thicknesses, indices, and Abbe numbers
! (all other perturbations have a nominal value of zero)

trad1_nom = TOLV(3,90)
trad2_nom = TOLV(4,90)
trad3_nom = TOLV(5,90)
trad4_nom = TOLV(6,90)
trad5_nom = TOLV(7,90)
trad6_nom = TOLV(8,90)

tthi1_nom = TOLV(9,90)
tthi2_nom = TOLV(10,90)
tthi3_nom = TOLV(11,90)
tthi4_nom = TOLV(12,90)
tthi5_nom = TOLV(13,90)

tind1_nom = TOLV(38,90)
tind3_nom = TOLV(39,90)
tind5_nom = TOLV(40,90)

tabb1_nom = TOLV(41,90)
tabb3_nom = TOLV(42,90)
tabb5_nom = TOLV(43,90)

! Get values from MC files

N$ = $FILEPATH()	# Store name of nominal file, which we will load at end of cycle
A$ = $PATHNAME()	# Get name for path in which nominal file is located - assume this is same path for MC files
B$ = A$+"\MC_T"		# Basic file name structure for Monte Carlo files
FORMAT "%#04i" LIT	# Provides correct format for MC file number to append to name, assuming < 10,000 MC files
FOR i, 1, n_files, 1	# Loop over all MC files
	F$ = B$+$STR(i)+".zmx"
	LOADLENS F$
	! Criterion value
	tcrit_per(i) = MFCN()
	! Radii perturbations
	trad1_per(i) = RADI(2) - trad1_nom
	trad2_per(i) = RADI(3) - trad2_nom
	trad3_per(i) = RADI(7) - trad3_nom
	trad4_per(i) = RADI(8) - trad4_nom
	trad5_per(i) = RADI(12) - trad5_nom
	trad6_per(i) = RADI(13) - trad6_nom
	! Thickness perturbations
	tthi1_per(i) = THIC(2) - tthi1_nom
	tthi2_per(i) = THIC(5) - tthi2_nom
	tthi3_per(i) = THIC(7) - tthi3_nom
	tthi4_per(i) = THIC(10) - tthi4_nom
	tthi5_per(i) = THIC(12) - tthi5_nom
	! Element tilts and decenters
	tedx12_per(i) = PARM(1,1)
	tedy12_per(i) = PARM(2,1)
	tetx12_per(i) = PARM(3,1)
	tety12_per(i) = PARM(4,1)
	tedx34_per(i) = PARM(1,6)
	tedy34_per(i) = PARM(2,6)
	tetx34_per(i) = PARM(3,6)
	tety34_per(i) = PARM(4,6)
	tedx56_per(i) = PARM(1,11)
	tedy56_per(i) = PARM(2,11)
	tetx56_per(i) = PARM(3,11)
	tety56_per(i) = PARM(4,11)
	! Surface decenters
	tsdx1_per(i) = PARM(1,2)
	tsdx3_per(i) = PARM(1,7)
	tsdx5_per(i) = PARM(1,12)
	tsdy1_per(i) = PARM(2,2)
	tsdy3_per(i) = PARM(2,7)
	tsdy5_per(i) = PARM(2,12)
	! Irregularity magnitude
	tirrm1_per(i) = PARM(5,2)
	tirrm2_per(i) = PARM(5,3)
	tirrm3_per(i) = PARM(5,7)
	tirrm4_per(i) = PARM(5,8)
	tirrm5_per(i) = PARM(5,12)
	tirrm6_per(i) = PARM(5,13)
	! Irregularity angle
	tirra1_per(i) = PARM(8,2)
	tirra2_per(i) = PARM(8,3)
	tirra3_per(i) = PARM(8,7)
	tirra4_per(i) = PARM(8,8)
	tirra5_per(i) = PARM(8,12)
	tirra6_per(i) = PARM(8,13)
	! Refractive index
	tind1_per(i) = SOLV(2,2,1)
	tind3_per(i) = SOLV(7,2,1)
	tind5_per(i) = SOLV(12,2,1)
	! Abbe number
	tabb1_per(i) = SOLV(2,2,2)
	tabb3_per(i) = SOLV(7,2,2)
	tabb5_per(i) = SOLV(12,2,2)
NEXT i
LOADLENS N$

! Print the results

PRINT "Run#   Criterion       ",
PRINT "RAD1       RAD2       RAD3       RAD4       RAD5       RAD6       ",
PRINT "THI1       THI2       THI3       THI4       THI5       ",
PRINT "TEDX12     TEDY12     TETX12     TETY12     ",
PRINT "TEDX34     TEDY34     TETX34     TETY34     ",
PRINT "TEDX56     TEDY56     TETX56     TETY56     ",
PRINT "TSDX1      TSDX3      TSDX5      TSDY1      TSDY3      TSDY5       ",
PRINT "TIRRM1          TIRRM2          TIRRM3          ",
PRINT "TIRRM4          TIRRM5          TIRRM6          ",
PRINT "TIRRA1     TIRRA2     TIRRA3     TIRRA4     TIRRA5     TIRRA6       ",
PRINT "TIND1      TIND3      TIND5      ",
PRINT "TABB1      TABB3      TABB5"
FOR i, 1, n_files, 1
	FORMAT "%#04i" LIT
	PRINT i, "   ", 
	FORMAT 10.5 EXP
	PRINT tcrit_per(i), " ", 
	FORMAT 10.5
	PRINT trad1_per(i), " ", trad2_per(i), " ", trad3_per(i), " ", 
	PRINT trad4_per(i), " ", trad5_per(i), " ", trad6_per(i), " ",
	PRINT tthi1_per(i), " ", tthi2_per(i), " ", tthi3_per(i), " ",
	PRINT tthi4_per(i), " ", tthi5_per(i), " ",
	PRINT tedx12_per(i), " ", tedy12_per(i), " ", 
	PRINT tetx12_per(i), " ", tety12_per(i), " ",
	PRINT tedx34_per(i), " ", tedy34_per(i), " ", 
	PRINT tetx34_per(i), " ", tety34_per(i), " ",
	PRINT tedx56_per(i), " ", tedy56_per(i), " ", 
	PRINT tetx56_per(i), " ", tety56_per(i), " ",
	PRINT tsdx1_per(i), " ", tsdx3_per(i), " ", tsdx5_per(i), " ",
	PRINT tsdy1_per(i), " ", tsdy3_per(i), " ", tsdy5_per(i), "    ",
	FORMAT "%+10.5e" LIT
	PRINT tirrm1_per(i), "   ", tirrm2_per(i), "   ", tirrm3_per(i), "   ",
	PRINT tirrm4_per(i), "   ", tirrm5_per(i), "   ", tirrm6_per(i), "   ",
	FORMAT 10.5
	PRINT tirra1_per(i), " ", tirra2_per(i), " ", tirra3_per(i), " ",
	PRINT tirra4_per(i), " ", tirra5_per(i), " ", tirra6_per(i), " ",
	PRINT tind1_per(i), " ", tind3_per(i), " ", tind5_per(i), " ",
	PRINT tabb1_per(i), " ", tabb3_per(i), " ", tabb5_per(i), " "
NEXT i

! Release memory associated with arrays

RELEASE tcrit_per

RELEASE trad1_per
RELEASE trad2_per
RELEASE trad3_per
RELEASE trad4_per
RELEASE trad5_per
RELEASE trad6_per

RELEASE tthi1_per
RELEASE tthi2_per
RELEASE tthi3_per
RELEASE tthi4_per
RELEASE tthi5_per

RELEASE tedx12_per
RELEASE tedy12_per
RELEASE tetx12_per
RELEASE tety12_per

RELEASE tedx34_per
RELEASE tedy34_per
RELEASE tetx34_per
RELEASE tety34_per

RELEASE tedx56_per
RELEASE tedy56_per
RELEASE tetx56_per
RELEASE tety56_per

RELEASE tsdx1_per
RELEASE tsdx3_per
RELEASE tsdx5_per

RELEASE tsdy1_per
RELEASE tsdy3_per
RELEASE tsdy5_per

RELEASE tirrm1_per
RELEASE tirrm2_per
RELEASE tirrm3_per
RELEASE tirrm4_per
RELEASE tirrm5_per
RELEASE tirrm6_per

RELEASE tirra1_per
RELEASE tirra2_per
RELEASE tirra3_per
RELEASE tirra4_per
RELEASE tirra5_per
RELEASE tirra6_per

RELEASE tind1_per
RELEASE tind3_per
RELEASE tind5_per

RELEASE tabb1_per
RELEASE tabb3_per
RELEASE tabb5_per

END