REBOL [
	Title: "Tile Game"
	Date: 15-May-2000
	Author: "Sterling Newton"
	Purpose: "Classic tile sliding game in less than a page of code."
	File: %tile-game.r
	Category: [view vid 4]
]

space-grid: 4x4
space-pos: 3 * 40x40
btn-color: 100.150.150

grid-styles: stylize [
	tile: button 40x40 100.150.150 edge [size: 2x2 effect: 'bevel][
		if any [all [face/grid/y = space-grid/y 1 = absolute face/grid/x - space-grid/x]
				all [face/grid/x = space-grid/x 1 = absolute face/grid/y - space-grid/y]][
			temp: face/grid
			face/grid: space-grid
			space-grid: temp
			old-offset: temp: face/offset
			face/offset: space-pos
			space-pos: temp
		]
	] with [
		grid: 0x0
		effect: reduce ['gradient 0x1 btn-color btn-color / 10]
	]
]

tiles: [t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15]
reverse tiles

view out: layout/size [
	styles grid-styles
	origin 0x0 space 0x0 across
	t15: tile "15"  t14: tile "14"  t13: tile "13"  t12: tile "12" return
	t11: tile "11"  t10: tile "10"  t9:  tile "9"   t8:  tile "8" return
	t7:  tile "7"   t6:  tile "6"   t5:  tile "5"   t4:  tile "4" return
	t3:  tile "3"   t2:  tile "2"   t1:  tile "1"   go:  tile "GO!" 200.0.0 effect [] [
		tile: reduce tiles
		for y 1 4 1 [
			for x 1 4 1 [
				all [x = 4 y = 4 break]
				w: get first tiles tiles: next tiles
				w/grid: to-pair reduce [x y]
			]
		]
		remove find out/pane go
		show out
	]
] 160x160