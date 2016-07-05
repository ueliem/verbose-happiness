structure AST =

struct
  datatype a =
        Num of int
        | ID of string
        | IDList of a * a
        | EmptyList
  and c =
        Skip
        | Seq of c * c
  and m =
        Model of a * a * a * a
end

