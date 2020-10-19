# What a mess.

rm -rf x86/build
mkdir x86/build

# Build interface
#node ../casm/cli/node.js main.casm > x86/build/main.o



nasm x86/tiny.asm -f bin -o x86/build/boot.bin

# Burn binary to flash drive
# sudo dd bs=440 count=1 conv=notrunc if=build/boot.bin of=/dev/sdc

dd if=/dev/zero of=x86/build/floppy.img bs=512 count=2880
dd if=x86/build/boot.bin of=x86/build/floppy.img

# Build ISO image
# cd build
# 	mkdir iso
# 	cp floppy.img iso/
# 	genisoimage -no-emul-boot -boot-load-size 4 -boot-info-table -quiet -V 'CrypticOS' -o myos.iso -b floppy.img     -hide floppy.img iso/
# cd ..

read

qemu-system-x86_64 x86/build/floppy.img -monitor stdio

#qemu-system-x86_64 -monitor tcp:127.0.0.1:1234,server,nowait build/floppy.img &
