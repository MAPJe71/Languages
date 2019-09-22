/*****************************************************************************

                        Copyright (c) Becerril 2003 Private

******************************************************************************/

implement engine
    open core
    resolve
    shellExecute externally from "Shell32",
    getDesktopWindow externally  from "User32"
    constants
        className = "engine/engine".
        classVersion = "".

    clauses
        classInfo(className, classVersion).
  constants
% sW_SHOWMAXIMIZED = 3.
% sW_SHOWMINIMIZED = 2.
% sW_SHOWMINNOACTIVE = 7.
% sW_SHOWNA = 8.
% sW_SHOWNOACTIVATE = 4.
% sW_SHOWNORMAL = 1.
 empty=0.
% quote_D_F=1.
 quote_D_T=2.
% quote_S_F=3.
% quote_S_T=4.
% com_F=5.
 com_T=6.
 s_com=7.
 green="<font color=\"Green\">".
 navy="<font color=\"Navy\"><b>".
 blue="<font color=\"Blue\">".
 red="<font color=\"#993333\">".
 redred="<font color=\"Red\">".
 darkGreen="<font color=\"#808000\"><b>".
 endDG="</b></Font>".
 endx="</Font>".

 class facts
    check:integer:=empty.


    clauses

    clauses
    reserved("class").
    reserved("clauses").
    reserved("constants").
    reserved("constructors").
    reserved("div").
    reserved("domains").
    reserved("end").
    reserved("facts").
    reserved("from").
    reserved("implement").
    reserved("interface").
    reserved("inherits").
    reserved("goal").
    reserved("guards").
    reserved("mod").
    reserved("monitor").
    reserved("open").
    reserved("predicates").
    reserved("resolve").
    reserved("supports").

 clauses

     reserved2("align").
     reserved2("and").
     reserved2("as").
     reserved2("bitsize").
     reserved2("determ").
     reserved2("digits").
     reserved2("erroneous").
     reserved2("externally").
     reserved2("failure").
     reserved2("language").
     reserved2("multi").
     reserved2("nondeterm").
     reserved2("or").
     reserved2("procedure").
     reserved2("reference").
     reserved2("single").


     reserved3("include").
     reserved3("requires").
     reserved3("#").

 clauses
  formating(InputFile,OutputFile):-
         %trap(Input=inputStream_file::openFile8(InputFile),TraceId,(exception::clear(TraceId),fail)),
         trap(InputString = file::readString(InputFile, _Unicode),_TraceId,fail),
         Input=inputStream_string::new(InputString),
         stdIO::setInputStream(Input),
         trap(Output=outputStream_file::append8(Outputfile),_TraceIdAppend,fail),
         stdIO::setOutputStream(Output),
         stdIO::write("<pre>","<font face=\"Arial\" size=\"2\" >"),
         engine::parsing( Input),
         stdIO::write(endx,"</pre>"),
         Input:close(),
         Output:close(),
         vpiCommonDialogs::note("Done !").

    formating(_,_):-
          vpiCommonDialogs::note("Please select a file."),!.

        parsing(InputStream):-
              InputStream:endOfStream(),!.

        parsing(InputStream):-
              stdIO::readLine()=Line,
              engine::myRead(Line),
              stdIO::write("<br>"),
              engine::parsing(InputStream).

    parsing(_InputStream).



   myRead(Line):-
     check=empty,
     string::frontToken(Line,XX,Rest),
     string::toLowerCase(XX)=Lower,
     reserved(Lower),
     stdIO::write(darkGreen,XX," ",endDG),
     myRead(Rest).

 myRead(Line):-
     check=empty,
     string::frontToken(Line,XX,Rest),
     string::toLowerCase(XX)=Lower,
     reserved2(Lower),
     stdIO::write(navy,XX," ",endDG),
     myRead(Rest).


 myRead(Line):-
     check=empty,
     string::frontToken(Line,XX,Rest),
     string::toLowerCase(XX)=Lower,
     reserved3(Lower),
     stdIO::write(red,XX," ",endDG),
     myRead(Rest).

 myRead(Line):-

     string::frontToken(Line,XX,Rest),
     string::frontchar(XX,CAP,_),
     OO=uncheckedConvert(integer16,CAP),
     OO=60, % <=37
     stdIO::write("&lt;"),
     myRead(Rest).

 myRead(Line):-
     string::frontToken(Line,XX,Rest),
     string::frontchar(XX,CAP,_),
     uncheckedConvert(integer16,CAP)=OO,
     OO=62, % >=37
     stdIO::write("&gt;"),
     myRead(Rest).


 myRead(Line):-
    string::frontToken(Line,XX,Rest),
    string::frontToken(Rest,X2,Rest2),
    XX="\\",
    X2=ANY,
    string::concat("\\",ANY)=Escape,
    stdIO::write(Escape),
    myRead(Rest2).

 myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontToken(Rest,X2,Rest2),
    XX="/",
    X2="*",
    blueC("/*"),

    check:=com_T,
    myRead(Rest2).

