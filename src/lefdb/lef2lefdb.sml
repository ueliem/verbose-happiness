structure LEF2Graph : sig
    val processUnits : LEFAST.u * LEFDatabase.lefdb -> LEFDatabase.lefdb
    val processStatement : LEFAST.s * LEFDatabase.lefdb -> LEFDatabase.lefdb
    val lef2lefdb : LEFAST.t -> LEFDatabase.lefdb
end =
struct 

    fun processUnits (u, init) = 
        case u of
            LEFAST.TimeNS ns => init
            | LEFAST.CapacitancePF pf => init
            | LEFAST.ResistanceOhms ro => init
            | LEFAST.PowerMW mw => init
            | LEFAST.CurrentMA ma => init
            | LEFAST.VoltageVolts v => init
            | LEFAST.DatabaseMicrons m => init
            | LEFAST.FreqMHz mhz => init

    fun processStatement (s, init) = 
        case s of
            LEFAST.VersionStmt v => init (* ignore for now *)
            | LEFAST.NamesCaseSensitiveStmt b => init (* ignore for now *)
            | LEFAST.BusBitCharsStmt c => init (* ignore for now *)
            | LEFAST.DividerCharStmt c => init (* ignore for now *)
            | LEFAST.ClearanceMeasureStmt c => init (* ignore for now *)
            | LEFAST.UnitsStmt ul => foldl processUnits init ul
            | LEFAST.UseMinSpacingObsStmt b => init
            | LEFAST.UseMinSpacingPinStmt b => init
            | LEFAST.ManufacturingGridStmt g => init
            | LEFAST.LayerMasterslice name => init
            | LEFAST.LayerCut name => init
            | LEFAST.LayerRouting name => init
            | LEFAST.LayerImplant name => init

    fun lef2lefdb (tree) =
        case tree of
            LEFAST.Top s => foldl processStatement LEFDatabase.empty s

end

