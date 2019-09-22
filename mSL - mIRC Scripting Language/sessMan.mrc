menu channel,status {
  Session Manager
    .Save Session
    ..Save New:/sessMan.save
    ..-
    ..$submenu( $sessMan.menu.save( $1 ) )
    .Load Session
    ..$submenu( $sessMan.menu.load( $1 ) )
    .Rename Session
    ..$submenu( $sessMan.menu.rename( $1 ) )
    .Delete Session
    ..$submenu( $sessMan.menu.delete( $1 ) )
    .-
    .List Session Channels
    ..$submenu( $sessMan.menu.listChannels( $1 ) )    
    .Add/Remove Individual Channels
}

menu channel {
  ;By separating it into three parts,
  ;I don't have to use those $iif bits that seem to break mIRC or AdiIRC depending on which way I do it
  Session Manager

    ..Add $chan To Existing
    ...$submenu( $sessMan.menu.append( $1 ) )
    ..Remove $chan From Existing
    ...$submenu( $sessMan.menu.detach( $1 ) )
    ..-
}

menu channel,status {
  Session Manager
    ..Add Custom Channel To Existing
    ...$submenu( $sessMan.menu.append( $1, custom ) )
    ..Remove Custom Channel From Existing
    ...$submenu( $sessMan.menu.detach.custom( $1 ) )
    .-
    .Options
    ..Advanced Mode (Does Nothing Currently)
    ...$iif( $readini( sessMan-options.ini,config,advancedMode ) == true,$style( 1 ),$null ) $+ Enable:writeini sessMan-options.ini config advancedMode true
    ...$iif( $readini( sessMan-options.ini,config,advancedMode ) == $null,$style( 1 ),$null ) $+ Disable:remini sessMan-options.ini config advancedMode
    ..Auto Part current channels on loading
    ...$iif( $readini( sessMan-options.ini,config,autoPart ) == true,$style( 1 ),$null ) $+ Enable:writeini sessMan-options.ini config autoPart true
    ...$iif( $readini( sessMan-options.ini,config,autoPart ) == $null,$style( 1 ),$null ) $+ Disable:remini sessMan-options.ini config autoPart
    ..Auto Join Session on Connect
    ...$iif( $readini( sessMan-options.ini,config,autoJoin ) == truedef,$style( 1 ),$null ) $+ Join Default:writeini sessMan-options.ini config autoJoin truedef
    ...$iif( $readini( sessMan-options.ini,config,autoJoin ) == trueprev,$style( 1 ),$null ) $+ Join Previous:writeini sessMan-options.ini config autoJoin trueprev
    ...$iif( $readini( sessMan-options.ini,config,autoJoin ) == $null,$style( 1 ),$null ) $+ Disable:remini sessMan-options.ini config autoJoin
    ..Auto Save 'previous' on Disconnect
    ...$iif( $readini( sessMan-options.ini,config,autoSave ) == true,$style( 1 ),$null ) $+ Enable:writeini sessMan-options.ini config autoSave true
    ...$iif( $readini( sessMan-options.ini,config,autoSave ) == $null,$style( 1 ),$null ) $+ Disable:remini sessMan-options.ini config autoSave
}

on *:DISCONNECT:{
  if ( $readini( sessMan-options.ini,config,autoSave ) == true ) {
    echo -ag Saving currently connected channels to session 'previous'
    sessMan.save previous
  }
}

on *:CONNECT:{
  if ( $readini( sessMan-options.ini,config,autoJoin ) == truedef ) {
    sessMan.load default quiet
  } 
  elseif ( $readini( sessMan-options.ini,config,autoJoin ) == trueprev ) {
    sessMan.load previous quiet
  }
}

alias sessMan.save {
  var %i = 1
  var %chanlist = $null

  if ( $1 == $null ) {
    %sessionName = $?"Session Name. (If blank, will use 'default')"
  }
  else {
    %sessionName = $1
  }

  if ( %sessionName == $null ) {
    %sessionName = default
  }

  while ( %i <= $chan( 0 ) ) {
    ;
    ; Turns out using tokens makes this a one liner without needing an if at all
    ; Who knew? ( Apparently everyone who knows AdiIRC/mIRC scripting )
    ;
    %chanlist = $addtok( %chanlist,$chan( %i ),44 )
    inc %i
  }

  if ( %chanlist != $null ) {
    writeini sessMan-sessions.ini $network %sessionName %chanlist
    if ( $2 != quiet ) {
      sessMan.func.startMsg
        echo -ag Saved %chanlist
        echo -ag $str( $chr( 160 ),2 ) to session: %sessionName
        echo -ag $str( $chr( 160 ),2 ) for network: $network
      sessMan.func.endMsg
    }
  }
}

