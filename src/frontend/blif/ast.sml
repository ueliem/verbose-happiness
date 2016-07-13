structure AST =

struct
    datatype a =
        Num of int
        | ID of string
        | Zero
        | One
        | Two
        | Three
        | IDList of a * a
        | FormalActual of string * string
    and c =
        Skip
        | LogicGate of string list * (a list list)
        | ModelRef of string * a list
    and m =
        Model of string * string list * string list * string list * c list
end

