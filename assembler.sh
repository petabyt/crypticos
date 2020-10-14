rm -rf build
mkdir build

# Assemble assembler
node /home/daniel/Documents/CrypticScript/cli/node.js assembler/assembler.casm > build/assembler.o
/home/daniel/Documents/CrypticScript/cli/emulator build/assembler.o "ASDF0"
