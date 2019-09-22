REBOL [
	Title: "Block Diagram"
	Date:  24-Apr-2001
	Author: "Carl Sassenrath"
]

i1: to-image layout [
	origin 0 backcolor white
	style box box font [color: 0.0.0 valign: 'top shadow: none space: 0x4]
		edge [size: 2x2]

	b1: box 180x120 "View / Pro" effect [gradient 0x1 220.160.220 20.0.20]
	at b1/offset + 20x30
	box 140x90 "View" effect [gradient 0x1 160.160.250 0.0.60]
	at b1/offset + 40x60
	box 100x60 "Core" effect [gradient 0x1 250.130.130 80.0.0]
	at b1/offset + 0x118
	image 180x32 "REBOL Client" black
]

i2: to-image layout [
	origin 0 backcolor white
	style box box font [color: 0.0.0 valign: 'top shadow: none space: 0x4]
		edge [size: 2x2]

	b1: box 180x120 "Command" effect [gradient 0x1 220.220.140 20.20.0]
	at b1/offset + 20x30
	box 140x90 "Core / Pro" effect [gradient 0x1 160.250.160 0.60.0]
	at b1/offset + 40x60
	box 100x60 "Core" effect [gradient 0x1 250.130.130 80.0.0]
	at b1/offset + 0x118
	image 180x32 "REBOL Server" black
]

i3: to-image layout [
	origin 0
	backcolor white
	at 0x0 box 40x40 white effect [arrow rotate 270]
	at 110x0 box 40x40 white effect [arrow rotate 90]
	at 24x10 box black 100x20
]

y: i2/size/y - i3/size/y / 2

view layout [
	backcolor white
	across space 0
	image i1
	pad 0x1 * y
	a1: image i3 effect [shadow 255.255.255]
	pad 0x-1 * y
	image i2
	at a1/offset - 0x20
	text "Internet" a1/size font-size 16 bold center 
]