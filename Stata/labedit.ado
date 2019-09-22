program define labedit
*! Version 1.0.5  <15Feb2000>
** Author:  John R. Gleason, Syracuse University, Syracuse NY, USA
**          (loesljrg@accucom.net)

   local JRGver "1.0.5"

   version 6.0
   window control clear
   macro drop DB*
   global DB_DBuf 5

   syntax [varlist] [, Novalue]
   global DB_var "`varlist'"
   tokenize `varlist'
   local i 1
   while "``i''" != "" {
      global DB_v`i' "``i''"
      local i = `i' + 1
   }
   global DB_NV1 = `i' - 1
   global DB_DBuf1 = min($DB_NV1, $DB_DBuf)
   global DB_DBuf0 = $DB_DBuf
   global DB_Dbuf0 1
   global DB_DSL : data label

   qui if "`novalue'" == "" {
      tempfile golly
      lab save _all using `golly'
      preserve
      global DB_NV0 0
      infix str8 x 14-21 using `golly', clear
      gen byte tt = index(x, " ")
      replace x = cond(tt, substr(x, 1, tt-1), x)
      sort x
      by x: keep if _n == 1
      while $DB_NV0 < _N {
         global DB_NV0 = $DB_NV0 + 1
         local t = x[$DB_NV0]
         global DB_vlu "${DB_vlu}`t' "
      }
      restore
      nobreak {
         lab drop _all
         run `golly'
      }
   }

   global DB_ex   "exit 3000"
   window control button "Exit" 292  4 30  9 DB_ex  escape
   global DB_hlp  "whelp labedit"
   window control button "Help" 292 13 30  9 DB_hlp help

   window control static DB_NV1   5  4 65 31 blackframe
   global DB_Vars "$DB_NV1 Variables"
   window control static DB_Vars  8  6 59  8 center
   window control scombo DB_var   8 13 59 85 DB_VarX
   global DB_Vsel "VLab1"
   window control button "Select Variable" 8 24 55 9 DB_Vsel
   global DB_note  "Notes"
   window control button " " 63 24 4 9 DB_note

   window control static DB_NV1 73  4 97 31 blackframe
   global DB_Vals "$DB_NV0 Value Labels"
   wind control static DB_Vals  76  6 59  8 center
   window control scombo DB_vlu 76 13 59 85 DB_ValX
   global DB_vsel "VLab0"
   window control button "Select Label" 76 24 59 9 DB_vsel
   global DB_UDir "List dir"
   window control button "Dir"   137  6 30 9 DB_UDir
   global DB_ULst "List list DB_ValX"
   window control button "List"  137 15 30 9 DB_ULst
   global DB_Uqry "UpDate0 1"
   window control button "Query" 137 24 30 9 DB_Uqry

   global DB_FND "File last saved: $S_FNDATE"
   window control static DB_FND 174 6 115 8
   global DB_Dsav "Save"
   window control button "New Dataset Label" 174 15 75 9 DB_Dsav
   window control edit 174 25 148 9 DB_DSL  maxlen 80

   window control static DB_NV1  5 44 317 59 blackframe
   global DB_Brows 0
   window control check "Browse" 5 37  40  6 DB_Brows
   global DB_Fh0 "No."
   global DB_Fh2 "Value Label"

   local i  0
   local j 40
   while `i' < $DB_DBuf {
      local i = `i' + 1
      local j = `j' + 10
      window control edit 119 `j'  53 8 DB_val`i'  maxlen 8
      window control edit 174 `j' 145 8 DB_buf`i'  maxlen 80
      window control static DB_Buf`i' 40 `j' 19 8 right
      window control static DB_Nam`i' 62 `j' 53 8 right
   }

   global DB_Top "Scroll 0"
   window control button "Top"    8 47 30 9 DB_Top
   global DB_PgUp "Scroll -$DB_DBuf"
   window control button "PgUp"   8 56 30 9 DB_PgUp
   global DB_Up "Scroll -1"
   window control button "Up"     8 65 30 9 DB_Up
   global DB_Dn "Scroll 1"
   window control button "Dn"     8 74 30 9 DB_Dn
   global DB_PgDn "Scroll $DB_DBuf"
   window control button "PgDn"   8 83 30 9 DB_PgDn
   global DB_Bot "Scroll ."
   window control button "Bottom" 8 92 30 9 DB_Bot

   VLab1
   window control static DB_Fh0  49 37  10 6 right
   window control static DB_Fh1  85 37  30 6 right
   window control static DB_Fh2 119 37  53 6 center
   window control static DB_Fh3 180 37  50 6 left

   capture noi window dialog  /*
      */    `"Labels Editor `JRGver' > $S_FN"'  . . 330 117
   macro drop DB*
   exit 0
end


program define ClrBuf
   local i 0
   while `i' < $DB_DBuf {
      local i = `i' + 1
      global DB_buf`i' " "
      global DB_val`i' " "
      if "$DBIsVar" == "0" { global DB_Nam`i' "" }
   }
end


program define UpDate1
   local i 0
   while `i' < $DB_DBuf1 {
      local i = `i' + 1
      local j ${DB_Buf`i'}
      local t = trim(`"${DB_buf`i'}"')
      lab var ${DB_v`j'} `"`t'"'
      local t : type ${DB_v`j'}
      if !index("`t'", "str") { lab val ${DB_v`j'} ${DB_val`i'} }
   }
end


program define UpDate0
   if "$DB_ValX" == "" {
      window stopbox stop "Select or assign a" "value label name"
      exit
   }
   local i 0
   while `i' < $DB_DBuf {
      local i = `i' + 1
      local j = trim(`"${DB_val`i'}"')
      if `"`j'"' != "" {
         qui cap confirm integer number `j'
         if _rc  {
            window stopbox stop /*
               */    `"`j' is not a"' "non-negative integer"
            exit
         }
         if "`1'"=="1" { global DB_buf`i' : label $DB_ValX `j' }
         else {
            local t = trim(`"${DB_buf`i'}"')
            if "`j'" != `"`t'"' {
               if `"`t'"' != "" { local t `"${DB_buf`i'}"' }
               lab def $DB_ValX `j' `"`t'"', modify
               global DB_DBuf0 = max($DB_DBuf0, `j'+1)
               global DB_Dbuf0 = min($DB_Dbuf0, `j'+1)
            }
         }
      }
   }
end


program define Scroll
   if !$DB_Brows { UpDate${DBIsVar} }
   local t `1'
   if "`1'" == "." {
      local t = cond("$DBIsVar"=="1", $DB_NV1, $DB_DBuf0)-$DB_DBuf+1
   }
   else if "`1'" == "0" {
      local t = cond("$DBIsVar"=="1", `1', $DB_Dbuf0)
   }
   else { local t = `1' + $DB_Buf1 }
   if "$DBIsVar" == "1" {
      local t = min($DB_NV1-$DB_DBuf+1, `t')
      local t = max(1, `t')
   }
   Draw${DBIsVar} `t'
end


program define Draw1
   local i `1'
   local j 0
   while `j' < $DB_DBuf1 {
      local j = `j' + 1
      local V "${DB_v`i'}"
      local T : char `V'[note0]
      if "`T'" != "" { local T "* " }
      global DB_Nam`j' "`T'`V'"
      local t : variable label `V'
      global DB_buf`j' `"`t'"'
      local t : type `V'
      if index("`t'", "str") { local t "<String>" }
      else { local t : value label `V' }
      global DB_val`j' `"`t'"'
      global DB_Buf`j' `i'
      local i = `i' + 1
   }
end


program define Draw0
   local i `1'
   local j 0
   while `j' < $DB_DBuf {
      local j = `j' + 1
      global DB_Buf`j' `i'
      local t = `i' - 1
      global DB_val`j' : di %8s "`t'"
      local tt
      if `"$DB_ValX"' != "" { local tt : label $DB_ValX `t' }
      global DB_buf`j' `"`tt'"'
      local i = `i' + 1
   }
end


program define VLab1
   global DB_Fh1 "Variable"
   global DB_Fh2 "Value Label"
   global DB_Fh3 "Variable Label"
   if "$DBIsVar" != "1" {
      ClrBuf
      global DBIsVar 1
      Draw1 1
      exit
   }
   global DBIsVar 1
   local t "$DB_VarX"
   if "`t'" == "" { local t "$DB_v1" }
   local i 0
   while (`i' < $DB_NV1) & ("`done'" == "") {
      local i = `i' + 1
      if index("${DB_v`i'}", trim("`t'")) == 1 { local done 1 }
   }
   if "`done'" == "" {
      window stopbox stop "Variable `t'" "not found"
      exit
   }
   Scroll `i'-$DB_Buf1
end


program define VLab0
   global DBIsVar 0
   global DB_DBuf0 = $DB_DBuf
   global DB_Dbuf0 1
   ClrBuf
   global DB_Fh1 " "
   global DB_Fh2 "Numeric Value"
   global DB_Fh3 "Value Label"
   Draw0 1
end


program define List
   if "$DBIsVar" == "0" { lab `1' ${`2'} }
end


program define Save
   lab dat "$DB_DSL"
end


program define Notes
   if "$DB_VarX" == "" { exit }
   local nn : char $DB_VarX[note0]
   if `"`nn'"' == "" { exit }
   di in ye _new "$DB_VarX:"
   local i 1
   while `i' <= `nn' {
      local b : char $DB_VarX[note`i']
      if `"`b'"' != "" { di in gr %4.0g "  `i'. ", `"`b'"' }
      local i = `i' + 1
   }
end
