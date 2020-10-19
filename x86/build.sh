# What a mess.

rm -rf build
mkdir build

nasm bootloader.asm -f bin -o build/boot.bin

# dd if=/dev/zero of=build/floppy.img bs=1024 count=2880
# dd if=build/boot.bin of=build/floppy.img

read

qemu-system-x86_64 -drive format=raw,file=build/boot.bin
