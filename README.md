
![](https://raw.githubusercontent.com/CrypticOS/CrypticOS.github.io/master/logo.png)
### World's Smallest Operating System
CrypticOS is an operating system mostly written in a custom  
bytecode, which can be emulated anywhere.  

## Design
1. Any program should be loaded on any emulator, and run perfectly.
2. X86 bootable should be usable within 512 bytes.
3. "Make it simple, and keep it simple"

## Goals
- [x] Write OS in <512 bytes  
- [x] Write simple programs for it
- [x] Write assembler that compiles to it (https://github.com/pufflegamerz/casm)  
- [x] Write operating environment in the assembler  
- [ ] Self host the assembler or make a C compiler  

## CrypticASM (CASM)
The main language for CrypticOS internals and applications. You can find the official  
development kit here: https://github.com/pufflegamerz/casm (assembler + emulator)  

## Building
### Install CASM assembler (for main test binary)
```
git clone https://github.com/CrypticOS/casm
cd casm
make
cp casm /bin/
```
Note: Make sure you are in the `x86` directory.  
### Main test binary
```
sudo apt install qemu-system-x86 nasm
cd x86
make
```
Try: `!%***.`  
Also try `!%` to load the edit app. Press ESC to exit.  

### 256 byte Version
Very basic. Type `!%***.` and enter to test it out.
```
make tiny
```

## So what does it do?
CrypticOS uses a BrainF* inspired esoteric language as its main runtime.  
It is different in many ways, mainly with logic and loops. In design it should  
have the simplicity of BrainF*, but be more usable, efficient, and Assembly-like.

You can see the full specification here: https://github.com/CrypticOS/cins  
