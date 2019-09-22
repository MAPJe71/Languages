let
    client_id = "d2f23f3d-ecc7-4ab4-94cc-2f14f73b47e0",
    redirect_uri = "urn:ietf:wg:oauth:2.0:oob",
    token_uri = "https://login.microsoftonline.com/common/oauth2/v2.0/token",
    authorize_uri = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize",
    logout_uri = "https://login.microsoftonline.com/logout.srf",

    scope_prefix = "https://graph.microsoft.com/",
    scopes = {
        "User.ReadWrite",
        "Contacts.Read",
        "User.ReadBasic.All",
        "Calendars.ReadWrite",
        "Mail.ReadWrite",
        "Mail.Send",
        "Contacts.ReadWrite",
        "Files.ReadWrite",
        "Tasks.ReadWrite",
        "People.Read",
        "Notes.ReadWrite.All",
        "Sites.Read.All"
    },

    Value.IfNull = (a, b) => if a <> null then a else b,

    GetScopeString = (scopes as list, optional scopePrefix as text) as text =>
        let
            prefix = Value.IfNull(scopePrefix, ""),
            addPrefix = List.Transform(scopes, each prefix & _),
            asText = Text.Combine(addPrefix, " ")
        in
            asText,

    StartLogin = (resourceUrl, state, display) =>
        let
            authorizeUrl = authorize_uri & "?" & Uri.BuildQueryString([
                client_id = client_id,  
                redirect_uri = redirect_uri,
                state = state,
                scope = GetScopeString(scopes, scope_prefix),
                response_type = "code",
                response_mode = "query",
                login = "login"    
            ])
        in
            [
                LoginUri = authorizeUrl,
                CallbackUri = redirect_uri,
                WindowHeight = 720,
                WindowWidth = 1024,
                Context = null
            ],

    TokenMethod = (grantType, code) =>
        let
            tokenResponse = Web.Contents(token_uri, [
                Content = Text.ToBinary(Uri.BuildQueryString([
                    client_id = client_id,
                    code = code,
                    scope = GetScopeString(scopes, scope_prefix),
                    grant_type = grantType,
                    redirect_uri = redirect_uri])),
                Headers = [
                    #"Content-type" = "application/x-www-form-urlencoded",
                    #"Accept" = "application/json"
                ],
                ManualStatusHandling = {400} 
            ]),
            body = Json.Document(tokenResponse),
            result = if (Record.HasFields(body, {"error", "error_description"})) then 
                        error Error.Record(body[error], body[error_description], body)
                     else
                        body
        in
            result,

    FinishLogin = (context, callbackUri, state) =>
        let
            parts = Uri.Parts(callbackUri)[Query],
            result = if (Record.HasFields(parts, {"error", "error_description"})) then 
                        error Error.Record(parts[error], parts[error_description], parts)
                     else
                        TokenMethod("authorization_code", parts[code])
        in
            result,

    Refresh = (resourceUrl, refresh_token) => TokenMethod("refresh_token", refresh_token),

    Logout = (token) => logout_uri,

    MyGraph.Feed = (url as text) =>
        let
            source = OData.Feed(url, null, [ ODataVersion = 4, MoreColumns = true ])
        in
            source,

    Resource = [
        Description = "MyGraphConnector",
        Type = "Singleton",
        MakeResourcePath = () => "MyGraphConnector",
        ParseResourcePath = (resource) => { },
        TestConnection = (resource) => {  "MyGraph.Feed", "https://graph.microsoft.com/v1.0/me/" },
        Authentication = [
            OAuth= [
                StartLogin=StartLogin,
                FinishLogin=FinishLogin,
                Refresh=Refresh,
                Logout=Logout
            ]
        ],
        Exports = [
            MyGraph.Feed = MyGraph.Feed
        ],
        ExportsUX = [
            MyGraph.Feed = [
                ButtonText = { "MyGraph.Feed", "Connect to Graph" },
                SourceImage = Icons,
                SourceTypeImage = Icons
            ]
        ],
        Label = "MyGraph",
        Icons = [
            Icon16 = { Extension.Contents("MyGraph16.png"), Extension.Contents("MyGraph20.png"), Extension.Contents("MyGraph24.png"), Extension.Contents("MyGraph32.png") },
            Icon32 = { Extension.Contents("MyGraph32.png"), Extension.Contents("MyGraph40.png"), Extension.Contents("MyGraph48.png"), Extension.Contents("MyGraph64.png") }
        ]
    ],
    Extension = Extension.Module("MyGraph", { Resource })
in
    Extension