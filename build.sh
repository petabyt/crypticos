rm -rf build
mkdir build

nasm boot.asm -f bin -o build/boot.bin

# Burn binary to flash drive
# sudo dd bs=440 count=1 conv=notrunc if=build/boot.bin of=/dev/sdc

dd if=/dev/zero of=build/floppy.img bs=512 count=2880
dd if=build/boot.bin of=build/floppy.img

# Build ISO image
# cd build
# 	mkdir iso
# 	cp floppy.img iso/
# 	genisoimage -no-emul-boot -boot-load-size 4 -boot-info-table -quiet -V 'CrypticOS' -o myos.iso -b floppy.img     -hide floppy.img iso/
# cd ..

read

qemu-system-x86_64 build/floppy.img
