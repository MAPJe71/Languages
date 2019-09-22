#!/bin/bash
# ============================================================================
#             GNU-AS LANGUAGE DEFINITION BUILDER FOR NOTEPAD++
#                       rom1nux - 14/11/2014
# ============================================================================
# This script build notepad++ compatible user language definition file for the
# GNU assembler (GAS) from binutils sources files. 
# ============================================================================
# Usage :
#  1 - Configure script with a good binutils directory path (BINUTILS_DIR)
#  2 - Run the script for all or one supported language
#  3 - Go to Notepad++ > Language > Define your language > Import
#  4 - Select the generated xml file
#  5 - Restart Notepad++
# Notes :
#  - If you install several languages definitions you need to switch it manually because
#    all use .S and .s extension.
#  - You can got color confusion with '#' line comment and '#...' preprocessor definition.
#    (You probably must dont use the '#' for line comment.)
#  - Arm definition is not completed yet.
# ============================================================================
#  2014-11-18 - V0.03
#   - Minors corrections, arm source checking
#  2014-11-16 - V0.02
#   - Add support for multiple platform
#   - Add arm base support
#  2014-11-14 - V0.01
#   - Writing code base
# ============================================================================
# arm support is not completed yet, unrognized :
# * Registers :
#   	a1,a2,a3,a4,v1,v2,v3,v4,v5,v6,v7,v8,wr,sb
#		wcid,wcgr0,wcgr1,wcgr2,wcasf,wibble
#		apsr,cpsr,spsr,apsr_nzcvq,cpsr_f,spsr,apsr_nzcvqg,iapsr,eapsr,primask,iapsr_g,basepri_max
#		xpsr_nzcvq,iapsr_nzcvq,xpsr_nncvq,xpsr_nzcv,spsr,primask_nzcvq
#		cpsr_fs,cpsr_fx,cpsr_fc,cpsr_sf,cpsr_sx,cpsr_sc, cpsr_xf,cpsr_xs,cpsr_xc,cpsr_cf,cpsr_cs,cpsr_cx,
# * Directives :
#		.dcb.d
#		.fini_array
#   	.syntax unified 
#		%function, %progbits
# * Opcodes :
#		popret,
#		it ge,ittt ge,
#   	asl,rrx,lsl,
#   	movne,moval,moveq,movlt,movge,movle,movgt,movcc,movcs,movmi,movpl,movvs,
#   	movvc,movhi,movls,movhs,movul,movuls,moveq,
#   	ldralt,ldreq,ldrmi,ldgesb,ldgesh,ldrd,ldr.n,ldr.w,ldrge,ldrt,ldsgeb,ldsgeh,
#		ldrbt,ldclpl
#		nopge,
#		strd,strbt,stclpl,stmfd
#   	wxorne,wzeroge,
#		wmadduxgt,wmadduneq,wmaddsxne,wmaddsnge,torvscbgt,torvschne,torvscweq,
#		wabsbgt,wabsdiffbgt,waddbhusmgt,waddbhuslgt,waddsubhxlt,waddsubhxeq,waddsubhxgt,
#		wavg4gt,wavg4rgt,wmergegt,wmiatteq,wmiatbgt,wmiabtne,wmiabbgt,wmiattneq,wmiatbnne,
#		wmiabtngt,wmiabbneq,wmiawtteq,wmiawtbgt,wmiawbtne,wmiawbbgt,wmiawttnne,wmiawtbngt,
#		wmiawbtneq,wmiawbbnne,wmulwumeq,wmulwumrgt,wmulwsmne,wmulwsmreq,wmulwlgt,wmulwlge,
#		wqmiattne,wqmiattneq,wqmiatbgt,wqmiatbnge,wqmiabtne,wqmiabtneq,wqmiabbgt,wqmiabbnne,
#		wqmulmgt,wqmulmreq,wqmulwmgt,wqmulwmreq,wsubaddhxgt,wldrwgt,wstrwgt,
#		cfldrseq,cfldrsmi,cfldrsvc,cfldrslt,cfldrscc,fldrscs,cfldrsls,cfldrsle,cfldrsvs,
#		cfldrscc,cfldrdcs,cfldrdls,cfldrdle,cfldrdvs,cfldrdcc
# 		cfldr32cs,cfldr32ls,cfldr32le,cfldr32vs,cfldr32cc,cfldr64cs,cfldr64ls,cfldr64le,cfldr64vs,cfldr64cc
#		cfstrscs,cfstrsls,cfstrsle,cfstrsvs,cfstrscc,cfstrdcs,cfstrdls,cfstrdle,cfstrdvs,cfstrdcc
#		cfstr32cs,cfstr32ls,cfstr32le,cfstr32vs,cfstr32cc,cfstr64cs,cfstr64ls,cfstr64le,cfstr64vs,cfstr64cc,
#		cfmvsrcs,cfmvsrpl,cfmvsrls,cfmvsrcc	mvf8,cfmvsrvc,cfmvrsgt,cfmvrseq,cfmvrsal,cfmvrsge,etc...
#		vldreq.32,vmovlt.16,vmovge,vmovcc,vmovne.32,vmovcs,vmovcc,vdupeq.32,vmov.f32,vmov.8,vmov.16,vmov.32,vld1.8,vst2.8,vld4.64,vorr.i32
#		mov_imm
#		vmoveq 
# ============================================================================

