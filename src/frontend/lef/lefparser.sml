use "mlyacc-lib/base.sig";
use "mlyacc-lib/stream.sml";
use "mlyacc-lib/lrtable.sml";
use "mlyacc-lib/join.sml";
use "mlyacc-lib/parser2.sml";


use "src/frontend/lef/ast.sml";
use "src/frontend/lef/lef.grm.sig";
use "src/frontend/lef/lef.grm.sml";
use "src/frontend/lef/lef.lex.sml";

structure LEFParse : sig
    val parse : string -> LEFAST.t
end =
struct 

    structure LEFLrVals =
	LEFLrValsFun(structure Token = LrParser.Token)
    structure LEFLex = 
	LEFLexFun(structure Tokens = LEFLrVals.Tokens)
    structure LEFParser =
	JoinWithArg
		(structure ParserData=LEFLrVals.ParserData
		structure Lex=LEFLex
		structure LrParser=LrParser)

fun parse (filename) =
    let val file = TextIO.openIn filename
        fun print_error (s,i:int,_) =
            TextIO.output(TextIO.stdOut,
                          "Error, line " ^ (Int.toString i) ^ ", " ^ s ^ "\n")
        fun get _ = TextIO.input file
        val lexer = LEFParser.makeLexer get filename
        val (ast, lexer) = LEFParser.parse(0, lexer, print_error, ())
    in ast
    end

end

