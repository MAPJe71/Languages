/*

#########################################

	 #      URL-Search       #
	  # v1.0 - (13/12/2016) #
	   # Thanks Supporters #

#########################################

*/

; --- Start of dialogs ---

dialog -l wus_sets {
  title ""
  size -1 -1 329 154
  option dbu disable
  icon $scriptdir $+ wus_main.ico, 0
  button "Close this window", 1, 77 136 193 17, default ok
  tab "Settings 1", 2, 2 2 324 122
  text "Ignore channel(s):", 3, 4 20 75 8, tab 2 center
  list 4, 4 30 78 92, disable tab 2 size hsbar vsbar
  button "Add", 6, 84 30 43 10, tab 2
  button "Del", 7, 84 40 43 10, disable tab 2
  button "Clear", 8, 84 111 43 12, disable tab 2
  button "Add", 16, 200 30 43 10, tab 2
  text "Ignore user(s):", 14, 248 20 76 8, tab 2 center
  button "Del", 17, 200 40 43 10, disable tab 2
  list 15, 245 30 78 92, disable tab 2 size hsbar vsbar
  button "Clear", 18, 200 111 43 12, disable tab 2
  tab "Settings 2", 13
  text "Private Notice Command:", 9, 4 20 125 8, tab 13
  edit "", 5, 130 19 18 9, tab 13 limit 1
  text "Channel Message Command:", 11, 4 30 125 8, tab 13
  edit "", 10, 130 29 18 9, tab 13 limit 1
  combo 19, 4 55 63 57, tab 13 size drop
  text "Language:", 20, 4 45 63 8, tab 13 center
  check "Enable", 12, 2 141 54 10
  text "", 21, 306 144 22 8, center disable
  check "Show the 'Title' information", 29, 160 18 164 10, tab 13
  check "Show the 'Description' information", 30, 160 28 164 10, tab 13
  check "Show the 'Format' information", 31, 160 38 164 10, tab 13
  check "Show the 'Provider' information", 32, 160 48 164 10, tab 13
  check "Show color/bold/underline in informations", 52, 4 75 155 10, tab 13
  text "Max 'Title' information characters", 46, 4 104 155 8, tab 13
  edit "", 47, 160 103 18 9, tab 13 limit 3
  text "Max 'Description' information characters", 48, 4 114 155 8, tab 13
  edit "", 49, 160 113 18 9, tab 13 limit 3
  tab "Settings 3", 53
  check "Display the 'menubar' module menu", 54, 4 20 180 10, tab 53
  check "Display the 'status' module menu", 55, 4 30 180 10, tab 53
  check "Display the 'channel' module menu", 56, 4 40 180 10, tab 53
  check "Display the 'query' module menu", 57, 4 50 180 10, tab 53
  check "Display the 'nicklist' module menu", 58, 4 60 180 10, tab 53
  menu "Menu", 22
  item "Help", 23, 22
  item break, 501
  item "About", 24, 22
  item break, 502
  item "Restart", 25, 22
  item break, 503
  item "Exit", 26, 22
}

; --- End of dialogs ---

; --- Start of events ---