# ========================
#      CONFIGURATION
# ========================

# Binutils directory
BINUTILS_DIR=/usr/src/binutils-2.24
# User definition language xml file
LANGUAGE_FILE_PREFIX="gnuas_"
# Language name previx
LANGUAGE_NAME_PREFIX="GNU AS "
# Language extentions (without dot)
LANGUAGE_EXTS="S s"
# Hash (#) beavior (0: Preprocessor macro, 1: line comment)
OPTION_HASH_IS_LINE_COMMENT=0
# Colors
DEFAULT_FG_COLOR="000000"
DEFAULT_BG_COLOR="FFFFFF"
COMMENTS_FG_COLOR="008000"
COMMENTS_BG_COLOR="FFFFFF"
LCOMMENTS_FG_COLOR="008000"
LCOMMENTS_BG_COLOR="FFFFFF"
NUMBERS_FG_COLOR="0080FF"
NUMBERS_BG_COLOR="FFFFFF"
REGISTERS_FG_COLOR="FF8040"
REGISTERS_BG_COLOR="FFFFFF"
OPCODES_FG_COLOR="0000FF"
OPCODES_BG_COLOR="FFFFFF"
DIRECTIVES_FG_COLOR="FF00FF"
DIRECTIVES_BG_COLOR="FFFFFF"
ARCHS_FG_COLOR="8000FF"
ARCHS_BG_COLOR="EBEBEB"
OPERATORS_FG_COLOR="FF0000"
OPERATORS_BG_COLOR="FFFFFF"
STRINGS_FG_COLOR="8000FF"
STRINGS_BG_COLOR="FFFFFF"
BRACKETS_FG_COLOR="000000"
BRACKETS_BG_COLOR="FFFFFF"
SBRACKETS_FG_COLOR="000000"
SBRACKETS_BG_COLOR="FFFFFF"
CBRACKETS_FG_COLOR="000000"
CBRACKETS_BG_COLOR="FFFFFF"
PREPROCS_FG_COLOR="804000"
PREPROCS_BG_COLOR="FFFFFF"


# ========================
#      SCRIPT DATA
# ========================

# Script title
SCRIPT_TITLE="NOTEPAD++ GNU-AS USER DEFINED LANGUAGE BUILDER"
# Script version
SCRIPT_VERSION="0.03"
# Supported formats
SCRIPT_SUPPORTS="all|i386|arm"
# Hash colors
HASH_FG_COLOR=""
HASH_BG_COLOR=""

# ========================
#        FUNCTIONS
# ========================

# Die on error
function die()
{
	echo -e "ERROR : ${@}"
	exit 1
}

