
![](https://raw.githubusercontent.com/CrypticOS/CrypticOS.github.io/master/logo.png)
### World's Smallest Operating System
CrypticOS is a simple hobby OS that aims to feel like a  
programming a TI calculator, but be 10x simpler.  

## Design
1. Any program should be loaded on any emulator, and run perfectly.
2. It should be usable within 512 bytes, and not have to squeeze bytes in order to implement basic functionality.  
3. Programs would be written in CASM, assembled, and loaded via floppy or by serial cable.
4. Everything should be as simple as possible, and be easy to hack and mess with.

## Goals
- [x] Write OS in <512 bytes  
- [x] Write simple programs for it
- [x] Write assembler that compiles to it (https://github.com/pufflegamerz/casm)  
- [x] Write operating environment in the assembler  
- [ ] Self host the assembler  

## CrypticASM (CASM)
The main language for CrypticOS internals and applications. You can find the official  
development kit here: https://github.com/pufflegamerz/casm (assembler + emulator)  

## Building
Note: Make sure you are in the `x86` directory.  
### 256 Byte Bootable
```
nasm -f bin tiny.asm
qemu-system-x86_64 tiny
# Or, type `make tiny`
```
Try: `!%***.`  

### 512 byte Version
The same as `tiny.asm`, but more usable and stuff.  
The final binary will be a few kilobytes, since it has to  
load in demo programs.
```
make
```

## So what does it do?
CrypticOS uses a BrainF* inspired esoteric language as its main runtime.  
It is different in many ways, mainly with logic and loops. In design it should  
have the simplicity of BrainF*, but be more usable, efficient, and Assembly-like.

You can see the full specification here: https://github.com/CrypticOS/cins  
