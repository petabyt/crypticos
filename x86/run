touch build.asm
echo "db \"`casm -a ../main.casm`\", 0" >> build.asm
nasm -f bin main.asm
rm -rf build.asm
qemu-system-x86_64 main
rm -rf main
