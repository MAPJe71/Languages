A$ = "Test.ZMX"  # This sets the filename to strip the extension from
FOR n, 1, 500, 1
	B$ = $LEFTSTRING(A$,n)  # Reads the "n" leftmost characters of the filename
	C$ = $RIGHTSTRING(B$,1) # Reads the rightmost character of the above string variable
	IF (C$ $== ".")  # Checks to see if the rightmost character is a period
		x = n-1 
		D$ = $LEFTSTRING(A$,x)  # Reads all of the characters to the left of the period
		PRINT D$
	ENDIF
NEXT