REBOL [
	Title: "Font Lab"
	Version: 1.1.1
	Author: "Carl Sassenrath"
	Date: 31-Mar-2001 ;10-Sep-2000
]

change-styles: func [style start facet subfacet value /local v][
	start: find style/pane start
	foreach f start [
		f: in f facet
		if subfacet <> 'none [f: in get f subfacet]
		either block? value [
			if not block? get f [set f either none? get f [copy []][reduce [get f]]]
			either v: find get f value [remove v][head insert get f value]
		][set f value]
	]
	show style
]

chg: func ['facet 'subfacet value] [change-styles layo norm-start facet subfacet value]
shad: does [chg font shadow sdir * to-integer sl2/data * 16]
sdir: 1x1
sz: 180x40
sx2: sz/x / 2
layo: center-face layout [
	style tgl toggle 60
	style lab vtext bold
	backcolor rebolor
	space 0x5
	across 
	p: choice 180 "Sans-Serif Style" "Serif Style" "Fixed Width Style" 
		[chg font name pick reduce [font-sans-serif font-serif font-fixed] index? p/data]
		return
	tgl "Bold" [chg font style [bold]]
	tgl "Italic" italic [chg font style [italic]]
	tgl "Lined" underline [chg font style [underline]]
	return
	tgl "Left" of 'tg1 [chg font align 'left]
	tgl "Center" of 'tg1 [chg font align 'center]
	tgl "Right" of 'tg1 [chg font align 'right]
	return
	tgl "Top" of 'tg2 [chg font valign 'top]
	tgl "Middle" of 'tg2 [chg font valign 'middle]
	tgl "Bottom" of 'tg2 [chg font valign 'bottom]
	return
	lab "Size:" 60x20 font []
	sl: slider 120x20 [chg font size max 8 to-integer sl/data * 40]
	return
	lab "Space:" 60x20 font []
	sl1: slider 120x20 [chg font space (1x0 * to-integer sl1/data * 20) - 5x0]
	return
	lab "Shadow:" 60x20 font []
	sl2: slider 120x20 [shad]
	return
	lab "Shad Dir:" 60x20
	arrow left  [sdir: sdir * 0x1 + -1x0 shad] pad 6
	arrow right [sdir: sdir * 0x1 + 1x0 shad]  pad 6
	arrow up    [sdir: sdir * 1x0 + 0x-1 shad] pad 6
	arrow down  [sdir: sdir * 1x0 + 0x1 shad]  pad 6
	return
	button sx2 "Text Color" [chg font color request-color]
	button sx2 "Area Color" [chg color none request-color]
	return
	button sx2 "Help" [alert "Click the controls on the left to change text on the right."]
	button sx2 "Close" #"^Q" [quit]
	below
	at p/offset + (p/size * 1x0) + 10x0
	norm-start:
	Title "Title" sz
	h1 "Heading 1" sz
	h2 "Heading 2" sz
	h3 "Heading 3" sz
	h4 "Heading 4" sz
	h5 "Heading 5" sz
	at norm-start/offset + (norm-start/size * 1x0) + 10x0
	banner "Banner" sz
	vh1 "Video Heading 1" sz
	vh2 "Video Heading 2" sz
	vh3 "Video Heading 3" sz
	vtext "Video Text" sz
	text "Document Text" sz
]
sl1/data: .5
sl2/data: .5
chg color none silver - 0.0.10
view/title layo reform ["Font Lab" system/script/header/version]
