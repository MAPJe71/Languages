REBOL [
	title: "REBtris"
	author: "Frank Sievertsen"
	version: 1.0.2
	date: 2-Apr-2001 ;30-Jul-2000
	copyright: "Freeware"
]

rebtris: context [
	field-size: 10x20
	stone-size: 20x20
	stones: {
		xxxx

		xxx
		 x

		xxx
		x

		xxx
		  x

		xx
		 xx

		 xx
		xx

		xx
		xx
	}
	walls: none
	lay: none
	pan: none
	stone: none
	akt-falling: none
	stoning: none
	pause: no
	points: 0
	points-pane: none
	level: 1
	preview: none
	start-button: none
	new-start: func [/local ex col rnd] [
		if not empty? preview/pane [hide preview/pane/1 insert pan/pane akt-falling: preview/pane/1 clear preview/pane ]
		insert preview/pane make pick walls random length? walls []
		preview/pane/1/parent-face: preview
		ex: preview/pane/1/pane
		col: poke 200.200.200 random 3 0
		col: poke col random 3 0
		forall ex [
			change ex make first ex compose/deep [effect: [gradient 1x1 (col) (col / 2)]]
		]
		preview/pane/1/rotate/norot
		preview/pane/1/offset: preview/size - preview/pane/1/size / 2
		if not akt-falling [new-start exit]
		akt-falling/parent-face: pan
		akt-falling/offset: field-size * 1x0 / 2 - 1x0 * stone/size
		points: points + level
		show [points-pane preview pan akt-falling]
	]
	init: func [/local ex] [
		walls: copy/deep [[]]
		akt-column: akt-row: 1
		layout [
			stone: image (stone-size) 200.200.0 effect [gradient 1x1 200.200.0 100.100.0]
		]
		if not parse/all stones [newline tabs some [end-up | no-stone | one-stone | new-row | new-wall]]
			[make error! [user message "parse error"]]
		forall walls [
			layout [
				ex: box 100x100 with [
					old-pos: none
					rotate: func [/norot /local minx miny maxx maxy] [
						foreach face pane [
							if not norot [face/offset: reverse face/offset * -1x1]
							if none? minx [
								minx: face/offset/x
								miny: face/offset/y
							]
							minx: min minx face/offset/x
							miny: min miny face/offset/y
						]
						maxx: maxy: 0
						foreach face pane [
							face/offset/x: face/offset/x - minx
							face/offset/y: face/offset/y - miny
							maxx: max maxx face/offset/x
							maxy: max maxy face/offset/y
						]
						size: stone/size + to-pair reduce [maxx maxy]
					]
					poses: func [/local out] [
						out: make block! length? pane
						foreach face pane [
							append out offset + face/offset + face/size
						]
						out
					]
					legal?: func [/local val out] [
						out: make block! length? pane
						foreach val out: poses [
							if any [
								val/x > pan/size/x
								val/y > pan/size/y
								val/x < stone/size/x
								val/y < stone/size/y
								find stoning val
							] [
								restore-pos
								return false
							]
						]
						save-pos
						out
					]
					del-line: func [num /local pos changed maxy] [
						foreach pos poses [
							either pos/y = num [
								remove pane
								changed: yes
							] [
								if pos/y < num [changed: yes pane/1/offset/y: pane/1/offset/y + stone/size/y]
								pane: next pane
							]
						]
						pane: head pane
						if changed [
							maxy: 0
							foreach p pane [
								maxy: max maxy p/offset/y
							]
							size/y: maxy + stone/size/y
							show self
						]
					]
					save-pos: func [] [
						old-pos: make block! 2 + length? pane
						repend/only old-pos [offset size]
						foreach face pane [
							repend/only old-pos [face/offset]
						]
					]
					restore-pos: func [/local pos] [
						if not old-pos [exit]
						
						set [offset size] first old-pos
						pos: next old-pos
						foreach face pane [
							face/offset: pos/1/1
							pos: next pos
						]
					]
				]
			]
			ex/pane: copy []
			foreach pos first walls [
				append ex/pane make stone [offset: pos - 1x1 * stone/size]
			]
			change walls ex
			stoning: copy []
		]
		walls: head walls
		lay: layout [
			backdrop effect [gradient 1x1 100.100.100 0.0.0]
			panel 0.0.0 effect [gradient 0x1 100.0.0 0.80.0] edge [color: gray size: 1x1] [
				size (field-size * stone/size)
				sens: sensor 1x1 rate 2 feel [
					engage: func [face action event /local tmp] [
						switch action [
							time [
								if pause [exit]
								if akt-falling [
									akt-falling/offset: akt-falling/offset + (stone/size * 0x1)
									if not akt-falling/legal? [
										show akt-falling
										append stoning tmp: akt-falling/legal?
										check-lines
										new-start
										if not akt-falling/legal? [akt-falling: none start-button/text: "Start" show start-button]
										eat-queue
										exit
									]
									show akt-falling
								]
							]
						]
					]
				]
			]
			return
			banner "REBtris"
			vh1 "Frank Sievertsen" with [font: [size: 12]]
			panel 0.0.0 [
				size (stone/size * 5x4)
			]
			style button button with [effect: [gradient 1x1 180.180.100 100.100.100]]
			start-button: button "Start" [
				either akt-falling
					[start-button/text: "Start" show start-button akt-falling: none]
					[sens/rate: 2 show sens start-button/text: "Stop" show start-button pause: no points: 0 if points-pane [show points-pane] clear pan/pane clear stoning show pan new-start]
			]
			button "Pause" [pause: not pause]
			vh1 "Level:"
			level-pane: banner "888" feel [
				redraw: func [face] [face/text: to-string level]
			] with [font: [align: 'left]]
			vh1 "Points:"
			points-pane: banner "88888888" feel [
				redraw: func [face /local mem tmp] [
					mem: [1]
					if mem/1 < (tmp: to-integer points / 1000) [level: level + 1 show level-pane sens/rate: level + 1 show sens]
					mem/1: tmp
					face/text: to-string points
				]
			] with [font: [align: 'left]]
		]
		lay/feel: make lay/feel [
			detect: func [face event] [
				if event/type = 'down [system/view/focal-face: none]
				event
			]
		]
		pan: lay/pane/2
		if not pan/pane [pan/pane: copy []]
		preview: lay/pane/5
		if not preview/pane [preview/pane: copy []]
		remove find pan/pane sens
		insert lay/pane sens
	]
	check-lines: func [/local lines full tmp pos] [
		lines: head insert/dup make block! field-size/y 0 field-size/y
		full: copy []
		foreach e stoning [
			e: e / stone/size
			poke lines e/y tmp: (pick lines e/y) + 1
			if tmp = field-size/x [append full e/y]
		]
		sort full
		foreach e full [
			foreach face pan/pane [
				face/del-line e * stone/size/y
			]
			pos: pan/pane
			forall pos [
				while [all [not tail? pos empty? pos/1/pane]]
					[hide pos/1 remove pos]
			]
			points: 100 + points
			show points-pane
		]
		clear stoning
		foreach face pan/pane [
			append stoning face/poses
		]
	]
	akt-column: akt-row: 1
	tabs: [some "^(tab)"]
	end-up: [newline tab end]
	no-stone: [" "
		(akt-column: akt-column + 1)
	]
	one-stone: ["x"
		(append/only last walls to-pair reduce [akt-column akt-row])
		(akt-column: akt-column + 1)
	]
	new-row: [newline tabs
		(akt-row: akt-row + 1)
		(akt-column: 1)
	]
	new-wall: [newline newline tabs
		(akt-row: akt-column: 1)
		(append/only walls copy [])
	]
	eat-queue: func [/local port] [
		port: open [scheme: 'event]
		while [wait [port 0]] [error? try [first port]]
		close port
	]
]

insert-event-func func [face event] bind [
	if all [
		event/type = 'key
		not system/view/focal-face
		find [up down left right #"p"] event/key
		akt-falling
		(not pause) or (event/key = #"p")
	] [
		switch event/key [
		left	[akt-falling/offset: akt-falling/offset - (stone/size * 1x0)]
		right	[akt-falling/offset: akt-falling/offset + (stone/size * 1x0)]
		down	[akt-falling/offset: akt-falling/offset + (stone/size * 0x1)]
		up	[akt-falling/rotate]
		#"p"	[pause: not pause]
		]
		akt-falling/legal?
		show akt-falling
		return none
	]
	event
] in rebtris 'self

if any [not system/script/args empty? form system/script/args] [
	random/seed now
	rebtris/init
	view rebtris/lay
]