structure T = Tokens
type pos = int             (* Position in file *)
type svalue = T.svalue
type ('a,'b) token = ('a,'b) T.token
type lexresult = (svalue,pos) token
type lexarg = string
type arg = lexarg
val linep = ref 1;         (* Line pointer *)

val error : string * int * int -> unit = fn
	(e,l1,l2) => TextIO.output(TextIO.stdOut,"lex:line "
		^Int.toString l1^" l2="^Int.toString l2
		^": "^e^"\n")
val badCh : int * char -> unit = fn
	(l1,ch) => TextIO.output(TextIO.stdOut,"lex:line "
		^Int.toString l1^": Invalid character "
		^Int.toString(ord ch)^"="^str(ch)^"\n")

val eof = fn fileName => T.EOF(!linep,!linep);

local
    val idlist = [("VERSION", T.VERSION),
		  ("NAMESCASESENSITIVE", T.NAMESCASESENSITIVE),
		  ("BUSBITCHARS", T.BUSBITCHARS),
		  ("DIVIDERCHAR", T.DIVIDERCHAR),
		  ("UNITS", T.UNITS),
		  ("END", T.END),
		  ("USEMINSPACING", T.USEMINSPACING),
		  ("OBS", T.OBS),
		  ("PIN", T.PIN),
		  ("ON", T.ON),
		  ("OFF", T.OFF),
		  ("CLEARANCEMEASURE", T.CLEARANCEMEASURE),
		  ("EUCLIDEAN", T.EUCLIDEAN),
		  ("MANUFACTURINGGRID", T.MANUFACTURINGGRID),
		  ("LAYER", T.LAYER),
		  ("TYPE", T.TYPE),
		  ("MASTERSLICE", T.MASTERSLICE),
		  ("CUT", T.CUT),
		  ("SPACING", T.SPACING),
		  ("ROUTING", T.ROUTING),
		  ("DIRECTION", T.DIRECTION),
		  ("HORIZONTAL", T.HORIZONTAL),
		  ("VERTICAL", T.VERTICAL),
		  ("PITCH", T.PITCH),
		  ("OFFSET", T.OFFSET),
		  ("WIDTH", T.WIDTH),
		  ("CAPACITANCE", T.CAPACITANCE),
		  ("RESISTANCE", T.RESISTANCE),
		  ("POWER", T.POWER),
		  ("CURRENT", T.CURRENT),
		  ("VOLTAGE", T.VOLTAGE),
		  ("DATABASE", T.DATABASE),
		  ("FREQUENCY", T.FREQUENCY),
		  ("NANOSECONDS", T.NANOSECONDS),
		  ("PICOFARADS", T.PICOFARADS),
		  ("OHMS", T.OHMS),
		  ("MILLIWATTS", T.MILLIWATTS),
		  ("MILLIAMPS", T.MILLIAMPS),
		  ("VOLTS", T.VOLTS),
		  ("MICRONS", T.MICRONS),
		  ("MEGAHERTZ", T.MEGAHERTZ),
		  ("RPERSQ", T.RPERSQ),
		  ("CPERSQDIST", T.CPERSQDIST),
		  ("EDGECAPACITANCE", T.EDGECAPACITANCE),
		  ("VIA", T.VIA),
		  ("DEFAULT", T.DEFAULT),
		  ("RECT", T.RECT),
		  ("POLYGON", T.POLYGON)]
in
    fun idToken (t, p) =
	case List.find (fn (id, _) => id = t) idlist of
	    NONE => T.ID (t, p, p)
	  | SOME (_, tok) => tok (p, p)
end

%%

%s COMMENT;
%header (functor LEFLexFun(structure Tokens: LEF_TOKENS));

%arg (fileName:string);

alpha=[A-Za-z];
digit=[0-9];
alphanumeric=[A-Za-z0-9];

idstart=[A-Za-z$/];
idchar=[A-Za-z0-9\$\/\.\_];

ws = [\ \t];
newline = "\n";
dot=".";
semicolon=";";

integer = -?{digit}+;
float = -?{digit}+"."{digit}+;
scinot = -?{digit}+("."{digit}+)?"e"-?{digit}+;
stringchar = [^"];

%%

<INITIAL>"#" => (YYBEGIN COMMENT; continue());
<COMMENT>. => (continue());
<COMMENT>{newline} => (linep := (!linep) + 1; YYBEGIN INITIAL; continue());

<INITIAL>{ws}+ => (continue());
<INITIAL>{newline} => (linep := (!linep) + 1; continue());

<INITIAL>{semicolon} => (Tokens.SEMICOLON(!linep,!linep));

<INITIAL>{idstart}{idchar}* => (idToken(yytext,!linep));

<INITIAL>{integer} => (Tokens.REAL(Option.valOf (Real.fromString yytext),!linep,!linep));
<INITIAL>{float} => (Tokens.REAL(Option.valOf (Real.fromString yytext),!linep,!linep));
<INITIAL>{scinot} => (Tokens.REAL(Option.valOf (Real.fromString yytext),!linep,!linep));

<INITIAL>\"{stringchar}*\" => (Tokens.STRING(
				Option.valOf (String.fromString (String.substring (yytext, 1, String.size yytext - 2))),
				!linep, !linep));

. => (error ("ignoring bad character " ^ yytext, !linep, !linep);
		continue());

