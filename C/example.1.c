/******************************************************************************
  MODULE: Statistics.c
  
  PURPOSE: Module providing classes for statistics over single and double variable
   Invalid results are returned with NAN value (defined in DEF.H)
******************************************************************************/

#include <float.h>
#include <math.h>
#include <Def.h>

#include "Statistics.h"

#if S_INNER==0
#define MINI FLT_MIN;         // If SInner is float
#define MAXI FLT_MAX;
#elif S_INNER==1 
#define MINI DBL_MIN;         // If SInner is double
#define MAXI DBL_MAX;
#else
#error Unknown type for internal computations (S_INNER macro)
#endif

#if S_INNER<S_INOUT
#pragma message( "S_INNER type smaller than S_INOUT type. Waste of memory !" )
#endif

#define BLA(x,y) (sizeof(x) / \
sizeof(y))

/*****************************************************************************/

void* FuncPointer1(void (*errorCallBack(int, int)),
                   void *(*allocFunc(unsigned int)),
                   void (*freeFunc(void *memblock)),
                   unsigned int initialAllocation) {
int test;
}

void* FuncPointer2(void (*errorCallBack(int, int)),void *(*allocFunc(unsigned int)),void (*freeFunc(void *memblock)),unsigned int initialAllocation) {
int test;
}

void* FuncPointer3(void (*errorCallBack(int, int)),void *(*allocFunc(unsigned int)),void (*freeFunc(void *memblock)),unsigned int initialAllocation) 
{
int test;
}

typedef void  (*FUNCPTR_ERRORCALLBACK(         int, int))
typedef void *(*FUNCPTR_ALLOCFUNC    (unsigned int     ))
typedef void  (*FUNCPTR_FREEFUNC     (void *           ))

void* FuncPointer4(FUNCPTR_ERRORCALLBACK errorCallBack,
                   FUNCPTR_ALLOCFUNC allocFunc,
                   FUNCPTR_FREEFUNC freeFunc,
                   unsigned int initialAllocation) {
int test;
}

void* FuncPointer5( FUNCPTR_ERRORCALLBACK  errorCallBack,
                    FUNCPTR_ALLOCFUNC      allocFunc,
                    FUNCPTR_FREEFUNC       freeFunc,
                    unsigned int           initialAllocation) {
int test;
}

void* FuncPointer6( FUNCPTR_ERRORCALLBACK  errorCallBack
                  , FUNCPTR_ALLOCFUNC      allocFunc
                  , FUNCPTR_FREEFUNC       freeFunc
                  , unsigned int           initialAllocation
                  ) {
int test;
}

void* FuncPointer7(FUNCPTR_ERRORCALLBACK errorCallBack,FUNCPTR_ALLOCFUNC allocFunc,FUNCPTR_FREEFUNC freeFunc,unsigned int initialAllocation) 
{
int test;
}

void* FuncPointer8( FUNCPTR_ERRORCALLBACK errorCallBack, FUNCPTR_ALLOCFUNC allocFunc, FUNCPTR_FREEFUNC freeFunc, unsigned int initialAllocation) {
int test;
}

void StatReset( int  Param1,
                int *Param2,
                bool Param3 ) {
Stat->N=0; Stat->S=0; Stat->S2=0; Stat->Min=MAXI; Stat->Max=-MAXI;
}

void StatAdd( CStat *Stat, const SIO X ) {                // Add a value
if (!IS_NAN(X)) {
Stat->N++; Stat->S+= X; Stat->S2+= X*X;
if (X<Stat->Min) Stat->Min= X;
if (X>Stat->Max) Stat->Max= X;
}   }

void StatAddC( CStat *Stat, const SIO X, const long Coef ) {     // Add a value with a ponderation Coef
if (!IS_NAN(X)) {
Stat->N+=Coef; Stat->S+= X*Coef; Stat->S2+= X*X*Coef;    // Modified : Sxx+=(X*Coef)*(X*Coef) -> Sxx+=X*X*Coef  (11.04.95)
if (X<Stat->Min) Stat->Min= X;
if (X>Stat->Max) Stat->Max= X;
}   }

void StatSub( CStat *Stat, const SIO X ) { 
if (!IS_NAN(X)) { Stat->N--; Stat->S-= X; Stat->S2-= X*X; }
}

SIO StatAvr( const CStat *Stat) { 
return (SIO)( Stat->N>0 ? Stat->S/Stat->N : NAN ); }

SIO StatVariance( const CStat *Stat) {
SInner Avr;
if (Stat->N<=1) return (SIO)NAN;
Avr=Stat->S/Stat->N;
return (SIO)( (Stat->S2 - 2*Avr*Stat->S + Stat->N*Avr*Avr ) / (Stat->N-1) );
}

SIO StatSigma( const CStat *Stat) {
SInner Avr;
if (Stat->N<=0) return (SIO)NAN;
Avr=Stat->S/Stat->N;
return (SIO)sqrt( (Stat->S2 - 2*Avr*Stat->S + Stat->N*Avr*Avr ) / (Stat->N-1) );
}

/*****************************************************************************/

void StatXYReset( CStatXY *Stat) {
Stat->N=0; Stat->Sx=0; Stat->Sy=0; Stat->Sxx=0; Stat->Syy=0; Stat->Sxy=0;
Stat->MinX=MAXI; Stat->MaxX=-MAXI;
Stat->MinY=MAXI; Stat->MaxY=-MAXI;}

