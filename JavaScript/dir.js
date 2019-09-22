
var fso = new ActiveXObject("Scripting.FileSystemObject");
var fldr = fso.getFolder("C:\\Windows");
 
var msg = new Array();
msg.push("Files in \""+ fldr.path +"\" :\r\n\r\n")
 
var ef = new Enumerator(fldr.files);
for( ef.moveFirst(); !ef.atEnd(); ef.moveNext() )
    msg.push(ef.item().name +"\r\n");
 
WScript.echo(msg.join(""));
