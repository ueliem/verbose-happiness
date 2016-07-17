use "src/frontend/blif/blifparser.sml";

use "src/netlist/netlist.sml";
use "src/netlist/blif2graph.sml";
(* use "src/fm.ml"; *)

(* val testvar = DirectedGraph.empty;
DirectedGraph.addNode ("in0", DirectedGraph.empty);
val p = partition_fm testvar; *)
fun main() = (
    let val ast = BLIFParse.parse("fulladder_mapped.blif")
        val graph = BLIF2Graph.blif2graph(ast)
    in
        print "Hello World\n";
        (* print (String.concatWith "\n" (DirectedGraph.nodes testvar));
        print "\n";
        print (Int.toString (List.length (DirectedGraph.nodes testvar))); *)
        print "Bye World\n"
    end
)

