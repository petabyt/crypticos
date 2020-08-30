rm -rf build
mkdir build

nasm boot.asm -f bin -o build/boot.bin

#dd status=noxfer conv=notrunc if=build/boot.bin of=build/boot.flp
#genisoimage build/boot.flp -o build/boot.iso

dd if=/dev/zero of=build/floppy.img bs=1024 count=2880
dd if=build/boot.bin of=build/floppy.img

read

qemu-system-x86_64 build/floppy.img
