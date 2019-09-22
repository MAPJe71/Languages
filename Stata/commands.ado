*commands.ado file for starting ado
capture log close
log using commands.txt
do commands.hlp
log close
di in gre "Read file" in wh "commands.txt" in gre "into word processor"
 