alias sessMan.load {
  if ( $1 == $null ) {
    ;var %sessionName = default
    echo -ag No Session Specified
    return
  }
  else {
    var %sessionName = $1
  }

  var %chanlist = $readini( sessMan-sessions.ini,$network,%sessionName )
  if ( %chanlist == $null ) {
    if ( $2 != quiet ) {
      echo -ag Session Does Not Exist
    }
    return
  } 
  else {
    if ( $readini( sessMan-options.ini,config,autoPart ) == true ) {
      sessman.partAll
    }
    join %chanlist
  }
}

alias sessMan.rename {
  if ( $1 == $null ) return
  var %oldSessionName = $1

  if ( $2 == $null ) {
    var %newSessionName = $?"New Session Name."
  }
  if ( %newSessionName == $null ) {
    echo -ag New session name is not optional
    return
  }

  var %chanlist = $readini( sessMan-sessions.ini,$network,%oldSessionName )
  if ( %chanlist == $null ) {
    echo -ag Can't rename a session that doesn't exist
    return
  }
  var %newCheck = $readini( sessMan-sessions.ini,$network,%newSessionName )
  if ( %newCheck != $null ) {
    echo -ag Can't rename a session to an exsiting name.
    echo -ag Make sure the new name doesn't already exist.
    return
  }
  remini sessMan-sessions.ini $network %oldSessionName
  writeini sessMan-sessions.ini $network %newSessionName %chanlist
  sessMan.func.startMsg
    echo -ag Renamed Session
    echo -ag $chr(160) $+ New Name: %newSessionName
    echo -ag $chr(160) $+ Old Name: %oldSessionName
  sessMan.func.endMsg
}

alias sessMan.delete {
  if ( $1 == $null) {
    echo -ag No Session Specified
    return
  }
  var %sessionName = $1

  var %chanlist = $readini( sessMan-sessions.ini,$network,%sessionName )
  if ( %chanlist == $null ) {
    echo -ag Selected session does not exist
    return
  }
  remini sessMan-sessions.ini $network %sessionName
  sessMan.func.startMsg
    echo -ag The session ' $+ %sessionName $+ ' was deleted
  sessMan.func.endMsg  
}

alias sessMan.append {
  if ( $1 == $null ) return
  var %sessionName = $1
  var %chanlist = $readini( sessMan-sessions.ini,$network,%sessionName )
  if ( %chanlist == $null ) {
    return
  }
  if ( $2 == custom ) {
    var %channel = $?"Add Which Channel?"
    if ( %channel == $null ) {
      echo -ag Must Choose a Channel
      sessMan.func.endMsg
      return
    }
  }
  else {
    var %channel = $chan
  }
  var %chanlist = $addtok( %chanlist,%channel,44 )
  var %chanlist = $sorttok( %chanlist, 44, a )
  echo -ag List is %chanlist
  writeini sessMan-sessions.ini $network %sessionName %chanlist
  sessMan.func.startMsg
    echo -ag %channel added to ' $+ %sessionName $+ '
  sessMan.func.endMsg
}

alias sessMan.detach {
  if ( $1 == $null || $2 == $null ) return
  var %sessionName = $1

  if ( $3 == custom ) {
    var %channel = $?"Remove Which Channel?"
    if ( %channel == $null ) {
      echo -ag Must Choose a Channel
      sessMan.func.endMsg
      return
    }
  }
  else {  
    var %channel = $2
  }
  var %chanlist = $readini( sessMan-sessions.ini,$network,%sessionName )
  %remove = $findtok( %chanlist, %channel, 1, 44 )

  if ( %remove == $null ) {
    echo -ag %channel is not in %sessionName
    echo -ag Nothing to remove
    sessMan.func.endMsg
    return
  }

  %newchanlist = $deltok( %chanlist, %remove, 44 )

  if ( %newchanlist == $null ) {
    remini sessMan-sessions.ini $network %sessionName
    sessMan.func.startMsg
      echo -ag %channel was the only channel in the session
      echo -ag Deleting the session instead
    sessMan.func.endMsg
    return
  }

  writeini sessMan-sessions.ini $network %sessionName %newchanlist
  sessMan.func.startMsg
    echo -ag Channel: %channel removed from Session ' $+ %sessionName $+ '
  sessMan.func.endMsg
}

alias sessMan.partAll {
  var %i = 1
  while ( %i <= $chan( 0 ) ) {
    part $chan( %i )
    inc %i
  }
}

