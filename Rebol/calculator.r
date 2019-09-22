REBOL [
	Title: "Calculator"
	Version: 1.2.2
	Date:   17-Jun-2005 ;2-Apr-2001
	Author: ["Jeff Kreis" "Allen Kamp" "Carl Sassenrath"]
	Purpose: {Simple numeric calculator.}
	Needs: [1.3.0]
]

auto-clear: true

calculate: does [
	if error? try [text-box/text: form do text-box/text][
		text-box/text: "Error"
		text-box/color: red
	]
	auto-clear: true
	show text-box
]

clear-box: does [
	clear text-box/text
	text-box/color: snow
	auto-clear: false
	show text-box
]

calculator: layout [   
	style btn btn 40x24
	style kc btn red [clear-box]
	style k= btn [calculate]
	style k  btn [
		if auto-clear [clear-box]
		append text-box/text face/text
		show text-box
	]
	origin 10 space 4
	backeffect base-effect
	text-box: field "0" 172x24 bold snow right feel none
	pad 4
	across
	kc "C" keycode [#"C" #"c" page-down]
	k "(" #"("  k ")" #")"  k " / " #"/" return 
	k "7" #"7"  k "8" #"8"  k "9" #"9"  k " * " #"*" return 
	k "4" #"4"  k "5" #"5"  k "6" #"6"  k " - " #"-" return 
	k "1" #"1"  k "2" #"2"  k "3" #"3"  k " + " #"+" return 
	k "0" #"0"  k "-"       k "." #"."
	k= green "=" keycode [#"=" #"^m"] return
	key keycode [#"^(ESC)" #"^q"] [quit]
]

view center-face calculator