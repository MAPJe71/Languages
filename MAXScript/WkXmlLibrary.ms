/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***


-- Purpose:
-----------   
	The purpose of this script is to give an easy and full access to XML files: creation, reading and modifications
	It is intented to be used with the same flexibility as a library: instanciate the structure where you need it
	in your code and use the member functions to manipulate the XML files.

	This script strongly relies on the DotNet interface.
	
	A script by WerwacK
	3dsMax Supported Versions:	from 3dsMax 9 to the most recent release (currently 3dsMax 2011)
	Contact: werwack@werwackfx.com
	Website: www.werwackfx.com
	Copyright: WerwacK
	Free for commercial and non-commercial use
	
-- Install:
-----------
	Just copy this script and the folders containing it into the Script directory of 3dsMax, so that
	you get this path:
		[3dsmax]\scripts\WerwacKScripts\WkXmlLibrary\WkXmlLibrary.ms
	
	You call now call the script as explained below or shown in details in the demo
	at the end of this file.
	

-- Use:
-------
	
	The use of the script is explained at the end of this file through several examples.
	Check for the line containing "WkXmlLibrary demo" and follow the instructions.

	
-- Notes:
---------
	
	- By default functions are CASE SENSITIVE for node (or tag) names (not for attributes).
	  This can be set not to be with the optional parameter "rbBeCaseSensitive" of those functions. 
	
	- the 3dsmax garbage collector function gc() may not be suitable to release the elements created
	in C#...
	
	- The XML file extension can be anything, not just "xml"
	
	
-- to do:
---------
   
-- mettre le header du xml
-- prevenir l 'ajout d espaces dans les noms des balises (actuellement: crash)	


-- Known troubles:
------------------  

-- References:
--------------

	- the DotNet page for XML:
	  http://msdn.microsoft.com/en-us/library/system.xml.xmldocument.aspx
	
	
-- Version history:
-------------------

-- V1.3 - 2010-08-28:
	- added robustness and error handeling to the code, cleaned a bit
	- added a demo part to explain how to use the script

-- V1.2:
	- fixed a bug in the SaveXml
	
-- V1.1:
	- created the general structure

-- V1.0: Base version from David Mackenzie (dave@daveandgoliath.com)

*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/



global gtWkXMLLib

DotNet.LoadAssembly "System.Xml"

