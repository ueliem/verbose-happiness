structure LEFAST =

struct
    datatype a =
        Real of real
        | ID of string
    and cm =
        MaxXY | Euclidean
    and u =
        TimeNS of int
        | CapacitancePF of int
        | ResistanceOhms of int
        | PowerMW of int
        | CurrentMA of int
        | VoltageVolts of int
        | DatabaseMicrons of int
        | FreqMHz of int
    and s =
        VersionStmt of real
        | NamesCaseSensitiveStmt of bool
        | BusBitCharsStmt of string
        | DividerCharStmt of string
        | ClearanceMeasureStmt of cm
        | UnitsStmt of u list
        | UseMinSpacingObsStmt of bool
        | UseMinSpacingPinStmt of bool
        | ManufacturingGridStmt of real
    and t =
        Top of s list
end

