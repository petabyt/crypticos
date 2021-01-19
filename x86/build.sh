touch build.asm
echo "db \"`casm -a ../demo/screen.casm`\", 0" >> build.asm
nasm -f bin main.asm
qemu-system-x86_64 main
rm -rf build.asm main
