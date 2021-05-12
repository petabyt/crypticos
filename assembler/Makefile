default: mini

demo := ../demo/count.casm

self:
	@casm -a self.casm > a
	@casm -a $(demo) > b
	@casm -r a -i "`cat b`"

	@rm -f a b c d

mini:
	@casm -a mini.casm > a
	@casm -r a -i "`cat test.mcas`" > b
	@cat b
	@casm -r b

	@rm -f a b c d

nasm:
	@casm -a $(demo) > d
	@casm -a compilenasm.casm > a
	@casm -r a -i "`cat d`" > b
	@nasm -felf64 b -o c
	@ld c -o d
	@chmod +x d
	@./d || :
	@echo ""
	@rm -f a b c d

c:
	@casm -a compilec.casm > a
	@casm -a $(demo) > c
	@casm -r a -i "`cat c`" > b.c
	@$(CC) -w b.c -o d
	@./d
	@echo ""
	@rm -f a b.c c d

clean:
	@rm -f a b c d
