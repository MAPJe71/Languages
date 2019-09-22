program define now
        capture log close
	local a = "`2'"
        set more off
        clear
        program drop _all
	discard
	if "`a'" == "a" {log using "`1'", append}
	else {log using "`1'", replace}
        display "Analysis do-file `1' run on $S_DATE at $S_TIME"
        capture noisily do "`1'"
        local myrc = _rc
        log close
        exit `myrc'
end
exit
