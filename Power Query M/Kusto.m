// TODO
// Register new client_id
let
    //client_id = "xxx",
    //client_secret = "xxx",
    redirect_uri = "https://preview.powerbi.com/views/oauthredirect.html",
    resource_uri = "https://microsoft/kusto",
    base_oauth_uri = "https://login.windows.net/microsoft.com",
    logout_uri = "https://login.windows.net/logout.srf",
    windowWidth = 1200,
    windowHeight = 1000,
    defaultMaxRows = 10000,

    // This callback starts the login process (gets the Authorization Token)
    StartLogin = (resourceUrl, state, display) =>
        let
            AuthorizeUrl = base_oauth_uri & "/oauth2/authorize?" & Uri.BuildQueryString([
                client_id = client_id,
                resource = resource_uri,
                state = state,
                response_type = "code",
                prompt = "login",
                redirect_uri = redirect_uri
                ])
        in
            [
                LoginUri = AuthorizeUrl,
                CallbackUri = redirect_uri,
                WindowHeight = windowHeight,
                WindowWidth = windowWidth,
                Context = null
            ],
            
    TokenMethod = (grantType, code) =>
        let
            Response = Web.Contents(base_oauth_uri & "/oauth2/token", [
                Content = Text.ToBinary(Uri.BuildQueryString([
                    client_id = client_id,
                    code = code,
                    grant_type = grantType,                
                    redirect_uri = redirect_uri,
                    resource = resource_uri,
                    client_secret = client_secret
                    ])),
                Headers=[#"Content-type" = "application/x-www-form-urlencoded", #"Accept" = "application/json"]]),
            Parts = Json.Document(Response)
        in
            Parts,
            
    // This callback is called with the Authorization Token, and exchanges it for an Access Token
    FinishLogin = (context, callbackUri, state) =>
        let
            Parts = Uri.Parts(callbackUri)[Query]
        in
            TokenMethod("authorization_code", Parts[code]),
    
    Refresh = (resourceUrl, refresh_token) =>
        let
            Response = Web.Contents(base_oauth_uri & "/oauth2/token?", [
                Content = Text.ToBinary(Uri.BuildQueryString([
                    client_id = client_id,
                    client_secret = client_secret,
                    grant_type = "refresh_token",
                    refresh_token = refresh_token,
                    resource = resource_uri
                    ])),
                Headers=[#"Content-type" = "application/x-www-form-urlencoded", #"Accept" = "application/json"]]),
            Parts = Json.Document(Response)
        in
            Parts,

    Logout = (token) => logout_uri,

    // Generates a navigation table from a list of values. The navigation table is wrapped in a Table.View that 
    // will skip the call to fetch the entire list when a specific item is specified. 
    //
    // listFunction - a zero arg function that returns a list. Used as the [Name] column in your nav table.
    // dataFunction - a one arg function that returns a table. Used to create the [Data] column in your nav table.
    NavigationTableFromList = (listFunction as function, dataFunction as function, optional isLeaf as logical) as table =>
        let
            _isLeaf = if (isLeaf = null) then true else isLeaf,
            View = (state) => Table.View(null, Diagnostics.WrapHandlers([
                GetType = () => type table [ Name = text, Data = table, ItemKind = text, ItemName = text, IsLeaf = logical ],
                GetRows = () => if (state <> null) then state else
                    let
                        list = listFunction(),
                        withName = Table.FromList(list, Splitter.SplitByNothing(), {"Name"}),
                        withData = Table.AddColumn(withName, "Data", each dataFunction(_)),
                        withItemKind = Table.AddColumn(withData, "ItemKind", each "Table"),
                        withItemName = Table.AddColumn(withItemKind, "ItemName", each [Name]),
                        withIsLeaf = Table.AddColumn(withItemName, "IsLeaf", each _isLeaf),
                        navTable = Table.ToNavigationTable(withIsLeaf, {"Name"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
                    in
                        navTable,

                OnSelectRows = (selector) =>
                    let
                        condition = RowExpression.From(selector),
                        kind = condition[Kind],
                        leftKind = condition[Left][Kind],
                        member = condition[Left][MemberName],
                        value = condition[Right][Value]
                    in
                        if (kind = "Binary" and leftKind = "FieldAccess" and member = "Name") then
                            Table.FromRecords({[
                                Name = value,
                                Data = dataFunction(value),
                                ItemKind = "Table",
                                ItemName = value,
                                IsLeaf = true
                            ]})
                        else
                            ...
            ]))
        in
            View(null),

    GetNavForDatabase = (cluster as text, database as text, optional options as record) as table =>
        NavigationTableFromList(
            () => Kusto.Tables(cluster, database),
            (table) => Kusto.SmartQuery(cluster, database, table, options),
            true
        ),

    GetNavForCluster = (cluster as text, optional options as record) as table =>
        NavigationTableFromList(
            () => Kusto.Databases(cluster),
            (db) => GetNavForDatabase(cluster, db, options),
            false
        ),

    Kusto.Contents = (cluster as text, optional database as text, optional table as text, optional options as record) =>
        if (table <> null and database = null) then
            error "database parameter must be specified when specifying a table value"
        else if (table <> null) then
            Kusto.SmartQuery(cluster, database, table, options)
        else if (database <> null) then
            GetNavForDatabase(cluster, database, options)
        else
            GetNavForCluster(cluster, options),

    Kusto.Databases = (cluster as text) as list =>
        let
            content = Web.Contents("https://" & cluster & ".kusto.windows.net:443/v1/rest/query?csl=.show version",
            [
                Content=Json.FromValue([
                    csl=".show schema"
                ]),
                Timeout=#duration(0, 0, 4, 0),
                Headers=[#"Content-Type" = "application/json; charset=utf-8"]
            ]),
            json = Json.Document(content),
            SourceTable = Record.ToTable(json),
            SourceTableExpanded = Table.ExpandListColumn(SourceTable, "Value"),
            SourceTableExpandedValues = Table.ExpandRecordColumn(SourceTableExpanded, "Value", {"TableName", "Columns", "Rows"}, {"TableName", "Columns", "Rows"}),
            RowsList = SourceTableExpandedValues{0}[Rows],
            FirstColumnValues = List.Distinct(List.Transform(RowsList, (r) => r{0}))
        in
            FirstColumnValues,
            
    Kusto.Tables = (cluster as text, database as text) as list =>
        let
            content = Web.Contents("https://" & cluster & ".kusto.windows.net:443/v1/rest/query?db=" & database & "&csl=.show version",
            [
                Content=Json.FromValue([
                    csl=".show schema"
                ]),
                Timeout=#duration(0, 0, 4, 0),                
                Headers=[#"Content-Type" = "application/json; charset=utf-8"]
            ]),
            json = Json.Document(content),
            SourceTable = Record.ToTable(json),
            SourceTableExpanded = Table.ExpandListColumn(SourceTable, "Value"),
            SourceTableExpandedValues = Table.ExpandRecordColumn(SourceTableExpanded, "Value", {"TableName", "Columns", "Rows"}, {"TableName", "Columns", "Rows"}),
            RowsList = SourceTableExpandedValues{0}[Rows],
            DatabaseRowsList = List.Select(RowsList, (r) => r{0} = database and r{1} <> null),
            FirstColumnValues = List.Distinct(List.Transform(DatabaseRowsList, (r) => r{1}))
        in
            FirstColumnValues,
    
    NormalizeColumnName = (name as text) as text => if (Text.Contains(name, " ")) then "[""" & name & """]" else name,
    
    Expressions = (expression) => 
        let 
            // Dummy functions placeholders, used to negate their matching functions
            Text.NotContains = () => {},
            Text.NotEndsWith = () => {},
            Text.NotStartsWith = () => {},
            List.NotContains = () => {},

            return = (value) => value,

            // Main expression handling based on its kind
            handleExpr = (x) => 
                let 
                    kind = x[Kind],
                    expr = if (kind = "Unary") then unaryExpr(x) else
                           if (kind = "Binary") then binaryExpr(x) else
                           if (kind = "If") then ifExpr(x) else
                           if (kind = "FieldAccess") then fieldAccessExpr(x) else
                           if (kind = "ElementAccess") then kind else //elementAccessExpr(x) else
                           if (kind = "Identifier") then identifierExpr(x) else
                           if (kind = "Constant") then constantExpr(x) else
                           if (kind = "Invocation") then invocationExpr(x) else
                           error Error.Record("Unhandled kind type", "Unhandled kind type: " & kind, null)
                in
                    expr,

            // Handles Unary operators
            unaryExpr = (x) => 
                 let 
                     operator = x[Operator],
                     innerExpr = x[Expression],
                     expressionKind = innerExpr[Kind],
                     expr = if (operator = "Not") then handleExpr(invertExpression(innerExpr)) else 
                            if (operator = "Negative") then "-" & handleExpr(innerExpr) else
                            handleExpr(innerExpr)
                 in 
                     expr,

            // Handles Binary operators
            binaryExpr = (x) => 
                let 
                    op = operatorExpr(x[Operator]),
                    left = handleExpr(x[Left]),
                    right = handleExpr(x[Right]),

                    bracketedLeft = if (comparePrecedence(op, left) < 0) then "(" & left & ")" else left,
                    bracketedRight = if (comparePrecedence(op, right) < 0) then "(" & right & ")" else right,
                    format = if (op = "&") then "strcat(#{0}, #{2})" // TODO: Optimize multiple concatenations strcat(strcat("a", "b"), "c") => strcat("a", "b", "c")
                        else "#{0} #{1} #{2}" 
                in 
                    Text.Format(format, { bracketedLeft, op, bracketedRight}) meta [Precedence = precedence(op)],

            // Handles If statements
            ifExpr = (x) => 
                let 
                    cond = handleExpr(x[Condition]),
                    left = handleExpr(x[TrueCase]),
                    right = handleExpr(x[FalseCase])
                in 
                   Text.Format("iff(#{0}, #{1}, #{2})", { cond, left, right }),

            // Handles Field Access expressions
            fieldAccessExpr = (x) => 
                let
                    rec = 
                    [
                        Kind = "FieldAccess",
                        MemberName = x[MemberName],
                        Expression = identifierExpr(x)
                    ]
                in 
                    rec[MemberName] meta [Precedence = -1],
        
            // Handles Element Access expressions
            elementAccessExpr = (x) => 
                let
                    rec = 
                    [
                        Kind = "ElementAccess",
                        Key = handleExpr(x[Key]),
                        Collection = handleExpr(x[Collection])
                    ]
                in 
                    Text.Format("(#{0}[#{1})", { rec[Collection], rec[Key] }) meta [Precedence = -1],

            // Handles Identifier expressions
            identifierExpr = (x) =>
                let rec = 
                    [
                        Kind = "Identifier",
                        Key = x[Name]
                    ]
                in
                    rec[Name],

            // Handles Constants expressions
            constantExpr = (x) => 
                let rec =
                    [
                        Kind = "Constant",
                        Value = escapeValue(x[Value]) meta [Precedence = -1]
                    ]
                in
                    rec[Value] meta [Precedence = -1],

            // Handles Function Invocations expressions
            invocationExpr = (x) => 
                let rec = 
                    [
                        Kind = "Invocation",
                        FunctionFormat = functionFormatExpr(x),
                        Arguments = List.Transform(x[Arguments], (a) => handleExpr(a)),
                        ArgumentsKinds = List.Transform(x[Arguments], (a) => a[Kind])
                    ]
                in 
                     "(" & Text.Format(rec[FunctionFormat], rec[Arguments]) & ")",

            //Invert expression based on inner expression kind
            invertExpression = (x) =>
                let
                    kind = x[Kind],
                    expr = if (kind = "Binary") then (
                                // Implementing DeMorgan law to negate left/right branches, and invert operator
                                if (x[Operator] = "And" or x[Operator] = "Or") then 
                                    [
                                        Kind = x[Kind],
                                        Left = @invertExpression(x[Left]),
                                        Right = @invertExpression(x[Right]),
                                        Operator = if (x[Operator] = "And") then "Or" else "And"
                                    ]
                                else // Invert operator in case of <, <=, >, >=, ==, <>
                                    [
                                        Kind = x[Kind],
                                        Left = x[Left],
                                        Right = x[Right],
                                        Operator = 
                                            if (x[Operator] = "Equals") then "NotEquals" else
                                            if (x[Operator] = "NotEquals") then "Equals" else
                                            if (x[Operator] = "GreaterThan") then "LessThanOrEquals" else
                                            if (x[Operator] = "GreaterThanOrEquals") then "NotEquals" else
                                            if (x[Operator] = "LessThan") then "GreaterThanOrEquals" else
                                            if (x[Operator] = "LessThanOrEquals") then "GreaterThan" else
                                            x[Operator]
                                    ]
                            )
                            // Replace Function to enable smart "negative" function calls (such as !startwith, !has, etc.)
                            else if (kind = "Invocation") then
                                [
                                    Kind = x[Kind],
                                    Arguments = x[Arguments],
                                    Function = [
                                        Kind = "Constant",
                                        Value = if (x[Function][Value] = Text.Contains) then Text.NotContains else
                                                if (x[Function][Value] = Text.EndsWith) then Text.NotEndsWith else
                                                if (x[Function][Value] = Text.StartsWith) then Text.NotStartsWith else
                                                if (x[Function][Value] = List.Contains) then List.NotContains else
                                                    x[Function][Value]
                                    ]
                                ]
                            else
                                x
                in
                    expr,

            // Convert Operator from Name to "sign"
            operatorExpr = (x) => 
                let op =
                        if (x = "Equals") then return("==" meta [Precedence = 0]) else
                        if (x = "NotEquals") then return("!=" meta [Precedence = 1]) else
                        if (x = "GreaterThan") then return(">" meta [Precedence = 2]) else
                        if (x = "GreaterThanOrEquals") then return(">=" meta [Precedence = 3]) else
                        if (x = "LessThan") then return("<" meta [Precedence = 4]) else
                        if (x = "LessThanOrEquals") then return("<=" meta [Precedence = 5]) else
                        if (x = "And") then return("and" meta [Precedence = 6]) else
                        if (x = "Or") then return("or" meta [Precedence = 7]) else
                        if (x = "Not") then return("not" meta [Precedence = 8]) else
                        if (x = "Add") then return("+" meta [Precedence = 9]) else
                        if (x = "Subtract") then return("-" meta [Precedence = 10]) else
                        if (x = "Multiply") then return("*" meta [Precedence = 11]) else
                        if (x = "Divide") then return("/" meta [Precedence = 12]) else
                        if (x = "Concatenate") then return("&" meta [Precedence = 13]) else
                        error Error.Record("Unhandled operator", "Unhandled operator type: " & x, null)
                in
                    op,

            // Get precedence of expresstion/operator
            precedence = (expressionOrOperator) =>
                let
                    precedence = Value.Metadata(expressionOrOperator)[Precedence]?
                in
                    if (precedence <> null) then precedence else 1000,

            // Compare precendence of 2 expressions/operators
            comparePrecedence = (x, y) =>
                if (precedence(x) < precedence(y)) then -1
                else if (precedence(x) > precedence(y)) then 1
                else 0,

            // Create format string for function invocation
            functionFormatExpr = (x) => 
                let 
                    func = x[Function][Value],
                    funcName = Value.Metadata(Value.Type(func))[Documentation.Name]?,
                    arguments = x[Arguments],
                    argumentsCount = List.Count(arguments),
                    formatStr = 

                        if (func = Text.From or funcName = "Text.From") then return("tostring(#{0})") 
                        else if (func = Text.At) then return("substring(#{0}, #{1}, 1)") 
                        else if (func = Text.Combine) then
                            let 
                                parts = List.FirstN(arguments, argumentsCount - 1),
                                separator = "," & handleExpr(List.Last(arguments)) & ","
                            in 
                                return ("strcat(" & Combiner.CombineTextByDelimiter(separator)(List.Transform(parts, (p) => handleExpr(p))) & ")")
                        else if (func = Text.Contains) then return("#{0} has #{1}") // TODO: Support optional comparer (3rd argument)
                        else if (func = Text.NotContains) then return("#{0} !has #{1}") // TODO: Support optional comparer (3rd argument)
                        else if (func = Text.End) then return("substring(#{0}, (strlen(#{0})-#{1}), #{1})") 
                        else if (func = Text.EndsWith) then return("#{0} endswith #{1}")  // TODO: Support optional comparer (3rd argument)
                        else if (func = Text.NotEndsWith) then return("#{0} !endswith #{1}")  // TODO: Support optional comparer (3rd argument)
                        else if (func = Text.Length) then return("strlen(#{0})") 
                        else if (func = Text.Lower or funcName = "Text.Lower") then return("tolower(#{0})") 
                        else if (func = Text.Middle) then (if (argumentsCount = 3) then return("substring(#{0}, #{1}, #{2})") else return("substring(#{0}, #{1})"))
                        else if (func = Text.Range) then (if (argumentsCount = 3) then return("substring(#{0}, #{1}, #{2})") else return("substring(#{0}, #{1})"))
                        else if (func = Text.Remove) then return("replace('[" & Text.Combine(List.Transform(arguments{0}, (a) => escapeJsonChar(a))) & "]', '', #{1})") 
                        else if (func = Text.RemoveRange) then (if (argumentsCount = 3) then return("strcat(substring(#{0}, 0, #{1}), substring(#{0}, #{1}+#{2}))") else return("strcat(substring(#{0}, 0, #{1}), substring(#{0}, #{1}+1))"))
                        else if (func = Text.Replace) then return("replace(#{1}, #{2}, #{0})") 
                        else if (func = Text.ReplaceRange) then return("replace('(.{#{1}})(.{#{2}})(.*)', strcat(@'\1',#{3},@'\3'), #{0})") 
                        else if (func = Text.Start) then return("substring(#{0}, 0, #{1})") 
                        else if (func = Text.StartsWith) then return("#{0} startswith #{1}") // TODO: Support optional comparer (3rd argument)
                        else if (func = Text.NotStartsWith) then return("#{0} !startswith #{1}") // TODO: Support optional comparer (3rd argument)
                        else if (func = Text.Upper or funcName = "Text.Upper") then return("toupper(#{0})") 
                        else if (func = Text.Insert) then return("strcat(substring(#{0}, 0, #{1}), #{2}, substring(#{0}, #{1}))") 
                        else if (func = Text.Split) then return("split(#{0}, #{1})") 
                        else if (func = Text.FromBinary) then return("tostring(#{0})") 
                        else if (func = Text.Trim) then (if (argumentsCount = 1) then return("replace(@'\A\s*(.*?)\s*$', @'\1', #{0})") else 
                            let chars = if (arguments{1} is text) then ("[" & escapeJsonChar(arguments{1}) & "]") else ("[" & Text.Combine(arguments{1}[Value]) & "]")
                            in return("replace(@'\A" & chars & "*(.*?)" & chars & "*$', @'\1', #{0})"))
                        else if (func = Text.TrimStart) then (if (argumentsCount = 1) then return("replace(@'\A\s*(.*?)$', @'\1', #{0})") else 
                            let chars = if (arguments{1} is text) then ("[" & escapeJsonChar(arguments{1}) & "]") else ("[" & Text.Combine(arguments{1}[Value]) & "]")
                            in return("replace(@'\A" & chars & "*(.*?)$', @'\1', #{0})"))
                        else if (func = Text.TrimEnd) then (if (argumentsCount = 1) then return("replace(@'\A(.*?)\s*$', @'\1', #{0})") else 
                            let chars = if (arguments{1} is text) then ("[" & escapeJsonChar(arguments{1}) & "]") else ("[" & Text.Combine(arguments{1}[Value]) & "]")
                            in return("replace(@'\A(.*?)" & chars & "*$', @'\1', #{0})"))
                    
                        else if (func = Byte.From or funcName = "Byte.From") then return("toint(#{0})") 
                        else if (func = Currency.From or funcName = "Currency.From") then return("todouble(#{0})") 
                        else if (func = Decimal.From or funcName = "Decimal.From") then return("todouble(#{0})") 
                        else if (func = Int8.From or funcName = "Int8.From") then return("toint(#{0})") 
                        else if (func = Int16.From or funcName = "Int16.From") then return("toint(#{0})") 
                        else if (func = Int32.From or funcName = "Int32.From") then return("toint(#{0})") 
                        else if (func = Int64.From or funcName = "Int64.From") then return("tolong(#{0})") 
                        else if (func = Single.From or funcName = "Single.From") then return("todouble(#{0})") 
                    
                        else if (func = Number.FromText) then return("todouble(#{0})")
                        else if (func = Number.IsEven) then return("#{0} % 2 == 0") 
                        else if (func = Number.IsOdd) then return("#{0} % 2 == 1") 
                        else if (func = Number.From or funcName = "Number.From") then return("todouble(#{0})") 
                        else if (func = Number.Mod) then return("#{0} % #{1}") 
                        else if (func = Number.Random) then return("rand()")  // TODO: Number.Random() is evaluated before reaching here
                        else if (func = Number.RandomBetween) then return("(#{0} + rand((#{1}-#{0}))") 
                        else if (func = Number.Round) then return("round(#{0}, #{1})")
                        else if (func = Number.RoundDown) then return("floor(#{0}, 1)") 
                        else if (func = Number.RoundUp) then return("-floor(-#{0}, 1)")
                        else if (func = Number.RoundTowardZero) then return("iff(#{0}>0,1,-1)*floor(abs(#{0}), 1)")
                        else if (func = Number.RoundAwayFromZero) then return("iff(#{0}>0,-1,1)*floor(-abs(#{0}), 1)")
                        else if (func = Number.Abs) then return("iff(#{0} < 0, -1 * #{0}, #{0})") 
                        else if (func = Number.Sign) then return("iff(#{0} < 0, -1, iff(#{0} > 0, 1, 0))") 
                        else if (func = Number.IntegerDivide) then return("toint(#{0} / #{1})") 
                        else if (func = Number.Sqrt) then return("sqrt(#{0})") 
                        else if (func = Number.Ln) then return("log(#{0})") 
                        else if (func = Number.Log10) then return("log10(#{0})") 
                        else if (func = Number.Log) then (if (argumentsCount = 1) then return("log(#{0})") else return("log(#{0}, #{1})"))
                        else if (func = Number.Exp) then return("exp(#{0})")
                        else if (func = Number.Power) then return("pow(#{0}, #{1})")
                        else if (func = Number.BitwiseAnd) then return("binary_and(#{0}, #{1})")
                        else if (func = Number.BitwiseOr) then return("binary_or(#{0}, #{1})")
                        else if (func = Number.BitwiseNot) then return("binary_not(#{0})")
                        else if (func = Number.BitwiseXor) then return("binary_and(binary_or(#{0}, #{1}), binary_not(binary_and(#{0}, #{1})))") // P^Q = (P | Q) & !(P & Q)


                        else if (func = List.Sum) then return("sum(#{0})") 
                        else if (func = List.Average) then return("avg(#{0})") 
                        else if (func = List.Count and argumentsCount = 1 and arguments{0} is list) then return("arraylength(#{0})") 
                        else if (func = List.Count and argumentsCount = 1) then return("count(#{0})") 
                        else if (func = List.Count) then return("arraylength(#{0})") 
                        else if (func = List.Max) then return("max(#{0})") 
                        else if (func = List.Min) then return("min(#{0})") 
                        else if (func = List.Sum) then return("sum(#{0})") 
                        else if (func = List.First) then return("#{0}[0]") 
                        else if (func = List.Last) then return("#{0}[arraylength(#{0})]") 
                        else if (func = List.Range) then return("#{0}[#{1}]")
                        else if (func = List.Contains) then return("#{1} in " & handleExpr(arguments{0}))
                        else if (func = List.NotContains) then return("#{1} !in " & handleExpr(arguments{0}))
                        //else if (func = List.AnyTrue) then Text.Combine(List.Positions(arguments, (i) => "#{" & i & "}"), " or ")
                    
                        else if (func = Table.RowCount) then return("count()")

                        else if (func = Record.ToTable) then return("#{0}") 

                        else if (func = DateTime.Date) then return("floor(#{0}, 1d)") 
                        else if (func = DateTime.FixedLocalNow) then return("now()") 
                        else if (func = DateTime.From or funcName = "DateTime.From") then return("datetime(#{0})") 
                        else if (func = DateTime.FromText or funcName = "DateTime.FromText") then return("datetime(#{0})") 

                        else if (func = DateTime.IsInPreviousNHours or funcName = "DateTimeIsInPreviousNHours") then return("#{0} >= floor(now(), 1h)-#{0}h and #{0} < floor(now(), (#{0}-1)h)") 
                        else if (func = DateTime.IsInPreviousNMinutes or funcName = "DateTime.IsInPreviousNMinutes") then return("#{0} >= floor(now(), 1m)-#{0}m and #{0} < floor(now(), (#{0}-1)m)") 
                        else if (func = DateTime.IsInPreviousNSeconds or funcName = "DateTime.IsInPreviousNSeconds") then return("#{0} >= floor(now(), 1s)-#{0}s and #{0} < floor(now(), (#{0}-1)s)") 

                        else if (func = DateTime.IsInPreviousHour or funcName = "DateTime.IsInPreviousHour") then return("#{0} >= floor(now(), 1h)-1h and #{0} < floor(now(), 1h)") 
                        else if (func = DateTime.IsInPreviousMinute or funcName = "DateTime.IsInPreviousMinute") then return("#{0} >= floor(now(), 1m)-1m and #{0} < floor(now(), 1m)") 
                        else if (func = DateTime.IsInPreviousSecond or funcName = "DateTime.IsInPreviousSecond") then return("#{0} >= floor(now(), 1s)-1s and #{0} < floor(now(), 1s)") 

                        else if (func = DateTime.IsInCurrentHour or funcName = "DateTime.IsInCurrentHour") then return("#{0} >= floor(now(), 1h) and #{0} < floor(now(), 1h)+1h") 
                        else if (func = DateTime.IsInCurrentMinute or funcName = "DateTime.IsInCurrentMinute") then return("#{0} >= floor(now(), 1m) and #{0} < floor(now(), 1m)+1m") 
                        else if (func = DateTime.IsInCurrentSecond or funcName = "DateTime.IsInCurrentSecond") then return("#{0} >= floor(now(), 1s) and #{0} < floor(now(), 1s)+1s") 

                        else if (func = DateTime.IsInNextHour or funcName = "DateTime.IsInNextHour") then return("#{0} >= floor(now(), 1h)+1h and #{0} < floor(now(), 1h)+2h") 
                        else if (func = DateTime.IsInNextMinute or funcName = "DateTime.IsInNextMinute") then return("#{0} >= floor(now(), 1m)+1m and #{0} < floor(now(), 1m)+2m") 
                        else if (func = DateTime.IsInNextSecond or funcName = "DateTime.IsInNextSecond") then return("#{0} >= floor(now(), 1s)+1s and #{0} < floor(now(), 1s)+2s") 

                        else if (func = DateTime.IsInNextNHours or funcName = "DateTime.IsInNextNHours") then return("#{0} >= floor(now(), 1h)+#{0}h and #{0} < floor(now(), 1h)+(#{0}+1)h") 
                        else if (func = DateTime.IsInNextNMinutes or funcName = "DateTime.IsInNextNMinutes") then return("#{0} >= floor(now(), 1m)+#{0}m and #{0} < floor(now(), 1m)+(#{0}+1)m") 
                        else if (func = DateTime.IsInNextNSeconds or funcName = "DateTime.IsInNextNSeconds") then return("#{0} >= floor(now(), 1s)+#{0}s and #{0} < floor(now(), 1s)+(#{0}+1)s") 

                        else if (func = DateTime.LocalNow) then return("now()") 
                        else if (func = DateTime.Time) then return("#{0} - floor(#{0}, 1d)") 
                        else if (func = DateTime.ToText) then return("tostring(#{0})") 

                        else if (func = Date.AddDays) then return("(#{0} + #{1}d)") 
                        else if (func = Date.Day) then return("datepart(""day"", #{0})") 
                        else if (func = Date.Month) then return("getmonth(#{0})") 
                        else if (func = Date.Year) then return("getyear(#{0})") 
                        else if (func = Date.DayOfWeek) then return("dayofweek(#{0})") 
                        else if (func = Date.DayOfYear) then return("dayofyear(#{0})") 
                        else if (func = Date.WeekOfYear or funcName = "Date.WeekOfYear") then return("weekofyear(#{0})")
                        else if (func = Date.WeekOfMonth or funcName = "Date.WeekOfMonth") then return("(dayofmonth(#{0})/7)+1")

                        else if (func = Date.StartOfDay) then return("startofday(#{0})") 
                        else if (func = Date.StartOfWeek) then return("startofweek(#{0})") // TODO: Support optional firstDay argument
                        else if (func = Date.StartOfMonth) then return("startofmonth(#{0})") 
                        else if (func = Date.StartOfQuarter or funcName = "Date.StartOfQuarter") then return ("(todatetime(strcat(getyear(#{0}),'-', 1+(3*floor((getmonth(#{0})-1) / 3, 1)),'-01 00:00:00')))")
                        else if (func = Date.StartOfYear) then return("startofyear(#{0})") 
                        else if (func = Date.EndOfDay) then return("endofday(#{0})") 
                        else if (func = Date.EndOfWeek) then return("endofweek(#{0})") 
                        else if (func = Date.EndOfMonth) then return("endofmonth(#{0})") 
                        else if (func = Date.EndOfYear) then return("endofyear(#{0})") 

                        else if (func = Date.IsInPreviousYear) then return("getyear(#{0})==(getyear(now()) - 1)") 
                        else if (func = Date.IsInPreviousMonth) then return("((getyear(#{0})*12+getmonth(#{0}))==(getyear(now())*12+getmonth(now()))-1)") 
                        
                        else if (func = Date.IsInCurrentYear) then return("getyear(#{0})==getyear(now())") 
                        else if (func = Date.IsInCurrentQuarter or funcName = "Date.IsInCurrentQuarter") then return("(floor((getmonth(#{0})-1) / 3, 1)==floor((getmonth(now())-1) / 3, 1) and getyear(#{0})==getyear(now()))")
                        else if (func = Date.IsInCurrentMonth) then return("((getyear(#{0})*12+getmonth(#{0}))==(getyear(now())*12+getmonth(now())))") 
                        
                        else if (func = Date.IsInNextYear) then return("getyear(#{0})==(getyear(now()) + 1)") 
                        else if (func = Date.IsInNextMonth) then return("((getyear(#{0})*12+getmonth(#{0}))==(getyear(now())*12+getmonth(now()))+1)") 
                        
                        else if (func = Date.IsInYearToDate) then return("(#{0} >= startofyear(now()) and #{0} <= now())") 

                        else if (func = Date.From or funcName = "Date.From") then return("floor(#{0},1d)") 
                        else if (func = Date.FromText or funcName = "Date.FromText") then return("floor(datetime(#{0}),1d)") 
                        else if (func = Date.ToText) then return("tostring(#{0})") 

                        else if (func = Time.StartOfHour) then return("floor(#{0}, 1h)") 
                        else if (func = Time.EndOfHour) then return("#{0} + 60m-1s - (#{0} - floor(#{0}, 1h))") 
                        else if (func = Time.Hour) then return("datepart(""hour"", #{0})") 
                        else if (func = Time.Minute) then return("datepart(""minute"", #{0})") 
                        else if (func = Time.Second) then return("datepart(""second"", #{0})") 
                        else if (func = Time.ToText) then return("tostring(#{0})") 

                        else if (func = Json.Document) then return("parsejson(#{0})") 

                        else if (func = Duration.FromText or funcName = "Duration.FromText") then return("totimespan(#{0})") 
                        else if (func = Duration.ToText) then return("tostring(#{0})") 

                        else if (func = Uri.Parts or funcName = "Uri.Parts") then return("parseurl(#{0})") 
                        
                        // Explicit unsupported methods
                        else if (func = Character.FromNumber) then error Error.Record("Unsupported function", "Unsupported function: Character.FromNumber", null)
                        else if (func = Character.ToNumber) then error Error.Record("Unsupported function", "Unsupported function: Character.ToNumber", null)
                        
                        else if (func = Text.FromBinary) then error Error.Record("Unsupported function", "Unsupported function: Text.FromBinary", null)
                        else if (func = Text.NewGuid) then error Error.Record("Unsupported function", "Unsupported function: Text.NewGuid", null)
                        else if (func = Text.ToBinary) then error Error.Record("Unsupported function", "Unsupported function: Text.ToBinary", null)
                        else if (func = Text.ToList) then error Error.Record("Unsupported function", "Unsupported function: Text.ToList", null)
                        else if (func = Text.PositionOf) then error Error.Record("Unsupported function", "Unsupported function: Text.PositionOf", null)
                        else if (func = Text.PositionOfAny) then error Error.Record("Unsupported function", "Unsupported function: Text.PositionOfAny", null)
                        else if (func = Text.Clean) then error Error.Record("Unsupported function", "Unsupported function: Text.Clean", null)
                        else if (func = Text.PadEnd) then error Error.Record("Unsupported function", "Unsupported function: Text.PadEnd", null)
                        else if (func = Text.PadStart) then error Error.Record("Unsupported function", "Unsupported function: Text.PadStart", null)
                        else if (func = Text.Proper) then error Error.Record("Unsupported function", "Unsupported function: Text.Proper", null)
                        else if (func = Text.Repeat) then error Error.Record("Unsupported function", "Unsupported function: Text.Repeat", null)
                        else if (func = Text.SplitAny) then error Error.Record("Unsupported function", "Unsupported function: Text.SplitAny", null)
                    
                        
                        else if (func = Number.Factorial) then error Error.Record("Unsupported function", "Unsupported function: Number.Factorial", null)
                        else if (func = Number.Combinations) then error Error.Record("Unsupported function", "Unsupported function: Number.Combinations", null)
                        else if (func = Number.Permutations) then error Error.Record("Unsupported function", "Unsupported function: Number.Permutations", null)
                    
                        else if (func = DateTime.AddZone) then error Error.Record("Unsupported function", "Unsupported function: DateTime.AddZone", null)
                        else if (func = DateTime.FromFileTime) then error Error.Record("Unsupported function", "Unsupported function: DateTime.FromFileTime", null)
                        else if (func = DateTime.ToRecord) then error Error.Record("Unsupported function", "Unsupported function: DateTime.ToRecord ", null)

                        else if (func = Date.AddMonths) then error Error.Record("Unsupported function", "Unsupported function: Date.AddMonths", null)
                        else if (func = Date.AddWeeks) then error Error.Record("Unsupported function", "Unsupported function: Date.AddWeeks", null)
                        else if (func = Date.DaysInMonth) then error Error.Record("Unsupported function", "Unsupported function: Date.DaysInMonth", null)
                        else if (func = Date.EndOfQuarter) then error Error.Record("Unsupported function", "Unsupported function: EndOfQuarter", null)
                        else if (func = Date.IsInCurrentWeek) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInCurrentWeek", null)
                        else if (func = Date.IsInNextQuarter) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInNextQuarter", null)
                        else if (func = Date.IsInNextWeek) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInNextWeek", null)
                        else if (func = Date.IsInPreviousWeek) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInPreviousWeek", null)
                        else if (func = Date.IsInPreviousQuarter) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInPreviousQuarter", null)
                        else if (func = Date.IsInPreviousNDays) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInPreviousNDays", null)
                        else if (func = Date.IsInPreviousNWeeks) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInPreviousNWeeks", null)
                        else if (func = Date.IsInPreviousNMonths) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInPreviousNMonths", null)
                        else if (func = Date.IsInPreviousNQuarters) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInPreviousNQuarters", null)
                        else if (func = Date.IsInPreviousNYears) then error Error.Record("Unsupported function", "Unsupported function: Date.IsInPreviousNYears", null)

                        else if (func = Time.From) then error Error.Record("Unsupported function", "Unsupported function: Time.From", null)
                        else if (func = Time.FromText) then error Error.Record("Unsupported function", "Unsupported function: Time.FromText", null)
                        else if (func = Time.ToRecord) then error Error.Record("Unsupported function", "Unsupported function: Time.ToRecord", null)

                        else 
                            let
                                //funcNameStr = if (funcName <> null) then funcName else Value.ToText(Type.FunctionParameters(Value.Type(func)))
                                funcNameStr = if (funcName <> null) then funcName else "Unknown. Args: " & Value.ToText(x, 10)
                            in
                                error Error.Record("Unsupported function", "Unsupported function: " & funcNameStr, null)
                in
                    formatStr,

            // Utility methods
            toHex = (i as number) as text =>
                let
                    chars = "0123456789abcdef",
                    low = Text.Range(chars, Number.Mod(i, 16), 1),
                    high = Text.Range(chars, Number.RoundDown(i / 16), 1)
                in high & low,
            escapeJsonChar = (text as text) as text =>
                if text = """" or text = "\" or text = "/" then "\" & text
                else if Character.ToNumber(text) < 32 then "\u00" & toHex(Character.ToNumber(text))
                else text,
            escapeJsonString = (text as text) as text => Text.Combine(List.Transform(Text.ToList(text), escapeJsonChar)),
            escapeValue = (value) =>
                if (value = null) then null
                else if (value = true) then true
                else if (value = false) then false
                else if (value is text) then """" & escapeJsonString(value) & """"
                else if (value is number) then Number.ToText(value)
                else if (value is logical) then Logical.ToText(value)
                else if (value is time) then "time(" & Time.ToText(value) & ")"
                else if (value is datetime) then "datetime(" & DateTime.ToText(value) & ")"
                else if (value is datetimezone) then "datetime(" & DateTimeZone.ToText(value) & ")"
                else if (value is list) then "(" & Text.Combine(List.Transform(value, (i) => if (i is record) then handleExpr(i) else @escapeValue(i)), ",") & ")"
                else
                    error Error.Record("DataSource.Error", "Unknown type for escaping", value)
        in
            handleExpr(expression),

    Kusto.SmartQuery = (cluster as text, database as text, tableName as text, optional options as record) => 
        let
            maxRows = options[MaxRows]?,
            // 9271076 - (workaround) add a null check on state[Query] to force eager evalution
            View = (state) => if (state[Query] <> null) then Table.View(null, Diagnostics.WrapHandlers([
                GetRows = () => let
                        calculatedMaxRows = Text.From(if (maxRows = null) then defaultMaxRows else if (maxRows > 65536) then 65536 else maxRows)
                    in
                        Kusto.Query(state[Cluster], state[Database], state[Query] & " | limit " & calculatedMaxRows),

                GetRowCount = () => let
                        rows = Kusto.Query(state[Cluster], state[Database], state[Query] & " | count")
                    in
                        rows{0}{0},

                GetSchema = () => let
                        schemaTable = if (state[Schema] = null)
                            then Kusto.Schema(state[Cluster], state[Database], state[Query])
                            else state[Schema]
                    in
                        schemaTable,

                GetType = () => let
                        schemaTable = GetSchema()
                    in
                        Value.Type(schemaTable),
                
                OnSelectColumns = (columns) => 
                    let
                        // Calculate updated schema
                        schema = GetSchema(),

                        existingColumns = Table.ColumnNames(schema),
                        columnsToRemove = List.Difference(existingColumns, columns),
                        newSchema = Table.RemoveColumns(schema, columnsToRemove), 

                        // Retrieve list of column names
                        normalizedColumns = List.Transform(columns, (c) => NormalizeColumnName(c)),

                        // Create new state
                        newState = state & [ 
                                Query = // Avoid adding "project" if no columns was removed
                                        if (List.IsEmpty(columnsToRemove)) then 
                                            state[Query]
                                        else
                                             state[Query] & " | project " & Text.Combine(normalizedColumns, ",") 
                                ,
                                Schema = newSchema
                            ]
                    in
                        @View(newState),

                OnSelectRows = (selector) => let
                        // Calculate updated schema
                        schema = GetSchema(),

                        // Calculate filtering
                        condition = RowExpression.From(selector),
                        
                        filter = Expressions(condition),

                        // Create new state
                        newState = state & [ 
                                Query = state[Query] & " | where " & filter,
                                Schema = schema
                            ]
                    in
                        @View(newState),

                OnSort = (order) => 
                    let
                        // Calculate updated schema
                        schema = GetSchema(),
                        
                        // Calculate sorting expression
                        sorting = List.Transform(order, (o) => let
                                name = o[Name],
                                order = o[Order],
                                orderText = if (order = 0) then "asc" else "desc"
                            in
                                name & " " & orderText),
                        
                        // Create new state
                        newState = state & [ 
                                Query = state[Query] & " | order by " & Text.Combine(sorting, ","),
                                Schema = schema
                            ]
                    in
                        @View(newState),

                OnTake = (count as number) => 
                    let
                        // Calculate updated schema
                        schema = GetSchema(),
                        
                        // Create new state
                        newState = state & [ 
                                Query = state[Query] & " | limit " & Text.From(count),
                                Schema = schema
                            ]
                    in
                        @View(newState),
                        
                OnAddColumns = (constructors) =>
                    let
                        // Calculate updated schema
                        schema = GetSchema(),
                        newSchema = List.Accumulate(constructors, schema, (t, c) => Table.AddColumn(t, c[Name], each null, c[Type])),

                        // Calculate newly-created columns
                        ctors = List.Transform(constructors, (a) => let 
                                name = a[Name],
                                normalizedName = NormalizeColumnName(name),
                                func = a[Function],
                        
                                funcExpr = RowExpression.From(func),
                                funcText = Expressions(funcExpr)
                            in 
                                normalizedName & "=" & funcText),

                        // Create new state
                        newState = state & [ 
                                Query = state[Query] & " | extend " & Text.Combine(ctors, ","),
                                Schema = newSchema
                            ]
                    in
                        @View(newState),

                OnGroup = (keys, aggregates, optional groupKind, optional comparer) => 
                    let
                        // Calculate updated schema
                        schema = GetSchema(),

                        newSchema = Table.SelectColumns(schema, keys),
                        newSchema2 = List.Accumulate(aggregates, newSchema, (t, c) => Table.AddColumn(t, c[Name], each null, c[Type])),
                        
                        // Calculate aggregated columns expression
                        aggrs = List.Transform(aggregates, (a) => let
                                name = a[Name],
                                normalizedName = NormalizeColumnName(name),
                                function = a[Function],
                                funcExpr = RowExpression.From(function),
                                funcText = Expressions(funcExpr)
                            in 
                                normalizedName & "=" & funcText),

                        keysQueryPart= if (List.Count(keys) > 0) then (" by " & Text.Combine(keys, ", ")) else "",

                        // Create new state
                        newState = state & [ 
                                Query = state[Query] & "| summarize " &  Text.Combine(aggrs, ", ") & keysQueryPart,
                                Schema = newSchema2
                            ]
                    in
                        @View(newState)

            ]))
            else error Error.Record("DataSource.Error", "Invalid view state", state)                
        in
            View([ Cluster = cluster, Database = database, Query = tableName, Schema = null ]),

    Kusto.ContentsDocs = let 
            clusterType = type text meta [
                Documentation.FieldCaption = "Cluster Name:"
            ],
            databaseType = type text meta [
                Documentation.FieldCaption = "Database Name:"
            ],
            tableOrQueryType = type text meta [
                Documentation.FieldCaption = "Table Name or Kusto Query:",
                Documentation.SampleValues = { "TracesTable", "Logs | where [Timestamp] > ago(1h)" }
            ],
            optionsType = type record meta [
                Documentation.FieldCaption = "Supported options: MaxRows = Num rows to retrieve (maximum value 65536)"
            ],
            t = type function (cluster as clusterType, optional database as databaseType, optional tableOrQuery as tableOrQueryType, optional options as optionsType) as table
        in 
            t meta [
                Documentation.Examples = {[
                    Description = "Returns a table of a 100 Storm Events information",
                    Code = "Kusto.Contents(""help"", ""Samples"", ""StormEvents"", [ MaxRows = 100 ])",
                    Result = "A table with 100 Storm Events from the Samples database in the help cluster"
                ]}
            ],
    
    Kusto.Schema = (cluster as text, database as text, query as text) as table =>
        let
            content = Web.Contents("https://" & cluster & ".kusto.windows.net:443/v1/rest/query?db=" & database & "&csl=.show version",
            [
                Content=Json.FromValue([
                    csl= query & " | getschema",
                    db=database
                ]),
                Timeout=#duration(0, 0, 4, 0),
                Headers=[#"Content-Type" = "application/json; charset=utf-8"]
            ]),
            json = Json.Document(content),
            TypeMap = #table(
                { "DataType", "Type" },
                {
                    { "System.Double",   type nullable Double.Type         },
                    { "System.Int64",    type nullable Int64.Type          },
                    { "System.Int32",    type nullable Int32.Type          },
                    { "System.Int16",    type nullable Int16.Type          },
                    { "System.UInt64",   type nullable Number.Type         },
                    { "System.UInt32",   type nullable Number.Type         },
                    { "System.UInt16",   type nullable Number.Type         },
                    { "System.Byte",     type nullable Byte.Type           },
                    { "System.Single",   type nullable Single.Type         },
                    { "System.Decimal",  type nullable Decimal.Type        },
                    { "System.TimeSpan", type nullable Duration.Type       },
                    { "System.DateTime", type nullable DateTimeZone.Type   },
                    { "System.String",   type nullable Text.Type           },
                    { "System.Boolean",  type nullable Logical.Type        },
                    { "System.SByte",    type nullable Logical.Type        },
                    { "System.Object",   type nullable Text.Type           }
                }),
            DataTable = json[Tables]{0},
            Columns = Table.FromRecords(DataTable[Columns]),
            Rows = Table.FromRows(DataTable[Rows], Columns[ColumnName]),
            RowsWithType = Table.Sort(Table.Join(Rows, {"DataType"}, TypeMap , {"DataType"}), {"ColumnOrdinal"}),
            ColumnsNames = Table.Column(RowsWithType, "ColumnName"),
            ColumnsTypes = Table.Column(RowsWithType, "Type"),
            ColumnsData = List.Zip({ ColumnsNames, ColumnsTypes}),
            TableWithColumns = #table(ColumnsNames, {}),
            TableWithTypedColumns = Table.TransformColumnTypes(TableWithColumns, ColumnsData)
        in
            TableWithTypedColumns,
            
    Kusto.Query = (cluster as text, database as text, query as text) as table =>
        let
            content = Web.Contents("https://" & cluster & ".kusto.windows.net:443/v1/rest/query?db=" & database & "&csl=.show version",
            [
                Content=Json.FromValue([
                    csl=query,
                    db=database
                ]),
                Timeout=#duration(0, 0, 4, 0),
                Headers=[#"Content-Type" = "application/json; charset=utf-8"]
            ]),
            json = Json.Document(content),
            TypeMap = #table(
                { "DataType", "Type" },
                {
                    { "Double",   type nullable Double.Type },
                    { "Int64",    type nullable Int64.Type },
                    { "Int32",    type nullable Int32.Type },
                    { "Int16",    type nullable Int16.Type },
                    { "UInt64",   type nullable Number.Type },
                    { "UInt32",   type nullable Number.Type },
                    { "UInt16",   type nullable Number.Type },
                    { "Byte",     type nullable Byte.Type },
                    { "Single",   type nullable Single.Type },
                    { "Decimal",  type nullable Decimal.Type },
                    { "TimeSpan", type nullable Duration.Type },
                    { "DateTime", type nullable DateTimeZone.Type },
                    { "String",   type nullable Text.Type },
                    { "Boolean",  type nullable Logical.Type },
                    { "SByte",    type nullable Logical.Type }
                }),
            DataTable = json[Tables]{0},
            Columns = Table.FromRecords(DataTable[Columns]),
            ColumnsWithType = Table.Join(Columns, {"DataType"}, TypeMap , {"DataType"}),
            Rows = Table.FromRows(DataTable[Rows], Columns[ColumnName]),
            TypedTable = Table.TransformColumnTypes(Rows, Table.ToList(ColumnsWithType, (c) => {c{0}, c{3}}))
        in
            TypedTable,
            
    Resource = [
        Description = "Kusto",
        Type = "Singleton",
        MakeResourcePath = () => "Kusto",
        ParseResourcePath = (resource) => { },
        TestConnection = (cluster) => { "Kusto.Databases", cluster },
        Authentication=[
            OAuth=[StartLogin=StartLogin, FinishLogin=FinishLogin, Refresh=Refresh, Logout=Logout]
        ],
        Exports = [
            Kusto.Contents = Value.ReplaceType(Kusto.Contents, Kusto.ContentsDocs),
            Kusto.Databases = Kusto.Databases
            //Kusto.Tables = Kusto.Tables,
            //Kusto.SmartQuery = Kusto.SmartQuery,
            //Kusto.Query = Kusto.Query,
            //Kusto.Schema = Kusto.Schema
        ],
        ExportsUX = [
            Kusto.Contents = [
                Beta = true,
                LearnMoreUrl = "http://aka.ms/csl",
                ButtonText = { Extension.LoadString("FormulaTitle"), Extension.LoadString("FormulaHelp") },
                SourceImage = [Icon32 = { Extension.Contents("Kusto_32.png"), Extension.Contents("KustoSheet_40.png"),
                                          Extension.Contents("KustoSheet_48.png"), Extension.Contents("KustoSheet_56.png") }],
                SourceTypeImage = Icons
            ]
        ],
        Label = Extension.LoadString("ResourceLabel"),
        Icons = [
            Icon16 = { Extension.Contents("Kusto_16.png"), Extension.Contents("Kusto_20.png"), Extension.Contents("Kusto_24.png"), Extension.Contents("Kusto_32.png")},
            Icon32 = { Extension.Contents("Kusto_32.png"), Extension.Contents("Kusto_40TM.png"), Extension.Contents("Kusto_48.png"), Extension.Contents("Kusto_64.png") }
        ]
    ],
    
    // Diagnostics-related functions are generic should be pulled into a separate module
    Value.ToText = (value, optional depth) =>
        let
            nextDepth = if depth = null then 3 else depth - 1,
            result = if depth = 0 then "..."
                else if value is null then "<null>"
                else if value is function then Record.FieldOrDefault(Value.Metadata(Value.Type(value)), "Documentation.Name", "<function>")
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
            navigationTable
in
    Extension.Module("Kusto", { Resource })