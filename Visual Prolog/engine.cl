/*****************************************************************************

                        Copyright (c) Becerril 2003 Private

******************************************************************************/

class engine : engine
    open core

    predicates
        classInfo : core::classInfo.
        % @short Class information  predicate. 
        % @detail This predicate represents information predicate of this class.
        % @end
    predicates
       
       shellExecute:(core::integer32,string,string,string,string,core::integer32)-> core::integer32 procedure(i,i,i,o,o,i) language apicall.   
       getDesktopWindow:() -> core::integer32 procedure  language apicall.
   predicates
      formating:(string,string) multi.
      myRead:(string) multi.
      parsing:(inputStream) multi.
      read2:(string) multi.
      blueC:(string) nondeterm.
      writeSpaces:(integer,integer) multi.
  
      reserved:(string) determ.
      reserved2:(string) determ.
      reserved3:(string) determ.
 
end class engine