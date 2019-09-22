PI = 3.14159
Z_OFFSET = 10
LENGTH = 0

Aperture_X = NPAR(1,1,1) # get X Aperture parameter of rectangular CPC object
Aperture_Y = NPAR(1,1,3) # get Y Aperture parameter of rectangular CPC object

X_ANGLE = PI*NPAR(1,1,2)/180 # get X Angle parameter of rectangular CPC object in radian
Y_ANGLE = PI*NPAR(1,1,4)/180 # get Y Angle parameter of rectangular CPC object in radian


 # Calcualte the length given by the formula in the manual
X_LENGTH = (APERTURE_X*(1+ SINE(X_ANGLE)))/(TANG(X_ANGLE)*SINE(X_ANGLE))
Y_LENGTH = (APERTURE_Y*(1+ SINE(Y_ANGLE)))/(TANG(Y_ANGLE)*SINE(Y_ANGLE))

 # Make the values of the LENGTH variable the smaller one between X and Y
IF (X_LENGTH > Y_LENGTH) 
LENGTH = Y_LENGTH + Z_OFFSET
ELSE
LENGTH = (X_LENGTH + Z_OFFSET)
ENDIF

 # If LENGTH is larger than the "Length" parameter (parameter #5) then
 # LENGTH = Parameter #5 value plus 10

IF (LENGTH > NPAR(1,1,5)) 
LENGTH = NPAR(1,1,5) + Z_OFFSET
ELSE
ENDIF

 # return the LENGTH value to the editor
SOLVERETURN LENGTH

END