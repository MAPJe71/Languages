XIncludeFile "MainWindow.pbf" ; Include the first window definition
XIncludeFile "DateWindow.pbf" ; Include the second window definition

OpenMainWindow() ; Open the first window. This procedure name is always 'Open' followed by the window name
OpenDateWindow() ; Open the second window

; The event procedures, as specified in the 'event procedure' property of each gadget
Procedure OkButtonEvent(EventType)
  Debug "OkButton event"
EndProcedure

Procedure CancelButtonEvent(EventType)
  Debug "CancelButton event"
EndProcedure

Procedure TrainCalendarEvent(EventType)
  Debug "TrainCalendar event"
EndProcedure

; The main event loop as usual, the only change is to call the automatically
; generated event procedure for each window.
Repeat
  Event = WaitWindowEvent()
  
  Select EventWindow()
    Case MainWindow
      MainWindow_Events(Event) ; This procedure name is always window name followed by '_Events'
      
    Case DateWindow
      DateWindow_Events(Event)
      
  EndSelect
  
Until Event = #PB_Event_CloseWindow ; Quit on any window close