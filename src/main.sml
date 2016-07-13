use "src/frontend/blif/blifparser.sml";

(* use "src/graph/graph.ml";
use "src/fm.ml"; *)

(* val testvar = DirectedGraph.empty;
DirectedGraph.addNode ("in0", DirectedGraph.empty);
val p = partition_fm testvar; *)
fun main() = (
    print "Hello World\n";
    (* print (String.concatWith "\n" (DirectedGraph.nodes testvar));
    print "\n";
    print (Int.toString (List.length (DirectedGraph.nodes testvar))); *)
    (BLIFParse.parse("fa3.blif"));
    print "Bye World\n"
)

