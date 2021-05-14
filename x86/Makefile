run: compile emulate clean
tiny: compiletiny emulate clean

help:
	@echo "make run		Run main OS"
	@echo "make tiny	Run tiny <256 version"

compile:
	@casm -a ../assembler/interpret.casm > a
	@casm -a ../edit.casm > b
	@nasm -f bin main.asm -o main

compiletiny:
	@nasm -f bin tiny.asm -o main

iso: compile isoA
isoA:
	@dd if=/dev/zero of=floppy.img bs=1024 count=1440
	@dd if=main of=floppy.img seek=0 conv=notrunc
	@genisoimage -quiet -V "CrypticOS" -input-charset iso8859-1\
		-o cryptic.iso -b floppy.img -hide floppy.img .

emulate:
	@qemu-system-x86_64 main

cleanBin:
	@rm -rf *.bin main a b c

clean: cleanBin cleanImg
cleanImg:
	@rm -rf *.img *.iso
