; r_idlehide.mrc -- by Raccoon 2014-2017 (2017/02/04)
; "Do you join hundreds of channels? Make your Switchbar great again!"
; This script automatically hides inactive channels from the switchbar.
; Settings can be modified by right-clicking within a channel window.
; Just set it and forget it.
;
; Commands:  /idlehide  /readall  /showall

On *:START: IdleHide start

; This alias gets called every 10 minutes.
; You can also manually type /idlehide at any time.
ALIAS IdleHide {
  ; Initialize Variables
  if (%__IdleHide.On          == $null)  set %__IdleHide.On           $true
  if (%__IdleHide.Timer       == $null)  set %__IdleHide.Timer        10
  if (%__IdleHide.Never       == $null)  set %__IdleHide.Never        #IRCHelp
  if (%__IdleHide.IdleMessage == $null)  set %__IdleHide.IdleMessage  120
  if (%__IdleHide.IdleEvent   == $null)  set %__IdleHide.IdleEvent    30
  if (%__IdleHide.IdleRead    == $null)  set %__IdleHide.IdleRead     10
  if (%__IdleHide.IdleTyped   == $null)  set %__IdleHide.IdleTyped    60
  if (%__IdleHide.DebugWin    == $null)  set %__IdleHide.DebugWin     $true
  ; Start Timer, or Stop Timer, and open Debug Window per settings/change.
  if ($1 == start) {
    if (%__IdleHide.On) { .timerIDLEHIDE -oi 0 $calc(%__IdleHide.Timer * 60) /IdleHide }
    else { .timerIDLEHIDE off | return }
    if (%__IdleHide.DebugWin) { window -Deiz @idlehide }
  }
  var %idlemsg = $calc(%__IdleHide.IdleMessage * 60)
  var %idlevnt = $calc(%__IdleHide.IdleEvent * 60)
  var %idlread = $calc(%__IdleHide.IdleRead * 60)
  var %idltype = $calc(%__IdleHide.IdleTyped * 60)
  ; Cycle through all the channel windows on all the server connections.
  var %i_con = 1
  WHILE $scon(%i_con) {
    scon %i_con
    inc %i_con
    var %uptime = $uptime                    | ; seconds
    var %i_chan = 1
    WHILE $chan(%i_chan) {
      var %chan = $v1
      inc %i_chan
      var %wid = $chan(%chan).wid            | ; window id
      var %idle = $chan(%chan).idle          | ; seconds
      var %meidle = $nick(%chan,$me).idle    | ; seconds
      var %state = $window(%chan).sbstate    | ; 0=hidden, 1=shown
      var %status = $chan(%chan).status      | ; joining, joined, kicked
      var %color = $window(%chan).sbcolor    | ; event, message, highlight
      if (%state == 1) { ; visible in switchbar
        if ($istok(%__IdleHide.Never,%chan,32))  { continue }  ; channels to never hide
        if (%wid == $activewid)                  { continue }  ; don't hide active channel
        if (%status == joining)                  { continue }  ; don't hide if waiting to join
        if (%status == kicked)                   { continue }  ; don't hide if kicked
        if ($editbox(%chan) != $null)            { continue }  ; don't hide if text in editbox
        if (%color == highlight)                 { continue }  ; don't hide if highlighted
        if (%color == message) && (%idle < %idlemsg) { continue }  ; unread messages
        if (%color == event) && (%idle < %idlevnt)   { continue }  ; unread events
        if (%color == $null) {
          if (%idle < %idlread)                      { continue }  ; has been read
          if ($calc(%uptime - %meidle) > 120) $&
            && (%meidle < %idltype)                  { continue }  ; have recently joined or typed in
        }
        window -w2 %chan
      }
      elseif (%state == 0) { ; hidden from switchbar
        noop
      }
    }
} } ; by Raccoon 2014-2017

On *:TEXT:*:#: {
  if ($window($chan).sbstate == 0) { 
    if ($uptime < 120) && ($msgstamp || [??:??] iswm $1 || $nick == ***) { return } ; znc playback
    window -w3 $chan
    winblink $chan
    if ($window(@idlehide)) { echo -ti2 $v1 Show $chan < $+ $nick $+ > $1- }
} }
On *:ACTION:*:#: {
  if ($window($chan).sbstate == 0) { 
    if ($uptime < 120) && ($msgstamp || [??:??] iswm $1 || $nick == ***) { return } ; znc playback
    window -w3 $chan
    winblink $chan
    if ($window(@idlehide)) { echo -ti2c action $v1 Show $chan * $nick $1- }
} }
On *:NOTICE:*:#: {
  if ($window($chan).sbstate == 0) { 
    if ($uptime < 120) && ($msgstamp || [??:??] iswm $1 || $nick == ***) { return } ; znc playback
    window -w3 $chan
    winblink $chan
    if ($window(@idlehide)) { echo -ti2c notice $v1 Show $chan - $+ $nick $+ - $1- }
} }
On *:KICK:#: {
  if ($knick == $me) && ($window($chan).sbstate == 0) { 
    window -w3 $chan
    winblink $chan
    if ($window(@idlehide)) { echo -ti2c kick $v1 Show $chan You were kicked by $nick ( $+ $1- $+ ) }
} }
On *:INPUT:#: {
  if ($window($chan).sbstate == 0) { 
    window -w3 $chan
    if ($window(@idlehide)) { echo -ti2 $v1 Show $chan (me) $1- }
} }

