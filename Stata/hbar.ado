*! version 1.2.1 NJC 1 April 1998
* version 1.2.0 NJC 26 March 1998
* version 1.1.2 NJC 6 Oct 1997
* version 1.1.1 NJC 24 Sept 1997
* Fred Wolfe unearthed bugs and suggested features marked `FW'
* version 1.1.0 NJC 17 June 1997
program define hbar
    version 5.0
    loc if "opt"
    loc in "opt"
    loc varlist "min(1)"

    #delimit ;
    loc options "BOrder GSOrt(string) noXaxis noYaxis PEn(string)
    SHading(string) T1title(string) T2title(string) TItle(string) TTIck
    XLAbel(string) XLIne(string) XSCale(str) XTIck(str) Axtol(int 600)
    BARFrac(real 0.6) Blank flipt fmt(string) FONTC(int 290) FONTR(int
    570) FONTCB(int 444) FONTRB(int 923) GAPMag(real 1) GAPs(string)
    GLegend(string) gllj glpos(int -1) t2m(int 0) LAP Legend(string) NIT2
    Openbar(string) tim(int 0) Vat(string) VATFmt(string) VATPos(int 32000)
    Cstart(int 10000) SAving(string) VAP t1m(int 0) PENText(int 1)"  ;
    #delimit cr

    parse "`*'"

    qui {
        tempvar touse gleg gap dneg dpos dneg2 dpos2
        mark `touse' `if' `in'
        Markout2 `touse' `varlist'
        gsort - `touse' `gsort'
        count if `touse'
        local nuse = _result(1)

        /* gap legend? */
        g str1 `gleg' = " "
        loc glj = cond("`gllj'" != "", -1, 1)
        if "`glegend'" != "" {
            parse "`glegend'", parse("!")
            loc j 1
            while "`1'" != "" {
                if "`1'" != "!" {
                    if "`1'" == "." { loc 1 " " }
                    loc gleg`j' "`1'"
                    loc j = `j' + 1
                }
                mac shift
            }
        }

        /* gaps between bars? */
        g `gap' = 0
        if "`gaps'" != "" {
            loc j 1
            parse "`gaps'", parse(",")
            while "`1'" != "" {
                if "`1'" != "," {
                    if "`1'" == "0" {
                        loc gleg0 "`gleg`j''"
                        if "`gleg0'" == "" { loc gleg0 " " }
                    }
                    else {
                        replace `gap' = 1 in `1' if `1' <= `nuse'
                        replace `gleg' = "`gleg`j''" in `1' if `1' <= `nuse'
                    }
                    loc j = `j' + 1
                }
                mac shift
            }
        }
        count if `gap'
        loc ngaps = _result(1) + ("`gleg0'" != "")

        /* axis scale */
        if "`xscale'" != "" {
            parse "`xscale'", parse(",")
            if "`4'" != "" | "`2'" != "," {
                di in r "invalid xscale( ) option"
                exit 198
            }
            loc xscmin `1'
            loc xscmax `3'
        }
        if "`xscmin'" == "" { loc min 0 }
        else { loc min `xscmin' }
        if "`xscmax'" == "" { loc max 0 }
        else { loc max `xscmax' }

        g `dneg' = 0
        g `dpos' = 0
        parse "`varlist'", parse(" ")
        while "`1'" != "" {
            replace `dneg' = `dneg' + `1' if `1' < 0
            replace `dpos' = `dpos' + `1' if `1' >= 0 & `1' < .
            mac shift
        }
        su `dneg' if `touse'
        loc dnegmin = _result(5)
        loc dnegmax = _result(6)
        su `dpos' if `touse'
        loc dposmax = _result(6)
        loc dnegmin = cond(`dnegmin' == 0, _result(5), `dnegmin')
        loc dposmax = cond(`dposmax' == 0, `dnegmax', `dposmax')
        loc min = min(`min', `dnegmin')
        loc max = max(`max', `dposmax')
        loc drange = `max' - `min'
        loc zero = cond(`min' >= 0, max(0,`min'), min(0,`max'))
        g `dpos2' = `zero'
        g `dneg2' = `dneg'  /* was `zero' before 1.2.0 */
        replace `dpos' = 0
*       replace `dneg' = 0
    }

    /* legend on left */
    if "`blank'" == "blank" & "`legend'" == "" {
        tempvar legend
        qui g str1 `legend' = ""
    }
    else if "`legend'" == "" {
        tempvar legend
        g `legend' = _n
    }
    else {
        confirm variable `legend'
        capture confirm string variable `legend'
        if _rc == 7 {
            tempvar legend2
            capture decode `legend', g(`legend2')
            if _rc == 0 { loc legend "`legend2'" }
        }
    }

    /* edit these parameters if necessary */

    loc t1start 1000       /* row for t1title */
    loc t2start 1900       /* row for t2title */
    loc ybeg 2400
    loc ylength 17600
                               /* `axtol' is space at ends of y-axis */
    if `axtol' > `ylength'/2 { /* axtol too large => ystep negative FW */
        di in bl "axtol too large: reset to default 600"
        loc axtol 600
    }
    loc ystart = `ybeg' + `axtol'
                               /* row where first bar starts */
    loc ystep = (`ylength' - 2 * `axtol')
    loc ystep = `ystep' / (`nuse' - 1 + `barfrac' + `ngaps' * `gapmag')
                      /* step between bars: one gap defaults to one bar */
    loc yend = `ybeg' + `ylength'
    loc ynudge = 200 * (`fontr'/570)^2
                               /* text displaced downwards from bars */
    loc ytick 400          /* tick length */
    loc yleg 1000          /* labels down from axis */
    loc yleg = `yend' + `yleg'
    loc ytitle 1400        /* title down from labels */
    loc ytitlef 900        /* title down from labels, flip titles */

    loc xstart `cstart'    /* col where first bar begins */
    loc xgap 400           /* gap between left legend and body of plot */
    loc xbeg = `xstart' - `xgap'
    if `glpos' == -1 { loc glpos `xbeg' }
    loc xlength = 30000 - `xstart'
                               /* horizontal extent of data region */
    loc xend = `xbeg' + `xgap' + `xlength'
    loc xz = `xbeg' + `xgap' + `xlength' * (`zero' - `min') / `drange'
    loc mcent = (`cstart' + 30000)/2 + `tim'
                               /* col where main title centred */
    loc keyb1 300          /* dimensions of key box */
    loc keyb2 300

    if "`fmt'" == "" { loc fmt "%1.0f" }
    if "`vatfmt'" == "" { loc vatfmt "%1.0f" }

    /* end of parameter block */

    if "`saving'" != "" { loc saving ", saving(`saving')" }
    gph open `saving' /* FW */
    gph pen `pentext'
    gph font `fontr' `fontc'

    /* y-axis */
    if "`yaxis'" == "" {
        gph line `ybeg' `xstart' `yend' `xstart'
    }

    /* ttick => top ticks */
    loc ttick = "`ttick'" == "ttick"
    if `ttick' { loc border "border" } /* ttick should => border FW */

    /* x-axis and labels */
    if "`xaxis'" == "" {
        gph line `yend' `xstart' `yend' `xend'
        loc ytick2 = `ybeg' - `ytick'/2
        loc ytick = `yend' + `ytick'
        if "`xlabel'" == "" {
            gph line `yend' `xstart' `ytick' `xstart'
            gph line `yend' `xend' `ytick' `xend'
            if `ttick' {
                gph line `ybeg' `xstart' `ytick2' `xstart'
                gph line `ybeg' `xend' `ytick2' `xend' /* FW */
            }
            loc text = cond("`lap'" == "lap", abs(`min'), `min')
            loc text : di `fmt' `text'
            gph text `yleg' `xstart' 0 0 `text'
            loc text = cond("`lap'" == "lap", abs(`max'), `max')
            loc text : di `fmt' `text'
            gph text `yleg' `xend' 0 0 `text'
        }
        else {
            parse "`xlabel'", parse(",")
            while "`1'" != "" {
                if "`1'" != "," {
                    if `1' >= `min' & `1' <= `max' {
                        loc xtickp =  `xbeg' + `xgap' + /*
                         */ `xlength' * (`1' - `min')/`drange'
                        gph line `yend' `xtickp' `ytick' `xtickp'
                        if `ttick' {
                            gph line `ybeg' `xtickp' `ytick2' `xtickp'
                        }
                        loc text = /*
                         */ cond("`lap'" == "lap", abs(`1'), `1')
                        loc text : di `fmt' `text'
                        gph text `yleg' `xtickp' 0 0 `text'
                    }
                }
                mac shift
            }
        }
    }

    /* x-ticks */
    if "`xtick'" != "" {
        parse "`xtick'", parse(",")
        while "`1'" != "" {
            if "`1'" != "," {
                if `1' >= `min' & `1' <= `max' {
                    loc xtickp =  `xbeg' + `xgap' + /*
                     */ `xlength' * (`1' - `min')/`drange'
                    gph line `yend' `xtickp' `ytick' `xtickp'
                    if `ttick' {
                            gph line `ybeg' `xtickp' `ytick2' `xtickp'
                    }
                }
            }
            mac shift
        }
    }

    /* x-lines */
    if "`xline'" != "" {
        parse "`xline'", parse(",")
        while "`1'" != "" {
            if "`1'" != "," {
                if `1' >= `min' & `1' <= `max' {
                    loc xli = `xbeg' + `xgap' + /*
                     */ `xlength' * (`1' - `min')/`drange'
                    gph line `yend' `xli' `ybeg' `xli'
                }
            }
            mac shift
        }
    }

    if "`border'" != "" {
        gph line `ybeg' `xstart' `ybeg' `xend'
        gph line `ybeg' `xend' `yend' `xend'
        if "`xaxis'" != "" { gph line `yend' `xstart' `yend' `xend' }
    }

    parse "`varlist'", parse(" ")
    loc nvars : word count `varlist'
    loc nv = 1 + int(`nvars'/5)

    if "`pen'" == "" { loc pen : di _dup(`nv') "23451" }
    if "`shading'" == "" { loc shading : di _dup(`nv') "01234" }
    if "`openbar'" == "" { loc openbar: di _dup(`nvars') "n" }
    if "`vat'" == "" { loc vat : di _dup(`nvars') "." }

    loc l = length("shading")
    loc i 1
    while `i' <= `l' {
        loc char = substr("`shading'",`i',1)
        if "`char'" == "n" { loc nvars = `nvars' - 1 }
        loc i = `i' + 1
    }

    loc j 1

    while "`1'" != "" {

        loc data "`1'"
        loc i 1
        loc sh = substr("`shading'",`j',1)
        loc pe = substr("`pen'",`j',1)
        loc open = substr("`openbar'",`j',1)
        loc v = substr("`vat'",`j',1)
        loc y `ystart'
        qui replace `dneg' = `dneg' - `data' if `data' < 0
        qui replace `dpos' = `dpos' + `data' if `data' >= 0 & `data' < .

        if "`gleg0'" != "" {
            loc y = `y' + `ystep' * `gapmag'
            if `j' == 1 {
                loc y2 = `y' - (1 - 0.5 * `barfrac') * `ystep' + `ynudge'
                gph text `y2' `glpos' 0 `glj' `gleg0'
            }
        }

        while `i' <= `nuse'  {
            gph pen `pe'
            loc y1 = `y' + `barfrac' * `ystep'
            loc y2 = `y' + 0.5 * `barfrac' * `ystep' + `ynudge'
            local value = `data'[`i']
            if `value' >= 0 & `value' != . {
                loc x = `xbeg' + `xgap' + /*
                  */ `xlength' * (`dpos'[`i'] - `min') / `drange'
                loc x1 = `xbeg' + `xgap' + /*
                  */ `xlength' * (`dpos2'[`i'] - `min') / `drange'
            }
            else {
                loc x = `xbeg' + `xgap' + /*
                 */ `xlength' * (`dneg'[`i'] - `min') / `drange'
                loc x1 = `xbeg' + `xgap' + /*
                 */ `xlength' * (`dneg2'[`i'] - `min') / `drange'
            }
            if `value' != 0 & `value' != . & "`sh'" != "n" {
                if "`sh'" == "." {
                    gph line  `y' `x' `y' `x1'
                    if "`open'" != "y" { gph line  `y' `x1' `y1' `x1' }
                    gph line  `y1' `x1' `y1' `x'
                    gph line  `y1' `x' `y' `x'
                }
                else { gph box `y' `x' `y1' `x1' `sh' }
            }
            gph pen `pentext'
            if "`v'" != "." & `value' != 0 & `value' != . {
                Hbar_v `value' `v' `x' `x1' `vatpos'
                loc vatpos $S_1
                loc jus $S_2
                if "`vap'" != "" { loc text = abs(`value') }
                else loc text = `value'
                loc text : di `vatfmt' `text'
                gph text `y2' `vatpos'  0 `jus' `text'
            }
            if `j' == 1 {
                loc text = `legend'[`i']
                gph text `y2' `xbeg'  0 1 `text'
            }
            if `gap'[`i'] {
                loc y = `y' + `ystep' * `gapmag'
                if `j' == 1 {
                    loc text = `gleg'[`i']
                    loc y2 = `y' + 0.5 * `barfrac' * `ystep' + `ynudge'
                    gph text `y2' `glpos'  0 `glj' `text'
                }
            }
            loc y = `y' + `ystep'
            loc i = `i' + 1
        }
        qui replace `dneg2' = `dneg'
        qui replace `dpos2' = `dpos'
        loc j = `j' + 1
        mac shift
    }

    /* t2title, left justified (defaults to key for 2 or more variables) */
    if "`t2title'" == "." { loc t2title }
    else if "`t2title'" != "" {
        loc xl = `xstart' + `t2m'
        gph text `t2start' `xl' 0 -1 `t2title'
    }
    else if `nvars' >= 2 {
        loc t2l = `t2start' - `ynudge' + `keyb1'
        loc t2u = `t2start' - `ynudge' - `keyb2'
        loc xjump =  `xlength' / `nvars'
        loc xjump2 = `xjump' / 50
        loc xl = `xstart' + `t2m' + `xjump2' - `keyb1'
        loc xr = `xstart' + `t2m' + `xjump2' + `keyb2'
        loc j 1
        while `j' <= `nvars' {
            loc sh = substr("`shading'",`j',1)
            if "`sh'" == "n" {
                loc j = `j' + 1
                loc sh = substr("`shading'",`j',1)
            }
            loc pe = substr("`pen'",`j',1)
            gph pen `pe'
            if "`sh'" == "." {
                gph line  `t2l' `xl' `t2u' `xl'
                gph line  `t2u' `xl' `t2u' `xr'
                gph line  `t2u' `xr' `t2l' `xr'
                gph line  `t2l' `xr' `t2l' `xl'
            }
            else if "`sh'" != "n" { gph box `t2l' `xr' `t2u' `xl' `sh' }
            loc x2 = `xr' - `fontc'/2
            loc var : word `j' of `varlist'
            if "`nit2'" == "" {
                loc text : variable label `var'
                if "`text'" == "" { loc text "`var'" }
            }
            else { loc text "`var'" }
            gph pen `pentext'
            gph text `t2start' `x2' 0 -1 `text'
            loc xl = `xl' + `xjump'
            loc xr = `xr' + `xjump'
            loc j = `j' + 1
        }
    }

    if "`title'" == "" & `nvars' == 1 {
        loc title : variable label `data'
        if "`title'" == "" { loc title "`data'" }
    }
    else if "`title'" == "." { loc title }

    loc xL = `xstart' + `t1m'
    if "`flipt'" == "" { /* default */
        /* t1title, left justified */
        gph text `t1start' `xL' 0 -1 `t1title'

        /* main title at bottom, centred */
        gph font `fontrb' `fontcb'
        loc ytitle = `yleg' + `ytitle'
        gph text `ytitle' `mcent' 0 0 `title'
    }
    else { /* flip titles from default */
        /* bottom title, centred (and closer to axis than default) */
        loc ytitle = `yleg' + `ytitlef'
        gph text `ytitle' `mcent' 0 0 `t1title'

        /* main title at top, left justified */
        gph font `fontrb' `fontcb'
        gph text `t1start' `xL' 0 -1 `title'
    }

    gph close
end

program def Hbar_v  /* values as text */
loc value `1'
loc v  `2'
loc x `3'
loc x1 `4'
loc vbp `5'

if "`v'" == "L" | "`v'" == "r" | "`v'" == "e" { loc jus 1 }
else if "`v'" == "l" | "`v'" == "R" { loc jus -1 }
else if "`v'" == "m" { loc jus 0 }
else if "`v'" == "N" | "`v'" == "f" {
    if `value' > 0 { loc jus 1 }
    else { loc jus -1 }
}
else if "`v'" == "n" | "`v'" == "F" {
    if `value' > 0 { loc jus -1 }
    else { loc jus 1 }
}

if "`v'" == "r" | "`v'" == "R" { loc vp `x' }
else if "`v'" == "l" | "`v'" == "L" { loc vp `x1' }
else if "`v'" == "m" { loc vp = (`x' + `x1')/2 }
else if "`v'" == "N" | "`v'" == "n" {
    if `value' > 0 { loc vp `x1' }
    else { loc vp `x' }
}
else if "`v'" == "F" | "`v'" == "f" {
    if `value' > 0 { loc vp `x' }
    else { loc vp `x1' }
}
else if "`v'" == "e" { loc vp `vbp' }

global S_1 `vp'
global S_2 `jus'

end

program def Markout2 /* marks out obs with all missing values */
* 1.0.1 NJC 25 March 1998
    version 5.0
    local varlist "req ex min(1)"
    local options "Strok"
    parse "`*'"
    parse "`varlist'", parse(" ")
    local nvars : word count `varlist'
    if `nvars' == 1 { exit }
    local nvars = `nvars' - 1
    local markvar `1'
    mac shift
    tempvar nmiss
    gen `nmiss' = 0
    qui {
        while "`1'" != "" {
            local type : type `1'
            if substr("`type'",1,3) == "str" {
                if "`strok'" != "" {
                    replace `nmiss' = `nmiss' + (`1' == "")
                }
                else {
                    replace `nmiss' = `nmiss' + 1
                }
           }
           else { replace `nmiss' = `nmiss' + (`1' == .) }
           mac shift
        }
        replace `nmiss' = `nmiss' == `nvars'
        replace `markvar' = 0 if `nmiss'
    }
end