myRead(Line):-
    check=com_T,
    string::frontToken(Line,XX,Rest),
    string::frontToken(Rest,X2,Rest2),
    XX="*",
    X2="/",
    blueC("*/"),
    check:=empty,
    myRead(Rest2).

  myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    CAP='(',
    stdIO::write(red,XX,endx),
    myRead(Rest).

  myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    CAP=')',
    stdIO::write(red,XX,endx),
    myRead(Rest).

  myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    CAP=';',
    stdIO::write(redred,XX,endx),
    myRead(Rest).

 myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    CAP='@',
    stdIO::write(blue,XX,endx),
    myRead(Rest).

  myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    uncheckedConvert(integer16,CAP)=OO,
    OO=34,  %  "=34
    stdIO::write(blue,XX),
    check:=quote_D_T,
    myRead(Rest).

myRead(Line):-
    check=quote_D_T,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    uncheckedConvert(integer16,CAP)=OO,
    OO=34,  %  "=34
    blueC(XX),
    check:=empty,
    myRead(Rest).

 myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    uncheckedConvert(integer16,CAP)=OO,
    OO=39,  % '=39
    stdIO::write(bLUE,XX),
    check:=quote_D_T,
    myRead(Rest).

myRead(Line):-
    check=quote_D_T,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    uncheckedConvert(integer16,CAP)=OO,
    OO=39,  % '=39
    blueC(XX),
    check:=empty,
    myRead(Rest).


 myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontToken(Rest,Next,Rest2),
    string::length(Line)=Len0,
    string::length(Rest)=Len,
    string::length(XX)=Len2,
    string::length(Next)=Len3,
    string::length(Rest2)=Len4,
    Len+Len2=Len1,
    Len1-(Len2+Len3+Len4)=COSA,
    Len0-Len1=Indent,
    engine::writeSpaces(Indent,0),
    string::frontchar(XX,CAP,_),
    uncheckedConvert(integer16,CAP)=OO,
    OO<97,  % a=97, _=95
    OO>64, % A=65
    stdIO::write(gREEN,XX,endx),
    engine::writeSpaces(COSA,0),
    string::concat(NExt,Rest2)=ReST3,
    myRead(Rest3).

  myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    uncheckedConvert(integer16,CAP)=OO,
    OO<97,  % a=97, _=95
    OO>64, % A=65
    stdIO::write(gREEN,XX,endx),
    myRead(Rest).


myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    uncheckedConvert(integer16,CAP)=OO,
    OO>47, % 0=48
    OO<58, % 9=57
    stdIO::write(bLUE,XX,endx),
    myRead(Rest).

 myRead(Line):-
    check=empty,
    string::frontToken(Line,XX,Rest),
    string::frontchar(XX,CAP,_),
    uncheckedConvert(integer16,CAP)=OO,
    OO=37, % %=37
    stdIO::write(bLUE,XX),
    check:=s_com,
    read2(Rest).


 myRead(Line):-
    string::frontToken(Line,XX,Rest),
    string::frontToken(Rest,Next,Rest2),
    string::length(Line)=Len0,
    string::length(Rest)=Len,
    string::length(XX)=Len2,
    string::length(Next)=Len3,
    string::length(Rest2)=Len4,
     Len+Len2=Len1,
     Len1-(Len2+Len3+Len4)=COSA,
     Len1-Len0=Indent,
     writeSpaces(Indent,0),
     stdIO::write(XX),
     writeSpaces(COSA,0),
     string::concat(NExt,Rest2)=ReST3,
     myRead(Rest3).



 myRead(X):-
     string::frontToken(X,XX,Rest),
     stdIO::write(XX),
     myRead(Rest).

 myRead(_):-
     stdIO::write("&nbsp;").


 %myRead(_Line):-!.

 read2(X):-
      string::frontToken(X,XX,Rest),
      stdIO::write(" ",XX),
      read2(Rest).

 read2(_):-
      stdIO::write(endx),
      check:=empty.

 blueC(XX):-
     check=empty,
     XX="/*",
     stdIO::write(blue,XX).


 blueC(XX):-
     check<>empty,
     stdIO::write(XX,endx).

 writeSpaces(COSA,Num):-
     Num<COSA,
     stdIO::write("&nbsp;"),
     Num2=Num+1,
     writeSpaces(COSA,Num2).

 writeSpaces(_,_):-!.

end implement engine
