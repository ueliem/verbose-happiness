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
        | LayerMasterslice of {name:string}
        | LayerCut of {name:string,spacing:real}
        | LayerRouting of
            {name:string,
            dir:d,
            pitch:real,
            offset:real,
            width:real,
            spacing:real,
            res:real,
            cap:real,
            ecap:real}
        | LayerImplant of {name:string}
    and t =
        Top of s list
end

