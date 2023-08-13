f ?= test2.crc
default: build clean

build:
	@cd src; $(CC) lex.c compiler.c parse.c -o ../crc
	@./crc casm/$(f) > a
	@cat a
	@echo "-----"
#@casm -a a > b
#@casm -r b

clean:
	@rm -rf a b
