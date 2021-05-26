run: compile emulate clean
tiny: compileTiny emulate clean

define compile
	@touch t
	@echo "#define X86 0" > t
	@cat ../$(1) >> t
	@casm -a t > $(2)
	@rm -rf t
endef

help:
	@echo "make run		Run main OS"
	@echo "make tiny	Run tiny <256 version"

compile:
	$(call compile,util/cat.casm,a)
	$(call compile,arch/video.casm,b)
	@#$(call compile,cins/interpret.casm,a)
	@nasm -f bin main.asm -o main

compileTiny:
	@nasm -f bin -DSIZE tiny.asm -o main
	@ls -l main
	@nasm -f bin tiny.asm -o main

iso: compile isoA
isoA:
	@dd if=/dev/zero of=floppy.img bs=1024 count=1440
	@dd if=main of=floppy.img seek=0 conv=notrunc
	@genisoimage -quiet -V "CrypticOS" -input-charset iso8859-1\
		-o cryptic.iso -b floppy.img -hide floppy.img .

emulate:
	@qemu-system-x86_64 main

clean:
	@rm -rf *.bin main a b c t *.img *.iso tiny
