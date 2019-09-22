REBOL [
	Title:  "Rebodex"
	Date:    2-April-2001
	Author: "Carl Sassenrath"
	Version: 2.1.0
]

names-path: %names.r ;data file
name-list: none
fields: [name company title work cell home car fax web email smail notes updat]

names: either exists? names-path [load names-path][
	[[name "Carl Sassenrath" title "Founder" company "REBOL Technologies"
	email "carl@rebol.com" web "http://www.rebol.com"]]
]

brws: [
	if not empty? web/text [
		if not find web/text "http://" [insert web/text "http://"]
		error? try [browse web/text]
	]
]
dial: [request [rejoin ["Dial number for " name/text "?  (Not implemented.)"] "Dial" "Cancel"]]

dex-styles: stylize [
	lab: label  60x20 right bold middle font-size 11
	btn: button 64x20 font-size 11 edge [size: 1x1]
	fld: field  200x20 font-size 11 middle edge [size: 1x1]
	inf: info   font-size 11 middle edge [size: 1x1]
	ari: field wrap font-size 11 edge [size: 1x1] with [flags: [field tabbed]]
]

dex-pane1: layout/offset [
	origin 0 space 2x0 across
	styles dex-styles
	lab "Name"    name: fld bold return
	lab "Title"   title: fld return
	lab "Company" company: fld return
	lab "Email"   email: fld return
	lab "Web"     brws web: fld return
	lab "Address" smail: ari 200x72 return
	lab "Updated" updat: inf 200x20 return
] 0x0
updat/flags: none

dex-pane2: layout/offset [
	origin 0 space 2x0 across
	styles dex-styles
	lab "Work #"  dial work: fld 140 return
	lab "Home #"  dial home: fld 140 return
	lab "Cell #"  dial cell: fld 140 return
	lab "Alt #"   dial car:  fld 140 return
	lab "Fax #"   fax: fld 140 return
	lab "Notes"   notes: ari 140x72 return
	pad 136x1 btn "Close" #"^q" [store-entry save-file quit]
] 0x0

dex: layout [
	origin 8x8
	space 0x1
	styles dex-styles
	srch: fld 196x20 bold
	across
	rslt: list 180x150 [
		nt: txt 178x15 middle font-size 11 [
			store-entry curr: cnt find-name nt/text update-entry unfocus show dex
		]
	]
	supply [
		cnt: count + scroll-off
		face/text: ""
		face/color: snow
		if not n: pick name-list cnt [exit]
		face/text: select n 'name  face/font/color: black
		if curr = cnt [face/color: system/view/vid/vid-colors/field-select]
	]
	sl: slider 16x150 [scroll-list] return

	return
	btn "New" #"^n" [new-name]
	btn "Del" #"^d" [delete-name unfocus update-entry search-all show dex]
	btn "Sort" [sort names sort name-list show rslt]
	return
	
	at srch/offset + (srch/size * 1x0)
	bx1: box dex-pane1/size
	bx2: box dex-pane2/size

	return
]

bx1/pane: dex-pane1/pane
bx2/pane: dex-pane2/pane
rslt/data: []
this-name: first names
name-list: copy names
curr: none
search-text: ""
scroll-off: 0

srch/feel: make srch/feel [
	redraw: func [face act pos][
		face/color: pick face/colors face <> system/view/focal-face
		if all [face = system/view/focal-face face/text <> search-text] [
			search-text: copy face/text search-all
			if 1 = length? name-list [this-name: first name-list update-entry show dex]
		]
	]
]

update-file: func [data] [
	set [path file] split-path names-path
	if not exists? path [make-dir/deep path]
	write names-path data
]

save-file: has [buf] [
	buf: reform [{REBOL [Title: "Name Database" Date:} now "]^/[^/"]
	foreach n names [repend buf [mold n newline]]
	update-file append buf "]"
]

delete-name: does [
	remove find/only names this-name
	if empty? names [append-empty]
	save-file
	new-name
]

clean-names: function [][n][
	forall names [
		if any [empty? first names none? n: select first names 'name empty? n][
			remove names
		]
	]
	names: head names
]

search-all: function [] [ent flds] [
	clean-names
	clear name-list
	flds: [name] 
	either empty? search-text [insert name-list names][
		foreach nam names [
			foreach word flds [
				if all [ent: select nam word  find ent search-text][
					append/only name-list nam
					break
				]
			]
		]
	]
	scroll-off: 0
	sl/data: 0
	resize-drag
	scroll-list
	curr: none
	show [rslt sl]
]

new-name: does [
	store-entry
	clear-entry
	search-all
	append-empty
	focus name
;	update-entry
]

append-empty: does [append/only names this-name: copy []]

find-name: function [str][] [
	foreach nam names [
		if str = select nam 'name [
			this-name: nam
			break
		]
	]
]

store-entry: has [val ent flag] [
	flag: 0
	if not empty? trim name/text [
		foreach word fields [
			val: trim get in get word 'text
			either ent: select this-name word [
				if ent <> val [insert clear ent val  flag: flag + 1]
			][
				if not empty? val [repend this-name [word copy val] flag: flag + 1]
			]
			if flag = 1 [flag: 2  updat/text: form now]
		]
		if not zero? flag [save-file]
	]
]

update-entry: does [
	foreach word fields [
		insert clear get in get word 'text any [select this-name word ""]
	]
	show rslt
]

clear-entry: does [
	clear-fields bx1
	clear-fields bx2
	updat/text: form now
	unfocus
	show dex
]

show-names: does [
	clear rslt/data
	foreach n name-list [
		if n/name [append rslt/data n/name]
	]
	show rslt
]

scroll-list: does [
	scroll-off: max 0 to-integer 1 + (length? name-list) - (100 / 16) * sl/data
	show rslt
]

do resize-drag: does [sl/redrag 100 / max 1 (16 * length? name-list)]

center-face dex
new-name
focus srch
show-names
view/new/title dex reform [system/script/header/title system/script/header/version]
insert-event-func [
	either all [event/type = 'close event/face = dex][
		store-entry
		quit
	][event]
]
do-events
