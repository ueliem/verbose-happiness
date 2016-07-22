structure BLIF2Graph : sig
    val blif2graph : AST.m -> Netlist.netlist
    val extractNodeNames : AST.c list -> string list
    val createPads : string list * string * int -> Netlist.node list * Netlist.edge list
    val extractNodes : AST.c list * int -> Netlist.node list * string list
    val extractEdges : AST.c list * int * Netlist.node list -> Netlist.edge list
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

    fun addPortToNet(l, edgeName, newPort) =
        let val edge = retrieve (l, (fn x => (#1 x)=edgeName))
            val newEdge = (#1 edge, (ref newPort)::(#2 edge))
            fun f (x) =
                if (#1 x)=edgeName then newEdge else x
        in map f l
        end

    fun createPads(inlist, s, c) = 
        let val count = ref c
            fun toNode(i, (l1,l2)) =
                let val n = (!count, ref s)::l1
                    val e = 
                        let val newPort = ("", ref (List.nth (n, 0)))
                        in
                        (if List.exists (fn x => (#1 x)=i) l2
                            then addPortToNet(l2, i, newPort)
                            else (i,[ref newPort])::l2)
                        end
                in
                    count := (!count) + 1;
                    (n,e)
                end
        in foldr (toNode) ([],[]) inlist
        end

    fun extractNodeNames(commands) = 
        let fun comm2node (command, l) =
            (case command of
                AST.LibraryGate (name, _) => 
                    (if List.exists (fn x => x=name) l then l else name::l)
                | _ => [])
        in foldr (comm2node) [] commands
        end

    fun extractNodes(commands, c) = 
        let val ndb = extractNodeNames(commands)
            val count = ref c
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

    fun extractEdges(commands, c, nodes) =
        let val count = ref c
            fun comm2edge (command, l) = 
                let val n = (case command of
                    AST.LibraryGate (name, formalactuals) => (
                        let fun f (fa, fal) = 
                            case fa of
                                AST.FormalActual(portName,edgeName) => (
                                    let val newPort = (portName, ref (List.nth (nodes, (!count))))
                                    in
                                    (if List.exists (fn x => (#1 x)=edgeName) fal 
                                        then addPortToNet(fal, edgeName, newPort)
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
                    val inpads = createPads(ins, "INPAD", 0)
                    val outpads = createPads(outs, "OUTPAD",
                                                (List.length (#1 inpads)))
                    val clockpads = createPads(clock, "CLOCKPAD",
                                                (List.length (#1 inpads)) +
                                                (List.length (#1 outpads)))
                    (* Build the node database. We store the node type
                    * only once, so that it is more efficient. *)
                    val (mainNodes, nodedb) = extractNodes(comms,
                                                (List.length (#1 inpads)) +
                                                (List.length (#1 outpads)) +
                                                (List.length (#1 clockpads)))
                    val nodes = (#1 inpads)
                                @ (#1 outpads)
                                @ (#1 clockpads)
                                @ (mainNodes)
                    val edges = extractEdges(comms,
                                                (List.length (#1 inpads)) +
                                                (List.length (#1 outpads)) +
                                                (List.length (#1 clockpads)), 
                                                nodes)
                in
                print (String.concatWith "\n" (map (! o #2) nodes)); print "\n"; print "\n";
                print (String.concatWith "\n" (map #1 edges)); print "\n";
                (nodes, edges)
        end

end

