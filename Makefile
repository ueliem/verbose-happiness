build: blif-parser lef-parser
	polyc src/main.sml -o target/placement

blif-parser:
	mllex src/frontend/blif/blif.lex
	mlyacc src/frontend/blif/blif.grm

lef-parser:
	mllex src/frontend/lef/lef.lex
	mlyacc src/frontend/lef/lef.grm

run:
	./target/placement

clean:
	rm -f ./target/placement
	rm -f src/frontend/blif/*.lex.sml
	rm -f src/frontend/blif/*.grm.sml
	rm -f src/frontend/blif/*.sig
	rm -f src/frontend/blif/*.desc

