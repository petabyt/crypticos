
![](https://raw.githubusercontent.com/CrypticOS/CrypticOS.github.io/master/logo.png)
### World's Smallest Operating System
CrypticOS is an operating system written in a custom bytecode,  
which can be emulated anywhere.  

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
