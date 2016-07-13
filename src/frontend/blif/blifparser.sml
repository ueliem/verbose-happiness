use "mlyacc-lib/base.sig";
use "mlyacc-lib/stream.sml";
use "mlyacc-lib/lrtable.sml";
use "mlyacc-lib/join.sml";
use "mlyacc-lib/parser2.sml";


use "src/frontend/blif/ast.sml";
use "src/frontend/blif/blif.grm.sig";
use "src/frontend/blif/blif.grm.sml";
use "src/frontend/blif/blif.lex.sml";

structure BLIFParse : sig
    val parse : string -> AST.m
end =
struct 

    structure BLIFLrVals =
	BLIFLrValsFun(structure Token = LrParser.Token)
    structure BLIFLex = 
	BLIFLexFun(structure Tokens = BLIFLrVals.Tokens)
    structure BLIFParser =
	JoinWithArg
		(structure ParserData=BLIFLrVals.ParserData
		structure Lex=BLIFLex
		structure LrParser=LrParser)

fun parse (filename) =
    let val file = TextIO.openIn filename
        fun print_error (s,i:int,_) =
            TextIO.output(TextIO.stdOut,
                          "Error, line " ^ (Int.toString i) ^ ", " ^ s ^ "\n")
        fun get _ = TextIO.input file
        val lexer = BLIFParser.makeLexer get filename
        val (ast, lexer) = BLIFParser.parse(0, lexer, print_error, ())
    in ast
    end

end

