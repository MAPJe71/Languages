REBOL [
	Title: "Feedback"
	Author: "Carl Sassenrath"
	Version: 1.0.1
	Date: 2-Jul-2001 ; Better subject line
;	Date: 2-Apr-2001
]

fields: [f-cat f-area f-name f-email f-date f-prod f-vers f-summary f-descrp f-code f-urge]

submit: has [out dt t file] [
	out: rejoin [f-cat/text ": " f-summary/text newline newline]
	foreach f fields [
		repend out [skip form f 2 ": " mold get in get f 'text newline]
	]
	alert either not error? try [send feedback@rebol.net out][
		unview
		"Email has been sent to feedback. Thank you."
	][
		"Email could not be sent. Check network connection and settings."
	]
]

clear-field: func [f] [clear f/text f/line-list: none f/para/scroll: 0x0]

reset-fields: does [
	unfocus
	clear-field f-summary
	clear-field f-descrp
	clear-field f-code
	f-name/text: user-prefs/name ;system/user/name
	f-email/text: form system/user/email
	f-date/text: form now
	f-vers/text: form system/version
	f-urge/data: head f-urge/data
	f-cat/text: first head f-cat/data
	f-area/text: first head f-area/data
	focus f-summary
]

lo: layout [
	style tx label 100x24 right
	style fld field 400x24 
	across space 4x4
	tx "Categories:" f-cat: choice 196x24 "Bug Report" "Enhancement/Idea" "Comment/Praise" "General Question"
	f-area: choice 196x24 "General" "Core Functions" "Networking" "View/Graphics" "Desktop" "Command" "Application" "Documentation" "How To" "Web Site"
	return
	tx "Report From:" f-name: fld 196
	tx "Product:" 74 f-prod: fld 114x24 form system/product
	return 
	tx "Email Address:" f-email: fld 196
	tx "Version:" 74 f-vers: fld 114x24 form system/version 
	return 
	tx "Date/Time:"  f-date: fld 196x24 form now 
	tx "Urgency:" 74 f-urge: rotary 114 leaf "Normal" 200.0.0 "Critical" 40.40.180 "Low" 100.100.100 "Reminder"
	return 
	tx "Summary:" f-summary: fld return 
	tx "Description:" f-descrp: area wrap 400x72 return 
	here: at
	tx "Code Example:" f-code: area 400x72 font [name: font-fixed] return
	pad 106
	button "Send" #"^S" [submit]
;	pad 90
;	button "Clear" [reset-fields show fields]
	button "Cancel" escape [unview/only lo]
]

reset-fields
view center-face lo
