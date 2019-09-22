
let
    client_id = "xxx", 
    redirect_uri = "https://preview.powerbi.com/views/oauthredirect.html",
    logout_uri = "https://login.microsoftonline.com/logout.srf",
    windowWidth = 1024,
    windowHeight = 720,
    scope_prefix = null,
    scopes = { "user_impersonation" },
    oauth_prompt = "select_account",    // login, none, select_account

    defaultRequestHeaders = [
        #"Accept" = "application/json;odata.metadata=minimal",  // column name and values only
        #"OData-MaxVersion" = "4.0",                            // only support v4
        #"Prefer"="odata.include-annotations=""-*"""            // ignore anotations
    ],

    commonBatchHeaders = [
        #"OData-Version" = "4.0",
        #"OData-MaxVersion" = "4.0"
    ],

    // batch size for actions
    batch_size = 100,

    lineSeparator = "#(cr)#(lf)",

    // Schema format a table with two columns [ Name = field name, Value = data type ]
    // Alternate format is a json document
    SimpleOData.Feed = (url as text, optional _schema) as table => 
        let
            schema = if (_schema = null) then null else if (_schema is table) then _schema else SchemaTableFromJson(_schema),
            View = (state) => Table.View(null, Diagnostics.WrapHandlers([
                GetType = () => if (schema <> null) then TypeForSchema(schema) else Value.Type(GetRows()),
                GetRows = () => SimpleOData.PagedData(state[Url], state[Schema], state)
                //OnTake = (count as number) => @View(state & [maxrows = count]),
                //OnSkip = (count as number) => @View(state & [offset = count]),
            ]))
        in
            View([Url = url, Schema = schema]),
    
    // example key format {[Columns = {"id"}, Primary = true]}  -- call to Type.ReplaceTableKeys
    SimpleOData.Upsert = (url as text, entityName as text, rowsToUpsert as table, optional keys as list) as action =>
        let
            buffer = Table.Buffer(rowsToUpsert),
            batchUrl = Uri.Combine(url, "$batch"),
            entityUrl = Uri.Combine(url, entityName),
            withKeys = if (keys = null) then buffer else Table.ReplaceKeys(buffer, keys),
            urlColumn = "target_" & Text.NewGuid(),
            withEntity = AddTargetUrlToTable(entityUrl, urlColumn, withKeys),
            iterators = CreateIteratorList(batch_size, Table.RowCount(withEntity)),
            allActions = List.Accumulate(iterators, {}, (state, current) =>
                let
                    range = Table.Range(withEntity, current, batch_size),
                    batch = ODataBatch(batchUrl, urlColumn, range, current)
                in
                    state & {batch}
            ),
            combined = Action.Accumulate(allActions, {}, (x, y) => x & {y})
        in
            Action.Sequence({combined, (all) => Action.Return(Table.Combine(all))}),

    RowToODataBody = (row as record) as text => Text.FromBinary(Json.FromValue(row)),

    FormatHeaders = (_headers as record) as list => 
        let
            asTable = Record.ToTable(_headers),
            withColumn = Table.AddColumn(asTable, "Combined", each [Name] & ": " & Text.From([Value]), type text)
        in
            withColumn[Combined],

    CreateChangeSet = (_row as record, _urlColumn as text, _contentId as number, _changeTag as text) as text =>
        let
            changeHeaders = [
                #"Content-Type" = "application/http",
                #"Content-Transfer-Encoding" = "binary",
                #"Content-ID" = _contentId
            ],
            patchHeaders = commonBatchHeaders & [
                #"Content-Type" = "application/json;odata.metadata=minimal",
                #"Prefer" = "return=minimal",
                #"Accept" = "application/json;odata.metadata=minimal",
                #"If-Match" = "*"
            ],
            outputList = {
                { "--" & _changeTag },
                FormatHeaders(changeHeaders),
                { "" },
                { "PATCH " & Record.Field(_row, _urlColumn) & " HTTP/1.1" },
                FormatHeaders(patchHeaders),
                { "" },
                { RowToODataBody(Record.RemoveFields(_row, {_urlColumn})) },
                { "--" & _changeTag & "--" }
            },
            outputAsText = Text.Combine(List.Combine(outputList), lineSeparator)
        in
            outputAsText,

    CreateBatch = (_batchUrl as text, _data as table, _batchTag as text, _urlColumn as text, _rowCountColumn as text) as text =>
        let
            allRows = Table.ToRecords(_data),
            batch = List.Accumulate(allRows, {}, (state, current) =>
                let
                    changeTag = "changeset_" & Text.NewGuid(),            
                    contentId = Record.Field(current, _rowCountColumn),
                    removedRowCount = Record.RemoveFields(current, {_rowCountColumn}),
                    changeSet = CreateChangeSet(removedRowCount, _urlColumn, contentId, changeTag),
                    output = {
                        "--" & _batchTag,
                        "Content-Type: multipart/mixed; boundary=" & changeTag,
                        "",
                        changeSet
                    }
                in
                    List.Combine({state, output})
            ),
            output = Text.Combine(batch, lineSeparator) & lineSeparator & "--" & _batchTag & "--"
        in
            output,

    ProcessResponse = (_response as list) as record =>
        let
            // format of response will be:
            // {0} - Content-Type: multipart/mixed; boundary=<changeset_tag>
            // {1} - Contains changeset marker, content-type, and content-ID
            // {2} - HTTP status code, ETag and other response headers
            // {3} - Response body. Last line will be the boundary marker.
            changeResponse = Text.Split(_response{1}, "#(cr)#(lf)"),
            changeBoundary = changeResponse{0},
            changeTable = Table.FromList(List.RemoveFirstN(changeResponse, 1)),
            changeHeaders = Table.SplitColumn(changeTable, "Column1", Splitter.SplitTextByDelimiter(": "), {"Name", "Value"}),
            changeHeadersRecord = Record.FromTable(changeHeaders),

            patchResult = Text.Split(_response{2}, "#(cr)#(lf)"),
            patchStatusCode = Number.FromText(Text.Split(patchResult{0}, " "){1}),
            patchStatusText = Text.Trim(Text.Range(patchResult{0}, Text.PositionOf(patchResult{0}, " "))),
            patchTable = Table.FromList(List.RemoveFirstN(patchResult, 1)),
            patchHeaders = Table.SplitColumn(patchTable, "Column1", Splitter.SplitTextByDelimiter(": "), {"Name", "Value"}),
            patchHeadersRecord = Record.FromTable(patchHeaders),

            body = Text.Trim(Text.Replace(_response{3}, changeBoundary & "--", "")),
            formattedBody = if (Text.Length(body) > 0) then Json.Document(body) else body
        in
            [StatusCode = patchStatusCode, StatusText = patchStatusText, ContentId=changeHeadersRecord[#"Content-ID"]?, ChangeHeaders = changeHeadersRecord, ContentHeaders = patchHeadersRecord, Content = formattedBody],

    CreateIteratorList = (increment as number, max as number) as list => List.Generate(() => 0, (i) => i < max, (i) => i + increment),

    ODataBatch = (_batchUrl as text, _urlColumn as text, _data as table, _offset as number) as action =>
        let
            batchTag = "batch_" & Text.NewGuid(),
            batchHeaders = commonBatchHeaders & [
                #"Content-Type" = "multipart/mixed; boundary=" & batchTag,
                #"Accept" = "multipart/mixed"
            ],
            contentIdColumn = "contentId_" & Text.NewGuid(),
            withContentId = Table.AddIndexColumn(_data, contentIdColumn, _offset + 1),
            action = WebAction.Request(WebMethod.Post, _batchUrl, [
                Headers = batchHeaders,
                Content = Text.ToBinary(CreateBatch(_batchUrl, withContentId, batchTag, _urlColumn, contentIdColumn))
            ]),
            return = Action.Sequence({action, (response) => Action.Return(
                let
                    responseMeta = Value.Metadata(response),
                    responseHeaders = if (responseMeta[Content.Type]? = "multipart/mixed") then responseMeta[Headers]
                                      else error "Unexpected content-type on response: " & responseMeta[Content.Type]?,
                    contentType = responseHeaders[#"Content-Type"],
                    boundaryTag = Text.Split(contentType, "boundary="){1},
                    batches = Text.Split(Text.FromBinary(response), "--" & boundaryTag),
                    sections = List.Transform(batches, each Text.Split(Text.Trim(_),"#(cr)#(lf)#(cr)#(lf)")),
                    removeExtraSections = List.RemoveLastN(List.RemoveFirstN(sections, 1), 1),
                    toRecords = List.Transform(removeExtraSections, each ProcessResponse(_)),
                    toTable = Table.FromRecords(toRecords),

                    // We need to join the response with the request on the ContentId field we generated with the table index.
                    // This is done so the consumer can link the status with the input key.
                    setTypes = Table.TransformColumnTypes(toTable, {
                        {"StatusCode", Int32.Type},
                        {"StatusText", type text},
                        {"ContentId", Int32.Type}
                    }),
                    joined = Table.NestedJoin(setTypes, "ContentId", withContentId, contentIdColumn, "Input", JoinKind.Inner),
                    addTargetUrl = Table.AddColumn(joined, "TargetUrl", each Record.Field([Input]{0}, _urlColumn), type text),
                    inputToRecord = Table.TransformColumns(addTargetUrl, {
                        {"Input", each Table.First(_)}  // we want the first row
                    }),
                    removed = Table.TransformColumns(inputToRecord, {
                        {"Input", each Record.RemoveFields(_, {_urlColumn, contentIdColumn})}
                    }),
                    removeContentId = Table.RemoveColumns(removed, {"ContentId"}, MissingField.Ignore)
                in
                    removeContentId
            )})
        in
            return,

    Action.Accumulate = (list as list /* of action */, seed as any, accumulator as function) =>
        Action.Sequence({
            Action.Return(seed)} &
            List.Transform(list, (action) => (previous) => Action.Sequence({action, (current) => Action.Return(accumulator(previous, current))}))),

    // Creates OData key string format.
    // Each key/value is a field in the record.
    // If there is more than one key, the names are included (i.e. customer='AFK',id=222).
    // Non-number values receive single quotes around them.
    // We try to detect GUID values because they should not be quoted either
    // Caller is expected to add the surrounding braces.
    CreateKeyString = (_record as record) as text =>
        let
            ToTable = Record.ToTable(_record),
            QuoteValues = Table.TransformColumns(ToTable, {"Value", each if (_ is number or ValueIsGuid(_)) then Text.From(_) else "'" & Text.From(_) & "'"}),
            Combined = Table.AddColumn(QuoteValues, "Combined", each [Name] & "=" & Text.From([Value])),
            Formatted = if (Table.RowCount(ToTable) > 1) then Text.Combine(Combined[Combined], ",") else List.First(QuoteValues[Value])
        in
            Formatted,

    ValueIsGuid = (_value as text) as logical => Text.Length(_value) = 36 and List.Count(Text.Split(_value, "-")) = 5,

    // Given URL to the entity (i.e. http://local/odata/customer) this function
    // adds a new column with the full URL to reference each row. The table must have 
    // keys on its type.
    AddTargetUrlToTable = (_entityUrl as text, _columnName as text, _source as table) as table =>
        let
            tableType = Value.Type(_source),
            TableKeys = Type.TableKeys(tableType),
            // validate that we have keys
            sourceTable = if (List.Count(TableKeys) > 0) then _source else error "source table must have keys defined",
            ToTable = Table.FromList(TableKeys, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
            Expand = Table.ExpandRecordColumn(ToTable, "Column1", {"Columns", "Primary"}, {"Columns", "Primary"}),
            PrimaryOnly = Table.SelectRows(Expand, each [Primary] = true),
            ExpandKeys = Table.ExpandListColumn(PrimaryOnly, "Columns"),
            KeysAsRecord = Table.AddColumn(sourceTable, "KeyTable", each Record.SelectFields(_, ExpandKeys[Columns])),
            CreateKeyString = Table.AddColumn(KeysAsRecord, "KeyString", each CreateKeyString([KeyTable])),
            AddUrl = Table.AddColumn(CreateKeyString, _columnName, each _entityUrl & "(" & [KeyString] & ")", type text),
            Cleanup = Table.RemoveColumns(AddUrl,{"KeyTable", "KeyString"})
        in
            Cleanup,

    GetNextLink = (_context as text, _nextLink as text) as text =>
        if (Text.StartsWith(_nextLink, "http://") or Text.StartsWith(_nextLink, "https://")) then
            _nextLink
        else
            Text.Start(_context, Text.PositionOf(_context, "$metadata")) & _nextLink,

    SimpleOData.Page = (_query as nullable text, optional _schema as table, optional _options as record) as nullable table =>
        if (_query = null) then null else
        let
            webContext = Web.Contents(_query, [ Headers = defaultRequestHeaders ]),
            response = Json.Document(webContext),            
            context = try response[#"@odata.context"] otherwise error "Missing @odata.context in response. Is this an OData response?",
            next = Record.FieldOrDefault(response, "@odata.nextLink"),
            nextLink = if (next <> null) then GetNextLink(context, next) else null,
            data = Table.FromRecords(response[value]),
            formatted = if (_schema <> null) then EnforceSchema(data, _schema) else data
        in
            formatted meta [NextLink = nextLink],

    SimpleOData.PagedData = (_query as text, optional _schema as table, optional _options as record) as table => 
        let
            schemaType = if (_schema <> null) then TypeForSchema(_schema) else null,
            allPages = Table.GenerateByPage((previous) =>
                let
                    nextLink = if (previous = null) then _query else Value.Metadata(previous)[NextLink]
                in
                    SimpleOData.Page(nextLink, _schema),
                schemaType)
        in
            allPages,

    Resource = [
        Description = "SimpleOData",
        Type = "Url",
        MakeResourcePath = (url) => url,
        ParseResourcePath = (url) => { url },
        TestConnection = (url) => { "SimpleOData.Feed", url },
        Authentication = [
            OAuth=[StartLogin=StartLogin, FinishLogin=FinishLogin, Refresh=Refresh, Logout=Logout],
            UsernamePassword = [],
            Windows = [],
            Implicit = []
        ],
        Exports = [
            SimpleOData.Feed = SimpleOData.Feed,
            SimpleOData.Upsert = SimpleOData.Upsert
        ],
        ExportsUX = [
            SimpleOData.Feed = [
                ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
                SourceImage = Icons,
                SourceTypeImage = Icons,
                Beta = true,
                Category = "Web",
                SupportsDirectQuery = false
            ]
        ],
        Label = "SimpleOData",
        Icons = [
            Icon16 = { Extension.Contents("SimpleOData16.png"), Extension.Contents("SimpleOData20.png"), Extension.Contents("SimpleOData24.png"), Extension.Contents("SimpleOData32.png") },
            Icon32 = { Extension.Contents("SimpleOData32.png"), Extension.Contents("SimpleOData40.png"), Extension.Contents("SimpleOData48.png"), Extension.Contents("SimpleOData64.png") }
        ]
    ],

    StartLogin = (resourceUrl, state, display) =>
        let
            baseUrl = GetAuthUrl(resourceUrl),
            tenant = Text.Split(baseUrl, "/"){3},
            authorizeUrl = baseUrl & "?" & Uri.BuildQueryString([
                state = state,
                display = "popup",
                client_id = client_id,    
                redirect_uri = redirect_uri,
                resource = GetHost(resourceUrl),
                response_type = "code",
                prompt = oauth_prompt,
                scope = GetScopeString(scopes, scope_prefix)
            ])
        in
            [
                LoginUri = authorizeUrl,
                CallbackUri = redirect_uri,
                WindowHeight = windowHeight,
                WindowWidth = windowWidth,
                Context = tenant
            ],

    TokenMethod = (tenant, grantType, body as record) =>
        let
            TokenUrl = GetTokenUrl(tenant),
            Response = Web.Contents(TokenUrl, [
                Content = Text.ToBinary(Uri.BuildQueryString([
                    client_id = client_id,
                    redirect_uri = redirect_uri,
                    grant_type = grantType
                ] & body)),
                Headers = [
                    #"Content-type" = "application/x-www-form-urlencoded",
                    #"Accept" = "application/json"],
                ManualStatusHandling = {400} 
            ]),
            Parts = Json.Document(Response),
            Result = if (Record.HasFields(Parts, {"error", "error_description"})) then 
                        error Error.Record(Parts[error], Parts[error_description], Parts)
                     else
                        Parts
        in
            Result,

    FinishLogin = (context, callbackUri, state) =>
        let
            Parts = Uri.Parts(callbackUri)[Query],
            // check for error
            Result = if (Record.HasFields(Parts, {"error", "error_description"})) then 
                        error Error.Record(Parts[error], Parts[error_description], Parts)
                     else
                        TokenMethod(context, "authorization_code", [code = Parts[code]])
        in
            Result,

    Refresh = (resourceUrl, refresh_token) =>
        let
            authUrl = GetAuthUrl(resourceUrl),
            tenant = Text.Split(authUrl, "/"){3},
            result = TokenMethod(tenant, "refresh_token", [refresh_token = refresh_token])
        in
            result,

    Logout = (token) => logout_uri,
    GetTokenUrl = (tenant) as text => "https://login.microsoftonline.com/" & tenant & "/oauth2/token",
    GetAuthUrl = (resourceUrl) =>
        let
            options = [Headers=[Authorization="Bearer"], ManualStatusHandling={401}],
            headerKey = "WWW-Authenticate",
            response = Web.Contents(resourceUrl, options),
            authHeader = Record.FieldOrDefault(Value.Metadata(response)[Headers], headerKey),
            response2 = Web.Contents(resourceUrl & "/web?SDKClientVersion=7.0.0.2067", options),
            authHeader2 = if authHeader <> null then authHeader else Record.Field(Value.Metadata(response2)[Headers], headerKey),
            headerPos = Text.PositionOf(authHeader2, "="),
            baseUrl = List.First(Text.Split(Text.Range(authHeader2, 1 + headerPos), ","))
        in
            baseUrl,
    GetScopeString = (scopes as list, optional scopePrefix as text) as text =>
        let
            prefix = Value.IfNull(scopePrefix, ""),
            addPrefix = List.Transform(scopes, each prefix & _),
            asText = Text.Combine(addPrefix, " ")
        in
            asText,

    // Schema functions
    EnforceSchema = (table as table, schema as table) as table =>
        let
            schemaNames = schema[Name],
            foundNames = Table.ColumnNames(table),
            addNames = List.RemoveItems(schemaNames, foundNames),
            extraNames = List.RemoveItems(foundNames, schemaNames),
            tmp = Text.NewGuid(),
            added = Table.AddColumn(table, tmp, each []),
            expanded = Table.ExpandRecordColumn(added, tmp, addNames),
            result = if List.IsEmpty(addNames) then table else expanded,
            reordered = Table.SelectColumns(result, schemaNames),
            changedType = EnforceTypes(reordered, schema)
        in
            changedType,

    EnforceTypes = (table as table, schema as table) as table =>
        let
            map = (t) => if t = type list or t = type record or t = type any then null else t,
            mapped = Table.TransformColumns(schema, {"Value", map}),
            omitted = Table.SelectRows(mapped, each [Value] <> null),
            transforms = Table.ToRows(omitted),
            changedType = Table.TransformColumnTypes(table, transforms)
        in
            changedType,

    EmptyTable = (schema as table) as table =>
        let
            schemaNames = schema[Name],
            table = Table.FromRows({}, schemaNames),
            changedType = EnforceTypes(table, schema)
        in
            changedType,

    TypeForSchema = (schema as table) as type =>
        let
            toList = List.Transform(schema[Value], (t) => [Type=t, Optional=false]),
            toRecord = Record.FromList(toList, schema[Name]),
            toType = Type.ForRecord(toRecord, false)
        in
            type table (toType),

    Type.FromText = (typeName as text) as type =>
        let
           map = #table({"TypeName", "Type"}, {
                        {"Binary.Type", Binary.Type},
                        {"Byte.Type",	Byte.Type               },
                        {"Character.Type",	Character.Type      },
                        {"Currency.Type",	Currency.Type       },
                        {"Date.Type",	Date.Type               },
                        {"DateTime.Type",	DateTime.Type       },
                        {"DateTimeZone.Type", DateTimeZone.Type },
                        {"Decimal.Type",	Decimal.Type        },
                        {"Double.Type",	Double.Type             },
                        {"Duration.Type",	Duration.Type       },
                        {"Int16.Type",	Int16.Type              },
                        {"Int32.Type",	Int32.Type              },
                        {"Int64.Type",	Int64.Type              },
                        {"Int8.Type",	Int8.Type               },
                        {"Logical.Type",	Logical.Type        },
                        {"Null.Type",	Null.Type               },
                        {"Number.Type",	Number.Type             },
                        //{"Percentage.Type",	Percentage.Type     },
                        {"Single.Type",	Single.Type             },
                        {"Text.Type",	Text.Type               },
                        {"Time.Type",	Time.Type               }
            }),
            selected = Table.First(Table.SelectRows(map, each [TypeName] = typeName), null),
            valueType = if (selected = null) then Any.Type else selected[Type]
        in
            valueType,

    SchemaTableFromJson = (json) as table =>
        let
            SchemaTable = Table.FromRecords(Json.Document(json)),
            Sorted = Table.Sort(SchemaTable,{{"Position", Order.Ascending}}),
            AddFacets = Table.AddColumn(Sorted, "Facets", each [
                NumericPrecisionBase = [NumericPrecisionBase],
                NumericPrecision = [NumericPrecision],
                NumericScale = [NumericScale],
                DateTimePrecision = [DateTimePrecision],
                MaxLength = [MaxLength],
                IsVariableLength = [IsVariableLength],
                NativeTypeName = [NativeTypeName],
                NativeDefaultExpression = [NativeDefaultExpression],
                NativeExpression = [NativeExpression]
            ]),
            AddDocumentation = Table.AddColumn(AddFacets, "Documentation", each [ Documentation.IsWritable = [IsWritable], Documentation.Description = [Description] ]),
            AddType = Table.AddColumn(AddDocumentation, "Type", each Type.FromText([TypeName]), type type),
            SetNullable = Table.AddColumn(AddType, "NullableType", each try if ([IsNullable]) then (type nullable _[Type]) else _[Type] otherwise _[Type], type type),
            SetFinalType = Table.AddColumn(SetNullable, "Value", each Type.ReplaceFacets([NullableType], [Facets]) meta [Documentation], type type),
            TrimColumns = Table.SelectColumns(SetFinalType,{"Name", "Value", "Position"})
        in
            TrimColumns,

    // Diagnostics-related functions are generic should be pulled into a separate module
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

    Table.ToNavigationTable = (
        table as table,
        keyColumns as list,
        nameColumn as text,
        dataColumn as text,
        itemKindColumn as text,
        itemNameColumn as text,
        isLeafColumn as text
    ) as table =>
        let
            tableType = Value.Type(table),
            newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
            [
                NavigationTable.NameColumn = nameColumn, 
                NavigationTable.DataColumn = dataColumn,
                NavigationTable.ItemKindColumn = itemKindColumn, 
                Preview.DelayColumn = itemNameColumn, 
                NavigationTable.IsLeafColumn = isLeafColumn
            ],
            navigationTable = Value.ReplaceType(table, newTableType)
        in
            navigationTable,

    Uri.FromParts = (parts) =>
    let
        port = if (parts[Scheme] = "https" and parts[Port] = 443) or (parts[Scheme] = "http" and parts[Port] = 80) then "" else ":" & Text.From(parts[Port]),
        div1 = if Record.FieldCount(parts[Query]) > 0 then "?" else "",
        div2 = if Text.Length(parts[Fragment]) > 0 then "#" else "",
        uri = Text.Combine({parts[Scheme], "://", parts[Host], port, parts[Path], div1, Uri.BuildQueryString(parts[Query]), div2, parts[Fragment]})
    in
        uri,

    GetHost = (url) =>
        let
            parts = Uri.Parts(url),
            port = if (parts[Scheme] = "https" and parts[Port] = 443) or (parts[Scheme] = "http" and parts[Port] = 80) then "" else ":" & Text.From(parts[Port])
        in
            parts[Scheme] & "://" & parts[Host] & port,

    Table.GenerateByPage = (getNextPage as function, optional tableType as type) as table =>
        let
            listOfPages = List.Generate(
                () => getNextPage(null),
                (lastPage) => lastPage <> null,
                (lastPage) => getNextPage(lastPage)
            ),
            tableOfPages = Table.FromList(listOfPages, Splitter.SplitByNothing(), {"Column1"}, null, ExtraValues.Error),
            firstRow = tableOfPages{0}?,
            keys = if tableType = null then Table.ColumnNames(firstRow[Column1])
                else Record.FieldNames(Type.RecordFields(Type.TableRow(tableType))),
            appliedType = if tableType = null then Value.Type(firstRow[Column1]) else tableType
        in
            if ((tableType = null and firstRow = null) or Table.IsEmpty(tableOfPages)) then
                Table.FromRows({},{"Column1"})
            else
                Value.ReplaceType(
                    Table.ExpandTableColumn(tableOfPages, "Column1", keys),
                    appliedType)
in
    Extension.Module("SimpleOData", { Resource })