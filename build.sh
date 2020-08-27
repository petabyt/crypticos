rm -rf build
mkdir build

nasm boot.asm -f bin -o build/boot.bin

dd if=/dev/zero of=build/floppy.img bs=512 count=2880
dd if=build/boot.bin of=build/floppy.img

read

qemu-system-x86_64 build/floppy.img