# Write UDL (XML) file	
function write_output_file()
{	
	# Building file
	echo "-Building xml file..."
	echo "<NotepadPlus>
		<UserLang name=\"${2}\" ext=\"${LANGUAGE_EXTS}\" udlVersion=\"2.1\">
			<Settings>
				<Global caseIgnored=\"no\" allowFoldOfComments=\"yes\" foldCompact=\"no\" forcePureLC=\"0\" decimalSeparator=\"0\" />
				<Prefix Keywords1=\"no\" Keywords2=\"no\" Keywords3=\"no\" Keywords4=\"no\" Keywords5=\"no\" Keywords6=\"no\" Keywords7=\"no\" Keywords8=\"no\" />
			</Settings>
			<KeywordLists>
				<Keywords name=\"Comments\">00// 00@ 00# 01\ 02((EOL))((EOL)) 03/* 04*/</Keywords>
				<Keywords name=\"Numbers, prefix1\"></Keywords>
				<Keywords name=\"Numbers, prefix2\">0x 0b #</Keywords>
				<Keywords name=\"Numbers, extras1\">A B C D E F a b c d e f</Keywords>
				<Keywords name=\"Numbers, extras2\"></Keywords>
				<Keywords name=\"Numbers, suffix1\"></Keywords>
				<Keywords name=\"Numbers, suffix2\"></Keywords>
				<Keywords name=\"Numbers, range\"></Keywords>
				<Keywords name=\"Operators1\">${HOPERATORS}</Keywords>
				<Keywords name=\"Operators2\"></Keywords>
				<Keywords name=\"Folders in code1, open\"></Keywords>
				<Keywords name=\"Folders in code1, middle\"></Keywords>
				<Keywords name=\"Folders in code1, close\"></Keywords>
				<Keywords name=\"Folders in code2, open\"></Keywords>
				<Keywords name=\"Folders in code2, middle\"></Keywords>
				<Keywords name=\"Folders in code2, close\"></Keywords>
				<Keywords name=\"Folders in comment, open\"></Keywords>
				<Keywords name=\"Folders in comment, middle\"></Keywords>
				<Keywords name=\"Folders in comment, close\"></Keywords>
				<Keywords name=\"Keywords1\">${REGISTERS}</Keywords>
				<Keywords name=\"Keywords2\">${OPCODES}</Keywords>
				<Keywords name=\"Keywords3\">${DIRECTIVES}</Keywords>
				<Keywords name=\"Keywords4\">${ARCHS}</Keywords>
				<Keywords name=\"Keywords5\">${PREPROCS}</Keywords>
				<Keywords name=\"Keywords6\"></Keywords>
				<Keywords name=\"Keywords7\"></Keywords>
				<Keywords name=\"Keywords8\"></Keywords>
				<Keywords name=\"Delimiters\">00&quot; 01 02&quot; 03( 04 05) 06[ 07 08] 09{ 10 11} 12 13 14 15 16 17 18 19 20 21 22 23</Keywords>
			</KeywordLists>
			<Styles>
				<WordsStyle name=\"DEFAULT\" fgColor=\"${DEFAULT_FG_COLOR}\" bgColor=\"${DEFAULT_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"COMMENTS\" fgColor=\"${COMMENTS_FG_COLOR}\" bgColor=\"${COMMENTS_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"LINE COMMENTS\" fgColor=\"${HASH_FG_COLOR}\" bgColor=\"${HASH_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"NUMBERS\" fgColor=\"${NUMBERS_FG_COLOR}\" bgColor=\"${NUMBERS_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"KEYWORDS1\" fgColor=\"${REGISTERS_FG_COLOR}\" bgColor=\"${REGISTERS_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"KEYWORDS2\" fgColor=\"${OPCODES_FG_COLOR}\" bgColor=\"${OPCODES_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"KEYWORDS3\" fgColor=\"${DIRECTIVES_FG_COLOR}\" bgColor=\"${DIRECTIVES_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"KEYWORDS4\" fgColor=\"${ARCHS_FG_COLOR}\" bgColor=\"${ARCHS_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"KEYWORDS5\" fgColor=\"${PREPROCS_FG_COLOR}\" bgColor=\"${PREPROCS_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"KEYWORDS6\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"KEYWORDS7\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"KEYWORDS8\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"OPERATORS\" fgColor=\"${OPERATORS_FG_COLOR}\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"FOLDER IN CODE1\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"FOLDER IN CODE2\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"FOLDER IN COMMENT\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"DELIMITERS1\" fgColor=\"${STRINGS_FG_COLOR}\" bgColor=\"${STRINGS_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"DELIMITERS2\" fgColor=\"${BRACKETS_FG_COLOR}\" bgColor=\"${BRACKETS_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"117701887\" />		
				<WordsStyle name=\"DELIMITERS3\" fgColor=\"${SBRACKETS_FG_COLOR}\" bgColor=\"${SBRACKETS_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"117701887\" />
				<WordsStyle name=\"DELIMITERS4\" fgColor=\"${CBRACKETS_FG_COLOR}\" bgColor=\"${CBRACKETS_BG_COLOR}\" fontName=\"\" fontStyle=\"0\" nesting=\"117701887\" />
				<WordsStyle name=\"DELIMITERS5\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"DELIMITERS6\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"DELIMITERS7\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
				<WordsStyle name=\"DELIMITERS8\" fgColor=\"000000\" bgColor=\"FFFFFF\" fontName=\"\" fontStyle=\"0\" nesting=\"0\" />
			</Styles>
		</UserLang>
	</NotepadPlus>" > "${1}"
	echo " File '${1}' ready !"
}

