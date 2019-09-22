/*****************************************************************************

                        Copyright (c) Becerril 2003 Private

******************************************************************************/

implement taskWindow
    open core, vpiDomains, resourceIdentifiers

    constants
        className = "TaskWindow/taskWindow".
        classVersion = "".

    clauses
        classInfo(className, classVersion).

    facts
        thisWin : vpiDomains::windowHandle := uncheckedConvert(vpiDomains::windowHandle, 0).

    constants
        mdiProperty : integer = core::b_false.
    clauses
        show():-
            vpi::setAttrVal(attr_win_mdi, mdiProperty),
            vpi::setErrorHandler(vpi::dumpErrorHandler),
            vpi::init(windowFlags, eventHandler, menu, "", title).

    predicates
        eventHandler : vpiDomains::ehandler.
    clauses
        eventHandler(Win, Event) = Result :-
            Result = generatedEventHandler(Win, Event).

%    constants
%        maxMessageLines : integer = 100.
    predicates
        onCreate : vpiDomains::createHandler.
    clauses
        onCreate(_CreationData) = defaultHandling():-
         %   _ = vpiMessage::create(maxMessageLines).  %removes messages window
            vpi::winMove(thisWin,rct(50,250,680,440)).

    predicates
        onHelpAbout : vpiDomains::menuItemHandler.
    clauses
        onHelpAbout(_MenuTag) = handled(0) :-
            AboutDialog = aboutDialog::new(),
            AboutDialog:show(thisWin).

    predicates
        onFileExit : vpiDomains::menuItemHandler.
    clauses
        onFileExit(_MenuTag) = handled(0) :-
            vpi::winDestroy(thisWin).

    predicates
        onSizeChanged : vpiDomains::sizeHandler.
    clauses
        onSizeChanged(_Width, _Height) = defaultHandling():-
            vpiToolbar::resize(thisWin),
            vpiMessage::resize(thisWin).

    predicates
        onUpdate : vpiDomains::updateHandler.

    %Choose background colour.

    clauses
        onUpdate(Rectangle) = defaultHandling():-
            vpi::winClear( thisWin,Rectangle,vpi::getAttrVal(attr_color_btnface)).

    predicates
        onControlTransform : vpiDomains::controlHandler.
    clauses
        onControlTransform(CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0):-
            _ = onFileTransform(convert(vpidomains::menuTag,CtrlID)).

    predicates
        onControlInput : vpiDomains::controlHandler.
    clauses
        onControlInput(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0).


    predicates
        onControlInput1 : vpiDomains::controlHandler.
    clauses
        onControlInput1(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0):-
            FileName =vpiCommonDialogs::getFileName( "*.pro", ["Pro files","*.pro","Ph files","*.ph","I files","*.i","cl files","*.cl","All files","*.*"],
		"Choose PRO file to Transform", [], "", _),
		vpi::winGetCtlHandle(thisWin,idc_input)=Path,
                vpi::winSetText(PATH,FileName),
                FileHtm=fileName::setExtension(Filename, "htm"),
%                replace(Filename)=FileHtm,
                vpi::winGetCtlHandle(thisWin,idc_output)=Path2,
                vpi::winSetText(PATH2,FileHTM),
                !.
           onControlInput1(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0).

