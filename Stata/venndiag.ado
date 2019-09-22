*! Venn Diagram graphs V 2.12 JM.Lauritsen  (STB-xx: gr34.4)
*! v 2.13 correction related to tempfile and _merge variable
*! dec1999 enhanced design (Stata 6 STB54, gr34.3 v2.11) 
*!        (Martin Villumsen sorted out mathematics on ellipses)
*! STB-47/48/49 gr34.2 (stata 5)
program define venndiag
    version 6
    syntax varlist (min=2 max=4) [in] [if] [, C1(int 1) C2(int 1) C3(int 1) /*
    */ C4(int 1) T1title(string) T2title(string) T3title(string) ca(int 1)/*
    */ LAbel(string) MISsing CIRcle Ellipse SQuare xoff(int 6000) yoff(int 22000)/*
    */ NOframe NOLabel SAving(string) PRint SHow(string) Gen(string) NOGraph /*
    */ R1title(string) R2title(string) R3title(string) R4title(string) /*
    */ R5title(string) R6title(string) THick(string) PEN(string)]


if ("`if'" != "" | 	"`in'" != "" ) & "`gen'" != "" {
  di in blue "Check carefully for data errors because of combination of" in yel " if " in wh "or" in yel " in" }
	  
	tokenize `varlist'
	sort `varlist'
	local design ""

  if "`ellipse'" != "" {local design = "e"}
  if "`circle'" != "" {local design = "c"}
  if "`square'" != "" {local design = "s"}

 local varno: word count `varlist'

 if "`design'" == "" {local design = cond(`varno' < 4,"c","e")}

if `ca' != 1 {
        local c1 = `ca'
	local c2 = `ca'
	local c3 = `ca'
	local c4 = `ca'}

if `varno' == 4 & "`design'" == "c" {
         local design = "e"
	 di in yel " With four variables design cannot be " in red "Circle" in wh" (Only square or ellipse)" 
         more }

  if "`label'" == "all" & "`design'" == "s" {local label = "dcimt" }
  if "`design'" != "s" & "`label'" == "" { local label = "t" }
  if "`design'" != "s" & "`show'" == "" { local show = "cptdfl" }                            
  if "`label'" == "" {local label = "dt" }

  global S_7 = "`label'"
  if "`show'" == "" {local show = "cptf" }
  if "`show'" == "all" {local show = "cvtpfn" }

  if "`t1title'" == "" & index("`label'","x") == 0 {local t1title = "Venn Diagram"}
  local do_gen = cond("`gen'" == "",0,1)
  local gen = cond("`gen'" == "","_tmp_vd","`gen'")

  if length("`thick'") < 3 {local thick = "777777777"}
  if length("`thick'") > 9 {local thick = substr("`thick'",1,9)}

  if "`pen'" == "" {local pen = "12345"}
  if length("`pen'") < 3 {local pen = "`pen'" + "123"}

cap drop _tmp_id 
cap drop _tmp_vd

qui gen long _tmp_id = _n

sort _tmp_id 
preserve

confirm new var `gen'
capture confirm new var __merge1
capture confirm new var _merge
if _rc==110 { rename _merge __merge1}


local file = "File: " + "$S_FN" + " (" + substr("$S_FNDATE",1,12) + ")"

* Count number of variables
  parse "`varlist'", parse(" ")
  local varno =0
  while "`1'"~=""  {
     local varno=`varno'+1
     local j = `varno'+11
     global S_`j' = "`1'"
    macro shift
   }


*error if inapropriate arguments:
 vd_exit `varno' "`varlist'"
 if "$S_1" == "fail" {
capture drop _merge
capture confirm new var __merge1
if _rc==110 { rename __merge1 _merge  }
   exit
}

*define count value for S_ globals
local i = 1
while `i' <= `varno' {
   local j = `i'+7
   global  S_`j' = `c`i''
   local i = `i' + 1
   }
  
  qui count
  global S_2 = _result(1)
  
  * apply if and in
  capture keep `if'
  capture keep `in'
  qui count
  local before = _result(1)
  global S_3 = _result(1)

* save memory and gain speed
  
keep `varlist' _tmp_id

tempfile all miss ok 
qui gen str6 `gen' = ""
* now we have a pseudo id variable _tmp_id in the datasets
qui sort _tmp_id 
capture save `all'

