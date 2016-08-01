structure Partition : sig
    val split : 'a list -> 'a list * 'a list
    val computeGain : Netlist.node * Netlist.edge list * Netlist.node list * Netlist.node list -> int
    val createGainBucket : Netlist.node list * Netlist.node list * Netlist.edge list -> (Netlist.node * int) list
    val computePartitionCost : Netlist.edge list * Netlist.node list * Netlist.node list -> int
    val partition_fm : Netlist.netlist -> Netlist.netlist * Netlist.netlist
end =
struct 

    fun indexOf(ls, f) =
        let fun index (n, []) = NONE
            | index (n, l::ls) = if f(l) then SOME n else index(n+1, ls)
        in index(0, ls)
        end

    fun split [] = ([],[])
        | split [x] = ([x],[])
        | split (x::y::z) = 
            let val (xs,ys) = split z
            in
                (x::xs,y::ys)
            end

    fun computeGain (node, edges, thisBin, otherBin) =
        let val ecost = ref 0
            val icost = ref 0
            fun nOfP (p) = (!(#2 (! p)))
            fun f (edge : Netlist.edge) =
                if List.exists (fn x => (nOfP x)=node) (#2 edge) then
                    app (fn m => (if List.exists (fn x => x=m) thisBin then
                                      icost := (!icost) + 1
                                  else if List.exists (fn x => x=m) otherBin then
                                      ecost := (!ecost) + 1
                                  else ()))
                    (List.filter (fn x => x<>node) (map nOfP (#2 edge)))
                else ()
        in
            app f edges; (!ecost) - (!icost)
        end

    fun createGainBucket (thisBin, otherBin, edges) = 
        let val gains = ListPair.zip (thisBin, (map (fn n => computeGain (n, edges, thisBin, otherBin)) thisBin))
            fun sort ([]) = []
                | sort (x::xs) = 
                    let val (l,r) = List.partition (fn y => (#2 y)<(#2 x)) xs
                    in
                        sort l @ [x] @ sort r
                    end
        in List.rev (sort gains)
        end

    fun computePartitionCost (edges, binA, binB) =
        let fun nOfP (p) = (!(#2 (! p)))
            fun f (edge : Netlist.edge, t : int) =
                let val port_list : Netlist.port ref list = (#2 edge)
                    val countA = ref 0
                    val countB = ref 0
                    fun g (p) = 
                        if List.exists (fn x => x=(nOfP p)) binA then
                            countA := (!countA) + 1
                        else if List.exists (fn x => x=(nOfP p)) binB then
                            countB := (!countB) + 1
                        else ()
                in app g port_list; t + abs (!countA - !countB)
                end
        in foldl f 0 edges
        end

    fun partition_fm (([],_)) = (Netlist.empty, Netlist.empty)
        | partition_fm (g) =
        let
            (* Initial partition *)
            val (binAInit,binBInit) = split (Netlist.nodes g)
            val edges = Netlist.edges g
            val lockedNodes = Array.array (List.length (Netlist.nodes g), false)
            fun loop (binA, binB) =
                if Array.exists (fn x => x=false) lockedNodes then
                    let 
                        val _ = print ("binA: " ^ Int.toString (List.length binA) ^ "    ")
                        val _ = print ("binB: " ^ Int.toString (List.length binB) ^ "\n")
                        val gba = createGainBucket (binA, binB, edges)
                        val gbb = createGainBucket (binB, binA, edges)
                        val alen = Real.fromInt (List.length binA)
                        val blen = Real.fromInt (List.length binB)
                        val ra = alen / (alen + blen)
                        val rb = blen / (alen + blen)
                    in if (#2 (List.nth (gba, 0)))>0 andalso ra > 0.4
                            then
                                let val f = (fn x => x=(#1 (List.nth (gba, 0))))
                                    val (x,xs) = List.partition f binA
                                    val i = valOf (indexOf (Netlist.nodes g, f))
                                in
                                    Array.update (lockedNodes, i, true);
                                    loop (xs,x @ binB)
                                end
                            else if (#2 (List.nth (gbb, 0)))>0 andalso rb > 0.4
                            then
                                let val f = (fn x => x=(#1 (List.nth (gbb, 0))))
                                    val (x,xs) = List.partition f binB
                                    val i = valOf (indexOf (Netlist.nodes g, f))
                                in
                                    Array.update (lockedNodes, i, true);
                                    loop (x @ binA,xs)
                                end
                            else (binA,binB)
                    end
                else (binA,binB)
        in
            let val (binA,binB) = loop (binAInit,binBInit)
            in ((binA,edges), (binB,edges))
            end
        end
end

