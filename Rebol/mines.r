REBOL [
	Title: "Mine-Sweeper"
	Author: "Allen Kamp"
	Email: allenk@powerup.com.au 
	Version: 1.0.5
	File: %mines.r
	Date: 1-Jul-2000
	Purpose: {Mine-sweeper for REBOL/View beta2}
	Notes: {Still need to add a menu for game layout choices}
	History: [
	1.0.4 28-Mar-2001 {Starting to cleanup for Link}
   ]

	Usage: {
			Left Click         to clear square
			Right Click      to mark as a Mine  
		   }
]

set 'as-pair func [x y][to-pair reduce [x y]]


mine-sweep: make object! [
	;---------------
	; Parameters
	;---------------
	
	;--- Change these as you wish. Display will size to suit.
	;--- Be Warned! Too Large numbers will cause a stack overflow.
	;    note the comments on valid numbers 
	
	rows: 9    ; any number 1 or above
	columns: 9 ; any number 9 or above
	mines: 10 ; any number less than rows * columns
	
	;--- A few checks.
	if columns < 9 [columns: 9]
	if rows < 1 [rows: 1]
	if mines > (rows * columns) [mines: (rows * columns) - 1]
	
	
	;----------------
	; Globals
	;----------------
	
	grid-size: as-pair rows columns
	mines-flagged: 0
	mines-found: 0
	game-over: false
	game-started: false
	last-time: none
	cleared-count: 0
	
	
	;----------------------
	; Gameplay Functions
	;----------------------
	
	patterns: [
		-1x-1 0x-1 1x-1
		-1x0        1x0
		-1x1  0x1   1x1
	]
	
	square-index: func [rc [pair!]][
		either all [rc/x <= rows rc/y <= columns rc/x > 0 rc/y > 0][
			return ((rc/y - 1) * rows) + rc/x
		][
			return none
		]
	]  
	
	
	sweep: func [rc [pair!] /local index][
	   index: square-index rc
	   if all [not marked? rc
			   not mine? rc
	   ][
			  grid/pane/:index/gui-state: 'cleared
			  cleared-count: cleared-count + 1
			  grid/pane/:index/data: not grid/pane/:index/data
			  show grid/pane/:index 
			  if alone? rc [
				  foreach pattern patterns [
					  sweep rc + pattern
				  ]
			  ]      
	   ]
	exit
	]
	
	
	marked?: func [rc [pair!] /local index state][
		if none? index: square-index rc [return true]
		state: grid/pane/:index/gui-state
		any [
			 none? index 
			 same? state 'flag 
			 same? state 'cleared
		]
	]
	
	mine?: func [rc [pair!] /local index][
		if none? index: square-index rc [return false]
		same? grid/pane/:index/content 'X
	]
	
	
	alone?: func [rc [pair!] /local index][
		index: square-index rc
		same? grid/pane/:index/content 0
	]

	untouched?: func [face][
		not any [
			same? face/gui-state 'cleared
			same? face/gui-state 'flag
		]
	]

	
	make-grid: func [rows columns][
		grid/size: as-pair (columns) * 24 + 8 (rows) * 24 + 8 
		repeat column columns [	
			repeat row rows [
			   append grid/pane make square [
				   offset: as-pair (column - 1) * 24 + 2 (row - 1) * 24 + 2
				   square-id: as-pair row column
			   ]
		   ]
		]
	exit
	]
	
	survey-mines: func [/local column row result rc index][
		repeat column columns [
			repeat row rows [
				rc: as-pair row column
				index: square-index rc
				result: 0
				if not mine? rc [
					foreach pattern patterns [
						if mine? rc + pattern [result: result + 1]
					]
					grid/pane/:index/content: result
					if not zero? result [grid/pane/:index/f-colour: pick colors result]
				]
			]
		]
	]  
		
	
	place-mines: func [rows columns mines /local mines-placed location grid-size][
		random/seed now
		mines-placed: 0
		grid-size: rows * columns
		while [mines-placed <> mines][
			location: random grid-size
			if not same? grid/pane/:location/content 'X [
				grid/pane/:location/content: 'X
				mines-placed: mines-placed + 1
			]       
		]  
	]
	
	show-mines: func [][
		foreach square grid/pane [
		   if same? square/content 'X [
			   square/gui-state: 'cleared
			   show square
		   ]   
		]
	]
	
	new-game: func [/reset /local gp][
		if reset [
		gp: grid/pane
			repeat i length? gp [
				gp/:i/content: 0
				gp/:i/gui-state: 'covered
				gp/:i/font/color: 0.0.0 
				gp/:i/f-colour: 0.0.0
				gp/:i/color: 170.170.170
				gp/:i/data: off
				gp/:i/away: off
				
			]
		show gp
			status/text: mines
			time/text: "0000"
			last-time: none
			mines-found: mines-flagged: cleared-count: 0
			game-started: game-over: false
			show [status time]
		]
		   place-mines rows columns mines
		   survey-mines
	]
	
	;------------------
	;    Gui
	;------------------
	
	;--Images
	
	smiley: load to-binary decompress 64#{
	eJxz8n3BwgAGZkCsAcQiUMzIIMEAA0LcEAwDB2gAGFABabr+/0dBRJiARReqCWRq
	xK0dXSMawKsdRQFW/+LQS0AjXu1E+RSHsweLXrSwJRTU+BRjcMlJGMQnD6I1EqWd
	mOxAVj5CN4HE/EsfwMAAAKQP0/PoBAAA
	}
	
	ohoh: load to-binary decompress 64#{
	eJxz8n3BwgAGZkCsAcQiUMzIIMEAA0LcEAwDB2gAGFABabr+/0dBRJiARReqCcRq
	hANC2tHVNDRARYAAyMarHYulWNkYerF4E4+9qNqxBxFW/xKpl7gAp5peiE+R/Ygp
	giu4ML2JJoInjgjaS0zyoDBZEq0RoZ2sfIRuAgwQqYs+gIEBAG5tvhXoBAAA
	}
	
	sad: load to-binary decompress 64#{
	eJxz8n3BwgAGZkCsAcQiUMzIIMEAA0LcEAwDB2gAGFABabr+/0dBRJiARReqCWRq
	xK0doRGXCUgK8FmK1b84rMYVOAiA2+VE+XQw64WwCYlQJZyxxC8ee/EnDxLTFVHa
	ickOZOUjdBNIzL/0AQwMAExLz/foBAAA
	}
	
	sunnies: load to-binary decompress 64#{
	eJxz8n3GwgAGZkCsAcQiUMzIIAEW3wCUP8IHwTBwgAaAARWQpuv/fxREhAlYdKGa
	QKZG3NrRNaIBvNpRFGD1Lw69RLkWh9WU6oVrb2pB9yMEAMWxxRdUJZxEDiJMLi43
	YwYv1gDHFVx4ADFxRHnyoG6yJCY7YJqAGi9EmQADROqiDwAAF9WiUeYEAAA=
	}
	
	colors: [
		0.0.255   ;- 1 Blue
		0.240.0   ;- 2 Mid Green
		255.255.0 ;- 3 Yellow
		0.0.139   ;- 4 Dark Blue
		0.100.0   ;- 5 Dark Green
		100.0.0   ;- 6 Dark Red
		0.255.255 ;- 7 Aqua
		255.0.0   ;- 8 Red
	
	]  
	
	grid: make face [offset: 24x48 pane: [] size: 200x200 edge: make edge [effect: 'ibevel]]
	
	square: make face [
		offset: 24x0
		size: 24x24
		text: none
		font: make font [style: 'bold size: 14]
		color: 170.170.170
		edge: make edge [
			color: 190.190.190
			effect: 'bevel
		]
		effect: [gradcol 1x1 140.140.140 100.100.100]
		square-id: none
		content: 0
		gui-state: 'covered
		data: off
		right-down: false
		away: false
		f-colour: 0.0.0
		feel: make feel [
			redraw: func [face][
				face/text: to-string switch face/gui-state [
					covered [""]
					flag [face/font/color: 255.0.0 "!"]
					query [face/font/color: 0.0.200 "?"]
					cleared [face/font/color: face/f-colour
							 either face/content = 0 [copy ""][face/content]]
				]
				face/edge/effect: pick [ibevel bevel] face/data
						]
			engage: func [face action event /local result][
				if game-over [exit]
	
				if action = 'alt-down [
					;Toggle Markers
					face/right-down: true
					result: switch face/gui-state [
						covered [
							mines-flagged: mines-flagged + 1
							if mine? face/square-id [mines-found: mines-found + 1]
							'flag
						]
						flag [
							mines-flagged: mines-flagged - 1
							if mine? face/square-id [mines-found: mines-found - 1]
							'query
						]
						query ['covered]
							cleared ['cleared]
						] face/gui-state: result
				]
	
				if action = 'down [
					if untouched? face [
						face/data: true
						face/away: false
						start/image: ohoh
						show [face start]  
					]
				]            
			
				if action = 'away [
					if untouched? face [
						face/data: false
						face/away: true
						start/image: smiley
						show [face start]
					]
				]
	
				if action = 'alt-up [
					 face/right-down: false
				]            
	
				if action = 'over and not face/right-down [
					if untouched? face [
					face/data: true
					face/away: false
					start/image: ohoh
					show [face start]
					]
				] 
	
				if (action = 'up and not face/away) [
					game-started: true
					if untouched? face [
						if face/data [face/data: false]
						; or mined
						either same? face/content 'X [
							face/data: not face/data
							face/gui-state: 'cleared
							face/color: 255.0.0
							face/font/color: 0.0.0
							start/image: sad
							game-over: true
							;--show where mines were hidden
							show start
							show-mines
							
						][
						  	sweep face/square-id
						  	start/image: smiley
						  	show start
						]
					]
				]
				
				; Update Scores and Game status, redraw
				if any [action = 'alt-down action = 'up][
					if not game-over [status/text: mines - mines-flagged]
					if all [
						mines-found = mines
						(cleared-count + mines-found) = (rows * columns)
					][
						start/image: sunnies
						game-over: true
						show start
					] 
					show face
					show status
				]
			]
		]
	]
	
	;------------------
	;   Panel Gui
	;------------------
	
	status-panel: make face [
		offset: 24x10 
		size: 219x30
		edge: make edge [effect: 'ibevel]
		color: image: none
		pane: reduce [
			status: make face [
				offset: 1x1 
				text: mines
				size: 54x24
				font: make font [color: red style: 'bold size: 16 align: 'right]
				color: black
				edge: make edge [effect: 'ibevel size: 2x2]
			]
			start: make face [
				size: 25x25
				offset: 96x0
				image: smiley effect: [key 192.192.192 gradcol 1x1 1.170.170 0.100.100]
				feel: make feel [
					redraw: func [face][
						face/edge/effect: pick [ibevel bevel] face/data
					]
					engage: func [face act evt][
						act: switch/default act [
							down [on]
							over [on]
							up [if face/data [do face/action] off]
						][off]
						if act <> face/data [
							face/data: act
							show face
						]
					]
				]
				data: off
				action: [new-game/reset self/image: smiley show self]
			] 
			
			time: make status [
				text: "0000"
				offset: 159x1
				feel: make feel [
					redraw: func [face][
						redraw: none
						show face
					]
					engage: func [face action event /local i][
						if any [game-started = false game-over = true][exit] 
						if last-time <> now/time [
							last-time: now/time
							i: form 1 + to-integer face/text
							while [4 > length? i] [insert i "0"]
							face/text: i
							show face
						]
					]
				]
				after: none
				rate: 1
			]
	
		] 
	] ;end of status-panel
	
	
	; Generate the Grid 
	make-grid rows columns
	new-game
	
	board-size: as-pair grid/size/x + 24  grid/size/y + 60
	
	main-face: make face [
		color: 180.180.180
		size: board-size
	   pane: reduce [
			make status-panel [offset/x: (board-size/x / 2) - (status-panel/size/x / 2)]
			make grid [offset/x: (board-size/x / 2) - (grid/size/x / 2)]
		]
	] 
]

view center-face mine-sweep/main-face
