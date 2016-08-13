structure LEFAST =

struct
    datatype a =
        Real of real
        | ID of string
    and cm =
        MaxXY | Euclidean
    and d =
        Horizontal | Vertical
    and u =
        TimeNS of real
        | CapacitancePF of real
        | ResistanceOhms of real
        | PowerMW of real
        | CurrentMA of real
        | VoltageVolts of real
        | DatabaseMicrons of real
        | FreqMHz of real
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
        | LayerMasterslice of string
        | LayerCut of string
        | LayerRouting of string
        | LayerImplant of string
    and t =
        Top of s list
end

