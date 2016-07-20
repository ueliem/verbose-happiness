structure BLIF2Graph : sig
    val blif2graph : AST.m -> Netlist.netlist
    val extractNodeNames : AST.c list -> string list
    val extractNodes : AST.c list -> Netlist.node list * string list
    val extractEdges : AST.c list * Netlist.node list -> Netlist.edge list
end =
struct 

    exception SemanticsError

    fun indexOf(ls, f) =
        let fun index (n, []) = NONE
            | index (n, l::ls) = if f(l) then SOME n else index(n+1, ls)
        in index(0, ls)
        end

    fun retrieve(ls, f) =
        (List.nth (ls, (Option.valOf (indexOf (ls, f)))))

    fun addNet(l, edgeName, newPort) =
        let val edge = retrieve (l, (fn x => (#1 x)=edgeName))
            val newEdge = (#1 edge, (ref newPort)::(#2 edge))
            fun f (x) =
                if (#1 x)=edgeName then newEdge else x
        in map f l
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
                        (
                            (!count), 
                            ref (retrieve (ndb, (fn x => x=name)))
                        )::l
                    )
                    | _ => [])
                in
                    count := (!count) + 1;
                    n
                end
        in print "extracting nodes\n"; (foldr (comm2node) [] commands, ndb)
        end

    fun extractEdges(commands, nodes) =
        let val count = ref 0
            fun comm2edge (command, l) = 
                let val n = (case command of
                    AST.LibraryGate (name, formalactuals) => (
                        let fun f (fa, fal) = 
                            case fa of
                                AST.FormalActual(portName,edgeName) => (
                                    let val newPort = (portName, ref (List.nth (nodes, (!count))))
                                    in
                                    (if List.exists (fn x => (#1 x)=edgeName) fal 
                                        then addNet(fal, edgeName, newPort)
                                        else (edgeName,[ref newPort])::fal)
                                    end
                                )
                                | _ => raise SemanticsError
                        in foldr f l formalactuals
                        end
                    )
                    | _ => [])
                in
                    count := (!count) + 1;
                    n
            end
        in print "extracting edges\n"; foldr (comm2edge) [] commands
        end

    fun blif2graph(tree) =
        case tree of
            AST.Model (name, ins, outs, clock, comms) =>
                let 
                    (* Build the node database. We store the node type
                    * only once, so that it is more efficient. *)
                    val (nodes, nodedb) = extractNodes(comms)
                    val edges = extractEdges(comms, nodes)
                in
                print (String.concatWith "\n" (map (! o #2) nodes)); print "\n"; print "\n";
                print (String.concatWith "\n" (map #1 edges)); print "\n";
                (nodes, edges)
        end

end

