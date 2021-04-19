default: mini

mini:
	@casm -a mini.casm > a
	@casm -r a -i "`cat test.mcas`" > b
	@cat b
	@casm -r b
	@rm -f a b c d

compilenasm:
	@casm -a ../demo/hello.casm > d
	@casm -a compilenasm.casm > a
	@casm -r a -i "`cat d`" > b
	@nasm b -o c
	@sudo chmod +x c
	@./c
	@rm -f a b c d

compilec:
	@casm -a compilec.casm > a
	@casm -a ../demo/hello.casm > c
	@casm -r a -i "`cat c`" > b.c
	@$(CC) -w b.c -o d
	@./d
	@rm -f a b.c c d

clean:
	@rm -f a b c d
