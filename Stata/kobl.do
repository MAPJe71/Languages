set memory 30000
use grunddat
tab kommune
qui recode kommune min/438 440 442/446 448/460 462/470 472/482 484 486/490 492/496 498/max =999
tab kommune

generate dborn = mdy(fmnd,fdag,faar)
drop age-faar
generate dcivst = mdy(civstmnd,civstdag,civstaar)
generate dox = mdy(statmnd,statdag,stataar)
label data "person data til frakturstudie"
sort lbnr
save tempgrund,replace


use ..\keyfile,clear
sort lbnr
save keyfile,replace

merge id using tempgrund
