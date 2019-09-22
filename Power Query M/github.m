let

    // You MUST replace the values below for values for your own application
    // SignIn to GitHub and navigate to https://github.com/settings/applications/new
    // Follow the steps and obtain your client_id and client_secret

    client_id = "<place your client_id here>",
    client_secret = "<place your client_secret here>",
    redirect_uri = "https://preview.powerbi.com/views/oauthredirect.html",
    windowWidth = 1200,
    windowHeight = 1000,
    TokenMethod = (code) =>
        let
            Response = Web.Contents("https://github.com/login/oauth/access_token", [
                Content = Text.ToBinary(Uri.BuildQueryString([
                    client_id = client_id,
                    client_secret = client_secret,
                    code = code,
                    redirect_uri = redirect_uri])),
                Headers=[#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
            Parts = Json.Document(Response)
        in
            Parts,
    StartLogin = (resourceUrl, state, display) =>
        let
            AuthorizeUrl = "https://github.com/login/oauth/authorize?" & Uri.BuildQueryString([
                client_id = client_id,
                scope = "user, repo",
                state = state,
                redirect_uri = redirect_uri])
        in
            [
                LoginUri = AuthorizeUrl,
                CallbackUri = redirect_uri,
                WindowHeight = windowHeight,
                WindowWidth = windowWidth,
                Context = null
            ],
    FinishLogin = (context, callbackUri, state) =>
        let
            Parts = Uri.Parts(callbackUri)[Query]
        in
            TokenMethod(Parts[code]),
    Table.GenerateByPage = (getNextPage as function) as table =>
        let
            listOfPages = List.Generate(
                () => getNextPage(null),
                (lastPage) => lastPage <> null,
                (lastPage) => getNextPage(lastPage)
            ),
            tableOfPages = Table.FromList(listOfPages, Splitter.SplitByNothing(), {"Column1"}),
            firstRow = tableOfPages{0}?
        in
            if (firstRow = null) then
                Table.FromRows({})
            else
                Value.ReplaceType(
                    Table.ExpandTableColumn(tableOfPages, "Column1", Table.ColumnNames(firstRow[Column1])),
                    Value.Type(firstRow[Column1])
                ),
    GetNextLink = (link) =>
        let
            links = Text.Split(link, ","),
            splitLinks = List.Transform(links, each Text.Split(Text.Trim(_), ";")),
            next = List.Select(splitLinks, each Text.Trim(_{1}) = "rel=""next"""),
            first = List.First(next),
            removedBrackets = Text.Range(first{0}, 1, Text.Length(first{0}) - 2)
        in
            try removedBrackets otherwise null,
    GitHub.Contents = (url as text) =>
        let
            content = Web.Contents(url),
            link = GetNextLink(Value.Metadata(content)[Headers][#"Link"]?),
            json = Json.Document(content)
        in
            json meta [Next=link],
    GitHub.PagedTable = (url as text) => Table.GenerateByPage((previous) =>
        let
            next = if previous = null then null else Value.Metadata(previous)[Next],
            current = if previous <> null and next = null then null else GitHub.Contents(if next = null then url else next),
            link = if current = null then null else Value.Metadata(current)[Next],
            table = if current = null then null else Table.FromList(current, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
        in
            table meta [Next=link]),
    Resource = [
        Description = "github",
        Type="Singleton",
        MakeResourcePath = () => "github",
        ParseResourcePath = (resource) => { },
        TestConnection = (resource) => { "Github.Contents", "https://api.github.com/user" },
        Authentication=[OAuth=[StartLogin=StartLogin, FinishLogin=FinishLogin]],
        Exports = [
            Github.Contents = GitHub.Contents,
            Github.PagedTable = GitHub.PagedTable
        ]
    ],
    Extension = Extension.Module("github", { Resource })
in
    Extension