*count number of records with missing included in the diagram (when missing option present):
  local nmiss = 0   
  if "`missing'" != "" {
      parse "`varlist'", parse(" ")
      while "`1'"~=""  {
        quietly count if `1' == .
        local nmiss = `nmiss' + _result(1)
        macro shift
      }
   }
  global S_4 = `nmiss'

* drop all missing, including records
   parse "`varlist'", parse(" ")
      while "`1'"~=""  {
        quietly drop if `1' == .
        macro shift
      }

qui sort _tmp_id 
capture save `miss'

*  tab work selfemp,miss nolabel
if "`missing'" != "" {
   capture use `all',clear}
   qui count 
  global S_5 = $S_3 - _result(1)


*present documentation:
   vd_doc "`varlist'" `varno' "`if'"  "`in'"  "`missing'" "`file'" "`gen'" 
tempfile ok
qui sort _tmp_id 
capture save `ok'
* draw graphs 
if "`nograph'" == "" {
  if "`t2title'" == "" & index("`label'","x") == 0 {local t2title = "N = " + "$S_6"}
  if "`saving'" == "" {gph open}
  if "`saving'" != "" {
    local t = "`saving'"
    if index("`saving'",".") > 0 {local  t = substr("`saving'",1,(index("`saving'",".")-1))} 
    gph open,saving("`t'",replace)
    }
  if "$S_grid" == "y" {vd_grid}   /* for testing and lookup: Global S_grid = "y" */  

  local t =   real(substr("`pen'",2,1))

  gph pen `t'
  * draw boxes
  
if "`design'" == "s" {  
       vd_box `varno' `noframe' 
	local t =   real(substr("`pen'",3,1))
	gph pen `t'
	vd_frame `varno' `noframe' 
	}


local t =   real(substr("`pen'",1,1))
gph pen `t'

  * add labels:
  if index("`show'","f") > 0 {
   vd_font 0.48 
   gph text 22000 31500 0 1 `file'
   }

  if index("`show'","d") > 0 {
     local fn = substr("$S_DATE",1,12) 
     vd_font 0.45
     gph text 22000 2000 0 -1 `fn'
     }

  * titles
  if index("`label'","t") > 0 { /*show information of records */
    vd_font 0.82 
    local y = 6000
    if "`design'" != "s" { local y = 1000 }
    gph text 1000 `y' 0 -1  `t1title'
    vd_font 0.65
    local y = 19000
    if "`design'" != "s" { local y = 1000 }
    gph text 2500 `y' 0 -1  `t2title' 
    gph text 3500 `y' 0 -1  `t3title'
    }


     vd_lbl `varno' "`show'" "`nolabel'" "`varlist"' "`all'" "`miss'"



 if index("`label'","x") > 0 {     /*show user specified information */
    local line = cond(`xoff' < 20000,`xoff',20000)
    local yoff = cond(`yoff' < 23000 & `yoff' > 500,`yoff',22000)
    local height = 1000
    vd_font 0.82 
    gph text `line' `yoff' 0 -1  `r1title' 
    vd_font 0.65
    local line = `line' + cond(`line' > 20000,0,int(1.5*`height'))
    gph text `line' `yoff' 0 -1  `r2title' 
    local line = `line' + cond(`line' >20000,0,int(1.5*`height'))
    gph text `line' `yoff' 0 -1  `r3title'
    local line = `line' + cond(`line' >20000,0,int(1.5*`height'))
    gph text `line' `yoff' 0 -1  `r4title' 
    local line = `line' + cond(`line' >20000,0,int(1.5*`height'))
    gph text `line' `yoff' 0 -1  `r5title' 
    local line = `line' + cond(`line' >20000,0,int(1.5*`height'))
    gph text `line' `yoff' 0 -1  `r6title'
  }


  * add variables in boxes:

  if index("`design'","s") > 0 {vd_count "`show'" `varno'}
  else {vd_draw "`show'" `varno' "`design'" "`pen'" }

	  local t =   real(substr("`pen'",1,1))   

if index("`show'","f") > 0 & (index("`show'","p") > 0 | index("`show'","t") > 0) {
         vd_font 0.50
          vd_pen `t'
	  gph text 22000 10000 0 1 % of total
         }


  gph close
  * check for Win95 adn Mac. And print if that option was in call of venndiag:
  if ("$S_OS" == "Windows" | "$S_OS" == "Mac" | "$S_OS" == "MacOS"){   
    if "`saving'" != "" {
        if index("`saving'",".") == 0 {local  saving = "`saving'" + ".wmf"} 
        gphprint ,nologo thickness("`thick'") saving("`saving'",replace)
        }
    if "`print'" != "" {gphprint , nologo thickness(`thick')} 
  }
}

capture use `ok', clear
if `do_gen' == 0 {
  restore
}
else{
  /* add variable to original file */
  keep `gen' _tmp_id
  qui sort _tmp_id
  capture save `all',replace
  restore
  capture drop `gen' 
  merge _tmp_id using `all'
  qui  replace `gen' = "miss" if _merge <2
  qui  replace `gen' = "err." if _merge == 2
  di _newline
  drop _merge

  local vdlbl = "`varlist'" + "(vd)"
  label var `gen' "`vdlbl'"  
  local t = "$S_12" + ":"+ "`c1'" + " "+ "$S_13:" + "`c2'" + " "
  if `varno' > 2 {local t = "`t'" + " " +"$S_14" + ":"+ "`c3'" + "  " }
  if `varno' > 3 {local t = "`t'"+ " " +"$S_15" + ":"+ "`c4'"}
  di  "New variable created. Name: " in green "`gen'" in yel "  Label: " in green  "`vdlbl'"
  di  "notes added: "
  note `gen': generated by venndiag.ado on TS  . Variables and values were:
  note `gen': `t'
  local t = "`if'"+" "+ "`in'"
  if length("`t'") > 0 {
    local t = "`gen'"+"=miss for "+ string(($S_2-$S_3)) + " records excluded by:"+ "`t'"
    note `gen': `t'
    }

  if $S_5 > 0 {
    local t = "`gen'"+"=miss for " + string($S_5) + " records with missing values (.)"
    note `gen': `t'
    }

  if length("`missing'") > 0 & $S_4 > 0 {
      local t = "note that some records ("+ string($S_4) + " variables) had missing values (.)"
    note `gen': "`t'"
    }

  capture compress `gen'
  qui noi note `gen'
}

drop _tmp_id 

local i = 1
while `i' <= 39 {
   global S_`i' 
   local i = `i' + 1
   }

capture confirm new var __merge1
if _rc==110 { rename __merge1 _merge  }
end
* ------------------------------------------------------------------------------
* Some subroutines for various purposes

program define vd_draw
* make output for ellipse or circle 
local show = "`1'"
local varno = `2'
local design = "`3'"
local pen = "`4'"
local zero = 1

local ydev = 2000
local xdev = 1500


* position of marks:
local x1 = 3500
local x2 = 6000
local x3 = 9000
local x4 = 10500
local x5 = 12000
local x6 = 14000
local x7 = 19000
local xab = `x5'
local xa = `x4'
local xv = `x5'

local y1 = 9250
local y2 = 12000
local y2a = 10500
local ypos = 15000
local y4 = 18000
local y4a = 20000
local y5 = 23500


if index("`design'","e") > 0 {
local xpos = 16500
local ydev = 1000
local xdev = 0
local size = 9
local exc  = 0.875
local xv = `x3'-500}
else {
local xpos = 12500
local size = 50
local ydev = 2500
local xdev = 1000
local exc  = 0
local xa = `x6'
}

