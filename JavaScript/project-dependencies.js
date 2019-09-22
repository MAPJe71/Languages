///////////////////////////////////////////////////////////////////////////////
/** @file
* @brief Parse a solution file and create a project depencency graph using dot.
*
* This script parses a Microsoft Visual Studio 2008 solution file and draws
* project depencency graphs from it. It uses the dot tool of the graphviz
* application to render the graph.
*
* @param solution
* Microsoft Visual Studio solution file (*.sln).
* @param in
* Include filter. If the project file name contains this string its dependencies
* are evaluated. Multiple file filter must be separated by semicolons.
* Filters are case sensitive.
* @param out
* Exclude filter. If the project file name contains this string its dependencies
* are not evaluated. Multiple file filter must be separated by semicolons.
* Filters are case sensitive.
* @param format
* Output file format. Default 'png'. This option is passed to the dot application.
* Supported formats are ps, png, gif and svg. See the documentation on the dot program.
* The extension of the output file is made equal to the format.
* @param keep
* If specified, the .dot file is not destroyed after the dot tool has been run.
* @param dot
* Full name of the dot application that creates the graph. Optional.
*
* @example
* cscript //nologo //E:jscript project-dependencies.js /solution:"test.sln"
* cscript //nologo //E:jscript project-dependencies.js /solution:test.sln /in:"\lib\;MyProject" /out:Test /keep
*
* @author Skolnik
* @date January 18 2011
*
* References:
* http://www.graphviz.org/Documentation.php
* http://www.graphviz.org/doc/info/attrs.html
* www.graphviz.org/Documentation/dotguide.pdf
* http://unicode.org/faq/utf_bom.html#bom4
*/
///////////////////////////////////////////////////////////////////////////////
var g_solutionFile = ""; // arg 'solution'
var g_includeFilter = []; // arg 'in'
var g_excludeFilter = []; // arg 'out'
var g_outputFormat = "png"; // arg 'format'
var g_keepDot = false; // arg 'keep'
var g_dotApp = "c:\\Program Files\\ATT\\Graphviz\\bin\\dot.exe"; // arg 'dot'
var g_fso = null; ///< File system object (Scripting.FileSystemObject).
var g_shell = null; ///< Shell (WScript.Shell).
var g_logLevel = "INFO"; ///< Either "TRACE", "DEBUG", "INFO" or "ERROR"

