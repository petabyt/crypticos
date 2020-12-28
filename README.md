
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
### 256 byte OS
```
# Make sure you are in the x86 directory
nasm -f bin x86/tiny.asm -o build/boot.bin
qemu-system-x86_64 build/boot.bin
```
### Deluxe >256 byte version
This version has demos and stuff, but still the same idea as `tiny.asm`.
```
# Make sure you are in the x86 directory
# This will open in qemu
./build.sh
```
Usage:  
`p` Enter program mode. `q` to quit.
`>` load a program. Ex: `>a` to load pgrm a.
There are programs a-d. Have fun.

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

### CrypticCode Instruction Set

Move the two different pointers. Yes, based on WASD and arrow keys.  
`>` = `pointerb++`  
`<` = `pointerb--`  
`d` = `pointera++`  
`a` = `pointera--`  

Copying data:  
`^` = `top[pointer] = bottom[pointerb]`  
`v` = `mem[pointer] = top[pointer]`  
These are very useful for copying variables: `^>>v`  

Brainf based functions:  
`+` = `bottom[pointerb]++`  
`-` = `bottom[pointerb]--`  
`.` = `print(mem[pointerb])`  
`,` = `bottom[pointerb] = read()`  

Logic and Jumping:  
`?` = `if (top[pointera + 1] != top[pointera + 2]) {goto top[pointera]}`  
`$` = `goto top[pointera]`  
`|` = Declare a label. It is jumped to by its occurance (first = 1..)  
(a real specification paper will be finished soon)

MISC Instructions
`!` = `bottom[pointerb] = 0`  
`*` = `bottom[pointerb] += 5`  
`%` = `bottom[pointerb] += 50`  

Official specification document coming soon™
