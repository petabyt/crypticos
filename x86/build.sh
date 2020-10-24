# What a mess.

rm -rf build
mkdir build


node ../../casm/cli/node.js ../main.casm >> build/a.o

echo "; Main program file. Store programs here." >> build/pgrms.asm
echo "pgrm_a: db '!%****++.*****++++.*++..+++.!********++++.!******++.%*.****++++.+++.!%%*+++.!%%.!******+++.a', 0 ; Hello World" >> build/pgrms.asm
echo "pgrm_b: db '!%-->|<.>dd!<^>a!%*++^a!++^!?<+>!+^$|', 0 ; Count 1-10" >> build/pgrms.asm
echo "pgrm_c: db 'dd!**^a!**^a!+^!?!%***.|!%***+.', 0; Newline pgrm" >> build/pgrms.asm
echo "pgrm_d: db '`cat build/a.o`', 0" >> build/pgrms.asm
echo "pgrm_e: db '!**->!%***>!>!+>!+>!>!>!++<<<<<<<@', 0" >> build/pgrms.asm


# !**->!%***>!>!+>!+>!>!>!+<<<<<<<@
# !**.........................+++.

nasm bootloader.asm -f bin -o build/boot.bin

# dd if=/dev/zero of=build/floppy.img bs=1024 count=2880
# dd if=build/boot.bin of=build/floppy.img

#read

qemu-system-x86_64 -drive format=raw,file=build/boot.bin -monitor stdio
