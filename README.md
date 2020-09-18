# CrypticOS
Tiny Programmable Bootsector OS written in x86 Assembly.

## Design
The core design will not depend on CPU architecture. It should be easy to create  
an emulator in another language. It should be usable in 512 bytes, and not have to  
squeeze bytes in order to implement basic functionality.  

Here is simple emulator in MIT Scratch: https://scratch.mit.edu/projects/424817216/

## Goals
[-] Write interpreter OS in 512 bytes
[-] Write simple programs in that interpreter
[-] Write assembler that compiles to it (https://github.com/pufflegamerz/CrypticDK)
[ ] Write OS in that language
[ ] Rewrite assembler in the higher level language

## Applications
CrypticOS has an Assembly-like version of BrainF* as it's main runtime.  
It resembles a "machine code" that can be easily interpreted.  

The design is fairly simple. There are two pointers, and two memory arrays.  
One is the top, and the other is the bottom.  
The "top" acts like registers.
The "bottom" acts like real memory.

The following is an instruction set:  

Move the two different pointers. Yes, based on WASD and arrow keys.  
`>` = `pointer++`  
`<` = `pointer--`  
`d` = `pointer2++`  
`a` = `pointer2--`  
(Change ad to db?)

Use these to move a value up the top or bottom.  
Very useful for duplicating a register (^>v)
`^` = `top[pointer] = bottom[pointer]`
`v` = `mem[pointer] = top[pointer]`

You have your usual BrainF instructions:  
`+` = `bottom[pointer]++`  
`-` = `bottom[pointer]--`  
`.` = `print(mem[pointer])`  
`,` = `bottom[pointer] = read()`  


`?` = `if (top[pointer + 1] != top[pointer + 2]) {goto top[pointer]}`  
`$` = `goto top[pointer]`  
`|` = Label character. It can be accessed by it's occurrence (goto).

These aren't necessary, but definitely reduce code size.
`!` = `bottom[pointer] = 0`  
`*` = `bottom[pointer] += 5`  
`%` = `bottom[pointer] += 50`  

This programming language is small enough to have a full interpreter  
on the OS, and usable enough to compile a higher level language to.

## How to use
On boot, the usable commands are:
```
pgrm - Open programming interface  
help - show possible commands  
a - Run sample program (hello world in CrypticASM)  
```