-- This sctructure encapsulate a DotNet XML node (class System.Xml.XmlElement)
-- to facilitate its manipulation and to add several methods useful in a Maxscript context
struct tXMLNode
(
	mDotNetNode,		-- the DotNet node (of class System.Xml.XmlElement)
	
	-- *** Always call this method when instancianting a tXMLNode structure! ***
	-- Note: Well, technicaly we could use tXMLNode mDotNetNode:rDnNode but in case we may need an initialization... (cd constructors)
	fn mfInit rDotNetNode =
	(
	--	format "tXMLNode: mfInit: rDnNode: %\n" rDnNode
		mDotNetNode = rDotNetNode
	),
	
	fn mfConvertStringToLowercase rStr =
	(
		local lUpperArr = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		local lLowerArr = "abcdefghijklmnopqrstuvwxyz"

		local lNewStr = ""
		local lTmpInd
		for i=1 to rStr.count do
			if undefined != (lTmpInd = findString lUpperArr rStr[i]) then
				 lNewStr += lLowerArr[lTmpInd]
			else lNewStr += rStr[i]
			
		return lNewStr
	),
	
	-- ----------------------------------------------------------
	-- Node name (or tag name)
	-- Note: In this implementation, the node name refers to the DotNet attribute name, not localName
	fn mfGetName =
	(
		return mDotNetNode.name
	),
	
	fn mfSetName rNewNameStr =
	(
		mDotNetNode.name = rNewNameStr
	),
	
	-- ----------------------------------------------------------
	-- Text
	fn mfGetText =
	(
		mDotNetNode.InnerText
	), 
	
	fn mfSetText rTextStr =
	(
		mDotNetNode.InnerText = rTextStr
	),
	
	-- ----------------------------------------------------------
	-- Attributes
	-- rValue doesn't have to be a string
	fn mfAddAttribute rAttributeStr rValue =
	(
		mDotNetNode.SetAttribute rAttributeStr (rValue as string)
		return mDotNetNode.GetAttribute rAttributeStr
	),
	
	fn mfGetAttribute rAttributeStr =
	(
		mDotNetNode.GetAttribute rAttributeStr
	),
	
	-- rValue doesn't have to be a string
	fn mfSetAttribute rAttributeStr rValue =
	(
		mDotNetNode.SetAttribute rAttributeStr (rValue as string)
		return mDotNetNode.GetAttribute rAttributeStr
	),
	
	fn mfDeleteAttribute rAttributeStr =
	(
		mDotNetNode.RemoveAttribute rAttributeStr
	),
	
	fn mfGetAllAttributes =
	(
		local lAttributesArr = #()
		local lDotNetAttributesArr = mDotNetNode.Attributes
		for i = 0 to (lDotNetAttributesArr.Count - 1) do
		(
			itemsArr = #()
			item = (lDotNetAttributesArr.ItemOf i)
			append itemsArr item.Name
			append itemsArr item.Value
			append lAttributesArr itemsArr
		)
		
		return lAttributesArr
	),
	
	
	fn mfHasAttribute rAttributeStr rbBeCaseSensitive: =
	(
		local lbBeCaseSensitive = if unsupplied == rbBeCaseSensitive then true else rbBeCaseSensitive
		local lbAttributeFound = false
		
		if undefined == rAttributeStr then
			lbAttributeFound = false
		else if not lbBeCaseSensitive then
			(
				local lAttribsArr = mDotNetNode.Attributes
					
				local lAttribInd = 0		-- warning: index goes from 0 to count - 1
				-- get an attribute with same name as rAttributeStr
				while not lbAttributeFound and lAttribsArr.Count > lAttribInd do
				(
					if ((lAttribsArr.ItemOf lAttribInd).Name as name) == (rAttributeStr as name) do		-- matching attrib name
						lbAttributeFound = true
					lAttribInd += 1
				)
			)
		else lbAttributeFound = mDotNetNode.hasAttribute rAttributeStr
		
		return lbAttributeFound	
	),

	fn mfHasAttributeWithThisValue rAttributeStr rAttributeValueStr rbBeCaseSensitive: rbAttributeContainsValue: =
	(
		local lbBeCaseSensitive = if unsupplied == rbBeCaseSensitive then true else rbBeCaseSensitive
		local lbAttributeContainsValue = if unsupplied == rbAttributeContainsValue then false else rbAttributeContainsValue
		local lbAttributeFound = false
		
		if undefined == rAttributeStr or undefined == rAttributeValueStr then
			lbAttributeFound = false
		else
		(
			if not lbBeCaseSensitive then
			(
				local lAttribsArr = mDotNetNode.Attributes
						
				local lAttribInd = 0		-- warning: index goes from 0 to count - 1
				-- get an attribute with same name as rAttributeStr
				while not lbAttributeFound and lAttribsArr.Count > lAttribInd do
				(
					if ((lAttribsArr.ItemOf lAttribInd).Name as name) == (rAttributeStr as name) do		-- matching attrib name
							-- compare the value of the attribute
							if lbAttributeContainsValue then
							(
								local lTmpAttribValueStr = mfConvertStringToLowercase (lAttribsArr.ItemOf lAttribInd).Value
								local lAttributeValueStr = mfConvertStringToLowercase rAttributeValueStr
								if undefined != findString lTmpAttribValueStr lAttributeValueStr do
								(
									lbAttributeFound = true
								--	ltNewNode = tXMLNode()
								--	ltNewNode.mfInit mDotNetNode
								)
							)
							else if ((lAttribsArr.ItemOf lAttribInd).Value as name) == (rAttributeValueStr as name) do		-- perfect matching of attrib value (excemp case sensitive)
								(
									lbAttributeFound = true
								--	ltNewNode = tXMLNode()
								--	ltNewNode.mfInit mDotNetNode
								)
						lAttribInd += 1
				)
			)
			else								-- case sensitive
			(
				local lAttribsArr = mDotNetNode.Attributes
				
				local lAttribInd = 0		-- warning: index goes from 0 to count - 1
				-- get an attribute with same name as rAttributeStr
			--	format "lAttribsArr.Count: %\n" lAttribsArr.Count
				while undefined == ltNewNode and lAttribsArr.Count > lAttribInd do
				(
					if (lAttribsArr.ItemOf lAttribInd).Name == rAttributeStr do		-- matching attrib name
						-- compare the value of the attribute
						if lbAttributeContainsValue then
						(
							local lTmpAttribValueStr = (lAttribsArr.ItemOf lAttribInd).Value
							local lAttributeValueStr = rAttributeValueStr
							local lSubstringInd = findString lTmpAttribValueStr lAttributeValueStr
						--	format "lTmpAttribValueStr: %, lAttribInd:% \n" lTmpAttribValueStr lAttribInd
							if undefined != lSubstringInd do
							(
								-- case sensitive comparison of attribute values (utile??)
							--	local lSubstringStr = substring lTmpAttribValueStr lSubstringInd (lAttributeValueStr.count)
							--	if lSubstringStr == lAttributeValueStr do
								(
									lbAttributeFound = true
								--	ltNewNode = tXMLNode()
								--	ltNewNode.mfInit mDotNetNode
								)
							)
						)
				-- wkip compare les valeurs en case sensitive
						--else if (lAttribsArr.ItemOf lAttribInd).Value == rAttributeValueStr do		-- perfect matching of attrib value (excemp case sensitive)
						else if ((lAttribsArr.ItemOf lAttribInd).Value as name) == (rAttributeValueStr as name) do		-- perfect matching of attrib value (excemp case sensitive)
							(
								lbAttributeFound = true
								--	ltNewNode = tXMLNode()
								--	ltNewNode.mfInit mDotNetNode
							)
					lAttribInd += 1
				)
			)
		)
		
		return lbAttributeFound	
	),
	
	-- ----------------------------------------------------------
	-- Nodes

	-- Append the argument node as a child of the current node
	-- return true on success, false otherwise
	fn mfAppendChild rtNewNode =
	(
		local lbContinue = (classof rtNewNode == tXMLNode)
		
		if lbContinue do
			mDotNetNode.AppendChild (mDotNetNode.OwnerDocument.ImportNode rtNewNode.mDotNetNode true)
		
		return lbContinue
	),

	-- Create a new child node with the tag given as parameter
	-- returns the child as a tXMLNode instance on success, undefined otherwise
	fn mfCreateChildByName rName =
	(
		local lNewDotNetNode = mDotNetNode.OwnerDocument.CreateElement rName
		mDotNetNode.AppendChild (mDotNetNode.OwnerDocument.ImportNode lNewDotNetNode true)

		local ltNewNode = tXMLNode()
		ltNewNode.mfInit lNewDotNetNode

		return ltNewNode
	),
	
	-- Private - Call mfGetChildrenNodesByName instead
	fn mfGetChildrenNodesByNameRec rNodeNameStr rDotNetNode &rChildrenNodesArr rbBeCaseSensitive: =
	(
		local lbBeCaseSensitive = if unsupplied == rbBeCaseSensitive then true else rbBeCaseSensitive
		local lTmpNode
		
		for i=1 to rDotNetNode.ChildNodes.Count do
		(
			lTmpNode = rDotNetNode.ChildNodes.ItemOf (i - 1)
			
			if not lbBeCaseSensitive then		-- not case sensitive
				if (rNodeNameStr as name) == (lTmpNode.name as name) do
				(
					ltNewNode = tXMLNode()
					ltNewNode.mfInit lTmpNode
					append rChildrenNodesArr ltNewNode
				)
			else								-- case sensitive
				if rNodeNameStr == lTmpNode.name do
				(
					ltNewNode = tXMLNode()
					ltNewNode.mfInit lTmpNode
					append rChildrenNodesArr ltNewNode
				)
			
			mfGetChildrenNodesByNameRec rNodeNameStr lTmpNode &rChildrenNodesArr rbBeCaseSensitive:lbBeCaseSensitive
		)
	),
	
	-- return an array of tXMLNode containing all the nodes with the name rNodeNameStr contained in the current node
	fn mfGetChildrenNodesByName rNodeNameStr rbBeCaseSensitive: =
	(
		local lbBeCaseSensitive = if unsupplied == rbBeCaseSensitive then true else rbBeCaseSensitive
		local lChildrenNodesArr = #()
		
		mfGetChildrenNodesByNameRec rNodeNameStr mDotNetNode &lChildrenNodesArr rbBeCaseSensitive:lbBeCaseSensitive
		
		return lChildrenNodesArr
	),
		
	fn mfGetChildren =
	(
		local lChildrenNodesArr = #()
		local lDotNetNode
		
		for i = 0 to (mDotNetNode.ChildNodes.Count - 1) do
		(
			lDotNetNode = mDotNetNode.ChildNodes.ItemOf i
			local lNewNode = tXMLNode()
			lNewNode.mfInit lDotNetNode
			append lChildrenNodesArr lNewNode
		)
		
		return lChildrenNodesArr
	),

	-- rIndex starts at 1
	fn mfGetChildByIndex rIndex =
	(
		local lDotNetNode = mDotNetNode.ChildNodes.ItemOf (rIndex - 1)
		local ltNewNode 			-- new tXMLNode
		
		if undefined != lDotNetNode and lDotNetNode.name != "#text" do
		(
			ltNewNode = tXMLNode()
			ltNewNode.mfInit lDotNetNode
		)
		
		return ltNewNode
	),

	
	
	-- warning: node names and attributes are case sensitive!!! We only look for "Name" and "name"
	-- case sensitive by default
	-- all the mDotNetNode have a property called name (the name of the node), which is different from attributes
	fn mfGetChildByName rChildNameStr rbBeCaseSensitive: =
	(
		local lbBeCaseSensitive = if unsupplied == rbBeCaseSensitive then true else rbBeCaseSensitive
		local lChildrenNodesArr = #()
		local ltNewNode
		
		local i = 1
		while undefined == ltNewNode and mDotNetNode.ChildNodes.Count >= i do
		(
			lTmpNode = mDotNetNode.ChildNodes.ItemOf (i - 1)
			if not lbBeCaseSensitive then		-- not case sensitive
				if (rChildNameStr as name) == (lTmpNode.name as name) do
				(
					ltNewNode = tXMLNode()
					ltNewNode.mfInit lTmpNode
				)
			else								-- case sensitive
				if rChildNameStr == lTmpNode.name do
				(
					ltNewNode = tXMLNode()
					ltNewNode.mfInit lTmpNode
				)
				
			i+=1
		)
		
		return ltNewNode
	),
	

	
	-- rbAttributeContainsValue:	set to false: the node attribute must match the value rAttributeValueStr (default)
	--								set to true: the node attribute must contain the value rAttributeValueStr
	-- returns the first node matching the settings
	/* for example: rNode2 = rNode.mfGetChildByNameAndAttribute "node" "name" "FixCam" with rNode name = "nodes"
		will return something with rNode2 name = "node" and rNode2 attribute name is "FixCam"
		<nodes>
			<node name="FixTeapot">
				...
            </node>
			<node name="FixCam">
				...
			</node>
		</nodes>
	*/
	fn mfGetChildByNameAndAttribute rChildNameStr rAttributeStr rAttributeValueStr rbBeCaseSensitive: rbAttributeContainsValue: =
	(
		local lbBeCaseSensitive = if unsupplied == rbBeCaseSensitive then true else rbBeCaseSensitive
		local lbAttributeContainsValue = if unsupplied == rbAttributeContainsValue then false else rbAttributeContainsValue
		local lChildrenNodesArr = #()
		local ltNewNode
		
		local i = 1
		while undefined == ltNewNode and mDotNetNode.ChildNodes.Count >= i do
		(
		--	format "i: %, mDotNetNode.ChildNodes.Count: %\n" i mDotNetNode.ChildNodes.Count
			local lTmpNode = mDotNetNode.ChildNodes.ItemOf (i - 1)
			
			if not lbBeCaseSensitive then		-- not case sensitive
			(
				-- look for a child with the node name matching with rChildNameStr
				if (rChildNameStr as name) == (lTmpNode.name as name) do
				(
					local lAttribsArr = lTmpNode.Attributes
					
					local lAttribInd = 0		-- warning: index goes from 0 to count - 1
					-- get an attribute with same name as rAttributeStr
					while undefined == ltNewNode and lAttribsArr.Count > lAttribInd do
					(
						if ((lAttribsArr.ItemOf lAttribInd).Name as name) == (rAttributeStr as name) do		-- matching attrib name
							-- compare the value of the attribute
							if lbAttributeContainsValue then
							(
								local lTmpAttribValueStr = mfConvertStringToLowercase (lAttribsArr.ItemOf lAttribInd).Value
								local lAttributeValueStr = mfConvertStringToLowercase rAttributeValueStr
								if undefined != findString lTmpAttribValueStr lAttributeValueStr do
								(
									ltNewNode = tXMLNode()
									ltNewNode.mfInit lTmpNode
								)
							)
							else if ((lAttribsArr.ItemOf lAttribInd).Value as name) == (rAttributeValueStr as name) do		-- perfect matching of attrib value (excemp case sensitive)
								(
									ltNewNode = tXMLNode()
									ltNewNode.mfInit lTmpNode
								)
						lAttribInd += 1
					)
				)
			)
			else								-- case sensitive
				-- look for a child with the node name matching with rChildNameStr
				if rChildNameStr == lTmpNode.name do
				(
					local lAttribsArr = lTmpNode.Attributes
					
					local lAttribInd = 0		-- warning: index goes from 0 to count - 1
					-- get an attribute with same name as rAttributeStr
				--	format "lAttribsArr.Count: %\n" lAttribsArr.Count
					while undefined == ltNewNode and lAttribsArr.Count > lAttribInd do
					(
						if (lAttribsArr.ItemOf lAttribInd).Name == rAttributeStr do		-- matching attrib name
							-- compare the value of the attribute
							if lbAttributeContainsValue then
							(
								local lTmpAttribValueStr = (lAttribsArr.ItemOf lAttribInd).Value
								local lAttributeValueStr = rAttributeValueStr
								local lSubstringInd = findString lTmpAttribValueStr lAttributeValueStr
							--	format "lTmpAttribValueStr: %, lAttribInd:% \n" lTmpAttribValueStr lAttribInd
								if undefined != lSubstringInd do
								(
									-- case sensitive comparison of attribute values (utile??)
								--	local lSubstringStr = substring lTmpAttribValueStr lSubstringInd (lAttributeValueStr.count)
								--	if lSubstringStr == lAttributeValueStr do
									(
										ltNewNode = tXMLNode()
										ltNewNode.mfInit lTmpNode
									)
								)
							)
					-- wkip compare les valeurs en case sensitive
							--else if (lAttribsArr.ItemOf lAttribInd).Value == rAttributeValueStr do		-- perfect matching of attrib value (excemp case sensitive)
							else if ((lAttribsArr.ItemOf lAttribInd).Value as name) == (rAttributeValueStr as name) do		-- perfect matching of attrib value (excemp case sensitive)
								(
									ltNewNode = tXMLNode()
									ltNewNode.mfInit lTmpNode
								)
						lAttribInd += 1
					)
				)
				
			i+=1
		)
		
		return ltNewNode
	),
	
	fn mfDeleteChild childNode =
	(
		if classof childNode == tXMLNode then (
			mDotNetNode.RemoveChild childNode.mDotNetNode
			return true
		)
		else false
	),
	
	fn mfDisplayNodeInfos =
	(
		local lStr = "\n name: " + mDotNetNode.name + "  \n"
		local lArr = mfGetAllAttributes()
		for i=1 to lArr.count do
			lStr += "   " + lArr[i][1] as string + ": " + lArr[i][2] as string + "\n"
		
		--lStr += "\n"
		format lStr
	)
)

