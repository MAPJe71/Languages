/*****************************************************************************

                        Copyright (c) Becerril 2003 Private

******************************************************************************/

implement aboutDialog
    open core, vpiDomains, resourceIdentifiers

    constants
        className = "TaskWindow/aboutDialog".
        classVersion = "".

    clauses
        classInfo(className, classVersion).

    facts
        thisWin : vpiDomains::windowHandle := uncheckedConvert(vpiDomains::windowHandle, 0).
            
    clauses
        show(Parent):-
            _ = vpi::winCreateDynDialog(Parent, controlList, eventHandler, 0).

    predicates
        eventHandler : vpiDomains::ehandler.
    clauses
        eventHandler(Win, Event) = Result :-
            Result = generatedEventHandler(Win, Event).

    predicates
        onCreate : vpiDomains::createHandler.
    clauses
        onCreate(_CreationData) = defaultHandling().
                        
    predicates
        onControlOK : vpiDomains::controlHandler.
    clauses
        onControlOK(_Ctrl, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0) :-
            vpi::winDestroy(thisWin).
                        
    predicates
        onControlCancel : vpiDomains::controlHandler.
    clauses
        onControlCancel(_Ctrl, _CtrlType, _CtrlWin, _CtrlInfo) = handled(0) :-
            vpi::winDestroy(thisWin).

    % This code is maintained automatically, do not update it manually. 14:08:58-9.4.2010
constants
    dialogType : vpiDomains::wintype = wd_modal.
    title : string = "About".
    rectangle : vpiDomains::rct = rct(122,26,266,126).
    dialogFlags : vpiDomains::wsflags = [wsf_Close,wsf_TitleBar].
    dialogFont = "MS Sans Serif".
    dialogFontSize = 8.

constants
    controlList : vpiDomains::windef_list =
        [
        dlgFont(wdef(dialogType, rectangle, title, u_DlgBase),
                dialogFont, dialogFontSize, dialogFlags),
        ctl(wdef(wc_Text,rct(12,36,132,46),"No description",u_DlgBase),idc_dlg_about_st_prj,[wsf_AlignLeft]),
        ctl(wdef(wc_Text,rct(12,46,132,56),"Version 1.0",u_DlgBase),idc_dlg_about_st_nomb,[wsf_AlignLeft]),
        ctl(wdef(wc_Text,rct(12,56,132,66),"Copyright (c) Becerril 2003",u_DlgBase),idc_dlg_about_st_copy,[wsf_AlignLeft]),
        ctl(wdef(wc_Text,rct(12,66,132,76),"Private",u_DlgBase),idc_dlg_about_st_firm,[wsf_AlignLeft]),
        ctl(wdef(wc_GroupBox,rct(4,28,140,80),"",u_DlgBase),idc_cancel,[]),
        icon(wdef(wc_Icon,rct(12,6,24,18),"",u_DlgBase),idc_aboutdialog_1,application_icon,[]),
        ctl(wdef(wc_PushButton,rct(48,84,96,96),"OK",u_DlgBase),idc_ok,[wsf_Default,wsf_Group,wsf_TabStop])
        ].

predicates
    generatedEventHandler : vpiDomains::ehandler.
clauses
    generatedEventHandler(Win, e_create(_)) = _ :-
        thisWin := Win,
        fail.
    generatedEventHandler(_Win, e_Create(CreationData)) = Result :-
        handled(Result) = onCreate(CreationData).
    generatedEventHandler(_Win, e_Control(idc_ok, CtrlType, CtrlWin, CtlInfo)) = Result :-
        handled(Result) = onControlOK(idc_ok, CtrlType, CtrlWin, CtlInfo).
    generatedEventHandler(_Win, e_Control(idc_cancel, CtrlType, CtrlWin, CtlInfo)) = Result :-
        handled(Result) = onControlCancel(idc_cancel, CtrlType, CtrlWin, CtlInfo).
    % end of automatic code
end implement aboutDialog
