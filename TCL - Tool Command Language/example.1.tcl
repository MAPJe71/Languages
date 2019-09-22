##########
# Sample Tcl Script
 
 
# A Simple proc with one argument (PlayerName)
#curly brace opened on the same line
proc COD2removeColorCodeFromPlayerName { playerName } {
     regsub -all {\^\d} $playerName {} result
     return $result
}
 
 
#A more complicated proc with no argument
 
proc analyse_banFile {} {
     #globale variables
     global banfilename listIPsBanned listGUIDsBanned listNamesBanned  
 
	 #setting a variable
     set formatStr {\s*(\d+\.\d+\.\d+\.\d+)\s*(\d+)\s*(.*)}
 
	 #open curly brace on the same line as if
     if {[catch {open $banfilename r} fileBanned]} {
          puts stderr "Cannot open $banfilename..."
          return 0
		  #else MUST be with both curly braces as follow
     } else {
	      #foreach sample
          foreach line [split [read $fileBanned] \n] {
               if {[regexp $formatStr $line match address guid name]} {
               if {$address ne "0.0.0.0"} {
                    lappend listIPsBanned $address
                }
                if { $guid ne "0" } {
                    lappend listGUIDsBanned $guid
                }
                if { $name ne "" } {
                    lappend listNamesBanned $name
                }
               }
 
          }
          lsort -dictionary listIPsBanned
          lsort -dictionary listGUIDsBanned
          lsort -dictionary listNamesBanned
 
     }
     return 1   
}

proc lrevert list {
   set res {}
   for {set i [llength $list]} {$i>0} {} {
      lappend res [lindex $list [incr i -1]]
   }
   set res
}

proc iota1 n {
   set res {}
   for {set i 1} {$i<=$n} {incr i} {lappend res $i}
   set res
}

proc myproc x {
    set x ""
}
set list "1 2 3 4 5"
myproc $list
puts $list

proc + {x args} {
    foreach e $args {
        set x [expr $x+$e]
    }
    return $x
}

proc lincr {l {increment 1}} {
	set result {}
	foreach e $l {
	    lappend result [expr $e+$increment]
	}
	return $result
}

proc Counter::bump {} {
    variable num
    return [incr num]
}

