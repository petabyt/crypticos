# What a mess.

mkdir build

casm a ../arch/video.casm > build/a.o
casm a ../demo/hello.casm > build/b.o
casm a ../demo/count.casm > build/c.o

# Insert programs
echo "pgrm_a: db '`cat build/b.o`', 0" >> build/pgrms.asm
echo "pgrm_b: db '`cat build/c.o`', 0" >> build/pgrms.asm
echo "pgrm_c: db '',0" >> build/pgrms.asm
echo "pgrm_d: db '`cat build/a.o`',0" >> build/pgrms.asm
echo "pgrm_e: db '',0" >> build/pgrms.asm

nasm bootloader.asm -f bin -o build/boot.bin

# dd if=/dev/zero of=build/floppy.img bs=1024 count=2880
# dd if=build/boot.bin of=build/floppy.img

#read

qemu-system-x86_64 -drive format=raw,file=build/boot.bin -monitor stdio

#rm -rf build