struct tXMLDocument
(
	mVersion = 1.3,
	mDotNetXmlDoc = undefined,
	mXmlFilePath = undefined,
	
	-- rActionStr can be "create", "load" or "save"
	fn mfIsPathValid rXmlFilePath rbDisplayErrorMessages rActionStr =
	(
		local lbContinue = true
		
		if undefined == rXmlFilePath do
		(
			lbContinue = false
			if rbDisplayErrorMessages do
				messagebox ("XML Document: Specified path is undefined\n\nCannot " + rActionStr + " XML file") title:"WkXmlLibrary - Error                        "
		)
		
		if lbContinue do		-- check directory
			if not doesFileExist (getFilenamePath rXmlFilePath) do
			(
				lbContinue = false
				if rbDisplayErrorMessages do
					messagebox ("XML Document: Specified file path is not valid:\n\n" + rXmlFilePath as string + "\n\nCannot " + rActionStr + " XML file") title:"WkXmlLibrary - Error                        "
			)
		
		if lbContinue and "create" == rActionStr do		-- check if file exists
			if doesFileExist rXmlFilePath do
			(
				lbContinue = false
				if rbDisplayErrorMessages do
					messagebox ("XML Document: Specified file already exists:\n\n" + rXmlFilePath as string + "\n\nCannot " + rActionStr + " XML file") title:"WkXmlLibrary - Error                        "
			)

		if lbContinue and "load" == rActionStr do		-- check if file exists
			if not doesFileExist rXmlFilePath do
			(
				lbContinue = false
				if rbDisplayErrorMessages do
					messagebox ("XML Document: Specified file not found:\n\n" + rXmlFilePath as string + "\n\nCannot " + rActionStr + " XML file") title:"WkXmlLibrary - Error                        "
			)
			
		return lbContinue
	),
	
	-- Create a new XML document
	-- By default the document is empty and has no root node, use mfSetRootNode for that once the document is created
	-- As long as mfSaveXML has not been called and the file path and name have not been set, the XML document is not writen to the disk
	-- Return true if the document has been created, false otherwise
	-- rXmlFilePath:	(optional): path and name of the xml file to create
	--					The file extension can be anything, not just "xml"
	-- 				** Warnings**:	- If the specified path is invalid, the document cannot be created
	-- 								- If the file already exists, the document cannot be created. In this case create the document without file name and use mfSaveXMLAs()
	--	eg: myXmlDoc.mfCreateXML()
	--	eg: myXmlDoc.mfCreateXML rXmlFilePath:"c:\\temp\\myXml.scene"
	fn mfCreateXML rXmlFilePath: rbDisplayErrorMessages:true =
	(
		local lbContinue = true
		
		if unsupplied != rXmlFilePath do
		(
			lbContinue = mfIsPathValid rXmlFilePath rbDisplayErrorMessages "create"
			if lbContinue do
				mXmlFilePath = copy rXmlFilePath
		)
		
		if lbContinue do
			mDotNetXmlDoc = dotNetObject "System.Xml.XmlDocument"
		
		return lbContinue
	),
	
	-- Load the content of a XML document from a text file
	-- There is no need to call mfCreateXML() when calling this function
	-- Return true if the document has been loaded, false otherwise
	-- rXmlFilePath:	path and name of the xml file to load
	--					The file extension can be anything, not just "xml"
	-- rbDisplayErrorMessages: (optional): By default an error message opens if an error appens
	--	eg: myXmlDoc.mfLoadXML rXmlFilePath: "c:\\temp\\myXml.scene"
	fn mfLoadXML rXmlFilePath rbDisplayErrorMessages:true =
	(
		local lbContinue = mfIsPathValid rXmlFilePath rbDisplayErrorMessages "load"
		
		if lbContinue do
		(
			if undefined == mDotNetXmlDoc do
				mDotNetXmlDoc = dotNetObject "System.Xml.XmlDocument"
			if undefined == mDotNetXmlDoc then
				lbContinue = false
			else
			(
				mDotNetXmlDoc.Load rXmlFilePath
				mXmlFilePath = copy rXmlFilePath
			)
		)
		
		return lbContinue
	),
	
	-- Save the content of the XML document to the file specified in mXmlFilePath
	-- Return true if the document has been saved, false otherwise
	-- rXmlFilePath:	path and name of the xml file to save
	--					The file extension can be anything, not just "xml"
	-- rbDisplayErrorMessages: (optional): By default an error message opens if an error appens
	--	eg: myXmlDoc.mfSaveXMLAs "c:\\temp\\myXml.scene"
	fn mfSaveXMLAs rXmlFilePath rbDisplayErrorMessages:true rbOverwriteIfExist:false =
	(
		local lbContinue = true
		
		if undefined == mDotNetXmlDoc do
		(
			lbContinue = false
			if rbDisplayErrorMessages do
				messagebox ("XMLDocument: XML document cannot be saved, it is not fully initialized.   \n\nWas is correctly created or loaded?") title:"WkXmlLibrary - Error                        "
		)
		
		if lbContinue do
			lbContinue = mfIsPathValid rXmlFilePath rbDisplayErrorMessages "save"
			
		if lbContinue do		-- check if file exists
			if doesFileExist rXmlFilePath and not rbOverwriteIfExist do
				lbContinue = querybox ("XML Document: Specified file already exists:\n\n" + rXmlFilePath as string + "\n\nDo you want to overwrite it?") title:"WkXmlLibrary - XML File Exists                        "
		
		if lbContinue do
		(
			-- document cannot be saved if it doesn't have a root node
			if undefined == mDotNetXmlDoc.DocumentElement then
			(
				lbContinue = false
				if rbDisplayErrorMessages do
					messagebox ("XMLDocument: Document cannot be saved because it has no root node:\n\n" + rXmlFilePath as string + "\n\n") title:"WkXmlLibrary - Error                        "			
			)
			else
			(
				try( mDotNetXmlDoc.Save rXmlFilePath )
				catch ( lbContinue = false )
				if lbContinue then
					mXmlFilePath = copy rXmlFilePath
				else if rbDisplayErrorMessages do
					messagebox ("XML Document: Specified file cannot be saved:\n\n" + rXmlFilePath as string + "\n\nCannot save XML file") title:"WkXmlLibrary - Error                        "			
			)
		)
		
		return lbContinue
	),
	
	-- Save the content of the XML document to the file specified in mXmlFilePath
	-- Return true if the document has been saved, false otherwise
	-- rbDisplayErrorMessages: (optional): By default an error message opens if an error appens
	fn mfSaveXML rbDisplayErrorMessages:true =
	(
		return mfSaveXMLAs mXmlFilePath rbDisplayErrorMessages:rbDisplayErrorMessages rbOverwriteIfExist:true
	),

	fn mfReleaseXML =
	(
		mDotNetXmlDoc = undefined
		mXmlFilePath = undefined
		gc()						-- note: we may probably call the DotNet garbage collector instead
	),
	
	-- Create a root node if none already exist
	-- return the root node of the document as a tXMLNode structure if the root node has been created,
	-- undefined otherwise.
	-- There can be only one root node. If a root node already exists the function returns false
	-- To modify an existing root node create a new node with mfGetNewNode() and set it with mfSetRootNode()
	fn mfCreateRootNode rName =
	(
		local lRootNode = undefined
		local lbContinue = undefined != mDotNetXmlDoc
				
		if lbContinue and undefined == mDotNetXmlDoc.DocumentElement do
		(
			local lDotNetNode = mDotNetXmlDoc.CreateElement rName
			mDotNetXmlDoc.AppendChild lDotNetNode
			if undefined != mDotNetXmlDoc.DocumentElement do
			(
				lRootNode = tXMLNode()
				lRootNode.mfInit mDotNetXmlDoc.DocumentElement
			)
		)
		
		return lRootNode
	),
	
	-- return the root node of the document as a tXMLNode structure, undefined if no root exists
	-- or if the document is not correctly initialized
	-- There can be only one root node
	fn mfGetRootNode =
	(
		local lRootNode = undefined
		local lbContinue = undefined != mDotNetXmlDoc
		
		if lbContinue and undefined != mDotNetXmlDoc.DocumentElement do
		(
			lRootNode = tXMLNode()
			lRootNode.mfInit mDotNetXmlDoc.DocumentElement
		)
		
		return lRootNode
	),

	-- return true if the node has been set, false otherwise
	-- There can be only one root node.
	-- If a root node already exists the existing one will be overwritten
	-- If the rNewRootNode is already in the tree, it is first removed
	-- rNewRootNode: tXMLNode structure containing the node to set as the new root
	fn mfSetRootNode rNewRootNode =
	(
		local lbContinue = undefined != mDotNetXmlDoc
		
		if lbContinue do
			lbContinue = (classof rNewRootNode == tXMLNode)
		
		if lbContinue do
			if undefined == mDotNetXmlDoc.DocumentElement then
				mDotNetXmlDoc.AppendChild rNewRootNode.mDotNetNode
			else mDotNetXmlDoc.ReplaceChild mDotNetXmlDoc.DocumentElement rNewRootNode.mDotNetNode
		
		return lbContinue
	),
	
	-- return a node in the form of a tXMLNode structure instance,
	-- undefined if the document has not been initialized with mfCreateXML() or mfLoadXML()
	-- The returned node has no parent and doesn't belong to the nodes hierarchy, it has to be added
	-- explicitly with wkip
	-- rName:	the name of the node
	-- eg:	myXmlDoc.mfGetNewNode "position"
	fn mfGetNewNode rName =
	(
		local ltNewNode 			-- new tXMLNode
		
	--	local lTmpDotNetNode = mDotNetXmlDoc.CreateElement rName
	--	format "  mfGetNewNode: lTmpDotNetNode = %\n" lTmpDotNetNode
	--	global lDotNetNode = mDotNetXmlDoc.ImportNode lTmpDotNetNode true
	--	format "  mfGetNewNode: lDotNetNode = %\n" lDotNetNode
		
		lDotNetNode = mDotNetXmlDoc.CreateElement rName
		
		ltNewNode = tXMLNode()
		ltNewNode.mfInit lDotNetNode

		
--		myLoadedXmlDoc.mDotNetXmlDoc.ImportNode (myLoadedXmlDoc.mDotNetXmlDoc.CreateElement "teset") true
--		myRootNode.mDotNetNode.AppendChild myNodeLevel2.mDotNetNode
		
		return ltNewNode
	)
)


