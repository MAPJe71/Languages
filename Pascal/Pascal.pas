UNIT Mathunit;
INTERFACE

TYPE
  PolyPtr       = ^Polynom;
  RootStack     = ^EachRoot;
  Complex       = RECORD
                     Re : DOUBLE;
                     Im : DOUBLE;
                  END;
  Polynom       = RECORD
                     Link  : PolyPtr;
                     Coeff : Complex;
                  END;
  EachRoot      = RECORD
                     Link  : RootStack;
                     Coeff : Complex;
                  END;

FUNCTION Floor(X : DOUBLE) : DOUBLE;  (* The next lowest integer             *)
FUNCTION Ceiling(X : DOUBLE) : DOUBLE; (* The next highest integer           *)
FUNCTION Log10(X : DOUBLE) : DOUBLE;  (* Base 10 log of x                    *)
FUNCTION Exp10(X : DOUBLE) : DOUBLE;  (* 10 raised to the x power            *)
FUNCTION PwrXY(X, Y : DOUBLE) : DOUBLE; (* raise x to the power y            *)
FUNCTION QDBV(Volts : DOUBLE) : DOUBLE; (* convert from volts to dB          *)
FUNCTION QDBW(Watts : DOUBLE) : DOUBLE; (* convert from watts to dB          *)
FUNCTION QWATTS(DB : DOUBLE) : DOUBLE; (* convert from dB to watts           *)
FUNCTION QVOLTS(DB : DOUBLE) : DOUBLE; (* convert from dB to volts           *)
FUNCTION SINH(X : DOUBLE) : DOUBLE;   (* hyperbolic sine                     *)
FUNCTION COSH(X : DOUBLE) : DOUBLE;   (* hyperbolic cosine                   *)
FUNCTION TANH(X : DOUBLE) : DOUBLE;   (* hyperbolic tangent                  *)
FUNCTION ISINH(X : DOUBLE) : DOUBLE;  (* arc hyperbolic sine                 *)
FUNCTION ICOSH(X : DOUBLE) : DOUBLE;  (* arc hyperbolic cosine               *)
FUNCTION ITANH(X : DOUBLE) : DOUBLE;  (* arc hyperbolic tangent              *)
FUNCTION ARCSIN(X : DOUBLE) : DOUBLE; (* arc sine using TP arctan function   *)
FUNCTION ARCCOS(X : DOUBLE) : DOUBLE; (* inverse cosine using TP arctan      *)
FUNCTION ATAN2(X, Y : DOUBLE) : DOUBLE; (* arctan function with quadrant check
 X is real axis value or denominator, Y is imaginary axis value or numerator *)
FUNCTION TAN(X : DOUBLE) : DOUBLE;    (* tangent of X                        *)
FUNCTION GAUSS (Mean, StdDev : DOUBLE) : DOUBLE; (* gaussian random number   *)
FUNCTION RESIDUE(Radix, Number : DOUBLE) : DOUBLE; (* remainder of number/radix
                                                                             *)
FUNCTION MINIMUM(A, B : DOUBLE) : DOUBLE; (* the minimum of a and b          *)
FUNCTION MAXIMUM(A, B : DOUBLE) : DOUBLE; (* the maximum of a and b          *)
PROCEDURE Cadd(C, D : Complex;
                   VAR Result : Complex); (* add two complex numbers         *)
PROCEDURE Cconj(A : Complex;
                   VAR Result : Complex); (* complex conjugate               *)
PROCEDURE Cdiv(Num, Denom : Complex;
                   VAR Result : Complex); (* complex division   *)
PROCEDURE Cinv(A : Complex;
                   VAR Result : Complex); (* complex inverse                 *)
FUNCTION Cmag(C : Complex) : DOUBLE;  (* magnitude of a complex number       *)
PROCEDURE Cmake(A, B : DOUBLE;
                   VAR Result : Complex); (* form a complex number           *)
PROCEDURE Cmult(C, D : Complex;
                   VAR Result : Complex); (* multiply two complex numbers    *)
PROCEDURE Csub(C, D : Complex;
                   VAR Result : Complex); (* subtract D from C complex number
                                                                             *)
PROCEDURE Cexp(A : Complex;
                   VAR Result : Complex); (* exponential of a complex number *)
PROCEDURE Csqr(A : Complex;
                   VAR Result : Complex); (* square of a complex number      *)
PROCEDURE Csqrt(A : Complex;
                   VAR Result : Complex); (* sqrt of a complex number        *)
PROCEDURE Cln(A : Complex;
                   VAR Result : Complex); (* natural log of complex A        *)
PROCEDURE CpwrXY(X, Y : Complex;
                   VAR Result : Complex); (* raise X to the Y power          *)
PROCEDURE Csinh(A : Complex;
                   VAR Result : Complex); (* hyperbolic sine of complex A    *)
PROCEDURE Ccosh(A : Complex;
                   VAR Result : Complex); (* hyperbolic cosine of complex A  *)
PROCEDURE Ctanh(A : Complex;
                   VAR Result : Complex); (* hyperbolic tangent of complex A *)
PROCEDURE Csin(A : Complex;
                   VAR Result : Complex); (* sine of complex A               *)
PROCEDURE Ccos(A : Complex;
                   VAR Result : Complex); (* cosine of complex A             *)
PROCEDURE Ctan(A : Complex;
                   VAR Result : Complex); (* tangent of complex A            *)
PROCEDURE Carcsin(A : Complex;
                   VAR Result : Complex); (* inverse sine of complex A       *)
