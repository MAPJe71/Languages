Path$=$DATAPATH()+"\POP\BEAMFILES\"

file1$="ZBFSUM_demo1.ZBF"
file2$="ZBFSUM_demo2.ZBF"
file3$="ZBFSUM_demo_result.zbf"
file1_full_path$=path$ + file1$
file2_full_path$=path$ + file2$

! Run POP and save the beam file at surface 3 as ZBFSUM_demo1.zbf
POP file1$, 3                                  

! Create a copy of ZBFSUM_demo1.zbf file named ZBFSUM_demo2.zbf
COPYFILE file1_full_path$, file2_full_path$    

!Tilt the phase of the ZBFSUM_demo1.zbf
ZBFTILT file1$, 0,0, 0, 30                      

! Decenter the beams so that they are completly separated initially

!Decenter the ZBFSUM_demo2.zbf beam in -Y direction
ZBFRESAMPLE file2$, 128,128, 1.5040, 1.5040, 0, -0.36 
!Decenter the ZBFSUM_demo1.zbf beam in +Y direction
ZBFRESAMPLE file1$, 128,128, 1.5040, 1.5040, 0, 0.36  

FOR i, 0, 41, 1

	! Incrementally move the ZBFSUM_demo2.zbf beam towards +Y direction
	ZBFRESAMPLE file2$, 128,128, 1.5040, 1.5040, 0, 0.018  
	! Incrementally move the ZBFSUM_demo1.zbf beam towards -Y direction
	ZBFRESAMPLE file1$, 128,128, 1.5040, 1.5040, 0, -0.018 

	! Coherently sum the two beam and save the result as ZBFSUM_demo_result.zbf
	ZBFSUM 1 file1$ file2$ file3$ 
	! Update the Beam File Viewer window
	UPDATE 1					 
	
	
	!WAIT some time before decentering again
	PAUSE TIME, 50

NEXT i

PRINT "done"
END

