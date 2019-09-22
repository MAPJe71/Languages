      *
      * This is a sample program used to demonstrate
      * y2k-fix tool by Siber Systems.
      * 
       identification division.
       program-id. y2ksmpl.

       environment division.

       input-output section.
       file-control.
           select tran
           assign to "tran.dat".

       data division.
       file section.
       fd  tran
           record contains 1024 characters.

       01  tran-post.
           03  tran-key                   pic x(10).
           03  tran-data.
               05  tran-trade-date        pic 9(06).
               05  tran-amount            pic 9999V99.

       working-storage section.

       01  w-begin-date                   pic 9(06) value 971231.
       01  w-eow-date                     pic 9(06) value 991231.

       01  i                              pic 9(8) binary.
       01  x                              pic 9999V99.

       procedure division.

      *
      * Generate trade history file
      *
       fill-it-up.
           open output tran.
           move 1.12 to tran-amount.
           move w-begin-date to tran-trade-date.
	   move 1 to i.
           perform 10 times
             move i to tran-key
             write tran-post
             compute i = i + 1 
             compute tran-trade-date = 
                     function rem (tran-trade-date + 10000, 1000000)
             compute tran-amount = tran-amount + 3.62
           end-perform.
           close tran.

      *
      * Read and analyze trade history file
      *
           open input tran.

       read-tran-next.
           read tran next
               at end go to process-tran-x.
           display " "
           display "Tran #" tran-key " Amount=" tran-amount
           if tran-trade-date >= w-eow-date
               display "Traded after  EOW: " tran-trade-date 
                       " at " tran-amount
           end-if
           if tran-trade-date < 020704
               display "Traded before ID2: " tran-trade-date 
                       " at " tran-amount
           end-if
           go to read-tran-next.

       process-tran-x.
           close tran.