PROCEDURE Carccos(A : Complex;
                   VAR Result : Complex); (* inverse cosine of complex A     *)
PROCEDURE Carctan(A : Complex;
                   VAR Result : Complex); (* inverse tangent of complex A    *)
PROCEDURE PolyAssign(X : PolyPtr;     (* generate new polynomial at Y with   *)
                   VAR Y : PolyPtr);  (* same coefficients as poly at X      *)
PROCEDURE PolyClear(VAR Ptr : PolyPtr); (* remove a polynomial               *)
PROCEDURE PolyEval(X : PolyPtr;       (* evaluate polynomial X in S          *)
                   S : Complex;       (* at complex value S                  *)
                   VAR Result : Complex); (* assign to Result                *)
PROCEDURE PolyForm(A : RootStack;     (* form a polynomial B from the
                                                        roots of rootstack A *)
                   VAR B : PolyPtr);
PROCEDURE PolyMult(Xx, Yy : PolyPtr;
                   VAR Z : PolyPtr);  (* multiply two polynomials            *)
PROCEDURE PolyNegate(X : PolyPtr);
FUNCTION PolyOrder(Z : PolyPtr) : BYTE; (* order of a polynomial             *)
PROCEDURE PolyPower(I : BYTE;           (* raise a polynomial X to power I *)
                   X  : PolyPtr;
                   VAR Y : PolyPtr);
PROCEDURE PolyPrint(X : PolyPtr);     (* writeln for polynomial              *)
PROCEDURE PolyScale(X : PolyPtr;      (* multiply polynomial X by            *)
                   Scalar : Complex); (* complex number Scalar               *)
PROCEDURE PolyUnary(X : PolyPtr);     (* make the polynomial X unary         *)
(* i.e. the leading coef = 1                                                 *)
PROCEDURE RootPush(R : Complex;       (* add root R to a rootstack L         *)
                   VAR L : RootStack);
PROCEDURE RootPop(VAR L : RootStack;      (* get root from a rootstack L *)
                  VAR R : Complex);
PROCEDURE RootClear(VAR L : RootStack);   (* clear a rootstack L             *)
PROCEDURE RootRotate(N : BYTE;VAR L : RootStack);(* rotate rootstack L by N  *)
                                            (* so that last moves toward 1st *)
PROCEDURE RootCopy(S : RootStack;     (* copy a rootstack from S to D        *)
                   VAR D: RootStack);

CONST
  Cone : Complex = (Re : 1.0; Im : 0.0);
  Czero: Complex = (Re : 0.0; Im : 0.0);
  Ci   : Complex = (Re : 0.0; Im : 1.0);

IMPLEMENTATION
VAR
  Ln10          : DOUBLE;

  
  
FUNCTION Floor (X : DOUBLE) : DOUBLE; (* The next lowest integer             *)

(* note that INT will not work when X is a negative number *)
BEGIN
  IF X >= 0.0 THEN
    Floor := Int(X)
  ELSE                                (* Use int for positive x              *)
    IF Frac(X) = 0.0 THEN
      Floor := X
    ELSE                              (* no shift on exact integer           *)
      Floor := - Int(1 - X)           (* Round away from zero                *)
END;                                  (* Floor                               *)

FUNCTION Ceiling (X : DOUBLE) : DOUBLE; (* The next highest integer          *)
BEGIN
  IF X <= 0.0 THEN
    Ceiling := Int(X)
  ELSE                                (* Use int for negative x              *)
    IF Frac(X) = 0.0 THEN
      Ceiling := X
    ELSE                              (* no shift on exact integer           *)
      Ceiling := 1 - Int(- X)         (* Shift x to negative                 *)
END;                                  (* Ceiling                             *)

FUNCTION Log10 (X : DOUBLE) : DOUBLE; (* Base 10 log of x                    *)
BEGIN                                 (* Ln(10) supplied for speed           *)
  Log10 := Ln(X) / Ln10               (* Easily derived                      *)
END;                                  (* Log10                               *)

FUNCTION Exp10 (X : DOUBLE) : DOUBLE; (* 10 raised to the x power            *)
BEGIN                                 (* Ln(10) supplied for speed           *)
  Exp10 := Exp(X * Ln10)              (* easily derived                      *)
END;                                  (* Exp10                               *)

FUNCTION PwrXY (X, Y : DOUBLE) : DOUBLE; (* raise x to the power y           *)
BEGIN
  IF (Y = 0.0) THEN
    PwrXY := 1.0
  ELSE
    IF (X <= 0.0) AND (Frac(Y) = 0.0) THEN
      IF (Frac(Y / 2)) = 0.0 THEN
        PwrXY := Exp(Y * Ln(Abs(X)))
      ELSE
        PwrXY := - Exp(Y * Ln(Abs(X)))
    ELSE
      PwrXY := Exp(Y * Ln(X));
END;                                  (* PwrXY                               *)

FUNCTION QDBV (Volts : DOUBLE) : DOUBLE; (* convert from volts to dB         *)
BEGIN
  QDBV := 20.0 * Log10(Volts)
END;                                  (* QDBV                                *)

FUNCTION QDBW (Watts : DOUBLE) : DOUBLE; (* convert from watts to dB         *)
BEGIN
  QDBW := 10.0 * Log10(Watts)
END;                                  (* QDBW                                *)

FUNCTION QWATTS (DB : DOUBLE) : DOUBLE; (* convert from dB to watts          *)
BEGIN
  QWATTS := Exp10(DB / 10.0);