ON *:DIALOG:wus_sets:*:*: {
  if ($devent == init) {
    dialog -t $dname $addon v $+ $wus_ver $lang(4) $iif($isalias(wmm_bel),$wmm_bel,->) (/wus_sets)
    did -ra $dname 1 $lang(3)
    did -ra $dname 2 $lang(4) 1
    did -ra $dname 3 $lang(5)
    did -ra $dname 6 $lang(6)
    did -ra $dname 7 $lang(7)
    did -ra $dname 8 $lang(8)
    did -ra $dname 16 $lang(6)
    did -ra $dname 14 $lang(9)
    did -ra $dname 17 $lang(7)
    did -ra $dname 18 $lang(8)
    did -ra $dname 13 $lang(4) 2
    did -ra $dname 9 $lang(10)
    did -ra $dname 11 $lang(11)
    did -ra $dname 20 $lang(12)
    did -ra $dname 12 $lang(13)
    did -ra $dname 21 v $+ $wus_ver
    did -o $dname 22 $lang(14)
    did -o $dname 23 $lang(15)
    did -o $dname 24 $lang(16)
    did -o $dname 25 $lang(17)
    did -o $dname 26 $lang(18)
    did -ra $dname 29 $lang(47) $qt($lang(43)) $lang(48)
    did -ra $dname 30 $lang(47) $qt($lang(44)) $lang(48)
    did -ra $dname 31 $lang(47) $qt($lang(45)) $lang(48)
    did -ra $dname 32 $lang(47) $qt($lang(49)) $lang(48)
    did -ra $dname 46 $lang(52) $qt($lang(43)) $lang(53)
    did -ra $dname 48 $lang(52) $qt($lang(44)) $lang(53)

    did -ra $dname 52 $lang(57)

    did -ra $dname 53 $lang(4) 3
    did -ra $dname 54 $lang(60) $qt(menubar) $lang(61)
    did -ra $dname 55 $lang(60) $qt(status) $lang(61)
    did -ra $dname 56 $lang(60) $qt(channel) $lang(61)
    did -ra $dname 57 $lang(60) $qt(query) $lang(61)
    did -ra $dname 58 $lang(60) $qt(nicklist) $lang(61)

    if ($istok(%wus_show,title,32)) { did -c $dname 29 }
    if ($istok(%wus_show,description,32)) { did -c $dname 30 }
    if ($istok(%wus_show,format,32)) { did -c $dname 31 }
    if ($istok(%wus_show,provider,32)) { did -c $dname 32 }

    if (%wus_status) { did -c $dname 12 }
    if (%wus_strip) { did -c $dname 52 }
    if (%wus_prefix_chan) { did -ra $dname 10 %wus_prefix_chan }
    if (%wus_prefix_nick) { did -ra $dname 5 %wus_prefix_nick }
    if (%wus_title_chars_max) { did -ra $dname 47 %wus_title_chars_max }
    if (%wus_desc_chars_max) { did -ra $dname 49 %wus_desc_chars_max }

    if ($istok(%wus_menu,menubar,32)) { did -c $dname 54 }
    if ($istok(%wus_menu,status,32)) { did -c $dname 55 }
    if ($istok(%wus_menu,channel,32)) { did -c $dname 56 }
    if ($istok(%wus_menu,query,32)) { did -c $dname 57 }
    if ($istok(%wus_menu,nicklist,32)) { did -c $dname 58 }

    var %f = $scriptdir $+ wus_lang.ini
    if ($ini(%f,0)) { 
      var %t = $v1
      var %i = 1
      while (%i <= %t) {
        var %l = $ini(%f,%i)
        if (%l) && (%l !== %wus_lang) { did -a $dname 19 %l }
        inc %i
      }
      if (%wus_lang) { did -ca $dname 19 %wus_lang }
    }
    else { did -b $dname 19 }
    wus_ignore_chans_list
    wus_ignore_nicks_list
  }
  if ($devent == menu) {
    if ($did == 23) { url $help_url }
    if ($did == 24) { _input ok 60 v $+ $wus_ver $lang(36) $wus_crdate $lang(26) $wus_owner }
    if ($did == 25) { dialog -k $dname | .timer -mo 1 500 wus_sets }
    if ($did == 26) { dialog -k $dname }
  }
  if ($devent == close) {
    if (!%wus_show) { set %wus_show title provider }
    if (!$did(5)) || ($did(5) isalnum) { set %wus_prefix_chan @ }
    if (!$did(10)) || ($did(10) isalnum) { set %wus_prefix_nick ! }
    if (!$did(47)) || (!$wmm_isdigit($did(47))) || ($did(47) > 300) { set %wus_title_chars_max 150 }
    if (!$did(49)) || (!$wmm_isdigit($did(49))) || ($did(49) > 300) { set %wus_desc_chars_max 50 }
    if ($did(19)) { set %wus_lang $did(19) }
  }
  if ($devent == edit) {
    if ($did == 5) {
      if ($did($did).text) { set %wus_prefix_nick $v1 }
      else { unset %wus_prefix_nick }
    }
    if ($did == 10) {
      if ($did($did).text) { set %wus_prefix_chan $v1 }
      else { unset %wus_prefix_chan }
    }
    if ($did == 47) {
      if ($did($did).text) { set %wus_title_chars_max $v1 }
      else { unset %wus_title_chars_max }
    }
    if ($did == 49) {
      if ($did($did).text) { set %wus_desc_chars_max $v1 }
      else { unset %wus_desc_chars_max }
    }
  }
  if ($devent == sclick) {
    if ($did == 29) {
      var %v = title
      if (!$istok(%wus_show,%v,32)) { set %wus_show $addtok(%wus_show,%v,32) }
      else { set %wus_show $remtok(%wus_show,%v,1,32) }
    }
    if ($did == 30) {
      var %v = description
      if (!$istok(%wus_show,%v,32)) { set %wus_show $addtok(%wus_show,%v,32) }
      else { set %wus_show $remtok(%wus_show,%v,1,32) }
    }
    if ($did == 31) {
      var %v = format
      if (!$istok(%wus_show,%v,32)) { set %wus_show $addtok(%wus_show,%v,32) }
      else { set %wus_show $remtok(%wus_show,%v,1,32) }
    }
    if ($did == 32) {
      var %v = provider
      if (!$istok(%wus_show,%v,32)) { set %wus_show $addtok(%wus_show,%v,32) }
      else { set %wus_show $remtok(%wus_show,%v,1,32) }
    }
    if ($did == 52) {
      if (!%wus_strip) { set %wus_strip 1 }
      else { set %wus_strip 0 }
    }
    if ($did == 12) {
      if (!%wus_status) { set %wus_status 1 }
      else { set %wus_status 0 }
    }
    if ($did == 54) {
      if (!$istok(%wus_menu,menubar,32)) { set %wus_menu $addtok(%wus_menu,menubar,32) }
      else { set %wus_menu $remtok(%wus_menu,menubar,1,32) }
    }
    if ($did == 55) {
      if (!$istok(%wus_menu,status,32)) { set %wus_menu $addtok(%wus_menu,status,32) }
      else { set %wus_menu $remtok(%wus_menu,status,1,32) }
    }
    if ($did == 56) {
      if (!$istok(%wus_menu,channel,32)) { set %wus_menu $addtok(%wus_menu,channel,32) }
      else { set %wus_menu $remtok(%wus_menu,channel,1,32) }
    }
    if ($did == 57) {
      if (!$istok(%wus_menu,query,32)) { set %wus_menu $addtok(%wus_menu,query,32) }
      else { set %wus_menu $remtok(%wus_menu,query,1,32) }
    }
    if ($did == 58) {
      if (!$istok(%wus_menu,nicklist,32)) { set %wus_menu $addtok(%wus_menu,nicklist,32) }
      else { set %wus_menu $remtok(%wus_menu,nicklist,1,32) }
    }
    if ($did == 4) { 
      if ($did($did).seltext) { did -e $dname 7 }
    }
    if ($did == 15) { 
      if ($did($did).seltext) { did -e $dname 17 }
    }
    if ($did == 7) {
      did -b $dname $did
      var %s = $did(4).seltext
      if (!%s) { return }
      var %net = $gettok(%s,1,32)
      var %chan = $gettok(%s,3,32)
      set %wus_ignore_ [ $+ [ %net ] $+ ] _chans $remtok(%wus_ignore_ [ $+ [ %net ] $+ ] _chans,%chan,1,32)
      if (!%wus_ignore_ [ $+ [ %net ] $+ ] _chans) { 
        unset %wus_ignore_ [ $+ [ %net ] $+ ] _chans
        set %wus_ignore_chans_networks $remtok(%wus_ignore_chans_networks,%net,1,32)
        if (!%wus_ignore_chans_networks) { unset %wus_ignore_chans_networks }
      }
      wus_ignore_chans_list
    }
    if ($did == 17) {
      did -b $dname $did
      var %s = $did(15).seltext
      if (!%s) { return }
      var %net = $gettok(%s,1,32)
      var %nick = $gettok(%s,3,32)
      set %wus_ignore_ [ $+ [ %net ] $+ ] _nicks $remtok(%wus_ignore_ [ $+ [ %net ] $+ ] _nicks,%nick,1,32)
      if (!%wus_ignore_ [ $+ [ %net ] $+ ] _nicks) { 
        unset %wus_ignore_ [ $+ [ %net ] $+ ] _nicks
        set %wus_ignore_nicks_networks $remtok(%wus_ignore_nicks_networks,%net,1,32)
        if (!%wus_ignore_nicks_networks) { unset %wus_ignore_nicks_networks }
      }
      wus_ignore_nicks_list
    }
    if ($did == 6) {
      var %net = $input($lang(27),eidbk60,$addon $iif($isalias(wmm_bel),$wmm_bel,->) $lang(22))
      if (!$dialog($dname)) { return }
      if (!%net) { wus_sets | return }
      if ($numtok(%net,32) !== 1) { _input error 60 $lang(28) | wus_sets | return }
      if ($len(%net) > 50) { _input error 60 $lang(29) | wus_sets | return }
      var %chan = $input($lang(30),eidbk60,$addon $iif($isalias(wmm_bel),$wmm_bel,->) $lang(22))
      if (!$dialog($dname)) { return }
      if (!%chan) { wus_sets | return }
      if ($numtok(%chan,32) !== 1) { _input error 60 $lang(31) | wus_sets | return }
      if ($numtok(%chan,44) !== 1) { _input error 60 $lang(31) | wus_sets | return }
      if ($left(%chan,1) !== $chr(35)) { _input error 60 $lang(32) | wus_sets | return }
      if ($istok(%wus_ignore_ [ $+ [ %net ] $+ ] _chans,%chan,32)) { _input error 60 $lang(33) | wus_sets | return }
      set %wus_ignore_ [ $+ [ %net ] $+ ] _chans $addtok(%wus_ignore_ [ $+ [ %net ] $+ ] _chans,%chan,32)
      if (!$istok(%wus_ignore_chans_networks,%net,32)) { set %wus_ignore_chans_networks $addtok(%wus_ignore_chans_networks,%net,32) }
      wus_ignore_chans_list
      wus_sets
    }
    if ($did == 16) {
      var %net = $input($lang(27),eidbk60,$addon $iif($isalias(wmm_bel),$wmm_bel,->) $lang(22))
      if (!$dialog($dname)) { return }
      if (!%net) { wus_sets | return }
      if ($numtok(%net,32) !== 1) { _input error 60 $lang(28) | wus_sets | return }
      if ($len(%net) > 50) { _input error 60 $lang(29) | wus_sets | return }
      var %nick = $input($lang(21),eidbk60,$addon $iif($isalias(wmm_bel),$wmm_bel,->) $lang(22))
      if (!$dialog($dname)) { return }
      if (!%nick) { wus_sets | return }
      if ($numtok(%nick,32) !== 1) { _input error 60 $lang(35) | wus_sets | return }
      if ($istok(%wus_ignore_ [ $+ [ %net ] $+ ] _nicks,%nick,32)) { _input error 60 $lang(34) | wus_sets | return }
      set %wus_ignore_ [ $+ [ %net ] $+ ] _nicks $addtok(%wus_ignore_ [ $+ [ %net ] $+ ] _nicks,%nick,32)
      if (!$istok(%wus_ignore_nicks_networks,%net,32)) { set %wus_ignore_nicks_networks $addtok(%wus_ignore_nicks_networks,%net,32) }
      wus_ignore_nicks_list
      wus_sets
    }
    if ($did == 8) {
      did -b $dname 8,7
      var %z = 1
      while (%z <= $numtok(%wus_ignore_chans_networks,32)) {
        var %net = $gettok(%wus_ignore_chans_networks,%z,32)     
        if (%wus_ignore_ [ $+ [ %net ] $+ ] _chans) { unset %wus_ignore_ [ $+ [ %net ] $+ ] _chans }
        inc %z
      }
      unset %wus_ignore_chans_networks
      wus_ignore_chans_list
    }
    if ($did == 18) {
      did -b $dname 18,17
      var %z = 1
      while (%z <= $numtok(%wus_ignore_nicks_networks,32)) {
        var %net = $gettok(%wus_ignore_nicks_networks,%z,32)     
        if (%wus_ignore_ [ $+ [ %net ] $+ ] _nicks) { unset %wus_ignore_ [ $+ [ %net ] $+ ] _nicks }
        inc %z
      }
      unset %wus_ignore_nicks_networks
      wus_ignore_nicks_list
    }
  }
}

