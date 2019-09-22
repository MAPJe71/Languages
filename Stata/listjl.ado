*! list values for a variable across lines, possibly broken down by a second variable.
*! JM.Lauritsen Oct1999, version 1.0
program define listjl
	version 6
	syntax varlist(min=1 max=1) [if] [in] [, By(string)]
	preserve
	if "`if'" != "" {qui keep `if'}
	if "`in'" != "" {qui keep `in'}
	tokenize `varlist'
        local id "`1'"
	local vt: t `1'

	local bc: word count `by'
	if `bc' > 1 {di in red "only one by variable allowed"}

	sort `by' `id' 
	local out=""
	scalar ij = 1
	if "`by'" != "" { tab1 `by' 
	local bt: t `by'}

	while ij <= _N {
		if ("`by'" != "" & `by'[ij] != `by'[(ij-1)]) | ij == 1{ 
		di _n "`out'"
		if "`by'" != "" {
		if  index("`bt'","str") > 0 {local out = "Group: `by' = " + `by'[ij] + " `id' :"}
		else {	local val = `by'[ij]
			local labx : label `by' `val'
			local out = "Group: `by' =  `labx' " + "   `id' :" }
		di _n(2) "`out'"
		}
		local out = "" }
		if  index("`vt'","str") > 0 {local out = "`out'" +  `id'[ij] + " "}
			else {local out = "`out'" +  string(`id'[ij]) + " "}
		if length(trim("`out'")) > 70 { 
			di _n "`out'" 
			local out = ""}
		scalar ij = ij +1
	}
		di _n "`out'"  		

end

