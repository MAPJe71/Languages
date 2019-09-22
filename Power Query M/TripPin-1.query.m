let
    Source = TripPin.Raw("http://services.odata.org/TripPinRESTierService/(S(njbl4y1givihcajsba2xiorr))/Airlines"),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"AirlineCode", "Name"}, {"AirlineCode", "Name"})
in
    #"Expanded Column1"