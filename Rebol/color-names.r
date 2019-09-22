REBOL [
	Title: "REBOL Standard Colors"
	Version: 1.0.1
	Date: 31-Mar-2001
	Author: "Carl Sassenrath"
]

colors:  [
	black  blue    navy   orange gold    tan
	coal   green   leaf   forest brown   coffee
	gray   cyan    teal   aqua   water   sky
	pewter red     maroon brick  crimson pink
	silver magenta purple violet papaya  rebolor
	snow   yellow  olive  oldrab khaki   mint
	white  ivory   linen  beige
]

out: [
	style btn button font-size 11 100x38 [sc/color: face/color show sc]
	across
]

cnt: 1
foreach color colors [
	repend out ['btn color reform [color newline get color]]
	if zero? cnt // 6 [append out 'return]
	cnt: cnt + 1
]

append out [
	sl: slider 208x38 "Multiplier" font [
		color: silver align: 'center valign: 'middle shadow: none][
		mult-color value
	]
	return
	sc: box 650x80 font-size 12 "Click a color to show it here" return
	button 650x40 black "Click here for custom color" [
		face/color: request-color/color any [face/color gray]
		face/texts: reduce [reform face/color]
		show face
	]
]

mult-color: func [factor /local clr n m d] [
	n: 1
	m: max 1 to-integer factor - .5 * 8
	d: max 1 to-integer .5 - factor * 8
	sl/text: reform either factor > .5 [["times" m]][["divided by" d]]
	foreach color colors [
		clr: either factor > .5 [(get color) * m][(get color) / d]
		window/pane/:n/color: clr
		window/pane/:n/texts: reduce [reform [color newline clr]]
		n: n + 1
	]
	show window
]

window: layout out
view window 