local xla = 17000
local xlb = 16000
local xlc = 3000

if "`design'" == "e" | `varno' > 2 {local xab = `x6'}

if "`design'" == "e" & `varno' > 2 {
   local x3 = `x3' + 1500
   local x4 = `x4' + 2500
   local xab = `x6' + 2200
   local y2 = `y2' + 1000
   local y4 = `y4' - 1000
   local y2a = cond(`varno' == 3,`y1',7000)

}

vd_font 0.65

if `varno' <= 3 {
ellipse 0.7854 (`ypos'+`ydev') `xpos' `size' `exc' "`pen'" 2
ellipse 2.3562 (`ypos'-`ydev') `xpos' `size' `exc' "`pen'" 3}

if `varno' == 3 {ellipse 1.5708 `ypos' (`xpos'-2.00*`ydev') `size' `exc' "`pen'" 4}

if `varno' == 4 { 
local size = 16
local exc  = 0.795
local xpos = 16500
local ydev = -1000
ellipse 0.75 (`ypos'-`ydev') (`xpos'-`xdev'-500) `size' `exc' "`pen'" 2
ellipse 0.90 (`ypos'-`ydev'+2800) (`xpos'-`xdev'-2500) `size' `exc' "`pen'" 3
ellipse 2.35 (`ypos'-`ydev'-1500) (`xpos'-`xdev'-500) `size' `exc' "`pen'" 4
ellipse 2.20 (`ypos'-`ydev'-4400) (`xpos'-`xdev'-2200) `size' `exc' "`pen'" 5
vd_pen 1
}

local t =   real(substr("`pen'",1,1))
gph pen `t'
vd_font 0.65

if index("`show'","n") == 0 {local zero = 0}

if index("`show'","l") > 0 {
      local varlbl : variable label $S_12   
      if length("`varlbl'") > 0 {gph text `xla' `y1' 0 1 `varlbl' /* label for A*/}
         else{      gph text `xla' `y1' 0 1 $S_12}
      local varlbl : variable label $S_13   
    local yb = cond(`varno' == 3,`y5',`y5'-1000) 
      if length("`varlbl'") > 0 {gph text `xlb' 22000 0 -1 `varlbl'}
         else{      gph text `xlb' `yb' 0 -1 $S_13}
     }    

if index("`show'","t") > 0 {
   	vd_tpct $S_36 `xla' 7500
	vd_tpct $S_37 `xlb' 24000}

if index("`show'","v") > 0 & `varno' < 4 {
       gph text `xv' `y1' 0 0 $S_12
       gph text `xv' `y4a' 0 0 $S_13}


if `varno' == 3 {                 /* add C */

    if index("`show'","v") > 0 {gph text `x1' `ypos' 0 0 $S_14}
    if index("`show'","t") > 0 {vd_tpct $S_38 `xlc' 20000}
    if index("`show'","l") > 0 {
      local varlbl : variable label $S_14   
      if length("`varlbl'") > 0 {gph text `xlc' 18000 0 -1 `varlbl'}
         else{      gph text `xlc' 18000 0 -1 $S_14}
      }      
  }


if `varno' == 4 {                                 /* add C+D */
    if index("`show'","v") > 0 {
       gph text `xv' 7000  0 0 $S_12
       gph text `xv' 23000 0 0 $S_13
       gph text `x1' 18000 0 0 $S_14
       gph text `x1' 11500 0 0 $S_15}

    if index("`show'","t") > 0 {
              vd_tpct $S_38 `xlc' 23000
	      vd_tpct $S_39 2500 8000 }
	      
    if index("`show'","l") > 0 {
      local varlbl : variable label $S_14   
      if length("`varlbl'") > 0 {gph text `xlc' 20000 0 -1 `varlbl'}
         else{      gph text `xlc' 20000 0 -1 $S_14}
      local varlbl : variable label $S_15   
      if length("`varlbl'") > 0 {gph text 4500 9000 0 1 `varlbl'}
        	 else{      gph text 4500 9000 0 1 $S_15}
      }    
 }


/* add counts and percentages */

* non group:
  if index("`show'","x") == 0 & index("`show'","c") > 0 {vd_text `x7' `ypos' 0 $S_20 `zero'}
  if index("`show'","x") == 0 & (index("`show'","t") > 0 | index("`show'","p")) > 0 /*
   */     {vd_tpct $S_20 `x7' `ypos' `zero'}


if `varno' < 4  {
  if index("`show'","c") {vd_text `xab' `ypos' 0 $S_25  `zero'}     /* ab */
  if index("`show'","p") > 0 {vd_pct `xab' `ypos' $S_25 `zero'}
  if index("`show'","c") {vd_text `xa' `y4a' 0 $S_22 `zero'}     /*    b */
  if index("`show'","p") > 0 {vd_pct `xa' `y4a' $S_22 `zero'}
  if index("`show'","c") {vd_text `xa' `y2a' 0 $S_21 `zero'}       /* a */ 
  if index("`show'","p") > 0 {vd_pct `xa' `y2a' $S_21 `zero'}
}



if `varno' == 3 {
  if index("`show'","c") > 0 {vd_text `x4' `ypos' 0 $S_31  `zero'}   /* a b c */
  if index("`show'","p") > 0 {vd_pct `x4' `ypos' $S_31 `zero'}

  if index("`show'","c")  > 0 {vd_text `x2' `ypos' 0 $S_23  `zero'}  /*     c */
  if index("`show'","p") > 0 {vd_pct `x2' `ypos' $S_23 `zero'}

  if index("`show'","c") {vd_text `x3' `y2' 0 $S_26  `zero'}  /* a   c*/
  if index("`show'","p") > 0 {vd_pct `x3' `y2' $S_26 `zero'}
 
  if index("`show'","c")  > 0 {vd_text `x3' `y4' 0 $S_28  `zero'} /*   b c*/
  if index("`show'","p") > 0 {vd_pct `x3' `y4' $S_28 `zero'}
}


if `varno' == 4  {
  if index("`show'","c") {vd_text 16500 15000 0 $S_25  `zero'}     /* ab */
  if index("`show'","p") > 0 {vd_pct 16500 15000 $S_25 `zero'}
  if index("`show'","c") {vd_text 10000 23000 0 $S_22 `zero'}     /*    b */
  if index("`show'","p") > 0 {vd_pct 10000 23000 $S_22 `zero'}
  if index("`show'","c") {vd_text 10000 7000 0 $S_21 `zero'}       /* a */ 
  if index("`show'","p") > 0 {vd_pct 10000 7000 $S_21 `zero'}

  if index("`show'","c")  > 0 {vd_text 4500 19000 0 $S_23  `zero'}  /*     c */
  if index("`show'","p") > 0 {vd_pct 4500 19000 $S_23 `zero'}

  if index("`show'","c")  > 0 {vd_text 4500 11000 0 $S_24  `zero'}  /*     d*/
  if index("`show'","p") > 0 {vd_pct 4500 11000 $S_24 `zero'}

  if index("`show'","c") {vd_text 6500 9750 0 $S_27  `zero'}  /* ad */
  if index("`show'","p") > 0 {vd_pct 6500 9750 $S_27 `zero'}

  if index("`show'","c") {vd_text 13500 10750 0 $S_26  `zero'}  /* a   c*/
  if index("`show'","p") > 0 {vd_pct 13500 10750 $S_26 `zero'}
 
  if index("`show'","c")  > 0 {vd_text 6500 20250 0 $S_28  `zero'} /*   b c*/
  if index("`show'","p") > 0 {vd_pct 6500 20250 $S_28 `zero'}

  if index("`show'","c") {vd_text 13500 19500 0 $S_29  `zero'} /* bd*/
  if index("`show'","p") > 0 {vd_pct 13500 19500 $S_29 `zero'}

  if index("`show'","c") {vd_text 6000 15000 0 $S_30 `zero'}  /* cd*/
  if index("`show'","p") > 0 {vd_pct 6000 15000 $S_30 `zero'}

  vd_font 0.5
  if index("`show'","c") > 0 {vd_text 14500 13100 1 $S_31  `zero'}   /* a b c */
  if index("`show'","p") > 0 {vd_pct 14500 13250 $S_31 `zero'}
  vd_font 0.5
  if index("`show'","c") {vd_text 14500 17250 -1 $S_32 `zero'}   /* abd */
  if index("`show'","p") > 0 {vd_pct 14500 17000 $S_32 `zero'}

  if index("`show'","p") > 0 {vd_pct 9000 11000 $S_33 `zero'}
  if index("`show'","c") {vd_text 9000 11000 0 $S_33 `zero' }   /* acd */

  if index("`show'","p") > 0 {vd_pct 9000 17500 $S_34 `zero'}
  if index("`show'","c") {vd_text 9000 17500 0 $S_34 `zero' }   /* bcd */

  if index("`show'","c") {vd_text 11000 15000 0 $S_35  `zero'}   /* abcd*/
  if index("`show'","p") > 0 {vd_pct 11000 15000 $S_35 `zero'}

}



end


program define vd_pen
gph pen `1'
end

program define vd_lbl
   local varno = `1'
   local label = "$S_7"
   local show  = "`2'"
   local nolabel = "`3'"
   local varlist = "`4'"
   local all = "`5'"
   local miss = "`6'"

   local top   = 8000
   local left  = 18500
   local height = 750
   local line = `top' - 4000
 
  if "`nolabel'" != "" {exit}

 if `varno' < 4 {local line = `line' + 0.5*`height'}

 if index("`label'","d") > 0 {           /*show description*/
    local line = `line' + int(1.5*`height')
    local i = 1
    parse "`varlist'", parse(" ")
    while "`1'"~=""  {
      local varlbl : variable label `1'   
      if "`varlbl'"=="" {local varlbl="`1'"}  
      local t = substr("ABCD",`i',1) + " `varlbl'"
      gph text `line' `left' 0 -1 `t'
       local i = `i' + 1
       local line = `line' + 1.25*`height'     
       mac shift
     }    
  local line = `line' + 1.25*`height'
  }  

  if `varno' < 4 {local line = `line' + 0.5*`height'}

  if index("`label'","c") > 0 {     /*show counting */
    gph text `line' `left' 0 -1 Value indicators:
    local line = `line' + int(1.25*`height')
    local i = 1
    parse "`varlist'", parse(" ")
    while "`1'"~=""  {
        local t = ""
        if `i' == 1  {local t = "A: (" + "`1'" + "=" + string($S_8)+")" }       
        if `i' == 2  {local t = "B: (" + "`1'" + "=" + string($S_9)+")"}        
        if `i' == 3  {local t = "C: (" + "`1'" + "=" + string($S_10)+")"}        
        if `i' == 4  {local t = "D: (" + "`1'" + "=" + string($S_11)+")"}        
       gph text `line' `left' 0 -1 `t'
       local i = `i' + 1
       local line = `line' + 1.25*`height'     
       mac shift
     }
  local line = `line' + `height'
  }

  if `varno' < 4 {local line = `line' + 0.5*`height'}

  if index("`label'","i") > 0 {     /*show information of records */
     local t = " Records in file: " 
     gph text `line' `left' 0 -1 `t'
     local t = string($S_2)
     local j = `left' + 12000
     gph text `line' `j' 0 1 `t'
     local t = " Excluded: Miss " + string($S_5) + " In/if: " + string($S_2-$S_3)
     vd_font 0.5
     if length("`t'") > 35 {vd_font 0.4}
     local line = `line' + `height'
     gph text `line' `left' 0 -1 `t'
     vd_font 0.65 
     local t = string($S_5+$S_2-$S_3)
     gph text `line' `j' 0 1 `t'
     local line = `line' + 1.1*`height'
     gph text `line' `left' 0 -1  Total Records in graph:
     local t = string($S_6)
     gph text `line' `j' 0 1 `t'
   }

  local line = `line' + 1.4*`height'
  if `varno' < 4 {local line = `line' + 0.5*`height'}

  if index("`label'","m") > 0 {/*show missing in variables */
    capture use `all',clear
    vd_font 0.48
    gph text `line' `left' 0 -1 Missing values (Records)
    vd_font 0.45 
    local l1 =  "(EXcluded)"
    if $S_5 == 0  {local l1 =  "(Included)"}
    gph text `line' 31000 0 1 `l1'
    vd_font 0.48
    local line = `line' + int(1.20*`height')
    local left = `left' + 500
    local i = 1
    parse "`varlist'", parse(" ")
    while "`1'"~=""  {
        local t = ""
        quietly count if `1' == .
        local t = substr("ABCD",`i',1) + ":(" + "`1'" + "=" + string(_result(1))+")"
       gph text `line' `left' 0 -1 `t'
       local i = `i' + 1
       local line = `line' + `height'    
       mac shift
     }
  capture use `ok', clear
*    if "`missing'" != "" {capture use `miss',clear}     /*use missing in variables */
  }
  
 vd_font 0.65
end

program define vd_pct
      if `3' == 0 & `4' != 1 {exit}
      local l1 = round(float(100.0*(`3'/$S_6)),1)
      local t = "`l1'" + " %"
      vd_font 0.50
      local y = `1' + 850
      gph text `y' `2' 0 0 `t'
      vd_font 0.65
end

program define vd_text
  * place text on graph
  if `4' == 0 & `5' != 1 {local x = 1 /*dummy*/ }
  else {local t = string(`4')
  gph text `1' `2' 0 `3' `t'}
end

program define vd_font
   * multiply size
     local vds: set textsize   
     local vds = `vds'/100
       local x = int(`vds'*923*(`1'))
       local y = int(`vds'*444*(`1'))
     gph font  `x' `y'
end

program define vd_frame
* draw frame on graph
  local varno `1' 
  local frame `2'
  local leftm = 2500
  if "`frame'" == "" {
   if `varno' == 2 {vd_gphsq 1500 (`leftm'+1000) (`leftm'+16500) 13500}
   if `varno' == 3 {vd_gphsq 1600 (`leftm'-1000) (`leftm'+17000) 15500}
   if `varno' == 4 {vd_gphsq 1600 (`leftm'-1500) (`leftm'+17150) 17350}
   }
end

program define vd_box
* draw boxes on graph
  local varno `1' 
  local frame `2'
  local leftm = 2500

  if `varno' < 4 {
      vd_gphsq 2000 (`leftm'+3500) 12000 6500 
      vd_gphsq 8000 (`leftm'+7000) 12000 7000 
      if `varno' == 3 {
          vd_gphsq 11000 `leftm' 6500 11000}
   }

 if `varno' == 4 {
  local leftm = `leftm' - 1500
  vd_gphsq 2000 (`leftm'+5900) 17250 6800  /* a*/
  vd_gphsq 6600 (`leftm'+9300) 14250 7150 
  vd_gphsq 9500 (`leftm'+300) 7000 15700   /*c*/
  vd_gphsq 6150 (`leftm'+750) 6500 16150 /* d */
   }
end

*draw grid on screen
program define vd_grid
local i = 5050
gph pen 1
while `i' < 20000 {
*   local txt = string(`i')
   local txt = substr(string(`i'),1,2)
   gph text `i' 500 0 -1 `txt'
   gph line  `i' 500  `i' 31500
   local i = `i' + 2000
   }
local i = 7550
while `i' < 25000 {
   local txt = substr(string(`i'),1,2)
   gph text  500 `i' 0 -1 `txt'
   gph line  500 `i' 22000 `i'
   local i = `i' + 2000
   }
end


* draw square on graph 
program define vd_gphsq
  local top = `1'      /* top row  */
  local left = `2'     /* top column */
  local bottom = `1' + `3'     /* rt + height   */
  local right  = `2' + `4'     /* ct+ width     */
  gph line `top' `left' `bottom'  `left'
  gph line `top' `left' `top'  `right'
  gph line `top' `right' `bottom'  `right'
  gph line `bottom' `left' `bottom'  `right'
end

program define vd_exit
local varno   = `1'
local varlist = "`2'"

  parse "`varlist'", parse(" ")
  local string = 0
  local vrs = ""
   while "`1'"~=""  {
     local fmt : format `1'
     if index("`fmt'","s") > 0 {local string = `string' + 1}
     if index("`vrs'","`1'") > 0 {local string = `string' + 1}    /*repeating var*/
     local vrs = "`vrs'" + "`1'"
    macro shift
   }

*error if inapropriate arguments:

 if `string' > 0 {
     di in red _dup(70) "_" _newline
     disp in red "Errors in command, therefore quitting" _newline         
     disp _newline in red "Variables must be numeric and different:" _newline
     d `varlist'
     di in red _dup(70) "_" _newline _newline _newline
     global S_1 = "fail"
 }
end

program define vd_doc
* display basis for diagram in results window
   local varlist = "`1'"
   local varno   = `2'  
   local if      = "`3'"
   local in      = "`4'"
   local missing = "`5'"
   local file    = "`6'"
   local vdvar   = "`7'"

   qui count
   global S_6 = _result(1)
   local after = _result(1)
   local before = $S_3
   local nmiss =  $S_4
   local total = $S_2
   
   di in green _dup(70) "_" _newline
   
   di in yellow "Venn diagram of variables: " in green "`varlist'"
   di in yellow "`file'" _newline
  * and variables: 
  local i = 1
  di in yellow "     Outcome    Variable and label "
  parse "`varlist'", parse(" ")
  local varno =0
  while "`1'"~=""  {
     local varno=`varno'+1
     local var`varno' = "`1'"
     local varlbl`varno' : variable label `1'
     local j = `i' + 7
     if "`varlbl`varno''"=="" {local varlbl`varno'="`1'"}
     * can't get macro substition to work - saving time
     if `i' == 1  {di in yellow substr("ABCD",`i',1) ": " _col(10) $S_8  _col(22) "`var`i''"  "    "  _column(22) "`varlbl`i''"}
     if `i' == 2  {di in yellow substr("ABCD",`i',1) ": " _col(10) $S_9  _col(22) "`var`i''"  "    "  _column(22) "`varlbl`i''"}
     if `i' == 3  {di in yellow substr("ABCD",`i',1) ": " _col(10) $S_10 _col(22) "`var`i''"  "    "  _column(22) "`varlbl`i''"}
     if `i' == 4  {di in yellow substr("ABCD",`i',1) ": " _col(10) $S_11 _col(22) "`var`i''"  "    "  _column(22) "`varlbl`i''"}
     local i = `i' + 1
     mac shift
     }
 
   local siz = length(string(`total'))+8
   di _newline in green _column(5) `total'  _column(`siz') "Records in file"
   
   if "`if'" != "" | "`in'" != "" {
          local col = length(string(`total'))+5 -length(string(`total'-`before'))
          di in green _column(`col') `total'-`before' in yellow _column(`siz') "Records excluded by [in/if] clauses"
          }

   if "`missing'" == "" {
         local col = length(string(`total'))+5 -length(string(`before'-`after'))
         di  in green _column(`col') `before'-`after' in yellow _column(`siz') "Records excluded by missing values"
         }

   local col = length(string(`total'))
   di in green _column(5) _dup(`col') "_"

   local col = length(string(`total'))+5 -length(string(`after'))
   di in green _column(`col') `after' in yellow _column(`siz') "Records in Diagram: "   

   if "`missing'" != ""  {
        local col = length(string(`total'))+5 -length(string(`nmiss'))
        di _newline in red _column(`col') `nmiss' in yellow _column(`siz') "variables in all records contain missing values"
        parse "`varlist'", parse(" ")
        while "`1'"~=""  {
          quietly count if `1' == .
          local col = `siz' + 13 
          di in yellow _column(`siz') "`1'" _column(`col') ":" _continue
          local col = 8 - length(string(_result(1)))
          di in red _column(`col') _result(1) 
          macro shift
       }
   }  
  vd_tabl "`vdvar'" `varno'

  di in green _dup(70) "_"
end

program define vd_tpct
      local l1 = round(float(100.0*(`1'/$S_6)),1)
      local t = "(" + "`l1'" + " %)"
      local x = `2' + 850
      vd_font 0.60
      gph text `x' `3' 0 0 `t'
      vd_font 0.65
end

program define vd_count
local show = "`1'"
local varno = `2'

local zero = 1

vd_font 0.65

if index("`show'","n") == 0 {local zero = 0}

if `varno' < 4 {
 
   if index("`show'","v") == 0 {
          vd_font 0.70
          local t = "A"}
       else {local t = "$S_12"}       
       gph text 3300 7000 0 -1 `t'
   if index("`show'","t") > 0 {vd_tpct $S_36 3300 8000}
   if index("`show'","v") == 0 {
          vd_font 0.70
          local t = "B"}
       else {local t = "$S_13"}
       gph text 9350 12700 0 -1 `t'
    if index("`show'","t") > 0 {vd_tpct $S_37 9350 14000}
    }


if `varno' == 3 {                                 /* add C */
    if index("`show'","v") == 0 {
          vd_font 0.70
          local t = "C"}
      else { local t = "$S_14"}
       gph text 12500 2750 0 -1 `t'
    if index("`show'","t") > 0 {vd_tpct $S_38 12500 4250}
  }


 if `varno' == 4 {               
                                  /* add letters */
   if index("`show'","v") == 0 { 
          vd_font 0.70
        gph text 3300 7500 0 -1 A
        gph text 20250 11000 0 -1 B
        gph text 14500 1500 0 -1 C
        gph text 7500 2000 0 -1 D
     }
     else {vd_font 0.65
       gph text 3300 7500 0 -1 $S_12
       gph text 20250 10500 0 -1 $S_13
       gph text 14500 1500 0 -1 $S_14
       gph text 7500 2000 0 -1 $S_15
     }
   vd_font 0.65
   if index("`show'","t") > 0 {
      vd_tpct $S_36 3300 8500
      vd_tpct $S_37 19400 15000
      vd_tpct $S_38 14500 3000
      vd_tpct $S_39 7500 3000
   }
  }

/* add counts and percentages */


if `varno' == 2 {
  if index("`show'","c") {vd_text 10000 11000 0 $S_25  `zero'}     /* ab */
  if index("`show'","p") > 0 {vd_pct 10000 11000 $S_25 `zero'}

  if index("`show'","c") {vd_text 16500 11000 0 $S_22 `zero'}     /*    b */
  if index("`show'","p") > 0 {vd_pct 16500 11000 $S_22 `zero'}

  if index("`show'","c") {vd_text 6000 8500 0 $S_21 `zero'}       /* a */ 
  if index("`show'","p") > 0 {vd_pct 6000 8500 $S_21 `zero'}

  if index("`show'","x") == 0 & index("`show'","c") {vd_text 4000 14500 0 $S_20 `zero'}
  if index("`show'","x") == 0 & (index("`show'","t") > 0 | index("`show'","p")){vd_tpct $S_20 5000 14500 `zero'}
}

if `varno' == 3 {
  if index("`show'","c") {vd_text 12500 11000 0 $S_31  `zero'}   /* a b c */
  if index("`show'","p") > 0 {vd_pct 12500 11000 $S_31 `zero'}

  if index("`show'","c") {vd_text 6000 8000 0 $S_21  `zero'}  /* a      */
  if index("`show'","p") > 0 {vd_pct 6000 8000 $S_21 `zero'}

  if index("`show'","c") {vd_text 18500 13500 0 $S_22  `zero'}  /*    b   */
  if index("`show'","p") > 0 {vd_pct 18500 13500 $S_22 `zero'}

  if index("`show'","c") {vd_text 15500 4500 0 $S_23  `zero'}  /*     c */
  if index("`show'","p") > 0 {vd_pct 15500 4500 $S_23 `zero'}

  if index("`show'","c") {vd_text 9250 11000 0 $S_25  `zero'}  /* a b  */
  if index("`show'","p") > 0 {vd_pct 9250 11000 $S_25 `zero'}

  if index("`show'","c") {vd_text 12500 7500 0 $S_26  `zero'}  /* a   c*/
  if index("`show'","p") > 0 {vd_pct 12500 7500 $S_26 `zero'}
 
  if index("`show'","c") {vd_text 15500 11000 0 $S_28  `zero'} /*   b c*/
  if index("`show'","p") > 0 {vd_pct 15500 11000 $S_28 `zero'}

  if index("`show'","x") == 0 & index("`show'","c") {vd_text 4000 14500 0 $S_20  `zero'}  /*       */ 
  if index("`show'","x") == 0 & (index("`show'","t") > 0 | index("`show'","p")) {vd_tpct $S_20 5000 14500 `zero'}
}

if `varno' == 4 {
  if index("`show'","c") {vd_text 4000 12000 0 $S_21  `zero'}  /* a      */
  if index("`show'","p") > 0 {vd_pct 4000 12000 $S_21 `zero'}

  if index("`show'","c") {vd_text 17500 15500 0 $S_22  `zero'}  /*    b   */
  if index("`show'","p") > 0 {vd_pct 17500 15500 $S_22 `zero'}

  if index("`show'","c") {vd_text 14500 5500 0 $S_23  `zero'}  /*     c */
  if index("`show'","p") > 0 {vd_pct 14500 5500 $S_23 `zero'}

  if index("`show'","c") {vd_text 7500 5500 0 $S_24  `zero'}  /*     d */
  if index("`show'","p") > 0 {vd_pct 7500 5500 $S_24 `zero'}

  if index("`show'","c") {vd_text 17500 11500 0 $S_25  `zero'}  /* ab*/
  if index("`show'","p") > 0 {vd_pct 17500 11500 $S_25 `zero'}

  if index("`show'","c") {vd_text 14500 8500 0 $S_26  `zero'}  /* ac*/
  if index("`show'","p") > 0 {vd_pct 14500 8500 $S_26 `zero'}

  if index("`show'","c") {vd_text 7500 8500 0 $S_27  `zero'}  /* ad */
  if index("`show'","p") > 0 {vd_pct 7500 8500 $S_27 `zero'}

  if index("`show'","c") {vd_text 14500 15500 0 $S_28  `zero'} /* bc*/
  if index("`show'","p") > 0 {vd_pct 14550 15500 $S_28 `zero'}

  if index("`show'","c") {vd_text 7500 15500 0 $S_29  `zero'} /* bd*/
  if index("`show'","p") > 0 {vd_pct 7500 15500 $S_29 `zero'}

  if index("`show'","c") {vd_text 11000 5500 0 $S_30 `zero'}  /* cd*/
  if index("`show'","p") > 0 {vd_pct 11000 5500 $S_30 `zero'}

  if index("`show'","p") > 0 {vd_pct 14500 12000 $S_31 `zero'}
  if index("`show'","c") {vd_text 14500 12000 0 $S_31  `zero'} /*abc*/

  if index("`show'","p") > 0 {vd_pct 7500 12000 $S_32 `zero'}
  if index("`show'","c") {vd_text 7500 12000 0 $S_32 `zero'}   /* abd */

  if index("`show'","p") > 0 {vd_pct 11000 8500 $S_33 `zero'}
  if index("`show'","c") {vd_text 11000 8500 0 $S_33 `zero' }   /* acd */

  if index("`show'","p") > 0 {vd_pct 11000 15500 $S_34 `zero'}
  if index("`show'","c") {vd_text 11000 15500 0 $S_34 `zero' }   /* bcd */

  if index("`show'","c") {vd_text 11000 12000 0 $S_35  `zero'}   /* abcd*/
  if index("`show'","p") > 0 {vd_pct 11000 12000 $S_35 `zero'}

  if index("`show'","x") == 0 & index("`show'","c") {vd_text 4000 15500 0 $S_20  `zero'}  /*       */ 
  if index("`show'","x") == 0 & (index("`show'","t") > 0 | index("`show'","p")) {vd_tpct $S_20 5000 15500 `zero'}
}

/* end counts and percentages */

end

program define vd_tabl
 local vdvar = "`1'"
 local varno = `2'


qui count if ($S_12 == $S_8)
  global S_36 = _result(1)

  qui count if ($S_13 == $S_9)
  global S_37 = _result(1)

if `varno' > 2 {
 qui count if ($S_14 == $S_10)
 global S_38 = _result(1)
  if `varno' > 3 {
    qui count if ($S_15 == $S_11)
    global S_39 = _result(1)
  }
 }
qui replace `vdvar' = "error"

set d l 132
di "Counts for combined variables:"
di _dup(70) "-"

if `varno' == 2 {
  vd_val "A"  2 `vdvar' 21
  vd_val "B"  2 `vdvar' 22
  vd_val "AB" 2 `vdvar' 25
  vd_val "--"  2 `vdvar' 20
}

if `varno' == 3 {
  vd_val "A"  3 `vdvar' 21
  vd_val "B"  3 `vdvar' 22
  vd_val "C" 3 `vdvar'  23
  vd_val "AB" 3 `vdvar' 25
  vd_val "AC" 3 `vdvar' 26
  vd_val "BC" 3 `vdvar' 28
  vd_val "ABC" 3 `vdvar' 31 
  vd_val "---"  3 `vdvar' 20
  }

if `varno' == 4 {
  vd_val "A"  4 `vdvar' 21
  vd_val "B"  4 `vdvar' 22
  vd_val "C" 4 `vdvar'  23
  vd_val "D" 4 `vdvar'  24
  vd_val "AB" 4 `vdvar' 25
  vd_val "AC" 4 `vdvar' 26
  vd_val "AD" 4 `vdvar' 27
  vd_val "BC" 4 `vdvar' 28
  vd_val "BD" 4 `vdvar' 29
  vd_val "CD" 4 `vdvar' 30
  vd_val "ABC" 4 `vdvar' 31
  vd_val "ABD" 4 `vdvar' 32
  vd_val "ACD" 4 `vdvar' 33
  vd_val "BCD" 4 `vdvar' 34
  vd_val "ABCD" 4 `vdvar' 35
  vd_val "----"  4 `vdvar' 20
}
di _dup(70) "-"

exit
end

program define vd_val
 local gen = "`3'"
 local a = "($S_12 == $S_8)"
 local b = "& ($S_13 == $S_9)"
 local c = "& ($S_14 == $S_10)"
 local d = "& ($S_15 == $S_11)"

 local na = " ($S_12 != $S_8)"
 local nb = "& ($S_13 != $S_9)"
 local nc = "& ($S_14 != $S_10)"
 local nd = "& ($S_15 != $S_11)"

* build logical if:
 local cnt = ""
 if index("`1'","A") > 0 {local cnt = "`a'"}
                    else {local cnt = "`na'"}
 if index("`1'","B") > 0 {local cnt = "`cnt'" + "`b'"}
                    else {local cnt = "`cnt'" + "`nb'"}

  if `2' > 2 {
    if index("`1'","C") > 0 {local cnt = "`cnt'" + "`c'"}
                    else {local cnt = "`cnt'" + "`nc'"}
  }

 if `2' > 3  {
    if index("`1'","D") > 0 {local cnt = "`cnt'" + "`d'"}
                    else {local cnt = "`cnt'" + "`nd'"}
  }

 qui  replace `gen' = "`1'" if `cnt'
 qui  count if `cnt'
 global S_`4' = _result(1) 
 local siz = 16 - length(string(_result(1)))
 local t = ""
 di "`1'" _col(8) "|" _col(`siz') _result(1) _continue
 local p =  round((_result(1)/$S_6)*100,1)
 local siz = 6 - length(string(`p'))
 di _col(`siz') "`p'" " %  " "`cnt'" 
end


program define ellipse
* draw ellipse on screen
* Martin Villumsen sorted out mathematics on ellipses
tempfile before
save "`before'" 
local V = `1'
local lam = `4'
local eps = `5'
local t = substr("`6'",`7',1)
gph pen `t'
local offx = `2'
local offy = `3'
nobreak {
clear
set obs 1001
tempvar i x y
gen `i' = -_pi+(2*_pi/1000)*(_n-1)
gen `x' =  ((1+`eps')*(`lam')*cos(`i'))/(1+(`eps')*cos(`V'-`i'))*100 + `offx'
gen `y'  = ((1+`eps')*(`lam')*sin(`i'))/(1+(`eps')*cos(`V'-`i'))*100 + `offy'
gph vline `y' `x'
use "`before'", clear
}
end


