let
	
	Troux.Feed = (url as text) =>
		let
            content = OData.Feed(Uri.Combine(url,"/TrouxODataService") as text)
		in 
			content,
			
	Troux.CustomFeed = (url as text, query as text) =>
		let
            options = if Value.FromText(query)=null then
                           null
                      else
                           [Headers=[Query=query]],  
			
            content = OData.Feed(Uri.Combine(url,"/TrouxODataService/Custom") as text, null, options),
			data = if Text.Contains(query, "meta=y") then
					let
					    #"Invoked FunctionTroux CustomFeed" = content,
						#"Parsed JSON" = Table.TransformColumns(#"Invoked FunctionTroux CustomFeed",{},Json.Document),
						#"Expanded json" = Table.ExpandRecordColumn(#"Parsed JSON", "json", {"id", "datatype", "name", "description", "active", "metaverseUuid", "parentType", "properties"}, {"json.id", "json.datatype", "json.name", "json.description", "json.active", "json.metaverseUuid", "json.parentType", "json.properties"}),
						#"Expanded json.properties2" = Table.ExpandListColumn(#"Expanded json", "json.properties"),
						 #"Expanded json.properties" = Table.ExpandRecordColumn(#"Expanded json.properties2", "json.properties", {"id", "datatype", "name", "description", "active", "metaverseUuid", "scope", "computed", "precision", "relationshipType", "otherComponentType", "minCardinality", "maxCardinality", "otherMinCardinality", "otherMaxCardinality", "enumerationSet", "min", "max"}, {"json.properties.id", "json.properties.datatype", "json.properties.name", "json.properties.description", "json.properties.active", "json.properties.metaverseUuid", "json.properties.scope", "json.properties.computed", "json.properties.precision", "json.properties.relationshipType", "json.properties.otherComponentType", "json.properties.minCardinality", "json.properties.maxCardinality", "json.properties.otherMinCardinality", "json.properties.otherMaxCardinality", "json.properties.enumerationSet", "json.properties.min", "json.properties.max"})
					in
						#"Expanded json.properties"
					else
					 let 
						#"Invoked FunctionTroux CustomFeed" = content,
						#"Parsed JSON1" = Table.TransformColumns(#"Invoked FunctionTroux CustomFeed",{},Json.Document),
						json = #"Parsed JSON1"{0}[json],
						#"Converted to Table" = Table.FromList(json, Splitter.SplitByNothing(), null, null, ExtraValues.Ignore)
					 in 
						#"Converted to Table"
		in
			data,
   

    Troux.TestConnection = (url as text) =>
	let
        content = OData.Feed(Uri.Combine(Uri.Combine(url, "/TrouxODataService"), "?Person?$top=1"))
	in 
		content,

    Troux.FeedType = 
        let
            url = type text meta [
                Documentation.FieldCaption = Extension.LoadString("Troux.Feed.Parameter.url.FieldCaption"),
                Documentation.SampleValues = {}],
			
			   
            t = type function (url as url) as table
        in
            t meta [
            	Documentation.Description = Extension.LoadString("Troux.Feed.Function.Description"),
				Documentation.DisplayName = Extension.LoadString("Troux.Feed.Function.DisplayName"),
				Documentation.Caption = Extension.LoadString("Troux.Feed.Function.Caption"),
				Documentation.Name = Extension.LoadString("Troux.Feed.Function.Name"),
				Documentation.LongDescription = Extension.LoadString("Troux.Feed.Function.LongDescription")
                ],
	Troux.FeedTypeCustom = 
        let
            url = type text meta [
                Documentation.FieldCaption = Extension.LoadString("Troux.Custom.Parameter.url.FieldCaption"),
				Documentation.FieldDescription = Extension.LoadString("Troux.Custom.Parameter.url.FieldCaption"),
                Documentation.SampleValues = {}],
				
			 query = type text meta [
                Documentation.FieldCaption = Extension.LoadString("Troux.Custom.Parameter.query.FieldCaption"),
				Documentation.FieldDescription = Extension.LoadString("Troux.Custom.Parameter.query.FieldCaption"),
                Documentation.SampleValues = {}
                ],
			
			   
            t = type function (url as url, query as query) as table
        in
            t meta [
            	Documentation.Description = Extension.LoadString("Troux.Custom.Function.Description"),
				Documentation.DisplayName = Extension.LoadString("Troux.Custom.Function.DisplayName"),
				Documentation.Caption = Extension.LoadString("Troux.Custom.Function.Caption"),
				Documentation.Name = Extension.LoadString("Troux.Custom.Function.Name"),
				Documentation.LongDescription = Extension.LoadString("Troux.Custom.Function.LongDescription")
                ],

    GetHost = (url) =>
        let
            parts = Uri.Parts(url),
            port = if (parts[Scheme] = "https" and parts[Port] = 443) or (parts[Scheme] = "http" and parts[Port] = 80) then "" else ":" & Text.From(parts[Port])
        in
            parts[Scheme] & "://" & parts[Host] & port,

     Resource = [
        Description = "Troux",
        Type = "Url",
        MakeResourcePath = (url) => GetHost(url),
        ParseResourcePath = (url) => { url },
        TestConnection = (url) => { "Troux.TestConnection", url },
        Authentication=[UsernamePassword=[UsernameLabel="User Name", Password="Client Secret"]],
        Exports = [
            Troux.Feed = Value.ReplaceType(Troux.Feed, Troux.FeedType),
			Troux.CustomFeed= Value.ReplaceType(Troux.CustomFeed, Troux.FeedTypeCustom),
            Troux.TestConnection = Troux.TestConnection
        ],
        
        ExportsUX = [
            Troux.Feed= [
                Beta = true,
                ButtonText = { Extension.LoadString("FormulaTitle"), Extension.LoadString("FormulaHelp") },
                SourceImage = [Icon32 = { Extension.Contents("TrouxSheet_32.png"), Extension.Contents("TrouxSheet_40.png"), 
                                          Extension.Contents("TrouxSheet_48.png"), Extension.Contents("TrouxSheet_64.png")}],
                SourceTypeImage = Icons
            ]
        ],
        
        Label = Extension.LoadString("ResourceLabel"),
        
        Icons = [
            Icon16 = { Extension.Contents("Troux_16.png"), Extension.Contents("Troux_20.png"), Extension.Contents("Troux_24.png"), Extension.Contents("Troux_32.png") },
            Icon32 = { Extension.Contents("Troux_32.png"), Extension.Contents("Troux_40.png"), Extension.Contents("Troux_48.png"), Extension.Contents("Troux_64.png") }
        ]
    ],
    
    Extension = Extension.Module("Troux", { Resource })
in
    
    Extension