ON *:LOAD: { wus_load }

ON *:UNLOAD: {
  wmm_d_close wus_sets
  var %1 = $scriptdir $+ wus_main.ico
  var %2 = $scriptdir $+ wus_lang.ini
  if ($isfile(%1)) { .remove -b $qt(%1) }
  if ($isfile(%2)) { .remove -b $qt(%2) }
  unset %wus_*
  hfree -w WUS_*
  .signal -n wmm_close $addon
}

CTCP *:VERSION: { .notice $nick $chr(3) $+ $color(info) $+ ( $+ $chr(3) $+ $color(ctcp) $+ $wmm_bold($nick) $+ $chr(3) $+ $color(info) $+ ): $addon $wmm_under(v) $+ $wmm_bold($wus_ver) Created by: $wmm_bold($wus_owner) on: $wmm_bold($wus_crdate) }

ON $*:TEXT:$(/^(\Q $+ $replacecs(%wus_prefix_nick,\E,\E\\E\Q) $+ \E|\Q $+ $replacecs(%wus_prefix_chan,\E,\E\\E\Q) $+ \E).*/Si):#: {
  if (!$isalias(wmm_ver)) || ($wmm_ver < $tools_ver) || (!%wus_status) || ($istok(%wus_ignore_ [ $+ [ $network ] $+ ] _chans,$chan,32)) || ($istok(%wus_ignore_ [ $+ [ $network ] $+ ] _nicks,$nick,32)) { return }
  tokenize 32 $strip($1-)
  var %cn = $network $+ ~ $+ $nick $+ ~ $+ $chan
  if ($hget(WUS_FLOOD,%cn)) { return }
  if ($1 == %wus_prefix_nick $+ urlinfo) {
    hadd -mu6 WUS_FLOOD %cn 1
    if (!$2) { .notice $nick ( $+ $wmm_bold($nick) $+ ): $lang(37) - $lang(38) $wmm_bold($1 < $+ $wmm_under($lang(46)) $+ >) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($help_url)) $+ ) | return }
    if (!$wmm_isurl($2)) { .notice $nick ( $+ $wmm_bold($nick) $+ ): $lang(54) - $lang(55) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($help_url)) $+ ) | return }
    wus_urlinfo_search $nick $chan .notice $2-
  }
  if ($1 == %wus_prefix_chan $+ urlinfo) {
    hadd -mu6 WUS_FLOOD %cn 1
    if (!$2) { .msg $chan ( $+ $wmm_bold($nick) $+ ): $lang(37) - $lang(38) $wmm_bold($1 < $+ $wmm_under($lang(46)) $+ >) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($help_url)) $+ ) | return }
    if (!$wmm_isurl($2)) { .notice $nick ( $+ $wmm_bold($nick) $+ ): $lang(54) - $lang(55) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($help_url)) $+ ) | return }
    wus_urlinfo_search $nick $chan .msg $2-
  }
}

