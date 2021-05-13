default: mini

demo := ../demo/tictac.casm
CC := tcc

interpret:
	@casm -a interpret.casm > a
	@casm -a $(demo) > b
	@casm -r a -i "`cat b`0123q"

mini:
	@casm -a mini.casm > a
	@casm -r a -i "`cat test.mcas`" > b
	@cat b
	@casm -r b

nasm:
	@casm -a $(demo) > d
	@casm -a compilenasm.casm > a
	
	@casm -r a -i "`cat d`" > b
	@cat b | head
	@nasm -felf64 b -o c
	@ld c -o d
	@chmod +x d
	@./d || :
	@echo ""

c:
# Assemble main file
	@casm -a compilec.casm > a
	@casm -r a -i "`cat a`" > b.c

# Now, self host a few times
	@$(CC) -w b.c -o d
	@./d a > b.c
	@$(CC) -w b.c -o d
	@./d a > b.c
	@$(CC) -w b.c -o d
	@./d a

	@echo ""

clean:
	@rm -f a b c d b.c c.c
