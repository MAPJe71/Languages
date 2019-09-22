let
    //
    // Global variables to replace
    //
    ModuleName = "ServiceNow",   
    FunctionSuffix = "Contents",
    DriverName = "Simba ServiceNow ODBC Driver",

    FunctionName = ModuleName & "." & FunctionSuffix,
    IconPrefix = ModuleName,

    // Set to true if the catalog is hierarchical in nature (i.e. DB -> Schema -> Table).
    // Set to false to flatten it into a single list of tables.
    HierarchicalNavigation = true,

    // Set to true if using the private driver manager
    UsePrivateDriverManager = true,

    // Other global variables
    AuthType_OAuth = "OAuth 2.0",
    AuthType_Basic = "Basic Authentication",

    // *******************************************************************************
    //
    // Diagnostics-related functions are generic should be pulled into a separate module
    //

    Value.ToText = (value, optional depth) =>
        let
            nextDepth = if depth = null then 3 else depth - 1,
            result = if depth = 0 then "..."
                else if value is null then "<null>"
                else if value is function then "<function>"
                else if value is table then "#table({" & Text.Combine(Table.ColumnNames(value), ",") & "},{" & Text.Combine(
                    List.Transform(Table.ToRows(Table.FirstN(value, 2)), each @Value.ToText(_, nextDepth)), "},#(cr)#(lf){") & "})"
                    //& "Row Count (" & Number.ToText(Table.RowCount(value)) & ")"
                else if value is list then "{" & Text.Combine(List.Transform(List.FirstN(value, 10), each @Value.ToText(_, nextDepth)), ",") & "}"
                else if value is record then "[" & Text.Combine(List.Transform(Record.FieldNames(value), each _ & "=" & @Value.ToText(Record.Field(value, _), nextDepth)), ",") & "]"
                else if value is type then List.First(Table.Schema(#table({"type"}, {{value}}))[TypeName], "<type>")
                else Text.From(value)
        in
            try result otherwise "<error>",
    Diagnostics.LogValue = (prefix, value, result, optional delayed) => Diagnostics.Trace(TraceLevel.Information, prefix & ": " & Value.ToText(value), result, delayed),
    Diagnostics.LogValue2 = (prefix, value) => Diagnostics.Trace(TraceLevel.Information, prefix & ": " & Value.ToText(value), value),
    Diagnostics.LogFailure = (text, function) =>
        let
            result = try function()
        in
            if result[HasError] then Diagnostics.LogValue(text, result[Error], () => error result[Error], true) else result[Value],
    Diagnostics.WrapFunctionResult = (innerFunction as function, outerFunction as function) as function =>
        let
            parameterCount = Record.FieldCount(Type.FunctionParameters(Value.Type(innerFunction)))
        in
            if parameterCount = 0 then () => outerFunction(() => innerFunction())
            else if parameterCount = 1 then (p1) => outerFunction(() => innerFunction(p1))
            else if parameterCount = 2 then (p1, p2) => outerFunction(() => innerFunction(p1, p2))
            else if parameterCount = 3 then (p1, p2, p3) => outerFunction(() => innerFunction(p1, p2, p3))
            else if parameterCount = 4 then (p1, p2, p3, p4) => outerFunction(() => innerFunction(p1, p2, p3, p4))
            else if parameterCount = 5 then (p1, p2, p3, p4, p5) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5))
            else if parameterCount = 6 then (p1, p2, p3, p4, p5, p6) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5, p6))
            else if parameterCount = 7 then (p1, p2, p3, p4, p5, p6, p7) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5, p6, p7))
            else if parameterCount = 8 then (p1, p2, p3, p4, p5, p6, p7, p8) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5, p6, p7, p8))
            else if parameterCount = 9 then (p1, p2, p3, p4, p5, p6, p7, p8, p9) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5, p6, p7, p8, p9))
            else error "Too many arguments to wrap",
    Diagnostics.WrapHandlers = (handlers as record) as record =>
        Record.FromList(
            List.Transform(
                Record.FieldNames(handlers),
                (h) => Diagnostics.WrapFunctionResult(Record.Field(handlers, h), (fn) => Diagnostics.LogFailure(h, fn))),
            Record.FieldNames(handlers)),

    Value.IfNull = (a, b) => if a <> null then a else b,

    GetHost = (url) =>
        let
            parts = Uri.Parts(url),
            port = if (parts[Scheme] = "https" and parts[Port] = 443) or (parts[Scheme] = "http" and parts[Port] = 80) then "" else ":" & Text.From(parts[Port])
        in
            parts[Scheme] & "://" & parts[Host] & port,

    //
    //
    // *******************************************************************************

    ExportFunction = (resource as text, optional _options as record) as table =>
        let
            ConnectionString =
            [
                // At minimum you will need to use the resource value that was passed in!
                Driver = DriverName,
                Host = resource
            ],

            // TODO: this is what you would do for basic auth, need handlers for other kinds of auth
            Credential = Extension.CurrentCredential(),
            CredentialConnectionString = if Credential[AuthenticationKind]? = "UsernamePassword" then [
                    UID = Credential[Username], 
                    PWD = Credential[Password],
                    Auth_Type = AuthType_Basic
                ] else [],

            Options = [
                CredentialConnectionString = CredentialConnectionString,
                ClientConnectionPooling = true,
                UseEmbeddedDriver = UsePrivateDriverManager
            ],

            OptionsWithOverride = if (_options <> null) then Options & _options else Options,

            OdbcDataSource = Odbc.DataSource(ConnectionString, OptionsWithOverride & [
                HierarchicalNavigation = HierarchicalNavigation,                
                SqlCapabilities = [
                    SupportsTop = true
                ],
                SoftNumbers = true,
                HideNativeQuery = false,

                // TODO - bug in the current driver which throws an error when listing foreign keys
                SQLGetFunctions = [ SQL_API_SQLFOREIGNKEYS = false]
            ])
        in
            // only return the Display schema
            OdbcDataSource{0}[Data]{[Name="Display"]}[Data],

    Resource = [
        Description = ModuleName,
        Type = "Url",
        MakeResourcePath = (resource) => resource,
        ParseResourcePath = (resource) => { resource },
        TestConnection = (resource) => { FunctionName, resource },
        Authentication = [
            UsernamePassword = [
                UsernameLabel= Extension.LoadString("BasicAuth.Username"), 
                PasswordLabel=Extension.LoadString("BasicAuth.Password"),
                Label = Extension.LoadString("BasicAuth.Label")
            ]
        ],
        Exports = Record.AddField([], FunctionName, ExportFunction),
        ExportsUX = Record.AddField([], FunctionName, [
            ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
            SourceImage = Icons,
            SourceTypeImage = Icons,
            Beta = true,
            Category = "Other",
            SupportsDirectQuery = false
        ]),

        Label = Extension.LoadString("Resource.Label"),
        Icons = [
            Icon16 = { Extension.Contents(IconPrefix & "ODBC16.png"), Extension.Contents(IconPrefix & "ODBC20.png"), Extension.Contents(IconPrefix & "ODBC24.png"), Extension.Contents(IconPrefix & "ODBC32.png") },
            Icon32 = { Extension.Contents(IconPrefix & "ODBC32.png"), Extension.Contents(IconPrefix & "ODBC40.png"), Extension.Contents(IconPrefix & "ODBC48.png"), Extension.Contents(IconPrefix & "ODBC64.png") }
        ]
    ]
in
    Extension.Module(ModuleName, { Resource })