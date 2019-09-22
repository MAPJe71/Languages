//************************************************
// File:    Shortcut.js (WSH sample in JScript)
// Author:  (c) G. Born
//
// Creating a shortcut to the current file in
// the script file's folder
//************************************************

var vbOKCancel = 1;       // Create variables.
var vbInformation = 64;
var vbCancel = 2;

var L_Welcome_MsgBox_Message_Text =
    "Creates a shortcut to this script file in the current folder";
var L_Welcome_MsgBox_Title_Text = "WSH sample - by G. Born";

Welcome();    // Welcome dialog box

// Get script path.
var path = WScript.ScriptFullName;
path = path.substr(0, path.lastIndexOf("\\") + 1);

// Get script filename and strip off extension.
var Lnk_Title = WScript.ScriptName
Lnk_Title = Lnk_Title.substr(0, Lnk_Title.lastIndexOf("."));

// Get WshShell object.
var WshShell = WScript.CreateObject("WScript.Shell");

// Create shortcut object.
var Shortcut = WshShell.CreateShortcut(path + Lnk_Title + ".lnk");

// Set shortcut properties.
Shortcut.TargetPath = WScript.ScriptFullName;
Shortcut.WorkingDirectory = path;
Shortcut.Save();     // Store shortcut file.

WScript.Echo("Shortcut created");

/////////////////////////////////////////////////////////////
//
// Welcome
//
function Welcome()
{
    var WshShell = WScript.CreateObject("WScript.Shell");
    var intDoIt;

    intDoIt =  WshShell.Popup(L_Welcome_MsgBox_Message_Text,
                              0,
                              L_Welcome_MsgBox_Title_Text,
                              vbOKCancel + vbInformation);
    if (intDoIt == vbCancel)
    {
        WScript.Quit(1);   // Cancel selected.
    }
}

//*** End