; --- End of events ---

; --- Start of aliases ---

alias wus_ver { return 1.0 }
alias wus_crdate { return 13/12/2016 }
alias wus_owner { return $+($chr(119),$chr(101),$chr(115),$chr(116),$chr(111),$chr(114)) }
alias -l tools_ver { return 3.2 }
alias -l key { return 29204c3839a048cdb7f97a78a8cd6ae6 }
alias -l addon { return $+($chr(85),$chr(82),$chr(76),$chr(45),$chr(83),$chr(101),$chr(97),$chr(114),$chr(99),$chr(104)) }
alias -l help_url { return http:// $+ $wus_owner $+ .ucoz.com/wmm }
alias -l main_ico_url { return http:// $+ $wus_owner $+ .ucoz.com/wmm/images/wus_main.ico?nocache= $+ $ticks }
alias -l lang_url { return http:// $+ $wus_owner $+ .ucoz.com/wmm/languages/wus_lang.ini?nocache= $+ $ticks }
alias -l _input {
  if (!$1) { return }
  if ($1 == ok) { .timer -ho 1 0 !noop $input($replace($3-,@newline@,$crlf),ouidbk $+ $iif($2 && $2 isnum,$2,0),$addon $iif($isalias(wmm_bel),$wmm_bel,->) $iif($lang(23),$v1,OK)) }
  if ($1 == warn) { .timer -ho 1 0 !noop $input($replace($3-,@newline@,$crlf),woudbk $+ $iif($2 && $2 isnum,$2,0),$addon $iif($isalias(wmm_bel),$wmm_bel,->) $iif($lang(24),$v1,Warn)) }
  if ($1 == error) { .timer -ho 1 0 !noop $input($replace($3-,@newline@,$crlf),houdbk $+ $iif($2 && $2 isnum,$2,0),$addon $iif($isalias(wmm_bel),$wmm_bel,->) $iif($lang(25),$v1,Error)) }
}

alias -l lang { 
  var %f = $scriptdir $+ wus_lang.ini
  if (!$isfile(%f)) { return 0 }
  if (!%wus_lang) { set %wus_lang English }
  var %chk_lang = $ini(%f,%wus_lang)
  if (!%chk_lang) { return READ-ERROR! }
  var %r = $readini(%f,n,%wus_lang,$1)
  if (!%r) { return N/A }
  elseif (%r) { return %r }
}

; ########################################################## 

alias wus_sets { 
  if (!$isalias(wmm_ver)) { _input error 60 You must download and install first the $qt($upper($wus_owner) Module Manager) in order to work this module! | url $help_url | .unload -nrs $qt($script) | return }
  if ($wmm_ver < $tools_ver) { _input error 60 You must download and install the latest $qt($upper($wus_owner) Module Manager) version in order to work this module! | url $help_url | .unload -nrs $qt($script) | return }
  if ($group(# [ $+ [ $lower($addon) ] ]).fname !== $script) { _input error 60 This module cannot work more than one time into this mIRC client because you already have this module installed! | .unload -nrs $qt($script) | return }
  var %d = wus_sets
  if ($dialog(%d)) { dialog -ve %d %d | return }
  var %i = $scriptdir $+ wus_main.ico
  var %l = $scriptdir $+ wus_lang.ini
  if (!$isfile(%l)) || (!$isfile(%i)) { var %delay = 1 }
  if (%delay) { wus_load | .timer[WUS_DELAY_DL_AND_OPEN] -o 1 3 wus_sets_reopen | _input ok 3 Downloading some require module files... | return }
  dialog -md %d %d
}

alias -l wus_sets_reopen {
  var %i = $scriptdir $+ wus_main.ico
  var %l = $scriptdir $+ wus_lang.ini
  if (!$isfile(%l)) || (!$isfile(%i)) { _input error 60 FATAL ERROR! @newline@ @newline@ $+ Error Code: 001 | return }
  wus_sets
}

alias -l wus_ignore_chans_list {
  var %d = wus_sets
  if (!$dialog(%d)) { return }
  did -b %d 7
  did -r %d 4
  if (!%wus_ignore_chans_networks) { did -b %d 4,8 | return }
  var %z = 1
  while (%z <= $numtok(%wus_ignore_chans_networks,32)) { 
    var %net = $gettok(%wus_ignore_chans_networks,%z,32)
    var %chans = %wus_ignore_ [ $+ [ %net ] $+ ] _chans
    if (!%net) { goto next_net }
    var %i = 1
    while (%i <= $numtok(%chans,32)) {
      var %c = $gettok(%chans,%i,32)
      if (%c) { did -a %d 4 %net $iif($isalias(wmm_bel),$wmm_bel,->) %c }
      inc %i
    }
    :next_net
    inc %z
  }
  if ($did(4).lines) { did -ez %d 4 | did -e %d 8 }
  else { did -b %d 4,8 }
}

alias -l wus_ignore_nicks_list {
  var %d = wus_sets
  if (!$dialog(%d)) { return }
  did -b %d 17
  did -r %d 15
  if (!%wus_ignore_nicks_networks) { did -b %d 15,18 | return }
  var %z = 1
  while (%z <= $numtok(%wus_ignore_nicks_networks,32)) { 
    var %net = $gettok(%wus_ignore_nicks_networks,%z,32)
    var %nicks = %wus_ignore_ [ $+ [ %net ] $+ ] _nicks
    if (!%net) { goto next_net }
    var %i = 1
    while (%i <= $numtok(%nicks,32)) {
      var %n = $gettok(%nicks,%i,32)
      if (%n) { did -a %d 15 %net $iif($isalias(wmm_bel),$wmm_bel,->) %n }
      inc %i
    }
    :next_net
    inc %z
  }
  if ($did(15).lines) { did -ez %d 15 | did -e %d 18 }
  else { did -b %d 15,18 }
}

alias -l wus_load {
  if (!$isalias(wmm_ver)) { _input error 60 You must download and install first the $qt($upper($wus_owner) Module Manager) in order to work this module! | url $help_url | .unload -nrs $qt($script) | return }
  if ($wmm_ver < $tools_ver) { _input error 60 You must download and install the latest $qt($upper($wus_owner) Module Manager) version in order to work this module! | url $help_url | .unload -nrs $qt($script) | return }
  if ($group(# [ $+ [ $lower($addon) ] ]).fname !== $script) { _input error 60 This module cannot work more than one time into this mIRC client because you already have this module installed! | .unload -nrs $qt($script) | return }
  if ($isalias(wmm_dl)) { wmm_dl $main_ico_url $qt($scriptdir $+ wus_main.ico) }
  if ($isalias(wmm_dl)) { wmm_dl $lang_url $qt($scriptdir $+ wus_lang.ini) }
  if (!$var(wus_menu,0)) { set %wus_menu menubar }
  if (%wus_strip == $null) { set %wus_strip 0 }
  if (%wus_status == $null) { set %wus_status 1 }
  if (%wus_lang == $null) { set %wus_lang English }
  if (%wus_prefix_nick == $null) { set %wus_prefix_nick ! }
  if (%wus_prefix_chan == $null) { set %wus_prefix_chan @ }
  if (%wus_title_chars_max == $null) { set %wus_title_chars_max 150 }
  if (%wus_desc_chars_max == $null) { set %wus_desc_chars_max 50 }
  if (%wus_show == $null) { set %wus_show title description provider format }
  hfree -w WUS_*
  .signal -n wmm_close $addon
}

alias -l wus_urlinfo_search {
  if (!$wmm_internet) || (!%wus_status) || (!$1-) { return }
  if ($3 == .msg) { var %output = $3 $2 }
  elseif ($3 == .notice) { var %output = $3 $1 }
  if (!%wus_show) { set %wus_show title provider }
  var %v = urlinfo_ $+ $wmm_random
  wmm_jsonopen -ud %v http://api.embed.ly/1/extract?key= $+ $key $+ &format=json&nojsoncallback=1&url= $+ $wmm_urlencode($4-)
  if ($wmm_jsonerror) { %output ( $+ $wmm_bold($1) $+ ): $lang(40) - ( $+ $lang(41) $wmm_bold($wmm_jsonerror) $+ ) | return }

  if ($istok(%wus_show,title,32)) { 
    var %title = $wmm_html2asc($wmm_fixtab($wmm_json(%v,title)))
    if (%title) && ($len(%title) >= %wus_title_chars_max) { var %title = $left(%title,$calc(%wus_title_chars_max -3)) $+ ... }
    if (!%title) { var %title = $lang(50) }
  }
  if ($istok(%wus_show,description,32)) { 
    var %desc = $wmm_html2asc($wmm_fixtab($wmm_json(%v,description)))
    if (%desc) && ($len(%desc) >= %wus_desc_chars_max) { var %desc = $left(%desc,$calc(%wus_desc_chars_max -3)) $+ ... }
    if (!%desc) { var %desc = $lang(50) }
  }
  if ($istok(%wus_show,provider,32)) { 
    var %provider = $wmm_json(%v,provider_name)
    if (!%provider) { var %provider = $lang(50) }
  }
  if ($istok(%wus_show,format,32)) {
    var %format = $wmm_json(%v,type)
    if (!%format) { var %format = $lang(50) }
  }

  var %msg = 11,12 $+ $gettok($addon,1,45) $+ -0,14 $+ $gettok($addon,2,45) $+ : $iif($isalias(wmm_bel),$wmm_bel,->) $iif(%title,$wmm_bold($lang(43)) $+ :6 %title $+ ) $iif(%desc,-*- $wmm_bold($lang(44)) $+ :14 %desc $+ ) $iif(%format,-*- $wmm_bold($lang(45)) $+ :7 %format $+ ) $iif(%provider,-*- $wmm_bold($lang(49)) $+ :2 %provider $+ )
  %output $iif(%wus_strip,$strip(%msg),%msg)
}

; --- End of aliases ---

; --- Start of menus ---

menu * {
  $iif($istok(%wus_menu,$menu,32),-)
  $iif($istok(%wus_menu,$menu,32),$iif($isalias(wmm_qd),$wmm_qd($addon v $+ $wus_ver - $iif($lang(4),$v1,Settings) $+ ),-*- $addon v $+ $wus_ver - Settings -*-)):wus_sets
  $iif($istok(%wus_menu,$menu,32),-)
}

; --- End of menus ---

; --- Start of groups ---

#url-search off
#url-search end

; --- End of groups ---

; ------------------------------------------------------------------------------ EOF ------------------------------------------------------------------------------