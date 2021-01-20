touch build.asm
echo "db \"`casm -a ../main.casm`\", 0" >> build.asm
nasm -f bin main.asm

dd if=/dev/zero of=floppy.img bs=1024 count=1440
dd if=main of=floppy.img seek=0 conv=notrunc

genisoimage -quiet -V "CrypticOS" -input-charset iso8859-1 -o cryptic.iso -b floppy.img -hide floppy.img .

rm -rf main build.asm