# Build all supported format
function build_all()
{
	# Loop through all format
	for format in $(echo ${SCRIPT_SUPPORTS}|tr '|' ' ')
	do
		[ "${format}" == "all" ] && continue;
		build_${format}
	done
}

# ========================
#          i386
# ========================
function build_i386()
{
	# Define format
	SCRIPT_FORMAT="i386"
	SCRIPT_UFORMAT=$(echo ${SCRIPT_FORMAT}|tr '[:lower:]' '[:upper:]')
	
	echo -e "\n      [${SCRIPT_UFORMAT}]"
	
	# Build registers list
	echo "-Building registers list..."
	filename=${BINUTILS_DIR}/opcodes/i386-reg.tbl
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	REGISTERS=$(grep  -v -e '^$' -e '//' ${filename}|cut -d',' -f1|sort|uniq|tr '\n' ' ')
	NREGISTERS=$(echo ${REGISTERS}|wc -w)
	echo " ${NREGISTERS} registers"
	#echo ${REGISTERS}

	# Build opcodes list
	echo "-Building opcodes list..."
	filename=${BINUTILS_DIR}/opcodes/i386-opc.tbl
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	optcs="";
	while read line; do
		# Extract opcode
		optc=${line/%\,*/}
		# Add optcode
		optcs="${optcs}${optc} "
		# Add opbcode with 'b' suffix
		if [[ ${line} != *No_bSuf* ]]; then
			optcs="${optcs}${optc}b "
		fi
		# Add opbcode with 'w' suffix
		if [[ ${line} != *No_wSuf* ]]; then
			optcs="${optcs}${optc}w "
		fi
		# Add opbcode with 'l' suffix
		if [[ ${line} != *No_lSuf* ]]; then
			optcs="${optcs}${optc}l "
		fi
		# Add opbcode with 's' suffix
		if [[ ${line} != *No_sSuf* ]]; then
			optcs="${optcs}${optc}s "
		fi
		# Add opbcode with 'q' suffix
		if [[ ${line} != *No_qSuf* ]]; then
			optcs="${optcs}${optc}q "
		fi	
	done < <(grep  -v -e '^$' -e '//' ${filename})
	OPCODES=$(echo ${optcs}|tr ' ' '\n'|sort|uniq|tr '\n' ' ')
	NOPCODES=$(echo ${OPCODES}|wc -w)
	echo " ${NOPCODES} opcodes"
	#echo ${OPCODES}

	# Building directives list
	echo "-Building directives list..."
	dirctvs=""
	# Common directives
	filename=${BINUTILS_DIR}/gas/read.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(grep -e '  {"' ${filename}|cut -d'"' -f2|grep -v -e '\.')"
	# elf directives
	filename=${BINUTILS_DIR}/gas/config/obj-elf.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(grep -e '  {"' ${filename}|cut -d'"' -f2)"
	# aout directives
	filename=${BINUTILS_DIR}/gas/config/obj-aout.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(grep -e '  {"' ${filename}|cut -d'"' -f2)"
	# coff directives
	filename=${BINUTILS_DIR}/gas/config/obj-coff.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(grep -e '  {"' ${filename}|cut -d'"' -f2)"
	# i386 directives
	filename=${BINUTILS_DIR}/gas/config/tc-i386.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(grep -e '  {"' ${filename}|grep -v -e 'OPTION'|cut -d'"' -f2)"
	# Add dot front of the directives
	dotdirctvs=""
	while read line; do	
		# Add dot to directive
		dotdirctvs="${dotdirctvs}.${line} "
	done < <(echo ${dirctvs}|tr ' ' '\n')
	#echo $dotdirctvs
	DIRECTIVES=$(echo ${dotdirctvs}|tr ' ' '\n'|sort|uniq|tr '\n' ' ')
	NDIRECTIVES=$(echo ${DIRECTIVES}|wc -w)
	echo " ${NDIRECTIVES} directives"
	#echo ${DIRECTIVES}

	# Building operators list
	echo "-Building operators list..."
	OPERATORS="* / << >> | & ^ ! + - == <> != < > >= <= && || ~ $ , ; : ( ) [ ] { } = %" 
	NOPERATORS=$(echo ${OPERATORS}|wc -w)
	echo " ${NOPERATORS} operators"
	#Contvert html entities
	HOPERATORS=${OPERATORS}
	HOPERATORS="$(echo "${HOPERATORS}"|sed "s/\&/\&amp;/g")"	# &	-> &amp;
	HOPERATORS="$(echo "${HOPERATORS}"|sed "s/</\&lt;/g")"	# < -> &lt;
	HOPERATORS="$(echo "${HOPERATORS}"|sed "s/>/\&gt;/g")"	# > -> &gt;
	#echo ${OPERATORS}
	#echo "${HOPERATORS}"

	# Building archs list
	echo "-Building archs list..."
	# i386 directives
	filename=${BINUTILS_DIR}/gas/config/tc-i386.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	ARCHS=$(grep -e '  { STRING_COMMA_LEN ("' ${filename}|grep -e 'PROCESSOR_'|cut -d'"' -f2|sort|uniq|tr '\n' ' ')
	NARCHS=$(echo ${ARCHS}|wc -w)
	echo " ${NARCHS} archs"
	#echo ${ARCHS}
	
	# Building preprocessor directive list
	echo "-Building preprocessor directives list..."
	PREPROCS="#define #undef #ifdef, #ifndef #if #endif #else #elif #line #error #include #pragma __FILE__ __LINE__ __DATE__ __TIME__ __ASSEMBLER__" 
	NPREPROCS=$(echo ${PREPROCS}|wc -w)
	echo " ${NPREPROCS} preprocessor directives"
	
	# Write output file
	filename="${LANGUAGE_FILE_PREFIX}${SCRIPT_FORMAT}.xml"
	name="${LANGUAGE_NAME_PREFIX}${SCRIPT_FORMAT}"
	write_output_file "${filename}" "${name}"
}


