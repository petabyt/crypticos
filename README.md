# CrypticOS
Tiny Programmable Bootsector (256 bytes) OS written in x86 Assembly.

## Design
1. The core design should not depend on CPU architecture.  
2. It should be usable within 512 bytes, and not have to squeeze bytes in order to implement basic functionality.  
3. The kernel, assembler, and environment should be written in CrypticASM.  

## Emulators
MIT Scratch: https://scratch.mit.edu/projects/424817216/

## Goals
- [x] Write interpreter OS in 512 bytes  
- [x] Write simple programs in that interpreter  
- [x] Write assembler that compiles to it (https://github.com/pufflegamerz/CrypticDK)  
- [ ] Write operating environment in that language  
- [ ] Rewrite assembler in the assembler  

## Applications
CrypticOS has a modified version of BrainF* as it's main run time.  
It resembles a "machine code" that can be easily interpreted.  

The design is fairly simple. There are two pointers, and two memory arrays.  
One is the top, and the other is the bottom.  
The "top" acts like registers.
The "bottom" acts like real memory.

The following is the instruction set:  

Move the two different pointers. Yes, based on WASD and arrow keys.  
`>` = `pointer++`  
`<` = `pointer--`  
`d` = `pointer2++`  
`a` = `pointer2--`  
(Change ad to db?)

Use these to move a value up the top or bottom.  
Very useful for duplicating an integer: `^>v`
`^` = `top[pointer] = bottom[pointer]`
`v` = `mem[pointer] = top[pointer]`

Some Brainf inspired functions:
`+` = `bottom[pointer]++`  
`-` = `bottom[pointer]--`  
`.` = `print(mem[pointer])`  
`,` = `bottom[pointer] = read()`  


`?` = `if (top[pointer + 1] != top[pointer + 2]) {goto top[pointer]}`  
`$` = `goto top[pointer]`  
`|` = Label character. It can be accessed by it's occurrence (goto).

Etc instructions to reduce code size and improve speed (compared to BrainF*)
`!` = `bottom[pointer] = 0`  
`*` = `bottom[pointer] += 5`  
`%` = `bottom[pointer] += 50`  

The small interpreter is currently ~200 bytes.

## How to use
On boot.asm, try this code:
```
!%***.
+.
+.
```