END;                                  (* QWATTS                              *)

FUNCTION QVOLTS (DB : DOUBLE) : DOUBLE; (* convert from dB to volts          *)
BEGIN
  QVOLTS := Exp10(DB / 20.0);
END;                                  (* QVOLTS                              *)

FUNCTION SINH (X : DOUBLE) : DOUBLE;  (* hyperbolic sine                     *)
BEGIN
  SINH := 0.5 * (Exp(X) - Exp(- X))
END;                                  (* SINH                                *)

FUNCTION COSH (X : DOUBLE) : DOUBLE;  (* hyperbolic cosine                   *)
BEGIN
  COSH := 0.5 * (Exp(X) + Exp(- X))
END;                                  (* COSH                                *)

FUNCTION TANH (X : DOUBLE) : DOUBLE;  (* hyperbolic tangent                  *)
BEGIN
  X := Exp(2.0 * X);
  TANH := (X - 1.0) / (X + 1.0)
END;                                  (* TANH                                *)

FUNCTION ISINH(X : DOUBLE) : DOUBLE; (* arc hyperbolic sine                 *)
BEGIN
  ISINH := Ln(Sqrt(1.0 + X * X) + X)
END;                                  (* ISINH                               *)

FUNCTION ICOSH (X : DOUBLE) : DOUBLE; (* arc hyperbolic cosine               *)
BEGIN
  ICOSH := Ln(X + Sqrt(X * X - 1.0))
END;                                  (* ICOSH                               *)

FUNCTION ITANH (X : DOUBLE) : DOUBLE; (* arc hyperbolic tangent              *)
BEGIN
  ITANH := Ln((1.0 + X) / (1.0 - X))
END;                                 (* answer returned in radians          *)

FUNCTION ARCSIN (X : DOUBLE) : DOUBLE; (* answer returned in radians          *)
BEGIN                                 (* answer returned in radians          *)
  IF X = 1.0 THEN
    ARCSIN := Pi / 2.0
  ELSE
    IF X = - 1.0 THEN
      ARCSIN := Pi / - 2.0
    ELSE
      ARCSIN := Arctan(X / Sqrt(1.0 - Sqr(X)))
END;                                 (* answer returned in radians          *)

FUNCTION ARCCOS (X : DOUBLE) : DOUBLE; (* inverse cosine using TP arctan     *)
BEGIN                                 (* answer returned in radians          *)
  IF X = 0.0 THEN
    ARCCOS := Pi / 2.0
  ELSE
    IF X < 0.0 THEN
      ARCCOS := Pi - Arctan(Sqrt(1.0 - Sqr(X)) / Abs(X))
    ELSE
      ARCCOS := Arctan(Sqrt(1.0 - Sqr(X)) / Abs(X))
END;                                  (* ARCCOS                              *)

FUNCTION ATAN2(X, Y : DOUBLE) : DOUBLE; (* arctan function with quadrant check
 X is real axis value or denominator, Y is imaginary axis value or numerator *)
BEGIN                                 (* answer returned in radians          *)
  IF Y <> 0.0 THEN
    IF X <> 0.0 THEN                  (* point not on an axis                *)
      IF X > 0.0 THEN                 (* 1st or 4th quadrant use std arctan  *)
        ATAN2 := Arctan(Y / X)
      ELSE
        IF Y > 0.0 THEN               (* 2nd quadrant                        *)
          ATAN2 := Pi + Arctan(Y / X)
        ELSE
          ATAN2 := Arctan(Y / X) - Pi (* 3rd quadrant                        *)
    ELSE                              (* point on the Y axis                 *)
      IF Y >= 0.0 THEN
        ATAN2 := Pi / 2.0             (* positive Y axis                     *)
       ELSE
        ATAN2 := - Pi / 2.0           (* negative Y axis                     *)
   ELSE                               (* point on the X axis                 *)
    IF X >= 0.0 THEN
      ATAN2 := 0.0                    (* positive X axis                     *)
     ELSE
      ATAN2 := - Pi                   (* negative X axis                     *)
END;                                  (* ATAN2                               *)

FUNCTION TAN (X : DOUBLE) : DOUBLE;   (* tangent of X                        *)
BEGIN
  TAN := Sin(X) / Cos(X)
END;                                  (* TAN                                 *)

FUNCTION GAUSS (Mean, StdDev : DOUBLE) : DOUBLE; (*  random number   *)
VAR
  I             : BYTE;               (* index for loop                      *)
  T             : DOUBLE;             (* temporary variable                  *)

BEGIN                                 (* Based on the central limit theorem  *)
  T := - 6.0;                         (* maximum deviation is 6 sigma, remove
                                         the mean first                      *)
  FOR I := 1 TO 12 DO
    T := T + Random;                  (* 12 uniform over 0 to 1              *)
  GAUSS := Mean + T * StdDev          (* adjust mean and standard deviation  *)
END;                                  (* GAUSS                               *)

FUNCTION RESIDUE (Radix, Number : DOUBLE) : DOUBLE; (* remainder of
                                         radix/number                        *)

(* uses APL residue definition *)
BEGIN
  RESIDUE := Number - Radix * Floor(Number / Radix)
END;                                  (* RESIDUE                             *)

FUNCTION MINIMUM (A, B : DOUBLE) : DOUBLE; (* the minimum of a and b         *)
BEGIN
  IF A < B THEN
    MINIMUM := A
  ELSE
    MINIMUM := B
END;                                  (* MINIMUM                             *)

