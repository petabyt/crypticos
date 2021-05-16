f ?= util/edit.casm

default: run clean
run:
	@casm -a $(f) > a
	@casm -r a

clean:
	@rm -rf a b c d
