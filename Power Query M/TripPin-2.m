let
    TripPin.Feed = (url as text) =>
        let
            source = OData.Feed(url)
        in
            source,

    Resource = [
        Description = "TripPin",
        Type = "Url",
        MakeResourcePath = (url) => url,
        ParseResourcePath = (url) => {url},
        TestConnection = (url) => {"TripPin.Feed", url},
        Authentication = [
            Implicit = []
        ],
        Exports = [
            TripPin.Feed = TripPin.Feed
        ],
        ExportsUX = [
            TripPin.Feed = [
                ButtonText = { "TripPin.Feed", "Connect to the TripPin service" },
                SourceImage = Icons,
                SourceTypeImage = Icons
            ]
        ],
        Label = "TripPin",
        Icons = [
            Icon16 = { Extension.Contents("TripPin16.png"), Extension.Contents("TripPin20.png"), Extension.Contents("TripPin24.png"), Extension.Contents("TripPin32.png") },
            Icon32 = { Extension.Contents("TripPin32.png"), Extension.Contents("TripPin40.png"), Extension.Contents("TripPin48.png"), Extension.Contents("TripPin64.png") }
        ]
    ]
in
    Extension.Module("TripPin", { Resource })