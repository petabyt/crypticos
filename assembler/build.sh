mkdir build
casm a hello.casm > build/a
casm a compilec.casm > build/b
casm r build/b "`cat build/a`" > build/c.c
tcc -w build/c.c -o build/c
./build/c
rm -rf build