%    predicates
%        replace:(string Filename) ->string FileHtm nondeterm.
%    clauses
%        replace(Filename)=FileHtm:-
%            string::replace(Filename,".pro",".htm",string::casePreserve)=FileHTM;
%            string::replace(Filename,".ph",".htm",string::casePreserve)=FileHTM;
%            string::replace(Filename,".i",".htm",string::casePreserve)=FileHTM;
%            string::replace(Filename,".cl",".htm",string::casePreserve)=FileHTM,!.

    predicates
        onControlOutput1 : vpiDomains::controlHandler.
    clauses
        onControlOutput1(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0):-
        _FileName =vpiCommonDialogs::getFileName( "*.htm", ["htm files","*.htm","html files","*.html","All files","*.*"],
		"Choose or name HTM target file.", [], "", _),!.
        onControlOutput1(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0):-!.

    predicates
        onControlTransformAndOpen : vpiDomains::controlHandler.
    clauses
        onControlTransformAndOpen(CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0):-
            _ = onFileTransformAndOpen(convert(vpiDomains::menuTag,CtrlID)).

    predicates
        onControlOutput : vpiDomains::controlHandler.
    clauses
        onControlOutput(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0).

    predicates
        onFileTransform : vpiDomains::menuItemHandler.
        %Get the file paths and names here.
    clauses
        onFileTransform(_MenuTag) = handled(0):-
                vpi::winGetCtlHandle(thisWin,idc_input)=InPath,
                vpi::winGetText(InPath)=Input,
                vpi::winGetCtlHandle(thisWin,idc_output)=OutPath,
                vpi::winGetText(OutPath)=Output,
                engine::formating(Input,Output),
                !.
 %       onFileTransform(_MenuTag) = handled(0).

    constants
        sW_SHOWMAXIMIZED = 3.
    predicates
        onFileTransformAndOpen : vpiDomains::menuItemHandler.
    clauses
        onFileTransformAndOpen(_MenuTag) = handled(0):-
              vpi::winGetCtlHandle(thisWin,idc_input)=InPath,
                vpi::winGetText(InPath)=Input,
                vpi::winGetCtlHandle(thisWin,idc_output)=OutPath,
                vpi::winGetText(OutPath)=Output,
                engine::formating(Input,Output),
                Input<>"",
                Output<>"",
                engine::getDesktopWindow()=Desk,
                engine::shellExecute(Desk,"open",Output,_,_,sW_SHOWMAXIMIZED)=Tok,
                Tok><31,
                !.
        onFileTransformAndOpen(_MenuTag) = handled(0).

    % This code is maintained by the VDE. Do not update it manually, 16:57:36-16.5.2003
    constants
        windowFlags : vpiDomains::wsflags = [wsf_Border,wsf_TitleBar,wsf_Close,wsf_Minimize,wsf_ClipSiblings].
        menu : vpiDomains::menu = resMenu(id_TaskMenu).
        title : string = "Blue&Green".

    predicates
        generatedEventHandler : vpiDomains::ehandler.
    clauses
        generatedEventHandler(Win, e_create(_)) = _ :-
            thisWin := Win,
            _ = vpi::winCreateControl(wc_Edit,rct(15,35,477,64),"",Win,[wsf_AlignLeft,wsf_Group,wsf_TabStop,wsf_AutoHScroll],idc_input),
            _ = vpi::winCreateControl(wc_Edit,rct(15,100,477,130),"",Win,[wsf_AlignLeft,wsf_Group,wsf_TabStop,wsf_AutoHScroll],idc_output),
            _ = vpi::winCreateControl(wc_PushButton,rct(495,35,580,60),"Browse...",Win,[wsf_Group,wsf_TabStop],idc_input1),
            _ = vpi::winCreateControl(wc_PushButton,rct(495,105,580,130),"Browse...",Win,[wsf_Group,wsf_TabStop],idc_output1),
            _ = vpi::winCreateControl(wc_PushButton,rct(16,141,150,165),"Transform",Win,[wsf_Group,wsf_TabStop],idc_transform),
            _ = vpi::winCreateControl(wc_PushButton,rct(234,141,478,165),"Transform and open",Win,[wsf_Group,wsf_TabStop],idc_transform_and_open),
            _ = vpi::winCreateControl(wc_Text,rct(20,10,116,30),"Input:",Win,[wsf_AlignLeft],idct_input),
            _ = vpi::winCreateControl(wc_Text,rct(20,70,116,90),"Output:",Win,[wsf_AlignLeft],idct_output),
            fail.
        generatedEventHandler(_Win, e_Create(CreationData)) = Result :-
            handled(Result) = onCreate(CreationData).
        generatedEventHandler(_Win, e_Update(Rectangle)) = Result :-
            handled(Result) = onUpdate(Rectangle).
        generatedEventHandler(_Win, e_Size(Width, Height)) = Result :-
            handled(Result) = onSizeChanged(Width, Height).
        generatedEventHandler(_Win, e_Menu(id_help_about, _)) = Result :-
            handled(Result) = onHelpAbout(id_help_about).
        generatedEventHandler(_Win, e_Menu(id_file_exit, _)) = Result :-
            handled(Result) = onFileExit(id_file_exit).
        generatedEventHandler(_Win, e_Menu(id_file_transform, _)) = Result :-
            handled(Result) = onFileTransform(id_file_transform).
        generatedEventHandler(_Win, e_Menu(id_file_transform_and_open, _)) = Result :-
            handled(Result) = onFileTransformAndOpen(id_file_transform_and_open).
        generatedEventHandler(_Win, e_Control(idc_transform, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlTransform(idc_transform, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_input, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlInput(idc_input, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_input1, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlInput1(idc_input1, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_output1, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlOutput1(idc_output1, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_transform_and_open, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlTransformAndOpen(idc_transform_and_open, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_output, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlOutput(idc_output, CtrlType, CtrlWin, CtlInfo).
    % end of automatic code
end implement taskWindow
