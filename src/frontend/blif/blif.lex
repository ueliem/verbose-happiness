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

%%

%header (functor BLIFLexFun(structure Tokens: BLIF_TOKENS));

%arg (fileName:string);

alpha=[A-Za-z];
digit=[0-9];
alphanumeric=[A-Za-z0-9];

idstart=[A-Za-z$/];
idchar=[A-Za-z0-9\$\/\.\_];

ws = [\ \t];
newline = "\n";
dot=".";
equals="=";
dash="-";
zero="0";
one="1";
two="2";
three="3";

integer = {digit}+;

%%

{ws}+ => (continue());
{newline} => (linep := (!linep) + 1; Tokens.NEWLINE(!linep,!linep));

<INITIAL>{equals} => (Tokens.EQUALS(!linep,!linep));
<INITIAL>{dash} => (Tokens.DASH(!linep,!linep));

<INITIAL>{zero} => (Tokens.ZERO(!linep,!linep));
<INITIAL>{one} => (Tokens.ONE(!linep,!linep));
<INITIAL>{two} => (Tokens.TWO(!linep,!linep));
<INITIAL>{three} => (Tokens.THREE(!linep,!linep));

<INITIAL>{idstart}{idchar}* => (Tokens.ID(yytext,!linep,!linep));
<INITIAL>{dot}{idstart}{idchar}* => (if yytext=".model"
						then Tokens.DOTMODEL(!linep,!linep)
					else if yytext=".inputs"
						then Tokens.DOTINPUTS(!linep,!linep)
					else if yytext=".outputs"
						then Tokens.DOTOUTPUTS(!linep,!linep)
					else if yytext=".clock"
						then Tokens.DOTCLOCK(!linep,!linep)
					else if yytext=".end"
						then Tokens.DOTEND(!linep,!linep)
					else if yytext=".names"
						then Tokens.NAMES(!linep,!linep)
					else if yytext=".def"
						then Tokens.DEF(!linep,!linep)
					else if yytext=".gate"
						then Tokens.GATE(!linep,!linep)
					else if yytext=".subckt"
						then Tokens.SUBCKT(!linep,!linep)
					else Tokens.ID(yytext,!linep,!linep));

. => (error ("ignoring bad character " ^ yytext, !linep, !linep);
		continue());