///////////////////////////////////////////////////////////////////////////////
/**
* Extend the string type; stip off leading and trailing spaces.
*/
///////////////////////////////////////////////////////////////////////////////
String.prototype.trim = function()
{
    return this.replace(/^\s*/, "").replace(/\s*$/, "");
}
///////////////////////////////////////////////////////////////////////////////
/**
* Log a message.
* @param level [in] Message type. Must be either TEST, DEBUG, INFO, WARNING or ERROR.
* @param message [in] Message to show.
*/
///////////////////////////////////////////////////////////////////////////////
function Log(level, message)
{
    if ((g_logLevel == "DEBUG") && (level == "TRACE"))
    {
        return;
    }
    if ((g_logLevel == "INFO") && ((level == "TRACE") || (level == "DEBUG")))
    {
        return;
    }
    if ((g_logLevel == "ERROR") && ((level == "TRACE") || (level == "DEBUG") || (level == "INFO")))
    {
        return;
    }
    WScript.Echo(level + ": " + message);
}
///////////////////////////////////////////////////////////////////////////////
/**
* Log a message and abort script.
* @param message [in] Abort reason.
*/
///////////////////////////////////////////////////////////////////////////////
function Die(message)
{
    Log("ERROR", message);
    Log("INFO", "Aborting script.");
    WScript.Quit(3);
}
///////////////////////////////////////////////////////////////////////////////
/**
* Run the application.
*
* The data is not piped inline because its too big, which will confuse gnuplot.
* This is probably due to the buffer size allocated for stdin, which is 4k
* (as far as I know).
*
* @param app [in] Application to execute.
* @param args [in] Application arguments.
*/
///////////////////////////////////////////////////////////////////////////////
function Exec(app, args)
{
    try
    {
        var code = g_shell.Run("\"" + app + "\" " + args, 0, true);
        if (code != 0)
        {
            Die("Failed to run '" + app + "'; " + code);
        }
    }
    catch (e)
    {
        Die("Failed to run '" + app + "'; " + e.description);
    }
}
///////////////////////////////////////////////////////////////////////////////
/**
* Parse the command line arguments and Die if there is any error in it.
*
* The arguments are assigned to global variables.
*/
///////////////////////////////////////////////////////////////////////////////
function ParseCommandLine()
{
// --- Input directory ----------------------------------------------------
    if ( WScript.Arguments.Named.Exists("solution") )
    {
        g_solutionFile = WScript.Arguments.Named.Item("solution");
    }
    if (g_solutionFile == null) 
        Die("No solution file specified");
    if (g_solutionFile.length <= 0) 
        Die("No solution file specified");
    if (!g_fso.FileExists(g_solutionFile)) 
        Die("Solution file does not exist '" + g_solutionFile + "'");
// --- include filter -----------------------------------------------------
    if ( WScript.Arguments.Named.Exists("in") )
    {
        var filter = WScript.Arguments.Named.Item("in");
        if (filter == null) 
            Die("No exclude filter specified");
        if (filter.length > 0) 
            g_includeFilter = filter.split(";");
    }
// --- exclude filter -----------------------------------------------------
    if ( WScript.Arguments.Named.Exists("out") )
    {
        var filter = WScript.Arguments.Named.Item("out");
        if (filter == null) 
            Die("No exclude filter specified");
        if (filter.length > 0) 
            g_excludeFilter = filter.split(";");
    }
// --- output format ------------------------------------------------------
    if ( WScript.Arguments.Named.Exists("format") )
    {
        g_outputFormat = WScript.Arguments.Named.Item("format");
        if (g_outputFormat == null) 
            Die("No output format specified");
        g_outputFormat = g_outputFormat.trim();
        if (g_outputFormat.length <= 0) 
            Die("No output format specified");
    }
// --- keep dot file ------------------------------------------------------
    if ( WScript.Arguments.Named.Exists("keep") )
    {
        g_keepDot = true;
    }
// --- Dot application ----------------------------------------------------
    if (WScript.Arguments.Named.Exists("dot") )
    {
        g_dotApp = WScript.Arguments.Named.Item("dot");
    }
    if (g_dotApp == null) 
        Die("No dot application specified");
    if (!g_fso.FileExists(g_dotApp)) 
        Die("Application not found '" + g_dotApp + "'");
}
///////////////////////////////////////////////////////////////////////////////
/**
* Check if the specified file matches the includeFilter/excludeFilter.
*/
///////////////////////////////////////////////////////////////////////////////
function PassesFilter(file)
{
    if (g_includeFilter.length <= 0)
    {
        if (g_excludeFilter.length <= 0)
        {
            return true;
        }
        else
        {
            var ii;
            for (ii = 0; ii < g_excludeFilter.length; ii++)
            {
                if (file.indexOf(g_excludeFilter[ii]) >= 0)
                {
                    return false;
                }
            }
            return true;
        }
    }
    else
    {
        var ii;
        for (ii = 0; ii < g_includeFilter.length; ii++)
        {
            if (file.indexOf(g_includeFilter[ii]) >= 0)
            {
                if (g_excludeFilter.length <= 0)
                {
                    return true;
                }
                else
                {
                    var jj;
                    for (jj = 0; jj < g_excludeFilter.length; jj++)
                    {
                        if (file.indexOf(g_excludeFilter[jj]) >= 0)
                        {
                            return false;
                        }
                    }
                    return true;
                }
            }
        }
        return false;
    }
}
///////////////////////////////////////////////////////////////////////////////
/**
* Class to store project identifier, name and path.
*/
///////////////////////////////////////////////////////////////////////////////
function Project(id, name, path)
{
    this.id = id;
    this.name = name;
    this.path = path;
}
/// Converts this instance to a String.
Project.prototype.toString = function ()
{
    return this.name + " " + this.path + " (" + this.id + ")";
}

///////////////////////////////////////////////////////////////////////////////
// Main
///////////////////////////////////////////////////////////////////////////////

// Create objects
g_fso = new ActiveXObject("Scripting.FileSystemObject");
g_shell = new ActiveXObject("WScript.Shell");

// Parse commandline arguments
ParseCommandLine();
var solutionName = g_fso.GetBaseName(g_solutionFile);
var outputFile = "project-dependencies-" + solutionName;
var dotFile = outputFile + ".dot";
outputFile = outputFile + "." + g_outputFormat;
Log("DEBUG", "Solution file : " + g_solutionFile);
Log("DEBUG", "Output file : " + outputFile);
Log("DEBUG", "Include filter : [" + g_includeFilter + "] (length " + g_includeFilter.length + ")");
Log("DEBUG", "Exclude filter : [" + g_excludeFilter + "] (length " + g_excludeFilter.length + ")");

