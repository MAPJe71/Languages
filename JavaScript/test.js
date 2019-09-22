function main()
{
    if( WScript.Arguments.Count() < 2 ) 
        throw "Error: File Name is missing";
    // cscript test.js test.xml test.txt
    var filenameXML = WScript.Arguments.Item(0); // test.xml
    var filenameTXT = WScript.Arguments.Item(1); // test.txt
    var gObjFs = new ActiveXObject("Scripting.FileSystemObject");

    var xmlRoot = parseConfiguration(filenameXML);
    var ForWriting = 2;
    var fileTXT = gObjFs.OpenTextFile(filenameTXT, ForWriting, true);

    var dot_prologue  = xmlRoot.selectSingleNode("dot").text;
    var initial_state = xmlRoot.attributes.getNamedItem("initial").text;
    var fsm_name      = xmlRoot.attributes.getNamedItem("name").text;
    
    fileTXT.WriteLine("/* This file is generated. Do not edit */");
    fileTXT.WriteLine("");

    var transitionList = xmlRoot.selectNodes("transition");
    var src_states = new Array;
    var src_max_actions = 0;
    var log_actions = 0;
    for( i = 0; i < transitionList.length; i++ ) 
    {
        var tNode = transitionList.item(i);
        var from = tNode.attributes.getNamedItem("from").text;
        var to = tNode.attributes.getNamedItem("to").text;
        var condition = tNode.attributes.getNamedItem("condition").text;
        src_states[from] = true;
        src_states[to] = true;

        var actionList = tNode.selectNodes("action");
        if( from == "-" && to == "-" && condition == "-" )
        {
            log_actions += actionList.length;
        }
        else 
        {
            if( actionList != null && src_max_actions < actionList.length ) 
            {
                src_max_actions = actionList.length;
            }
        }
    }    
    fileTXT.WriteLine("#define MAX_TRANSITIONS " + transitionList.length);
    fileTXT.WriteLine("#define MAX_ACTIONS (" + src_max_actions + " + " + log_actions + ")");
    fileTXT.WriteLine("");
    
    for( state in src_states ) 
    {
        if (state != "-") 
        {
            fileTXT.WriteLine("FSM_STATE " + fsm_name.toUpperCase() + "_" + state + " = \"" + state + "\";");
        }
    }
    fileTXT.WriteLine("");
    fileTXT.WriteLine("static FSM " + fsm_name.toLowerCase() + "_fsm;");
    fileTXT.WriteLine("");
    fileTXT.WriteLine("void Create" + fsm_name + "Fsm(FSM_CONTEXT context)");
    fileTXT.WriteLine("{");
    fileTXT.WriteLine(
          "  " 
        + fsm_name.toLowerCase() 
        + "_fsm = FSM_Create(" 
        + fsm_name.toUpperCase() 
        + "_" 
        + initial_state 
        + ", MAX_TRANSITIONS, MAX_ACTIONS, FSMF_ASSERT_OK, context);"
        );
    
    var actionHash = new Array;
    var conditionHash = new Array;
    for( i = 0; i < transitionList.length; i++ ) 
    {
        var tNode = transitionList.item(i);
        var from = tNode.attributes.getNamedItem("from").text;
        var to = tNode.attributes.getNamedItem("to").text;
        var condition         = tNode.attributes.getNamedItem("condition").text;
        var srcline_from      = fsm_name.toUpperCase() + "_" + from;
        var dotline_from      = from;
        var srcline_to        = fsm_name.toUpperCase() + "_" + to;
        var dotline_to        = to;
        var srcline_condition = condition;
        var dotline_condition = condition + "()";

        if( from == "-" ) 
        {
            srcline_from = "NULL";
            dotline_from = "any_state";
        }
        if( to == "-" ) 
        {
            srcline_to = "NULL";
            dotline_to = "any_state";
        }  
        if( condition == "-" ) 
        {
            srcline_condition = "NULL";
            dotline_condition = "";
        }  
        else 
        {
            conditionHash[srcline_condition] = 1;
        }

        var dotline = "  " + dotline_from + " -> " + dotline_to + " [ label = \"" + dotline_condition;

        var actionList = tNode.selectNodes("action");
        if( actionList != null && actionList.length != 0 ) 
        {
            dotline += "/";
            for( j = 0; j < actionList.length; j++ ) 
            {
                var action = actionList.item(j).attributes.getNamedItem("name").text;
                dotline += "\\n" + action + "();";
                fileTXT.WriteLine(
                      "  (void)FSM_ADD(" 
                    + fsm_name.toLowerCase() + "_fsm, " 
                    + srcline_from + ", "
                    + srcline_to + ", "
                    + srcline_condition + ", "
                    + action 
                    + ");"
                    );
                actionHash[action] = 1;
            }
        } 
        else 
        {
            fileTXT.WriteLine(
                  "  (void)FSM_ADD(" 
                + fsm_name.toLowerCase() 
                + "_fsm, " 
                + srcline_from + ", "
                + srcline_to + ", "
                + srcline_condition + ", "
                + "NULL" 
                + ");"
                );
        }
    }     
    fileTXT.WriteLine("}");
    
    fileTXT.Close();
}
    
// DESCRIPTION  : parses the input file as XML and returns a dictionary 
//                  containing the input
// IN           : strFileName  
// RETURNS      : an XML node representing the tree
// RAISES       : Exceptions if 
//                  file does not exist
//                  is not XML
//                  does not contain certain attributes
function parseConfiguration( strFileName )
{
    var gObjFs  = new ActiveXObject("Scripting.FileSystemObject");
    if( !gObjFs.FileExists( strFileName) ) 
        throw "File Name '"  + strFileName + "' does not exist";

    var xmlTree = new ActiveXObject("Microsoft.XMLDOM");
    xmlTree.async = false;
    if( !xmlTree.load( strFileName) ) 
        throw "Failed to load file as XML.\n" 
            + xmlTree.parseError.url 
            + ":" 
            + xmlTree.parseError.line 
            + "  " 
            + xmlTree.parseError.reason;

    var xmlRoot = xmlTree.documentElement;
    return xmlRoot;
}

try 
{
    main();
} 
catch (e) 
{
    WScript.echo(e)
}
