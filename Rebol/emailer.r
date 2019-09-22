REBOL [
	Title: "Quick Email Sender"
	Date: 2-Apr-2001
	Author: "Carl Sassenrath"
	Version: 1.0.4
]

lo: [
	style tx label 80x24 right
	style btn button 80x24
	style fld field 300x24
	origin 10x10
	vh4 "Quick Email Message Sender:"
	across space 2x1
	tx "To:"      f-to: fld return
	tx "CC:"      f-cc: fld return
	tx "From:"    f-email: fld return
	tx "Subject:" f-subject: fld return
	tx "Message:" f-msg: area wrap 300x200 return
	below at 10x256 space 0x4
	btn "Send" #"^S" [submit]
	btn "Clear" [clear-all]
	btn "Close" escape [close-em]
]

clear-all: does [
	clear-fields lo
	f-email/text: form system/user/email
	f-msg/line-list: none
	show lo
	focus f-to
]

submit: does [
	sending: flash "Sending..."
	either error? try [
		if empty? f-to/text [error-out-here]
		user: load/all f-to/text
		if not empty? f-cc/text [append user load/all f-cc/text]
		hdr: make system/standard/email [subject: f-subject/text]
		send/header user f-msg/text hdr
	][
		unview/only sending
		request/ok "Error sending email. Check fields and check your network setup."
	][
		unview/only sending
		close-em
		request/ok "Your email has been sent."
	]
]

close-em: does [unview/only lo]

set 'send-text func [
	"Pop up a quick email sender"
	/to "Specify a target address"
	target [string! email!]
	/subject "Specify a subject line"
	what [string!]
	/local req
][
	if block? lo [lo: layout lo  center-face lo none]
	if not all [system/user/email system/schemes/default/host] [
		req: request [{Your email settings are missing from the network preferences.
			Set them now?} "Setup" "Ignore" "Cancel"]
		if none? req [exit]
		if req [set-user]
	]
	clear-all
	if to [f-to/text: copy target]
	if subject [f-subject/text: copy what]
	focus f-to
	view lo
]

either system/script/args [send-text/to system/script/args][send-text]

