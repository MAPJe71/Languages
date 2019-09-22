#define  MEM_DATA   __EPAGE
#define  MEM_CODE   __FPAGE

#define  FUNC(Type,Module)   __FPAGE Type

#define    VAR(Type,Module)   Type
#define  CONST(Type,Module)   Type  const

#define       P2VAR(Type,ModuleDat,ModulePtr)   Type  *
#define  CONSTP2VAR(Type,ModuleDat,ModulePtr)   Type  * const

#define       P2CONST(Type,ModuleDat,ModulePtr)   Type  const *
#define  CONSTP2CONST(Type,ModuleDat,ModulePtr)   Type  const * const

typedef  unsigned char   uint8;
typedef  unsigned short  uint16;

typedef  enum
{
  BELOW = -1,

  ABC ,  //...
  MNO ,  //...
  XYZ ,  //...

  ABOVE
}
eIdent;



/****************************************************************************/
/*BUG*/
main()
{
  return 0;
}



/****************************************************************************/
/*OK*/
__FPAGE  void  fct000 (  void  )
{
}

/****************************************************************************/
/*BUG*/
FUNC( void , MEM_CODE )  fct001 (  void  )
{
}

/****************************************************************************/
/*BUG*/
__FPAGE  void  fct010 (  void  )   /*...*/
{
}

/****************************************************************************/
/*BUG*/
__FPAGE  void  fct011 /*...*/ (  void  )
{
}

/****************************************************************************/
/*BUG*/
__FPAGE  void /*...*/  fct012 (  void  )
{
}

/****************************************************************************/
/*BUG*/
__FPAGE /*...*/  void  fct013 (  void  )
{
}

/****************************************************************************/
/*BUG*/
/*...*/ __FPAGE  void  fct014 (  void  )
{
}



/****************************************************************************/
/*OK*/
__FPAGE  uint8  fct100 (  eIdent  const  idReq  )
{
  uint8  isValid = 0u;

  if( (  idReq > BELOW  ) && (  idReq < ABOVE  ) )
  {
    isValid++;
  }

  return(  isValid  );
}

/****************************************************************************/
/*BUG*/
FUNC( uint8 , MEM_CODE )  fct101 (  CONST( eIdent , MEM_DATA )  idReq  )
{
  VAR( uint8 , MEM_DATA )  isValid = 0u;

  if( (  idReq > BELOW  ) && (  idReq < ABOVE  ) )
  {
    isValid++;
  }

  return(  isValid  );
}



/****************************************************************************/
/*OK*/
__FPAGE  void  fct200 (  uint8  pbDest[] ,  uint8  const  pbSrc[] ,  uint16  const  nb  )
{
  uint16  ix = 0u;

  if( (  pbDest != (uint8*)0  ) && (  pbSrc != (uint8*)0  ) )
  {
    for(  ;  ix < nb ;  ix++  )
    {
      pbDest[ix] = pbSrc[ix];
    }
  }
}

/****************************************************************************/
/*BUG*/
FUNC( void , MEM_CODE )  fct201 (  VAR( uint8 , MEM_DATA )  pbDest[] ,  CONST( uint8 , MEM_DATA )  pbSrc[] ,  CONST( uint16 , MEM_DATA )  nb  )
{
  VAR( uint16 , MEM_DATA )  ix = 0u;

  if( (  pbDest != (uint8*)0  ) && (  pbSrc != (uint8*)0  ) )
  {
    for(  ;  ix < nb ;  ix++  )
    {
      pbDest[ix] = pbSrc[ix];
    }
  }
}



/****************************************************************************/
/*OK*/
__FPAGE  uint16  fct300 (  uint8  const * const  pSrc1st ,  uint8  const * const  pSrc2nd ,  uint16  const  nb  )
{
  uint16  ix = 0u;
  uint16  ixMax = nb;

  if( (  pSrc1st != (uint8*)0  ) && (  pSrc2nd != (uint8*)0  ) )
  {
    while(  ix < ixMax  )
    {
      if(  pSrc1st[ix] != pSrc2nd[ix]  )
      {
        ixMax = ix;
      }

      ix++;
    }
  }

  return(  ixMax  );
}

/****************************************************************************/
/*BUG*/
FUNC( uint16 , MEM_CODE )  fct301 (  CONSTP2CONST( uint8 , MEM_DATA , MEM_DATA )  pSrc1st ,  CONSTP2CONST( uint8 , MEM_DATA , MEM_DATA )  pSrc2nd ,  CONST( uint16 , MEM_DATA )  nb  )
{
  VAR( uint16 , MEM_DATA )  ix = 0u;
  VAR( uint16 , MEM_DATA )  ixMax = nb;

  if( (  pSrc1st != (uint8*)0  ) && (  pSrc2nd != (uint8*)0  ) )
  {
    while(  ix < ixMax  )
    {
      if(  pSrc1st[ix] != pSrc2nd[ix]  )
      {
        ixMax = ix;
      }

      ix++;
    }
  }

  return(  ixMax  );
}
