let
    Source = TripPin.Feed("http://services.odata.org/TripPinRESTierService/"),
    People = Source{[Name="People"]}[Data],
    SelectColumns = Table.SelectColumns(People, {"UserName", "FirstName", "LastName"})
in
    SelectColumns