# ========================
#          ARM
# ========================
# Currently under construction
function build_arm()
{
	# Define format
	SCRIPT_FORMAT="arm"
	SCRIPT_UFORMAT=$(echo ${SCRIPT_FORMAT}|tr '[:lower:]' '[:upper:]')
	
	echo -e "\n      [${SCRIPT_UFORMAT}]"
	
	# Build registers list
	echo "-Building registers list..."
	filename=${BINUTILS_DIR}/opcodes/arm-dis.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"		
	regs=""	
	regs="${regs} $(grep -A 1 -e "Select raw register names" ${filename}|tail -n 1|cut -d'}' -f1|tr -d '{'|tr -d '"'|tr -d ' '|tr ',' ' ')"
	regs="${regs} $(grep -A 1 -e "Select register names used by GCC" ${filename}|tail -n 1|cut -d'}' -f1|tr -d '{'|tr -d '"'|tr -d ' '|tr ',' ' ')"
	regs="${regs} $(grep -A 2 -e 'iwmmxt_regnames\[] =' ${filename}|tail -n 2|tr '\n' ' '|tr -d '{'|tr -d '"'|tr -d ' '|tr ',' ' ')"
	regs="${regs} $(grep -A 2 -e 'iwmmxt_cregnames\[] =' ${filename}|tail -n 2|tr '\n' ' '|tr -d '{'|tr -d '"'|tr -d ' '|tr -d 'reserved'|tr ',' ' ')"	
	REGISTERS=$(echo ${regs}|tr ' ' '\n'|sort|uniq|tr '\n' ' ')	
	NREGISTERS=$(echo ${REGISTERS}|wc -w)
	echo " ${NREGISTERS} registers"
	#echo ${REGISTERS}
	
	# Build opcodes list
	echo "-Building opcodes list..."
	filename=${BINUTILS_DIR}/gas/config/tc-arm.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"	
	OPCODES=$(grep  -e ' tCE(' \
					-e ' tC3(' \
					-e ' tC3w(' \
					-e '  CL(' \
					-e ' TCE(' \
					-e '  CE(' \
					-e '  C3(' \
					-e '  CM(' \
					-e ' TUF(' \
					-e '  UF(' \
					-e '  nUF(' \
					-e '  nCE(' \
					-e '  TUEc(' \
					-e ' cCE(' \
					-e ' cCL(' \
					-e ' NCE(' \
					-e ' nCE(' \
					-e ' nCEF(' \
					-e ' NCEF(' \
					-e ' NUF(' \
					-e ' nUF(' \
					${filename}|cut -d',' -f1|cut -d'(' -f2|tr -d '"'|sort|uniq|tr '\n' ' ')
	NOPCODES=$(echo ${OPCODES}|wc -w)
	echo " ${NOPCODES} opcodes"
	#echo ${OPCODES}
	
	# Building directives list
	echo "-Building directives list..."
	dirctvs=""
	# Common directives
	filename=${BINUTILS_DIR}/gas/read.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(grep -e '  {"' ${filename}|cut -d'"' -f2|grep -v -e '\.')"
	# elf directives
	filename=${BINUTILS_DIR}/gas/config/obj-elf.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(grep -e '  {"' ${filename}|cut -d'"' -f2)"
	# aout directives
	filename=${BINUTILS_DIR}/gas/config/obj-aout.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(grep -e '  {"' ${filename}|cut -d'"' -f2)"
	# coff directives
	filename=${BINUTILS_DIR}/gas/config/obj-coff.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(grep -e '  {"' ${filename}|cut -d'"' -f2)"
	# arm directives
	filename=${BINUTILS_DIR}/gas/config/tc-arm.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	dirctvs="${dirctvs} $(sed -n "/const pseudo_typeS md_pseudo_table/,/;/p" ${filename}|grep -e '  { "'|cut -d',' -f1|cut -d'"' -f2)"
	# Add dot front of the directives
	dotdirctvs=""
	while read line; do	
		# Add dot to directive
		dotdirctvs="${dotdirctvs}.${line} "
	done < <(echo ${dirctvs}|tr ' ' '\n')
	#echo $dotdirctvs
	DIRECTIVES=$(echo ${dotdirctvs}|tr ' ' '\n'|sort|uniq|tr '\n' ' ')
	NDIRECTIVES=$(echo ${DIRECTIVES}|wc -w)
	echo " ${NDIRECTIVES} directives"
	#echo ${DIRECTIVES}	
	
	
	# Building operators list
	echo "-Building operators list..."
	OPERATORS="* / << >> | & ^ ! + - == <> != < > >= <= && || ~ $ , ; : ( ) [ ] { } = %" 
	NOPERATORS=$(echo ${OPERATORS}|wc -w)
	echo " ${NOPERATORS} operators"
	#Contvert html entities
	HOPERATORS=${OPERATORS}
	HOPERATORS="$(echo "${HOPERATORS}"|sed "s/\&/\&amp;/g")"	# &	-> &amp;
	HOPERATORS="$(echo "${HOPERATORS}"|sed "s/</\&lt;/g")"	# < -> &lt;
	HOPERATORS="$(echo "${HOPERATORS}"|sed "s/>/\&gt;/g")"	# > -> &gt;
	#echo ${OPERATORS}
	#echo "${HOPERATORS}"

	# Building archs list
	echo "-Building archs list..."
	filename=${BINUTILS_DIR}/gas/config/tc-arm.c
	! [ -f ${filename} ] && die "File '${filename}' not found !"
	archs=$(grep -e '  ARM_CPU_OPT (' ${filename}|cut -d',' -f1|cut -d'(' -f2|tr -d '"')	
	archs="${archs} $(grep -e '  ARM_ARCH_OPT (' ${filename}|cut -d',' -f1|cut -d'(' -f2|tr -d '"')"
	archs="${archs} $(grep -e '",		FPU_' ${filename}|cut -d',' -f1|cut -d'{' -f2|tr -d '"')"
	ARCHS=$(echo "${archs}"|tr ' ' '\n'|sort|uniq|tr '\n' ' ')
	NARCHS=$(echo ${ARCHS}|wc -w)
	echo " ${NARCHS} archs"
	#echo ${ARCHS}
	
	
	
	# Building preprocessor directive list
	echo "-Building preprocessor directives list..."
	PREPROCS="#define #undef #ifdef, #ifndef #if #endif #else #elif #line #error #include #pragma __FILE__ __LINE__ __DATE__ __TIME__ __ASSEMBLER__" 
	NPREPROCS=$(echo ${PREPROCS}|wc -w)
	echo " ${NPREPROCS} preprocessor directives"
	
	# Write output file
	filename="${LANGUAGE_FILE_PREFIX}${SCRIPT_FORMAT}.xml"
	name="${LANGUAGE_NAME_PREFIX}${SCRIPT_UFORMAT}"
	write_output_file "${filename}" "${name}"
}


# ========================
#           MAIN
# ========================

# Script header
title="  ${SCRIPT_TITLE} V${SCRIPT_VERSION}  "
titlesz=${#title}
bar=$(printf "%${titlesz}s\n"|tr ' ' '-')
echo "${bar}"
echo "${title}"
echo "${bar}"

# Check if binutils is found
! [ -d ${BINUTILS_DIR} ] && die "Directory '${BINUTILS_DIR}' not found !\n(check script configuration)"

# Manage hash behavior
if [ ${OPTION_HASH_IS_LINE_COMMENT} -eq 1 ]; then
	HASH_FG_COLOR=${LCOMMENTS_FG_COLOR}
	HASH_BG_COLOR=${LCOMMENTS_BG_COLOR}
else
	HASH_FG_COLOR=${PREPROCS_FG_COLOR}
	HASH_BG_COLOR=${PREPROCS_BG_COLOR}
fi

# Process command
SCRIPT_CMD="${1}"
if [ "${SCRIPT_CMD}" == "" ]; then
	# Show usage
	echo -e "\nUsage :"
	echo -e "  $(basename $0) [format]"
	echo -e "\nFormat :"
	echo -e "  can be : ${SCRIPT_SUPPORTS}"
elif [[ "${SCRIPT_SUPPORTS}|" == *"${SCRIPT_CMD}|"* ]]; then
	# Call function
	build_${SCRIPT_CMD}
else
	die "Unsupported format '${SCRIPT_CMD}' !"
fi