// --- Create project list index on the project id ----------------------------
var lineNr = 0;
var firstLine = true;
var projectsList = new ActiveXObject("Scripting.Dictionary");
var xStartProject = /^\s*Project\s*\(\s*\"\{[A-F0-9\-]{36}\}\"\s*\)\s*=\s*\"(\S+)\"\s*,\s*\"(.*\.(vcproj|csproj))\"\s*,\s*\"\{([A-F0-9\-]{36})\}\"\s*$/i;

var solutionHandle = g_fso.OpenTextFile(g_solutionFile, 1);
while (!solutionHandle.AtEndOfStream)
{
    lineNr += 1;
    var line = solutionHandle.ReadLine();
    line = line.trim();
    if (line.length <= 0)
    {
        // Skip empty lines
        continue;
    }
    if (firstLine)
    {
        firstLine = false;
        var xFirstLine = /Microsoft\s+Visual\s+Studio\s+Solution\s+File\s*,\s*Format\s+Version\s+\d+[,\.]\d+/i
        if (!xFirstLine.test(line))
        {
            if (lineNr != 1)
            {
                Die("File is not a valid solution file (" + g_solutionFile + ")");
            }
            // First line might be UTF byte order marker (bom); try next line as well
            firstLine = true;
        }
        continue;
    }
    if (xStartProject.test(line))
    {
        var items = line.match(xStartProject);
        var id = items[4];
        var project = new Project(id, items[1], items[2]);
        projectsList.add(id, project);
        Log("TRACE", project);
    }
}
solutionHandle.Close();
if (projectsList.Count <= 1)
{
    Die("Only " + projectsList.Count + " projects found in file '" + g_solutionFile + "'");
}
Log("INFO", "Solution '" + g_solutionFile + "' contains " + projectsList.Count + " projects");

// --- Look up project dependencies -------------------------------------------
Log("INFO", "Writing file '" + dotFile + "'");

var dotHandle = g_fso.CreateTextFile(dotFile, true);
dotHandle.WriteLine("//");
dotHandle.WriteLine("// Generated by " + "project-dependencies.js");
dotHandle.WriteLine("// Creation date " + Date());
dotHandle.WriteLine("// Solution file " + g_solutionFile);
dotHandle.WriteLine("// Filters in/out [" + g_includeFilter + "] / [" + g_excludeFilter + "]");
dotHandle.WriteLine("//");
dotHandle.WriteLine("digraph ProjectDependencyGraph {");
dotHandle.WriteLine("rankdir=LR;");
dotHandle.WriteLine("node [fontname=\"Arial\",fontsize=10,shape=box,fillcolor=\"#E3E4FA\",style=filled];");
dotHandle.WriteLine("edge [arrowhead=open,fontname=\"Arial\",fontsize=10];");

lineNr = 0;
projectId = "";
parsingDependencies = false;

solutionHandle = g_fso.OpenTextFile(g_solutionFile, 1);
while (!solutionHandle.AtEndOfStream)
{
    lineNr += 1;
    var line = solutionHandle.ReadLine();
        line = line.trim();
    if (line.length <= 0)
    {
        // Skip empty lines
        continue;
    }
    
    // Find out which projects dependencies we're parsing
    if (projectId.length <= 0)
    {
        if (xStartProject.test(line))
        {
            var items = line.match(xStartProject);
            var id = items[4];
            if (PassesFilter(items[2]))
            {
                projectId = id;
                Log("TRACE", "Project " + items[1] + " passed filter (" + items [2] + ")");
            }
            else
            {
                Log("TRACE", "Skipping project " + items[1] + " (" + items [2] + ")");
            }
        }
    }
    else
    {
        var xEndProject = /^\s*EndProject\s*$/i;
        if (xEndProject.test(line))
        {
            projectId = "";
            continue;
        }
    }
    if (projectId.length <= 0) 
        continue;

    var parentProject = projectsList(projectId);
    if (!parsingDependencies)
    {
        var xStartDependencies = /^\s*ProjectSection\s*\(\s*ProjectDependencies\s*\)\s*=\s*postProject\s*$/i;
        if (xStartDependencies.test(line))
        {
            Log("TRACE", "line " + lineNr + "; start parsing dependencies of project " + parentProject.name);
            parsingDependencies = true;
        }
        continue;
    }
    else
    {
        var xEndDependencies = /^\s*EndProjectSection\s*$/i;
        if (xEndDependencies.test(line))
        {
            Log("TRACE", "line " + lineNr + "; end parsing dependencies of project " + parentProject.name);
            parsingDependencies = false;
            continue;
        }
    }

    if (!parsingDependencies) 
        continue;

        var xDependency = /^\s*\ {([A-F0-9\-]{36})\}\s*=\s*\{[A-F0-9\-]{36}\}\s*$/i;
    if (!xDependency.test(line)) 
        Die("Failed to match dependency on line " + lineNr + "; \"" + line + "\"");
    
    var id = line.match(xDependency)[1];
    childProject = projectsList(id);

//    Log("TRACE", "Project " + parentProject.name + " depends on project " + childProject.name);
    dotHandle.WriteLine("\"" + parentProject.name + "\" -> \"" + childProject.name + "\"");
}

solutionHandle.Close();

dotHandle.WriteLine("}");
dotHandle.Close();

Log("INFO", "Running dot...");
var arguments = "-T " + g_outputFormat + " -o \"" + outputFile + "\" \"" + dotFile + "\"";
Log("DEBUG", g_dotApp + " " + arguments);
Exec(g_dotApp, arguments);
if (!g_keepDot)
{
    try
    {
        g_fso.DeleteFile(dotFile);
    }
    catch (e)
    {
        Log("WARNING", "Failed to delete file '" + dotFile + "'; " + e.description);
    }
}
Log("INFO", "Done (" + outputFile + ")");
