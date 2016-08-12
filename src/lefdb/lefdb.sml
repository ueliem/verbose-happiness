structure LEFDatabase : sig
    type lefdb
    type dbu
    type micron
    type layer
    val empty : lefdb
    val dbu2micron : lefdb -> dbu -> micron
    val micron2dbu : lefdb -> micron -> dbu
    val mfgGridValue : lefdb -> dbu
end =
struct 
    type dbu = int
    type micron = int
    type layer = string
    type lefdb = {
        lefConvertFactor : int,
        gv : dbu,
        layers : layer list
    }
    val empty = {lefConvertFactor=100, gv=0, layers=[]}
    fun dbu2micron db d = d div (#lefConvertFactor db)
    fun micron2dbu db m = m * (#lefConvertFactor db)
    fun mfgGridValue (d) = #gv d
end

