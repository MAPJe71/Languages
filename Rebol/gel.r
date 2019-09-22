REBOL [
	Title:  "Cool Effect Gel"
	Author: "Carl Sassenrath"
	Date:   12-Nov-2003 ;2-Apr-2001 ;30-Aug-2000
	Version: 1.4.0
	Needs: [view 1.2.5]
	Purpose: {Power of the REBOL/View engine.}
	; Updated for new View 1.2.x
]

the-image: load-thru/binary http://www.rebol.com/view/demos/palms.jpg

faces: layout [
	size the-image/size
	backdrop the-image
	pad 0x20 space 0x2
	vh2 yellow "Grab the gel and drag it around."
	vtext bold "Click blue button to change effect."
	across
	at the-image/size * 0x1 + 10x-40
	pos: vh1 90x24
	rota: rotary 200 [
		v-face/effect: append copy [merge] load first rota/data
		show v-face
	]
	at 108x92
	v-face: box 100x100 edge [color: 250.120.40 size: 4x4] feel [
		engage: func [f a e] [  ;intercepts target face events
			if find [over away] a [
				pos/text: f/offset: confine f/offset + e/offset - f/data f/size
					0x0 f/parent-face/size
				show [f pos]
			]
			if a = 'down [f/data: e/offset]
		]
	]
]

effects: [
	[invert]
	[contrast 40]
	[colorize 0.0.200]
	[gradcol 1x1 0.0.255 255.0.0]
	[tint 100]
	[luma -80]
	[multiply 80.0.200]
	[grayscale emboss]
	[flip 0x1]
	[flip 1x0]
	[rotate 90]
	[reflect 1x1]
	[blur]
	[sharpen]
]

rota/data: []
foreach e effects [append/only rota/data form e]
v-face/effect: append [merge] first effects

view faces