gtWkXMLLib = tXMLDocument()
format "WkXmlLibrary V.% loaded and instanciated in the variable gtWkXMLLib...\n" gtWkXMLLib.mVersion
-- following line is required to get the structure instance directly from a call to fileIn() such as:
--		myXMLDoc = fileIn "c:\\program files\\3dsmax\\scripts\\werwackscripts\\wkxmllibV1\\wkxmllib.ms"
gtWkXMLLib


/*/--------------------------------------------------------------------------------------------------------//

	WkXmlLibrary demo:
	
	The following code describe how to use WkXmlLibrary.
	Copy the code commented below to the maxscript listener and execute it line per line.
	
//--------------------------------------------------------------------------------------------------------/*/

/* -- start of the demo - see the end comment char at the end of the file --


-- Principle:
-------------

-- This file contains 2 structures:
-- 		- tXMLDocument is the main structure and will be associated with an XML file.
-- 		- tXMLNode is a structure that will hold a node, and so all its children (or contained
--		  nodes) at a given level of the nodes hierarchy of the XML file.
--
-- The principle of this script is this:
--		- the structure tXMLDocument is instanciated and used to open or create an XML document.
--		- we then get the root node and query it to travel into its nodes hierarchy and get
--		  the informations we want
--		- then we save the file and release the variable.
--
-- *** Be sure to read the notes in the file header to understand the limitations of this script ***


-- Instancing the library structure:
------------------------------------

-- When this script is evaluated, an instance of the structure is put to a global variable named gtWkXMLLib.
-- we may use it or use our own.
-- It case it is required to have more than 1 XML file opened at the same time, we have to use distinct variables.

-- we evaluate the script and, for the purpose of the example, put the instance in our own variable
if undefined == tXMLDocument then
--	myXmlDoc = fileIn ( getMaxDir #maxroot + "scripts\\werwackscripts\\wkxmllibrary\\wkxmllibrary.ms"
	myXmlDoc = fileIn ( "D:\\WkDev\\Maxscript\\DefScripts\\WkXmlLibrary\\WkXmlLibraryV1\\" + "scripts\\werwackscripts\\wkxmllibrary\\wkxmllibrary.ms"
else myXmlDoc = tXMLDocument()


-- Creating a XML file from scratch, adding content and saving it:
------------------------------------------------------------------

-- when we create a document it is not written on disk before we save it. The validity of file path is checked though.
-- we can either:
--	- create the document and specify the XML file name when we save it, with the functions mfCreateXML() and mfSaveXMLAs()
--	- or specify the XML file name when the document is created, with mfCreateXML rXmlFilePath: and mfSaveXML()
myNewXmlDoc = tXMLDocument()
myNewXmlDoc.mfCreateXML rXmlFilePath:"d:\\temp\\myXmlFile.xml"

-- so far there is no root node, so the value undefined is returned
myRootNode = myNewXmlDoc.mfGetRootNode()

-- we create a root node and get it
-- it is mandatory to create at least one node, the root, to save the file
myRootNode = myNewXmlDoc.mfCreateRootNode "DocRoot"

-- root information are displayed
myRootNode.mfDisplayNodeInfos()

-- a new node is created, modified and added to the root node
myNodeLevel1 = myNewXmlDoc.mfGetNewNode "NodeLevel1"
myNodeLevel1.mfAddAttribute "name" "FirstNode"
myRootNode.mfAppendChild myNodeLevel1

-- the document is saved and released
myNewXmlDoc.mfSaveXML()
myNewXmlDoc.mfReleaseXML()


-- Loading an existing XML file, adding content and saving it:
--------------------------------------------------------------

-- instead of using mfCreateXML, we will load a file
myLoadedXmlDoc = tXMLDocument()
myLoadedXmlDoc.mfLoadXML "d:\\temp\\myXmlFile.xml"

-- we read some nodes
myRootNode = myLoadedXmlDoc.mfGetRootNode()
myRootNode.mfDisplayNodeInfos()
rootNodeChildrenArr = myRootNode.mfGetChildren()
for node in rootNodeChildrenArr do
	node.mfDisplayNodeInfos()

-- we modify it
myNodeLevel2 = myLoadedXmlDoc.mfGetNewNode "NodeLevel2"
myNodeLevel2.mfSetText "Text in node level 2"
myNodeLevel2.mfAddAttribute "Attribute" "1234"
myNodeLevel2.mfGetAttribute "Attribute"
myNodeLevel2.mfSetAttribute "Attribute" "123456789"
rootNodeChildrenArr[1].mfAppendChild myNodeLevel2

-- the document is saved and released
myLoadedXmlDoc.mfSaveXML()
myLoadedXmlDoc.mfReleaseXML()


*/ -- end of the demo --





