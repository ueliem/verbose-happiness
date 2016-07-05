build: parser
	polyc src/main.sml -o target/placement

parser:
	mllex src/frontend/blif/blif.lex
	mlyacc src/frontend/blif/blif.grm

run:
	./target/placement

clean:
	rm -f ./target/placement
	rm -f src/frontend/blif/*.lex.sml
	rm -f src/frontend/blif/*.grm.sml
	rm -f src/frontend/blif/*.sig
	rm -f src/frontend/blif/*.desc

