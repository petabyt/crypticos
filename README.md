
![](https://raw.githubusercontent.com/CrypticOS/CrypticOS.github.io/master/logo.png)
### A Tiny Programmable Operating System.

CrypticOS attempts to recreate the programming experience of old  
computers, and have the simplicity of a TI calculator.

## Design
1. Any program should be loaded on any architecture, and run perfectly.
2. It should be usable within 512 bytes, and not have to squeeze bytes in order to implement basic functionality.  
3. Programs would be written in CASM, and loaded via floppy or by serial cable.
4. Everything should be as simple as possible, and be easy to hack and play with.

## Goals
- [x] Write OS in <512 bytes  
- [x] Write simple programs for it
- [x] Write assembler that compiles to it (https://github.com/pufflegamerz/casm)  
- [x] Write operating environment in the assembler  
- [ ] Rewrite assembler in the assembler  (not finished, still on lexer)

## CrypticASM (CASM)
The main language for CrypticOS internals and applications. You can find the official  
development kit here: https://github.com/pufflegamerz/casm (assembler + emulator)  

## Building
Note: Make sure you are in the `x86` directory.  
### 256 Byte Bootable
```
nasm -f bin tiny.asm
qemu-system-x86_64 tiny
```
Type in CINS code. It will run.  

### 512 byte Version
The same as `tiny.asm`, but more usable and stuff.  
```
nasm -f bin main.asm
qemu-system-x86_64 main
```
Usage: See comments in `x86/main.asm`.

## So what does it do?
CrypticOS uses a BrainF* inspired esoteric language as its main runtime.  
It is different in many ways, mainly with logic and loops. In design it should  
have the simplicity of BrainF*, but be more usable, efficient, and Assembly-like.

There are 16 instructions (2^4), therefore any program written in it can be  
represented in a "nibble" 4 bit type. The program is loaded and read very similarly  
to BrainF*.

The design is fairly simple.
There are two pointers, and two memory arrays. One is the top, and the other is the bottom.  
The "top" acts like registers. The "bottom" acts like program memory.  

You can see the full specification here: https://github.com/CrypticOS/cins  