MENU Channel {
  Idle Hide
  .$iif(%__IdleHide.On,$style(1) Running...,Stopped.): set %__IdleHide.On $iif(%__IdleHide.On,$false,$true) | IdleHide start
  .Main Timer $chr(9) %__IdleHide.Timer $+ m: set %__IdleHide.Timer $$input(Idlehide channels every ___ minutes.,et,IdleHide,%__IdleHide.Timer)
  .Edit Channels To Never Hide $chr(9) [#___]: set %__IdleHide.Never $$input(Never Hide These Channels (on any network). $crlf $+ Separate channels by space.,et,IdleHide,%__IdleHide.Never)
  .-
  .Hide Channels w/ Unread Text $chr(9) %__IdleHide.IdleMessage $+ m: set %__IdleHide.Timer $$input(Idlehide channels with unread messages after ___ minutes.,et,IdleHide,%__IdleHide.IdleMessage)
  .Hide Channels w/ Unread Events $chr(9) %__IdleHide.IdleEvent $+ m: set %__IdleHide.Timer $$input(Idlehide channels with unread events after ___ minutes.,et,IdleHide,%__IdleHide.IdleEvent)
  .Hide Channels That Have Been Read $chr(9) %__IdleHide.IdleRead $+ m: set %__IdleHide.Timer $$input(Idlehide channels that have been read after ___ minutes.,et,IdleHide,%__IdleHide.IdleRead)
  .But Don't Hide Channels I have typed In $chr(9) %__IdleHide.IdleTyped $+ m: set %__IdleHide.Timer $$input(Don't hide channels that I have typed in ___ minutes.,et,IdleHide,%__IdleHide.IdleTyped)
  .-
  .$iif(%__IdleHide.DebugWin,$style(1) Debug Window Shown,Debug Window Hidden) : set %__IdleHide.DebugWin $iif(%__IdleHide.DebugWin,$false,$true) | if (%__IdleHide.DebugWin) window -aDeiz @idlehide
  $iif($istok(%__IdleHide.Never,$active,32),$style(1)) Never Hide $chr(58) $left($active,15) : {
    set %__IdleHide.Never $iif($istok(%__IdleHide.Never,$active,32),$remtok(%__IdleHide.Never,$active,0,32),$addtok(%__IdleHide.Never,$active,32))
} } ; by Raccoon 2017

; Blink a window's switchbar icon color for visual alerts.
; /winblink <#chan|Query|@wid> [times] [delay-ms] [delay2-ms]  
; Simply:  /winblink #mIRC
ALIAS winblink {
  var %win = $$1, %winc = $iif($window(%win).sbcolor,$replace($v1,message,1,highlight,2,event,3),0), %blinkc = $iif(%winc == 2,0,2)
  var %t = $iif($2 isnum,$v1,5), %d1 = $iif($3 isnum,$v1,500), %d2 = $iif($4 isnum,$v1,%d1), %c1 = $iif($5 isnum,$v1,%blinkc), %c2 = $iif($6 isnum,$v1,%winc)
  if ($$window(%win)) window -g $+ %c1 %win
  .timerWINBLINK2. $+ $cid $+ %win -mo 1 %d1 window -g $+ %c2 %win
  .timerWINBLINK1. $+ $cid $+ %win -mo $$iif($calc(%t -1) > 0,$v1) $calc(%d1 + %d2) window -g $+ %c1 %win $(|) .timerWINBLINK2. $+ $cid $+ %win -mo 1 %d1 window -g $+ %c2 %win
} ; by Raccoon 2017

ALIAS readall { var %i = 1 | WHILE ($scon(%i)) { scon %i | var %j = 1 | WHILE ($window(*,%j).wid) { window -g0 @ $+ $v1 | inc %j } | inc %i } } ; by Raccoon
ALIAS showall { var %i = 1 | WHILE ($scon(%i)) { scon %i | var %j = 1 | WHILE ($window(*,%j).wid) { window -w3 @ $+ $v1 | inc %j } | inc %i } } ; by Raccoon 2017

;end of script