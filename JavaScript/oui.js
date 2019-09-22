WScript.Echo("Script Name: " + WScript.ScriptFullName);
BasePath = WScript.ScriptFullName.replace(/^(.+)\\[^\\]+$/i, "$1");
WScript.Echo("Base Path: " + BasePath);

FileSystemObject = WScript.CreateObject("Scripting.FileSystemObject");

TextFile = FileSystemObject.OpenTextFile(BasePath + "\\oui.txt", 1, false, -2); // ForReading, TristateUseDefault

MemoryText = WScript.CreateObject("AlaxInfo.ReplaceInFiles.MemoryText");
MemoryText.Text = TextFile.ReadAll();

FileTextBackupHandler = WScript.CreateObject("AlaxInfo.ReplaceInFiles.FileTextBackupH");

ReplaceText = WScript.CreateObject("AlaxInfo.ReplaceInFiles.ReplaceText");
ReplaceText.GlobalMatch = true;
ReplaceText.RegularExpressions = true;
ReplaceText.IgnoreCase = true;
ReplaceText.Multiline = true;
ReplaceText.FindPatterns = 
  "\"" + "^{[0-9A-F][0-9A-F]}\\-{[0-9A-F][0-9A-F]}\\-{[0-9A-F][0-9A-F]}\\b+\\(hex\\)\\b+{.+?}$" + "\"" + "," +
  "\"" + "^{[^\\{].+}$" + "\"" + "," +
  "";
ReplaceText.ReplacePatterns = 
  "\"" + "{ 0x\\1, 0x\\2, 0x\\3, \"\"\\4\"\" }," + "\"" + "," +
  "\"" + "//\\1" + "\"" + "," +
  "";
ReplaceText.Replace(MemoryText);

HeaderFile = FileSystemObject.CreateTextFile(BasePath + "\\oui.txt.h", true, false);
HeaderFile.Write(MemoryText.Text);

