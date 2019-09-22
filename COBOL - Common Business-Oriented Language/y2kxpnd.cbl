      *
      * Y2K windowing routines
      *
       identification division.
       program-id. Y2KXPND.

       data division.
       linkage section.
       01 arg-date pic 9(8).

       procedure division using arg-date.

           if arg-date >= 600101
             compute arg-date = arg-date + 19000000
           else 
             compute arg-date = arg-date + 20000000
           end-if.
