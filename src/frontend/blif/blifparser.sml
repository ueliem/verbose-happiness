structure BLIFLrVals =
	BLIFLrValsFun(structure Token = LrParser.Token)
structure BLIFLex = 
	BLIFLexFun(structure Tokens = BLIFLrVals.Tokens)
structure BLIFParser =
	JoinWithArg
		(structure ParserData=BLIFLrVals.ParserData
		structure Lex=BLIFLex
		structure LrParser=LrParser)

