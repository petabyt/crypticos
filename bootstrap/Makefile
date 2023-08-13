demo := ../demo/count.casm
CC := tcc

interpret:
	@casm -a interpret.casm > a
	@casm -a $(demo) > b
	@casm -r a -i "`cat b`"

mcasm:
	@casm -a mcasm.casm > a
	@casm -r a -i "`cat test.mcas`" > b
	@cat b
	@casm -r b

nasm:
	@casm -a $(demo) > d
	@casm -a nasm.casm > a
	
	@casm -r a -i "`cat d`" > b
	@nasm -felf64 b -o c
	@ld c -o d
	@chmod +x d
	@./d || :
	@echo ""

boot:
	@echo "#define X86 0" > temp.casm
	@cat nasm.casm >> temp.casm
	@casm -a temp.casm > a
	@casm -a $(demo) > c
	@casm -r a -i "`cat c`0" > b.asm
	@nasm -f bin b.asm
	@qemu-system-x86_64 b

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
	@rm -f a b c d b.c c.c temp.casm b.asm
