! This macro is intended to demonstrate the use of the ZPL keyword ZRDPLAYBACK.
! This keyword allows data to be filtered after the ray-trace for post-
! processing. The macro should be used with the sample file "ZRDPLAYBACK.ZMX",
! which is provided as an attachment to the Knowledge Base Article entitled
! "How To Use the ZRDPLAYBACK Keyword To Obtain Filtered Results". 
!
! Written by S. Gangadhara, 07/01/2011
!

! Clear the detector
x = NSDE(1,0,0,0,0)

! Trace rays with scattering turned off
A$ = "No_Scatter.ZRD"
NSTR 1, 1, 0, 0, 1, 1, 1, 1, A$

! Obtain total power in Watts and Lumens
tot_pow_W = NSDE(1,4,0,0,1)
tot_pow_L = NSDE(1,4,0,0,3)

! Get power at each wavelength using ZRDPLAYBACK with filter string
ZRDPLAYBACK A$, 1, 4, 4, "W1"
w1_pow_W = NSDE(1,4,0,0,1)
w1_pow_L = NSDE(1,4,0,0,3)
ZRDPLAYBACK A$, 1, 4, 4, "w2"
w2_pow_W = NSDE(1,4,0,0,1)
w2_pow_L = NSDE(1,4,0,0,3)
ZRDPLAYBACK A$, 1, 4, 4, "w3"
w3_pow_W = NSDE(1,4,0,0,1)
w3_pow_L = NSDE(1,4,0,0,3)

! Print results
PRINT " "
PRINT "With no scattering on"
PRINT "Total Watts, Lumens = ", tot_pow_W, " ", tot_pow_L
PRINT "Watts, Lumens @ wavelength 1 = ", w1_pow_W, " ", w1_pow_L
PRINT "Watts, Lumens @ wavelength 2 = ", w2_pow_W, " ", w2_pow_L
PRINT "Watts, Lumens @ wavelength 3 = ", w3_pow_W, " ", w3_pow_L

! Update Detector Viewer for all wavelength data
ZRDPLAYBACK A$, 1, 4, 4
UPDATE 2

PAUSE "Ready to move on to scattering calculation..."

! Allow for bulk scattering by increasing detector size
! and clearing detector
SETNSCPARAMETER 1, 4, 1, 10
SETNSCPARAMETER 1, 4, 2, 10
x = NSDE(1,0,0,0,0)

! Trace rays with bulk scattering on
A$ = "Bulk_Scatter.ZRD"
NSTR 1, 1, 0, 1, 1, 1, 1, 1, A$

! Obtain total power in Watts and Lumens
tot_pow_W = NSDE(1,4,0,0,1)
tot_pow_L = NSDE(1,4,0,0,3)

! Get power at each wavelength using ZRDPLAYBACK with filter string
ZRDPLAYBACK A$, 1, 4, 4, "X_WAVERANGE(4,0.48,0.49)"
w1_pow_W = NSDE(1,4,0,0,1)
w1_pow_L = NSDE(1,4,0,0,3)
ZRDPLAYBACK A$, 1, 4, 4, "X_WAVERANGE(4,0.58,0.59)"
w2_pow_W = NSDE(1,4,0,0,1)
w2_pow_L = NSDE(1,4,0,0,3)
ZRDPLAYBACK A$, 1, 4, 4, "X_WAVERANGE(4,0.65,0.66)"
w3_pow_W = NSDE(1,4,0,0,1)
w3_pow_L = NSDE(1,4,0,0,3)

! Print results
PRINT " "
PRINT "Bulk scattering on"
PRINT "Total Watts, Lumens = ", tot_pow_W, " ", tot_pow_L
PRINT "Watts, Lumens @ wavelength 1 = ", w1_pow_W, " ", w1_pow_L
PRINT "Watts, Lumens @ wavelength 2 = ", w2_pow_W, " ", w2_pow_L
PRINT "Watts, Lumens @ wavelength 3 = ", w3_pow_W, " ", w3_pow_L

! Update Detector Viewer for all wavelength data
ZRDPLAYBACK A$, 1, 4, 4
UPDATE 2

END