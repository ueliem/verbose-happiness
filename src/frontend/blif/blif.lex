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
(* val mlCommentStack : (string*int) list ref = ref []; *)
(* val eof = fn fileName =>
	(if (!mlCommentStack)=[] then ()
	else let val (file,line) = hd (!mlCommentStack)
		in TextIO.output(TextIO.stdOut,
			"      I am surprized to find the"
			^" end of file \""fileName^"\"\n"
			^"      in a block comment which began"
			^" at "^file^"["^Int.toString line^"].\n")
		end;
	T.EOF(!linep,!linep)); *)
val eof = fn fileName => T.EOF(!linep,!linep);

structure KeyWord :
sig
	val find:string->(int*int->(svalue,int) token) option
end =
struct
	val TableSize =  422 (* 211 *)
	val HashFactor = 5
	val hash = fn
		s => List.foldr (fn (c,v) => (v*HashFactor+(ord c))
							mod TableSize) 0 (explode s)
	val HashTable = Array.array(TableSize,nil) :
		(string * (int * int -> (svalue,int) token))
		list Array.array
	val add = fn
		(s,v) => let val i = hash s
				in Array.update(HashTable,i,(s,v)
				:: (Array.sub(HashTable, i)))
				end
	val find = fn
		s => let val i = hash s
			fun f ((key,v)::r) = if s=key then SOME v
									else f r
				| f nil = NONE
		in  f (Array.sub(HashTable, i))
		end
	val _ = (List.app add [
		(".model",    T.DOTMODEL),
		(".inputs", T.DOTINPUTS),
		(".outputs",  T.DOTOUTPUTS),
		(".clock",   T.DOTCLOCK),
		(".end",   T.DOTEND)
	]) 
end

%%

%header (functor BLIFLexFun(structure Tokens: BLIF_TOKENS));

%arg (fileName:string);

alpha=[A-Za-z];
digit=[0-9];
ws = [\ \t];
newline="\n";
dot=".";

integer = {digit}+;

%%

{ws}+ => (continue());

