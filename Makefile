f ?= edit.casm

default: run clean
run:
	@casm -a $(f) > a
	@casm -r a

std:
	@touch a
	@echo '#define STANDALONE 0' >> a
	@echo 'inc "$$kernel/main.casm"' >> a
	@cat $(f) >> a
	@echo 'inc "$$kernel/end.casm"' >> a
	@cat a

clean:
	@rm -rf a b c d
