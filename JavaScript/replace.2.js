// replace.js: globally replace one string with another. 
// See directions for syntax. 

function directions() {
  WScript.Echo("Enter\n");
  WScript.Echo("cscript //Nologo replace.js targetstring \
replstring < infile.txt > outfile.txt");
     WScript.Echo("\nEnclose strings that have spaces in quotation marks.");
}
function processTextStream() {
    target = WScript.Arguments.Item(0);
    newString = WScript.Arguments.Item(1);
    while (!WScript.StdIn.AtEndOfStream) {
        line = WScript.StdIn.ReadAll();
        // If I wasn't passing a variable as the first argument 
        // of line.replace, I could use normal regex syntax like
        // line.replace(/Robert/g,"Bob")
        line = line.replace(RegExp(target,"g"),newString)
        WScript.Echo(line);
    }
}

// --------------------------------------------------

if (WScript.Arguments.length < 2) {
    directions();
}
else {
    processTextStream();
}

