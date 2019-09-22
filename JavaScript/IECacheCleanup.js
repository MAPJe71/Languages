//
// Internet Explorer Cache Cleanup
//

var TITLE = "IE Cache Cleanup 2.0";
var wsh   = WScript.CreateObject("WScript.Shell");
var fso   = WScript.CreateObject("Scripting.FileSystemObject");
var env   = wsh.Environment;
var nfiles = 0;
var nbytes = 0;

function delcache(dirname) {
	// Open directory name, catch "not found" error
	try {
		var dir = fso.GetFolder(dirname);
  	} catch(err) { return err; }
	var e;
	// Delete files in the current directory
	for (e = new Enumerator(dir.files); !e.atEnd(); e.moveNext()) {
		var file = e.item();
		try { file.Delete(1); } catch (err) { }
	}
	// Delete subdirectories recursively
	for (e = new Enumerator(dir.SubFolders); !e.atEnd(); e.moveNext()) {
		var folder = e.item();
		delcache(folder);
		try { folder.Delete(1); } catch (err) { }
	}
	return null;
}

function tally(dirname) {
	// Open directory name, catch "not found" error
	try {
		var dir = fso.GetFolder(dirname);
  	} catch(err) { return err; }
	var e;
	// Count number and size of files in this directory
	for (e = new Enumerator(dir.files); !e.atEnd(); e.moveNext()) {
		var file = e.item();
		nbytes += file.Size;
		nfiles++;
	}
	// Count files in the subdirectories as well
	for (e = new Enumerator(dir.SubFolders); !e.atEnd(); e.moveNext()) {
		var folder = e.item();
		tally(folder);
	}
	return null;
}

// Get IE cache directory name from the registry
var IEDIR = "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders\\Cache";
var iecache = "";
try {
	iecache = wsh.RegRead(IEDIR);
} catch(err) {}
if ( iecache && fso.FolderExists(iecache) )
	iecache = iecache.replace(/\\$/, "");

// Get IE cache max size (in megabytes) from the registry
var IEMAX = "HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Cache\\Content\\CacheLimit";
var iemax = 0;
try {
	iemax = wsh.RegRead(IEMAX);
} catch(err) {}
if ( iecache.length < 4 || !iemax ) {
	wsh.Popup("Cannot determine IE cache directory or settings.",0,TITLE,16);
	WScript.Quit(1);
}
if ( !iecache.match(/temp/i) ) {
	var msg = "Cache Folder: "+iecache;
	msg += "\n\nYour cache folder has a very non-standard name. ";
	msg += "There may be a problem with your configuration. No changes made.";
	wsh.Popup(msg,0,TITLE+": Too Scary To Delete!",16);
	WScript.Quit(1);
}

// Do you really want to go through with it?
tally(iecache);
var mb = Math.round(100*(nbytes/(1024*1024)))/100;
var msg = "Internet Explorer cache will be cleaned:\n\n";
msg += "Folder:\t"+iecache+"\n";
msg += "Maximum:\t"+iemax+" MB\n";
msg += "Currently:\t"+mb+" MB, "+nfiles+" files\n";
if ( mb > iemax )
	msg += "(NOTE: Cache space overflow!)\n";
msg += "\nYou will need to reboot to finish cleaning the cache.";
msg += "\nDo you want to continue?";
var yn = wsh.Popup(msg,0,TITLE,36);
if ( yn != 6 ) {
	wsh.Popup("Cancelled at your request. No changes made.",0,TITLE,16);
	WScript.Quit(4);
}

// Create batch file that will run on boot
var tmp = env("TEMP") || env("windir")+ "\\Temp";
var batfile = tmp+"\\iecache!.bat";
var fh = fso.CreateTextFile(batfile, true);
fh.WriteLine("prompt $G ");
fh.WriteLine(iecache.substr(0,2));
fh.WriteLine("cd \""+iecache+"\"");
try {
	fso.GetFolder(iecache+"\\content.ie5");
	fh.WriteLine("cd content.ie5");
} catch(err) { }
fh.WriteLine("attrib -r -h -s index.dat");
fh.WriteLine("del index.dat");
fh.WriteLine("rem ------ IE Cache cleanup complete, please close this window. ------");
fh.Close();

// Goodbye cache, hello disk space!
delcache(iecache);
var ROKEY = "HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\RunServicesOnce";
wsh.RegWrite(ROKEY+"\\ClearCache", batfile);

msg =  "Please reboot NOW to complete the\nInternet Explorer cache cleanup.";
wsh.Popup(msg,0,TITLE,64);
WScript.Quit(0);