FUNCTION MAXIMUM (A, B : DOUBLE) : DOUBLE; (* the maximum of a and b         *)
BEGIN
  IF A < B THEN
    MAXIMUM := B
  ELSE
    MAXIMUM := A
END;                                  (* MAXIMUM                             *)


PROCEDURE Cmult(C, D : Complex;
                   VAR Result : Complex); (* multiply two complex numbers    *)
BEGIN
  Result.Re := C.Re * D.Re - C.Im * D.Im; (* real part                       *)
  Result.Im := C.Re * D.Im + C.Im * D.Re; (* imaginary part                  *)
END;

PROCEDURE Cadd(C, D : Complex;
                   VAR Result : Complex); (* add two complex numbers         *)
BEGIN
  Result.Re := C.Re + D.Re;           (* real part                           *)
  Result.Im := C.Im + D.Im;           (* imaginary part                      *)
END;

PROCEDURE Csub(C, D : Complex;
                   VAR Result : Complex); (* subtract D from C complex number
                                                                             *)
BEGIN
  Result.Re := C.Re - D.Re;           (* real part                           *)
  Result.Im := C.Im - D.Im;           (* imaginary part                      *)
END;

FUNCTION Cmag (C : Complex) : DOUBLE; (* magnitude of a complex number       *)
BEGIN
  Cmag := Sqrt(Sqr(C.Re) + Sqr(C.Im));
END;

PROCEDURE Cmake(A, B : DOUBLE;
                   VAR Result : Complex); (* form a complex number           *)
BEGIN
  Result.Re := A;
  Result.Im := B;
END;

PROCEDURE Cconj(A : Complex;
                   VAR Result : Complex); (* complex conjugate               *)
BEGIN
  Result.Re := A.Re;
  Result.Im := - A.Im;
END;

PROCEDURE Cexp(A : Complex;
                   VAR Result : Complex); (* exponential of a complex number *)
VAR
  Magnitude     : DOUBLE;

BEGIN                               (* exp(real+j imag)=exp(real)exp(j imag) *)
  Magnitude := Exp(A.Re);
  Result.Re := Magnitude * Cos(A.Im); (* Eulers equation                     *)
  Result.Im := Magnitude * Sin(A.Im);
END;

PROCEDURE Csqr(A : Complex;
                   VAR Result : Complex); (* square of a complex number      *)
BEGIN                                 (* sqr(real + j imag)                  *)
  Result.Re := Sqr(A.Re) - Sqr(A.Im);
  Result.Im := 2.0 * A.Re * A.Im;
END;

PROCEDURE Csqrt(A : Complex;
                   VAR Result : Complex); (* sqrt of a complex number        *)
VAR
  Magnitude, Phase : DOUBLE;          (* A to be written as mag*exp(j phase) *)

