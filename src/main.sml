use "mlyacc-lib/base.sig";
use "mlyacc-lib/stream.sml";
use "mlyacc-lib/lrtable.sml";
use "mlyacc-lib/join.sml";
use "mlyacc-lib/parser2.sml";


use "src/frontend/blif/ast.sml";
use "src/frontend/blif/blif.grm.sig";
use "src/frontend/blif/blif.lex.sml";
use "src/frontend/blif/blif.grm.sml";
use "src/frontend/blif/blifparser.sml";

use "src/graph/graph.ml";
use "src/fm.ml";

val testvar = (*DirectedGraph.empty;*)
DirectedGraph.addNode ("in0", DirectedGraph.empty);
val p = partition_fm testvar;
fun main() = (
    print "Hello World\n";
    print (String.concatWith "\n" (DirectedGraph.nodes testvar));
    print "\n";
    print (Int.toString (List.length (DirectedGraph.nodes testvar)));
    print "\nBye World\n"
)