alias sessMan.listChannels {
  if ( $1 == $null ) return
  var %sessionName = $1
  var %chanlist = $readini( sessMan-sessions.ini, $network, %sessionName )
  if ( %chanlist == $null ) {
    if ( $2 != quiet ) {
      echo -ag Session Does Not Exist
    }
    return
  } 
  else {
    sessMan.func.startMsg
    echo -ag $chr( 160 ) $+ Channels in %sessionName
    var %i = 1
    while ( %i <= $numtok( %chanlist, 44 ) {
      echo -ag $str( $chr( 160 ), 4 ) $+ $gettok( %chanlist, %i, 44 )
      inc %i
    }
    sessMan.func.endMsg
  }
}

alias sessMan.menu.save {
  var %pos = $sessMan.func.menupos( $1 )
  var %sess = $ini( sessMan-sessions.ini,$network,%pos )

  ;This bit isn't stricly needed because it seems to immediately return null if the return STARTS with null.
  ;However, if there's text first, it will loop indefinitely since it will never return null, so I will include this anyway to be safe.
  ;Basically if I was just returning the variable, it would work right without the forced return on null.
  if ( %sess == $null ) return

  return %sess $+ :sessMan.save %sess
}

alias sessMan.menu.load {
  var %pos = $sessMan.func.menupos( $1 )
  %sess = $ini( sessMan-sessions.ini,$network,%pos )

  ;This bit isn't stricly needed because it seems to immediately return null if the return STARTS with null.
  ;However, if there's text first, it will loop indefinitely since it will never return null, so I will include this anyway to be safe.
  ;Basically if I was just returning the variable, it would work right without the forced return on null.
  if ( %sess == $null ) return
  return %sess $+ :sessMan.load %sess
}

alias sessMan.menu.rename {
  var %pos = $sessMan.func.menupos( $1 )
  %sess = $ini( sessMan-sessions.ini,$network,%pos )

  ;This bit isn't stricly needed because it seems to immediately return null if the return STARTS with null.
  ;However, if there's text first, it will loop indefinitely since it will never return null, so I will include this anyway to be safe.
  ;Basically if I was just returning the variable, it would work right without the forced return on null.
  if ( %sess == $null ) return
  return %sess $+ :sessMan.rename %sess
}

alias sessMan.menu.delete {
  var %pos = $sessMan.func.menupos( $1 )
  var %sess = $ini( sessMan-sessions.ini,$network,%pos )

  ;See the comment in save and load for an explanation on why this line is here
  if ( %sess == $null ) return
  return Delete %sess $+ :sessMan.delete %sess
}

alias sessMan.menu.listChannels {
  var %pos = $sessMan.func.menupos( $1 )
  var %sess = $ini( sessMan-sessions.ini,$network,%pos )

  ;See the comment in save and load for an explanation on why this line is here
  if ( %sess == $null ) return
  return %sess $+ :sessMan.listChannels %sess
}

alias sessMan.menu.append {
  var %pos = $sessMan.func.menupos( $1 )  
  var %sess = $ini( sessMan-sessions.ini,$network,%pos )
  var %custom = $2

  ;See the comment in save and load for an explanation on why this line is here
  if ( %sess == $null ) return 
  return %sess $+ :sessMan.append %sess %custom
}

alias sessMan.menu.detach {
  if ( $1 == begin ) {
    %i = 1
    %count = $ini( sessMan-sessions.ini,$network,0 )
    while ( %i <= %count ) {
      %position = $ini( sessMan-sessions.ini,$network,%i )
      if ( $pos( $readini( sessMan-sessions.ini,$network,%position ),$chan,0 ) == 1 ) {
        writeini sessMan-temp.ini menuGen $ini( sessMan-sessions.ini,$network,%i ) 1
      }   
      inc %i
    }
  }

  if ( $1 == end ) {
    remini sessMan-temp.ini menuGen
  }

  var %pos = $sessMan.func.menupos( $1 )  
  var %sess = $ini( sessMan-temp.ini,menuGen,%pos )

  ;See the comment in save and load for an explanation on why this line is here
  if ( %sess == $null ) return
  ;return Remove $chan from %sess :sessMan.detach %sess $chan  
  return %sess :sessMan.detach %sess $chan  
}

alias sessMan.menu.detach.custom {
  var %pos = $sessMan.func.menupos( $1 )
  %sess = $ini( sessMan-sessions.ini,$network,%pos )

  ;This bit isn't stricly needed because it seems to immediately return null if the return STARTS with null.
  ;However, if there's text first, it will loop indefinitely since it will never return null, so I will include this anyway to be safe.
  ;Basically if I was just returning the variable, it would work right without the forced return on null.
  if ( %sess == $null ) return
  return %sess $+ :sessMan.detach %sess $chan custom
}

alias sessMan.func.menupos {
  ;This is because for menus, I need it to not return null for 'begin' and 'end'
  if ( $1 == $null ) {
    return 1
  }
  else {
    return $1
  }
}

alias sessMan.func.startMsg {
  echo -ag $str( $chr( 45 ), 30 )
}

alias sessMan.func.endMsg {
  echo -ag $chr(160)
}

alias sessMan.func.menuini {
  ;This doesn't do anything because it was stupid
  ;Seriously, the line to load the ini is one line long
  ;It doesn't make sense to make it a function when the function call would ALSO be one line
  ;Go away, it's like fetch, it's never going to happen
}