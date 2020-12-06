rm -rf build
mkdir build

casm a hello.casm > build/a
casm a compilenasm.casm > build/b
casm r build/b "`cat build/a`" > build/c.asm
cat build/c.asm
nasm build/c.asm -o build/c
./build/c
#rm -rf build
