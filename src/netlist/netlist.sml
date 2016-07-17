structure Node =
struct
    datatype n =
        Node of int * p list
    and p =
        Port of string
end

signature NETLIST =
sig
    type netlist
    type edge
    type node
    val empty : netlist
    val isEmpty : netlist -> bool
    val addNode : node * netlist -> netlist
    val addEdge : edge * netlist -> netlist
    val nodes : netlist -> node list
    val edges : netlist -> edge list
end

structure Netlist : NETLIST =
struct
    type node = int * string ref
    type edge = node ref list * node ref list
    type netlist = node list * edge list
    val empty = ([],[])
    fun isEmpty ([], []) = true
        | isEmpty _ = false
    fun addNode (a, ([], [])) = ([a], [])
        | addNode (a, (nodes, edges)) = (a::nodes, edges)
    fun addEdge (a, ([], [])) = ([], [a])
        | addEdge (a, (nodes, edges)) = (nodes, a::edges)
    fun nodes (n, e) = n
    fun edges (n, e) = e
end