void StatXYAdd( CStatXY *Stat, const SIO X, const SIO Y ) {       // Add a couple
if (!IS_NAN(X) and !IS_NAN(Y)) {
Stat->N++; Stat->Sx+=X; Stat->Sy+=Y; Stat->Sxx+=X*X; Stat->Syy+=Y*Y; Stat->Sxy+=X*Y;
if (X<Stat->MinX) { Stat->MinX=X; Stat->YatminX=Y; }
if (X>Stat->MaxX) { Stat->MaxX=X; Stat->YatmaxX=Y; }
if (Y<Stat->MinY) { Stat->MinY=Y; Stat->XatminY=X; }
if (Y>Stat->MaxY) { Stat->MaxY=Y; Stat->XatmaxY=X; }
}   }

void StatXYAddC( CStatXY *Stat, const SIO X, const SIO Y, const long Coef ) {  // Add a couple with a ponderation Coef
if (!IS_NAN(X) and !IS_NAN(Y)) {
Stat->N+=Coef; Stat->Sx+=X*Coef; Stat->Sy+=Y*Coef; 
Stat->Sxx+=X*X*Coef;     // Modified : Sxx+=(X*Coef)*(X*Coef) -> Sxx+=X*X*Coef  (11.04.95)
Stat->Syy+=Y*Y*Coef;     //            Syy+=(Y*Coef)*(Y*Coef) -> Syy+=Y*Y*Coef            
Stat->Sxy+=X*Y*Coef;     //            Sxy+=(X*Coef)*(Y*Coef) -> Sxy+=X*Y*Coef            
if (X<Stat->MinX) { Stat->MinX=X; Stat->YatminX=Y; }
if (X>Stat->MaxX) { Stat->MaxX=X; Stat->YatmaxX=Y; }
if (Y<Stat->MinY) { Stat->MinY=Y; Stat->XatminY=X; }
if (Y>Stat->MaxY) { Stat->MaxY=Y; Stat->XatmaxY=X; }
}   }

void StatXYSub( CStatXY *Stat, const SIO X, const SIO Y ) {
if (!IS_NAN(X) and !IS_NAN(Y)) { Stat->N--; Stat->Sx-=X; Stat->Sy-=Y; Stat->Sxx-=X*X; Stat->Syy-=Y*Y; Stat->Sxy-=X*Y; }
}

/*
SIO test( const CStatXY *Stat) { return (SIO)( Stat->N>0 ? Stat->Sx/Stat->N : NAN); }
*/

SIO StatXYAvrX( const CStatXY *Stat) { return (SIO)( Stat->N>0 ? Stat->Sx/Stat->N : NAN); }

SIO StatXYVarX( const CStatXY *Stat) {
SInner Avr;
if (Stat->N<=1) return (SIO)NAN;
Avr=Stat->Sx/Stat->N;
return (SIO)( (Stat->Sxx - 2*Avr*Stat->Sx + Stat->N*Avr*Avr ) / (Stat->N-1) );}

SIO StatXYSigmaX( const CStatXY *Stat) {
SInner Avr;
if (Stat->N<=1) return (SIO)NAN;
Avr=Stat->Sx/Stat->N;
return (SIO)sqrt( (Stat->Sxx - 2*Avr*Stat->Sx + Stat->N*Avr*Avr ) / (Stat->N-1) );}

SIO StatXYAvrY( const CStatXY *Stat) { return (SIO)( Stat->N>0 ? Stat->Sy/Stat->N : NAN); }

SIO StatXYVarY( const CStatXY *Stat) {
SInner Avr;
if (Stat->N<=1) return (SIO)NAN;
Avr=Stat->Sy/Stat->N;
return (SIO)( (Stat->Syy - 2*Avr*Stat->Sy + Stat->N*Avr*Avr ) / (Stat->N-1) );}

SIO StatXYSigmaY( const CStatXY *Stat) {
SInner Avr;
if (Stat->N<=1) return (SIO)NAN;
Avr=Stat->Sy/Stat->N;
return (SIO)sqrt( (Stat->Syy - 2*Avr*Stat->Sy + Stat->N*Avr*Avr ) / (Stat->N-1) );
}

SIO StatXYAreg( const CStatXY *Stat) {
SInner Delta;
Delta= Stat->N*Stat->Sxx-Stat->Sx*Stat->Sx;
return (SIO)( Delta!=0 ? (Stat->Sxx*Stat->Sy-Stat->Sy*Stat->Sxy) / Delta : NAN );
}

SIO StatXYBreg( const CStatXY *Stat) {
SInner Delta;
Delta= Stat->N*Stat->Sxx-Stat->Sx*Stat->Sx;
return (SIO)( Delta!=0 ? (Stat->N*Stat->Sxy-Stat->Sx*Stat->Sy) / Delta : NAN );
}

SIO StatXYCreg( const CStatXY *Stat) { return (SIO)( Stat->N!=0 ? Stat->Sxy/(Stat->Sx*Stat->Sy*Stat->N) - 1/(Stat->N*Stat->N) : NAN ); }

SIO StatXYEvalY( const CStatXY *Stat, const SIO X) { 
return (SIO)( StatXYAreg(Stat)+X*StatXYBreg(Stat) ); }

SIO StatXYEvalX( const CStatXY *Stat, const SIO Y) { 
return (SIO)( (Y-StatXYAreg(Stat)) / StatXYBreg(Stat) ); }

#undef MINI
#undef MAXI