BEGIN                                 (* solve sqrt(mag)*exp(j .5*phase      *)
  Phase := 0.5 * Atan2(A.Re, A.Im);
  Magnitude := Sqrt(Sqrt(Sqr(A.Re) + Sqr(A.Im)));
  Result.Re := Magnitude * Cos(Phase); (* Eulers equation                    *)
  Result.Im := Magnitude * Sin(Phase);
END;

PROCEDURE Cln(A : Complex;
                   VAR Result : Complex); (* natural log of complex A        *)
BEGIN                                 (* A to be written as mag*exp(j phase) *)
  Result.Re := 0.5 * Ln(Sqr(A.Re) + Sqr(A.Im));
  Result.Im := Atan2(A.Re, A.Im);
END;

PROCEDURE CpwrXY(X, Y : Complex;
                   VAR Result : Complex); (* raise X to the Y power          *)
VAR
  Temp          : Complex;

BEGIN
  IF (X.Re = 0.0) AND (X.Im = 0.0) THEN (* avoid taking log of 0             *)
    BEGIN
      Result.Re := 0.0;
      Result.Im := 0.0;
    END
  ELSE
    BEGIN
      Cln(X,Temp);
      Cmult(Y,Temp,Temp);
      Cexp(Temp,Result);
    END
END;



PROCEDURE Csinh(A : Complex;
                   VAR Result : Complex); (* hyperbolic sine of complex A    *)
BEGIN
  Result.Re := Cos(A.Im) * Sinh(A.Re);
  Result.Im := Sin(A.Im) * Cosh(A.Re);
END;

PROCEDURE Ccosh(A : Complex;
                   VAR Result : Complex); (* hyperbolic cosine of complex A  *)
BEGIN
  Result.Re := Cos(A.Im) * Cosh(A.Re);
  Result.Im := Sin(A.Im) * Sinh(A.Re);
END;

PROCEDURE Ctanh(A : Complex;
                   VAR Result : Complex); (* hyperbolic tangent of complex A *)
VAR
  Denom         : DOUBLE;

BEGIN
  Denom := Cos(2.0 * A.Im) + Cosh(2.0 * A.Re);
  Result.Re := Sinh(2.0 * A.Re) / Denom;
  Result.Im := Sin(2.0 * A.Im) / Denom;
END;

PROCEDURE Csin(A : Complex;
                   VAR Result : Complex); (* sine of complex A               *)
BEGIN
  Result.Re := Sin(A.Re) * Cosh(A.Im);
  Result.Im := Cos(A.Re) * Sinh(A.Im);
END;

PROCEDURE Ccos(A : Complex;
                   VAR Result : Complex); (* cosine of complex A             *)
BEGIN
  Result.Re := Cos(A.Re) * Cosh(A.Im);
  Result.Im := - Sin(A.Re) * Sinh(A.Im);
END;

PROCEDURE Ctan(A : Complex;
                   VAR Result : Complex); (* tangent of complex A            *)
VAR
  Denom         : DOUBLE;

BEGIN
  Denom := Cos(2.0 * A.Re) + Cosh(2.0 * A.Im);
  Result.Re := Sin(2.0 * A.Re) / Denom;
  Result.Im := Sinh(2.0 * A.Im) / Denom;
END;

PROCEDURE Cinv(A : Complex;
                   VAR Result : Complex); (* complex inverse                 *)
VAR
  Scalar        : DOUBLE;

BEGIN
  Scalar := Sqr(A.Re) + Sqr(A.Im);
  Result.Re := A.Re / Scalar;
  Result.Im := - A.Im / Scalar;
END;

PROCEDURE Cdiv(Num, Denom : Complex;
                   VAR Result : Complex); (* complex division   *)

(* returns Num/Denom *)
VAR
  Scalar        : DOUBLE;

BEGIN

 (****************************************************************************)
 (* try to avoid overflow by normalizing the denominator                     *)
 (****************************************************************************)
  IF (Abs(Denom.Re) > Abs(Denom.Im)) THEN
    BEGIN
      Scalar := Denom.Re;
      Denom.Im := - Denom.Im / Scalar;
(*    Denom.Re := 1.0;  is implied *)
      Scalar := (Sqr(Denom.Im) + 1.0) * Scalar;
      Result.Re := (Num.Re - Num.Im * Denom.Im) / Scalar;
      Result.Im := (Num.Re * Denom.Im + Num.Im) / Scalar;
    END
  ELSE
    BEGIN
      Scalar := Denom.Im;
      Denom.Re := Denom.Re / Scalar;
(*    Denom.Im := -1.0;  is implied *)
      Scalar := (Sqr(Denom.Re) + 1.0) * Scalar;
      Result.Re := (Num.Re * Denom.Re + Num.Im) / Scalar;
      Result.Im := (Num.Im * Denom.Re - Num.Re) / Scalar;
    END;
END;

PROCEDURE Carcsin(A : Complex;
                   VAR Result : Complex); (* inverse sine of complex A       *)
VAR
  Temp          : Complex;

BEGIN
  Csqr(A, Temp);
  Csub(Cone, Temp, Temp);
  Csqrt(Temp, Temp);
  Cmult(Ci, A, A);
  Csub(Temp, A, Temp);
  Cln(Temp, Temp);
  Cmult(Ci, Temp, Result)
END;

PROCEDURE Carccos(A : Complex;
                   VAR Result : Complex); (* inverse cosine of complex A     *)
VAR
  Temp          : Complex;

BEGIN
  Csqr(A, Temp);
  Csub(Temp, Cone, Temp);
  Csqrt(Temp, Temp);
  Csub(A, Temp, Temp);
  Cln(Temp, Temp);
  Cmult(Ci, Temp, Result)
END;

PROCEDURE Carctan(A : Complex;
                   VAR Result : Complex); (* inverse tangent of complex A    *)
VAR
  Temp          : DOUBLE;

BEGIN
  Temp := Sqr(A.Re);
  Result.Re := 0.5 * Atan2((1.0 - Temp - Sqr(A.Im)),2.0 * A.Re);
  Result.Im := 0.25 * Ln((Sqr(1.0 + A.Im) + Temp) / (Sqr(1.0 - A.Im) + Temp));
END;

PROCEDURE PolyClear(VAR Ptr : PolyPtr); (* remove a polynomial               *)
VAR
  Tempptr       : PolyPtr;

BEGIN
  WHILE Ptr <> NIL DO                 (* for all polynomial coefficients     *)
    BEGIN
      Tempptr := Ptr^.Link;           (* store link to the next coefficient  *)
      Dispose(Ptr);                   (* free memory at current coefficient  *)
      Ptr := Tempptr;                 (* go to next coefficient              *)
    END;
END;

PROCEDURE PolyNext(VAR Ptr : PolyPtr); (* new linked list element            *)
BEGIN
  New(Ptr);                           (* get memory space for a coefficient  *)
  Ptr^.Coeff := Czero;                (* set the coefficient to zero         *)
  Ptr^.Link := NIL;                   (* next element in the list is
                                         nonexistant                         *)
END;

FUNCTION PolyOrder (Z : PolyPtr) : BYTE; (* order of a polynomial            *)
VAR
  OrderCtr      : BYTE;               (* maximum order is 255                *)

BEGIN
  OrderCtr := 0;                      (* return 0 for polynomial with one
                                         element                             *)
  WHILE Z^.Link <> NIL DO             (* last element in list ?              *)
    BEGIN
      Inc(OrderCtr);                  (* count number of times through loop  *)
      Z := Z^.Link;                   (* go to next coefficient              *)
    END;
  PolyOrder := OrderCtr;
END;

PROCEDURE PolyNew(N : BYTE;           (* create a zero polynomial of length N>*)
                   VAR Z : PolyPtr);  (* ** Z must be an existing polynomial **)
VAR
  I             : BYTE;               (* maximum order is 255                *)
  Ztemp         : PolyPtr;            (* to move through coefficient list    *)

BEGIN
  PolyClear(Z);                       (* free existing polynomial location   *)
  PolyNext(Z);                        (* get zeroth coefficient              *)
  Ztemp := Z;                         (* Z stays at first element of list    *)
  FOR I := 1 TO N DO                  (* add other coefficients to the list  *)
    BEGIN
      PolyNext(Ztemp^.Link);
      Ztemp := Ztemp^.Link;
    END;
END;

PROCEDURE PolyAssign(X : PolyPtr;     (* generate new polynomial at Y with   *)
                   VAR Y : PolyPtr);  (* same coefficients as poly at X      *)
VAR
  I             : BYTE;               (* length of polynomial X              *)
  Ytemp, YtStart : PolyPtr;           (* to move through the list            *)
  (* maximum order is 255                                                    *)

BEGIN
  IF X <> NIL THEN
    BEGIN
      I := PolyOrder(X);              (* order of X                          *)
      Ytemp := NIL;                   (* initialize Ytemp                    *)
      PolyNew(I, Ytemp);              (* get new poly of same order          *)
      YtStart := Ytemp;               (* remember first element of list      *)
      WHILE X <> NIL DO               (* go through X                        *)
        BEGIN
          Ytemp^.Coeff := X^.Coeff;   (* assign X coef to Y coef             *)
          Ytemp := Ytemp^.Link;       (* locate next element of Y            *)
          X := X^.Link;               (* locate next element of X            *)
        END;
      PolyClear(Y);                   (* in case PolyAssign(P1,P1)           *)
      Y := YtStart;
    END
  ELSE PolyClear(Y);
END;

PROCEDURE Root_Poly(Root : Complex;   (* form polynomial S-Root              *)
                   VAR Result : PolyPtr);
VAR
  ResultTemp    : PolyPtr;            (* to move through two element list    *)

BEGIN
  PolyNew(1, Result);                 (* generate two element list           *)
  ResultTemp := Result;               (* keep Result at 1st element of list  *)
  ResultTemp^.Coeff.Im := - Root.Im;  (* zeroth coefficient                  *)
  ResultTemp^.Coeff.Re := - Root.Re;
  ResultTemp := ResultTemp^.Link;     (* move to S*1 coefficient             *)
  ResultTemp^.Coeff := Cone;          (* set it equal to 1 + j0              *)
END;

PROCEDURE PolyMult(Xx, Yy : PolyPtr;
                   VAR Z : PolyPtr);
VAR
  X, Y, Ypt, Zpt, Zptsave : PolyPtr;
  Result        : Complex;
  I             : BYTE;               (* maximum order is 255                *)

BEGIN
  X := NIL;                           (* don't give PolyAssign trash         *)
  Y := NIL;                           (* don't give PolyAssign trash         *)
  PolyAssign(Xx, X);                  (* copy Xx, in case PolyMult(A,A,A)    *)
  PolyAssign(Yy, Y);                  (* copy Yy, in case PolyMult(A,A,A)    *)
  I := PolyOrder(X) + PolyOrder(Y);   (* resultant polynomial order          *)
  PolyClear(Z);                       (* release existing Z                  *)
  PolyNew(I, Z);                      (* make a list of length I             *)
  Zptsave := Z;                       (* keep Z at start of the list         *)
  WHILE X <> NIL DO                   (* for each element of x               *)
    BEGIN
      Zpt := Zptsave;                 (* remember start of list 2nd loop     *)
      Ypt := Y;                       (* remember start of list 2nd loop     *)
      WHILE Ypt <> NIL DO             (* 2nd loop goes over elements of Y    *)
        BEGIN                         (* scale Y polynomial by X coeff       *)
          Cmult(X^.Coeff, Ypt^.Coeff, Result);
          Cadd(Result, Zpt^.Coeff, Zpt^.Coeff);
          Ypt := Ypt^.Link;           (* next element in Y                   *)
          Zpt := Zpt^.Link;           (* next element in Z                   *)
        END;
      Zptsave := Zptsave^.Link;       (* begin at next higher element in Z   *)
      X := X^.Link;                   (* by multiplying by next X element    *)
    END;
  PolyClear(X);                       (* release X storage                   *)
  PolyClear(Y);                       (* release Y storage                   *)
END;

PROCEDURE PolyForm(A : RootStack;     (* form a polynomial B from the
                                                        roots of rootstack A *)
                   VAR B : PolyPtr);
VAR
  Tply          : PolyPtr;             (* will hold the 1st order polynomial *)
  DupRoots      : RootStack;           (* get a duplicate rootStack *)
  Troot         : Complex;

BEGIN
  PolyClear(B);                        (* erase B *)
  IF A <> NIL THEN
  BEGIN
   DupRoots := NIL;                    (* initialize DupRoots *)
   RootCopy(A,DupRoots);               (* don't destroy the contents of A *)
   RootPop(DupRoots,Troot);            (* get first root *)
   Root_Poly(Troot,B);                 (* form 1st order poly *)
   Tply := NIL;                        (* initialize Tply *)
   WHILE DupRoots <> NIL DO            (* for other each root *)
         BEGIN
         RootPop(DupRoots,Troot);
         Root_Poly(Troot,Tply);       (* form 1st order poly *)
         PolyMult(Tply,B,B);               (* multiply by current B *)
         END;
   PolyClear(Tply);                        (* free temporary polynomial *)
   RootClear(DupRoots);                    (* free temporary rootlist *)
  END;
END;

PROCEDURE PolyPrint(X : PolyPtr);
BEGIN
  WHILE X <> NIL DO
    BEGIN
      Writeln(X^.Coeff.Re, X^.Coeff.Im);
      X := X^.Link;
    END;
END;

PROCEDURE PolyPower(I : BYTE;           (* raise a polynomial X to power I *)
                   X  : PolyPtr;
                   VAR Y : PolyPtr);    (* assign to polynomial Y *)
VAR
  N             : BYTE;
  Xtemp         : PolyPtr;

BEGIN
  IF I = 0 THEN                         (* expression to the 0 power is 1 *)
    BEGIN
      PolyClear(Y);
      PolyNext(Y);
      Y^.Coeff.Re := 1.0;
    END
  ELSE                                  (* not 0 power *)
    BEGIN
      Xtemp := NIL;                     (* initialize Xtemp *)
      PolyAssign(X, Xtemp);             (* in case called PolyPwr(3,A,A) *)
      PolyAssign(Xtemp, Y);             (* first power *)
      N := 1;
      WHILE N < I DO                    (* continuing powers *)
        BEGIN
          PolyMult(Xtemp, Y, Y);        (* multiply by X *)
          INC(N);                       (* current power *)
        END;                          (* WHILE                               *)
      PolyClear(Xtemp);
    END                               (* IF                                  *)
END;

PROCEDURE PolyEval(X : PolyPtr;       (* evaluate polynomial X in S          *)
                   S : Complex;       (* at complex value S                  *)
                   VAR Result : Complex); (* assign to Result                *)
VAR
  Tempr, Temps  : Complex;

BEGIN
  Temps := S;                         (* in generating powers of S           *)
  IF X <> NIL THEN                    (* any coefficients in X               *)
    BEGIN
      Result := X^.Coeff;             (* add the constant of the polynomial  *)
      X := X^.Link;                   (* go to S*1 coefficient               *)
      WHILE X <> NIL DO               (* continue for each coefficient       *)
        BEGIN
          Cmult(X^.Coeff, Temps, Tempr); (* multiply by S*n                  *)
          Cadd(Result, Tempr, Result); (* add to running sum                 *)
          Cmult(S, Temps, Temps);     (* form S*(n+1)                        *)
          X := X^.Link;               (* next order                          *)
        END;                          (* while                               *)
    END;
END;

PROCEDURE PolyAdd(X, Y : PolyPtr;     (* add polynomials X and Y             *)
                   VAR Z : PolyPtr);  (* assign to polynomial Z              *)
VAR
  Xtemp, Ytemp, Tptr1, Tptr2, Tptr3 : PolyPtr;

BEGIN
  Xtemp := NIL;                       (* Initialize undefined polynomials    *)
  Ytemp := NIL;
  PolyAssign(X, Xtemp);               (* temporary working polynomials       *)
  PolyAssign(Y, Ytemp);
  PolyClear(Z);                       (* in case of PolyAdd(P1,P2,P2)        *)
  IF PolyOrder(Xtemp) > PolyOrder(Ytemp) THEN (* want to add the smaller to
                                         larger                              *)
    BEGIN                             (* Z will be same order of the larger  *)
      Tptr1 := Xtemp;
      Tptr2 := Ytemp;
    END
  ELSE
    BEGIN
      Tptr1 := Ytemp;
      Tptr2 := Xtemp;
    END;
  PolyAssign(Tptr1, Z);               (* Z is 0 + the larger                 *)
  Tptr3 := Z;                         (* keep Z at start of polynomial       *)
  WHILE Tptr2 <> NIL DO               (* for each coeff of the smaller       *)
    BEGIN
      Cadd(Tptr3^.Coeff, Tptr2^.Coeff, Tptr3^.Coeff); (* Z + smaller         *)
      Tptr3 := Tptr3^.Link;           (* next Z coef                         *)
      Tptr2 := Tptr2^.Link;           (* next smaller coef                   *)
    END;
  PolyClear(Xtemp);                   (* free Xtemp and Ytemp storage        *)
  PolyClear(Ytemp);
END;

PROCEDURE PolyNegate(X : PolyPtr);    (* change poly in S to poly in -S      *)
VAR
  Temp          : Complex;            (* to be 1+j0 or -1+j0                 *)

BEGIN
  Temp := Cone;                       (* initially 1+j0                      *)
  WHILE X <> NIL DO                   (* for each coefficient                *)
    BEGIN
      Cmult(X^.Coeff, Temp, X^.Coeff); (* multiply by 1 or -1                *)
      Temp.Re := - Temp.Re;           (* change 1 to -1 or -1 to 1           *)
      X := X^.Link;                   (* next coefficient                    *)
    END;
END;

PROCEDURE PolyScale(X : PolyPtr;      (* multiply polynomial X by            *)
                   Scalar : Complex); (* complex number Scalar               *)
BEGIN
  WHILE X <> NIL DO                   (* go through each element of X        *)
    BEGIN
      Cmult(Scalar, X^.Coeff, X^.Coeff); (* scale the coefficient            *)
      X := X^.Link;                   (* locate next element of X            *)
    END;
END;

PROCEDURE PolyUnary(X : PolyPtr);     (* make the polynomial X unary         *)
(* i.e. the leading coef = 1                                                 *)
VAR
  Xtemp         : PolyPtr;
  Scalar        : Complex;

BEGIN
  Xtemp := X;                         (* remember the start of the list      *)
  WHILE X <> NIL DO                   (* go through each element of X        *)
    BEGIN                             (* to locate last element              *)
      Scalar := X^.Coeff;             (* looking for the last coefficient    *)
      X := X^.Link;                   (* locate next element of X            *)
    END;                              (* while                               *)
  Cinv(Scalar, Scalar);               (* inverse of last element of X        *)
  PolyScale(Xtemp, Scalar);           (* will make last element = 1.0        *)
END;

PROCEDURE PolyDivide(Num, Denom : PolyPtr; (* Synthetic division *)
                     VAR Quotient, Remainder: PolyPtr);
VAR
  TempN, TempD, TempQ, TempR : PolyPtr;
  OrderNum, OrderDenom, OrderQuo  : BYTE;
  LeadingCoef, LeadingCoefD : Complex;
BEGIN
  OrderNum := PolyOrder(Num);
  OrderDenom := PolyOrder(Denom);
  IF OrderNum > OrderDenom THEN
    BEGIN
      TempN := NIL;                   (* initialize temporary numerator     *)
      TempD := NIL;                   (* initialize temporary denominator   *)
      PolyAssign(Num,TempN);          (* in case PolyDivide(A,B,A,B)        *)
      PolyAssign(Denom,TempD);        (* in case PolyDivide(A,B,A,B)        *)
      WHILE TempN <> NIL DO           (* find the leading coef of the num   *)
        BEGIN
          LeadingCoef := TempN^.Coeff;
          TempN       := TempN^.Link;
        END;
      WHILE TempD <> NIL DO           (* find the leading coef of the denom *)
        BEGIN
          LeadingCoefD:= TempD^.Coeff;
          TempD       := TempD^.Link;
        END;
      Cdiv(LeadingCoef,LeadingCoefD,LeadingCoef);  (* quotient leading coef *)
      TempQ := NIL;                   (* initialize temporary quotient      *)
      PolyClear(Quotient);
      PolyNew((OrderNum-OrderDenom),Quotient);
      TempR := NIL;                   (* initialize temporary remainder     *)

      PolyClear(Quotient);
      PolyClear(Remainder);







    END
  ELSE  (* denominator cannot divide into numerator *)
    BEGIN
      PolyAssign(Num,Remainder);
      PolyClear(Quotient);
    END;
END;

PROCEDURE RootPush(R : Complex;       (* add root R to a rootstack L         *)
                   VAR L : RootStack);
VAR
  NewSpace : RootStack;
BEGIN
  New(NewSpace);                      (* get memory space for new root       *)
  NewSpace^.Coeff := R;               (* set the coefficient to R            *)
  NewSpace^.Link  := L;               (* next element in the list is L       *)
  L               := NewSpace;        (* new top of stack                    *)
END;

PROCEDURE RootPop(VAR L : RootStack;      (* get root from a rootstack L *)
                  VAR R : Complex);
VAR
  Ltemp : RootStack;
BEGIN
  IF L <> NIL THEN
    BEGIN
      R := L^.Coeff;                  (* assign R from first stack element   *)
      Ltemp := L;                     (* remember top stack element location *)
      L := L^.Link;                   (* move L to second member of stack    *)
      Dispose(Ltemp);                 (* free memory at old top of stack     *)
    END;
END;

PROCEDURE RootClear(VAR L : RootStack);   (* clear a rootstack L             *)
VAR
  Dummy : Complex;
BEGIN
  WHILE L <> NIL DO RootPop(L,Dummy); (* pop until empty                     *)
END;

PROCEDURE RootRotate(N : BYTE;VAR L : RootStack);(* rotate rootstack L by N  *)
                                            (* so that last moves toward 1st *)
VAR
  MarkTop, Temp  : RootStack;
  Count : Byte;
BEGIN
  IF (L <> NIL) AND (N <> 0) THEN
    BEGIN                                   (* make the stack a ring *)
      MarkTop := L;                         (* link to top of L *)
      While L <> NIL DO                     (* search to the end of the list *)
        Begin
          Temp := L;                        (* Previous element *)
          L    := L^.Link;
        END;
      Temp^.Link := MarkTop;           (* wrap the last element to the first *)
      Temp := MarkTop;                 (* move temp back to top of the list  *)

(* in the following we locate the bottom of the list which is currently      *)
(* linked to the first element of the list.  Set the link at the bottom to   *)
(* NIL, and its link (being the top) to L                                    *)

      FOR Count := 1 to N DO           (* will locate bottom of list *)
          Temp := Temp^.Link;
      L := Temp^.Link;                 (* pointer to the top of list *)
      Temp^.Link := NIL;               (* split the ring *)
    END;
END;

PROCEDURE RootCopy(S : RootStack;     (* copy a rootstack from S to D        *)
                   VAR D: RootStack);
VAR
  Dtemp, DtempPrev : RootStack;
BEGIN
  If S <> D THEN                        (* if = then exit *)
  BEGIN
    IF D <> NIL THEN RootClear(D);      (* clear existing stack *)
    IF S <> NIL THEN
    BEGIN
      New(Dtemp);                       (* first element *)
      D := Dtemp;                       (* is at top of new stack *)
      D^.Coeff := S^.Coeff;             (* copy the first root *)
      D^.Link  := NIL;                  (* don't know if another element *)
      S := S^.Link;                     (* move to second coeff *)
      While S <> NIL DO
        BEGIN
        writeln('rootcopy');
        DtempPrev := Dtemp;
        New(Dtemp);
        Dtemp^.Coeff := S^.Coeff;       (* copy the root *)
        DtempPrev^.Link := Dtemp;       (* tie to previous stack element *)
        Dtemp^.Link := NIL;
        S := S^.Link;
        END; (* while *)
    END; (* if *)
  END;   (* if *)
END; (* RootCopy *)

BEGIN
  Randomize;
  Ln10 := Ln(10.0)
END; 