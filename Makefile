help:
	echo "Required packages: qemu-system-x86 gcc nasm"

b_casm:
	cd casm && $(MAKE)

b_x86: b_casm
	cd x86 && $(MAKE)

clean:
	cd x86 && $(MAKE) clean
	cd casm && $(MAKE) clean
