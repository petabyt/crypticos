default: mini

demo := ../demo/count.casm
CC := tcc

self:
	@casm -a self.casm > a
	@casm -a $(demo) > b
	@casm -r a -i "`cat b`"

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
	@casm -a compilec.casm > a
	@casm -a $(demo) > c
	@casm -r a -i "`cat c`" > b.c
	@cat b.c | head
	@$(CC) -w b.c -o d
	@./d
	@echo ""

clean:
	@rm -f a b c d b.c
