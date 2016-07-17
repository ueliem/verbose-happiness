structure BLIF2Graph : sig
    val blif2graph : AST.m -> Netlist.netlist
    val extractNodeNames : AST.c list -> string list
    val extractNodes : AST.c list -> Netlist.node list * string list
end =
struct 

    exception SemanticsError

    fun indexOf(ls, item) =
        let fun index (n, []) = NONE
            | index (n, l::ls) = if l=item then SOME n else index(n+1, ls)
        in index(0, ls)
        end

    fun extractNodeNames(commands) = 
        let fun comm2node (command, l) =
            (case command of
                AST.LibraryGate (name, _) => 
                    (if List.exists (fn x => x=name) l then l else name::l)
                | _ => [])
        in foldr (comm2node) [] commands
        end

    fun extractNodes(commands) = 
        let val ndb = extractNodeNames(commands)
            val count = ref 0
            fun comm2node (command, l) =
                let val n = (case command of
                    AST.LibraryGate (name, _) => (
                        (* print (Int.toString (!count) ^ "\t");
                        print (Int.toString (Option.valOf (indexOf (ndb, name)))
                        ^ "\n"); *)
                        ((!count), ref (List.nth (ndb, (Option.valOf (indexOf
                        (ndb, name))))))::l
                    )
                    | _ => [])
                in
                    count := (!count) + 1;
                    n
                end
        in print "extracting nodes\n"; (foldr (comm2node) [] commands, ndb)
        end

    fun blif2graph(tree) =
        case tree of
            AST.Model (name, ins, outs, clock, comms) =>
                let 
                    (* Build the node database. We store the node type
                    * only once, so that it is more efficient. *)
                    val (nodes, nodedb) = extractNodes(comms)
                in
                print (String.concatWith "\n" (map (! o #2) nodes)); print "\n";
                Netlist.empty
        end

end

