REBOL [
	Title: "REBOL Face Effect Lab"
	Date: 2-Apr-2001 ;30-Aug-2000
	Version: 1.3.2
	Author: "Carl Sassenrath"
	Purpose: "Show combinations of effects."
]

flash "Fetching image..."
image-data: load read-thru/to http://www.rebol.com/view/demos/nyc.jpg %nyc.jpg
unview

effect: func [effect state /local ef][
    ef: find sample/effect first effect
    if ef [remove/part ef length? effect]
    if state [append sample/effect effect]
    code/text: join "Effect: " mold sample/effect
    show sample
    show code
]

reffect: func [eff stat] [effect reduce eff stat]

main-styles: stylize [
    fld: field 100x24
    banner: image font [size: 18 style: none color: 255.255.100 shadow: 3x3]
]

int: :to-integer

sep: 0x26
a-tuple: func [val] [either error? val: try [to-tuple val][0.0.0][val]]

crop-eff: [reffect ['crop load s10/text load s11/text] s09/data]
grad-eff: [reffect ['gradient load s123/text a-tuple s22/text a-tuple s23/text] s21/data]

gradcol-eff: [reffect ['gradcol load s223/text a-tuple s224/text a-tuple s225/text] s221/data]
gradmul-eff: [reffect ['gradmul load s323/text a-tuple s324/text a-tuple s325/text] s321/data]
colr-eff: [reffect ['colorize a-tuple s13/text] s12/data]
mult-eff: [reffect ['multiply either 0.0.0 = z: a-tuple s17/text 
    [either error? try [z: load to-file s17/text][0.0.0][z]][z]] s16/data]
key-eff:  [reffect ['key a-tuple s15/text] s14/data]
luma-eff: [reffect ['luma load s27/text] s027/data]
tint-eff: [reffect ['tint int (255 * s28/data - 128)] s028/data]
cont-eff: [reffect ['contrast int (255 * s29/data - 128)] s029/data]
gray-eff: [effect [grayscale] s030/data]
invert-eff: [effect [invert] s130/data]
difference-eff: [reffect ['difference either 0.0.0 = z: a-tuple s117/text 
    [either error? try [z: load to-file s17/text][0.0.0][z]][z]] s116/data]
embs-eff: [effect [emboss] s031/data]
rfl-eff:  [effect compose [reflect (load s132/text)] s032/data]
std-eff: func ['effect stat-face val-face][
        reffect [effect a-tuple val-face/text] stat-face/data
]

main: layout [
	styles main-styles
	banner 710x34 reform [system/script/header/title system/script/header/version]
		effect [gradient 0x1 120.0.0 50.0.0]
	space 2
	sample: image image-data 300x300
	code: area wrap "Effect:" 300x50
	across
;	button "Save to Clipboard" 180
;	button "Close"
	return
;	vh3 "put right side in scrolling panel..."
	at sample/offset + (sample/size/x * 1x0) + 6x0
	space 1  guide

	s011: toggle "Image" (a011: [error? try [sample/image: either s011/data [load to-file s010/text][none] show sample]])
	s010: fld "nyc.jpg"       a011
	s001: toggle "Color" (a001: [sample/color: either s001/data [a-tuple s002/text][none] show sample])
	s002: fld "0.0.100"       a001
	return

	s012: toggle "Aspect"   [effect [aspect] s012/data]
	s01: toggle "Fit"       [effect [fit] s01/data]
	s02: toggle "Tile"      [effect [tile] s02/data]
	s03: toggle "Tile-View" [effect [tile-view] s03/data]
	return

	s06: toggle "Flip"  [effect compose [flip (load s07/text)] s06/data]
	s07: fld  "1x0"
	s08: rotary "Rotate" "Rotate 90" "Rotate 180" "Rotate 270" [effect pick [
		[rotate 0][rotate 90][rotate 180][rotate 270]] index? s08/data s08/data <> 1]
	s130: toggle "invert"   invert-eff
	return

	s09: toggle "Crop"     crop-eff
	s10: fld "80x45"       crop-eff
	s11: fld "80x50"       crop-eff
	return

	s04: toggle "Blur"      [effect [blur]    s04/data]
	s05: toggle "Sharpen"   [effect [sharpen] s05/data]

	s030: toggle "Grayscale" gray-eff
	s031: toggle "Emboss"   embs-eff
	return

	s35: toggle "Cross"     [std-eff cross s35 s351]
	s351: fld "255.150.50"  [std-eff cross s35 s351]
	s34: toggle "Oval"      [std-eff oval s34 s341]
	s341: fld "255.150.50"  [std-eff oval s34 s341]
	return

	s12: toggle "Colorize"   colr-eff
	s13: fld "250.150.50"    colr-eff
	s16: toggle "Multiply"   mult-eff
	s17: fld "nyc.jpg"       mult-eff
	return

	s14: toggle "Key"        key-eff
	s15: fld "200.150.50"    key-eff
	s027: toggle "Luma"      luma-eff
	s27: fld "10"            luma-eff
	return

	s21: toggle "Gradient"   grad-eff
	s123: fld "1x1"          grad-eff
	s22: fld "255.20.20"     grad-eff
	s23: fld "20.20.255"     grad-eff
	return

	s221: toggle "Gradcol"   gradcol-eff
	s223: fld "1x1"          gradcol-eff
	s224: fld "0.255.255"    gradcol-eff
	s225: fld "255.0.0"      gradcol-eff
	return

	s321: toggle "Gradmul"   gradmul-eff
	s323: fld "1x1"          gradmul-eff
	s324: fld "0.255.255"    gradmul-eff
	s325: fld "255.0.0"      gradmul-eff
	return

	s028: toggle "Tint"      tint-eff
	s28: slider 100x24       tint-eff

	s029: toggle "Contrast"  cont-eff
	s29: slider 100x24       cont-eff
	return

	s032: toggle "reflect"   rfl-eff
	s132: fld "1x0"          rfl-eff
	s116: toggle "difference" difference-eff
	s117: fld "127.127.127"
	return

	s534: toggle "arrow"    [std-eff arrow s534 s541]
	s541: fld "255.150.50"  [std-eff arrow s534 s541]
	return

;	vh2 "Need to Add:" return
;	button "Grid"
;	button "Round"
;	button "Shadow"
;	return
;	button "Luma"
;	return
;	vh3 "Need palm tree image..."
]

s011/state: s001/state: on
sample/color: 0.0.100
sample/effect: []
view main

