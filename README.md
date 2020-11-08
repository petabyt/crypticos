# CrypticOS
Tiny Programmable Bootsector (256 bytes) OS written in x86 Assembly.

## Design
1. The core design should not depend on CPU architecture.  
2. It should be usable within 512 bytes, and not have to squeeze bytes in order to implement basic functionality.  
3. The kernel, assembler, and environment should be written in CrypticASM (CASM).  

## Emulators
MIT Scratch: https://scratch.mit.edu/projects/424817216/

## Goals
- [x] Write OS in <512 bytes  
- [x] Write simple programs for it
- [x] Write assembler that compiles to it (https://github.com/pufflegamerz/CrypticDK)  
- [x] Write operating environment in the assemblers  
- [ ] Rewrite assembler in the assembler  (not finished, still on lexer)

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
`>` = `pointer++`  
`<` = `pointer--`  
`d` = `pointer2++`  
`a` = `pointer2--`  

Copying data:  
`^` = `top[pointer] = bottom[pointer]`
`v` = `mem[pointer] = top[pointer]`
These are very useful for copying variables: `^>>v`

Some Brainf inspired functions:  
`+` = `bottom[pointer]++`  
`-` = `bottom[pointer]--`  
`.` = `print(mem[pointer])`  
`,` = `bottom[pointer] = read()`  

Logic and Jumping:  
`?` = `if (top[pointer + 1] != top[pointer + 2]) {goto top[pointer]}`  
`$` = `goto top[pointer]`  
`|` = Declare a label. It is jumped to by its occurance (first = 1..)

Etc instructions to reduce code size/speed (compared to BrainF*)
`!` = `bottom[pointer] = 0`  
`*` = `bottom[pointer] += 5`  
`%` = `bottom[pointer] += 50`  

The small interpreter is currently ~200 bytes.  
The full bootable IDLE is ~250 bytes.

## CrypticASM (CASM)
The main language for CrypticOS internals and applications. You can find  
an online emulator and assembler here: https://pufflegamerz.github.io/CrypticDK/www/  

If you wish to write CASM with a modern text editor, use casm.yaml with the Micro editor.  

## Building
### 256 byte OS
```
nasm -f bin x86/tiny.asm -o build/boot.bin
qemu-system-x86_64 build/boot.bin # Run the binary in whatever you want
```
### Deluxe >512 byte version
This version has demos and stuff, but still the idea as `tiny.asm`.
`nasm -f bin bootloader.asm -o build/boot.bin`  
Usage:  
`p` Enter program mode. `q` to quit.
`>` load a program. Ex: `>a` to load pgrm a.
There are programs a-c. Have fun.
