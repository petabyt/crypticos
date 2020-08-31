# CrypticOS
Tiny Programmable Bootsector OS written in x86 Assembly.

## Design
Design: It should not depend too much on CPU architecture. It also must be
smaller 512 bytes, and not have to squeeze out bytes in order to implement   
basic functionality.  

## Applications
CrypticOS has an Assembly-like version of BrainF* called CrypticASM.  
The following is an instruction set:  

Move the two different pointers. Yes, based on WASD and arrow keys.  
`>` = `pointer++`  
`<` = `pointer--`  
`d` = `pointer2++`  
`a` = `pointer2--`  

Use these to move a value up to mem2 or down to mem.  
Think of the top (mem2) as registers, and the bottom, (mem),  
as the system memory.
`^` = `mem2[pointer2] = mem[pointer]`
`v` = `mem[pointer] = mem2[pointer2]`

`+` = `mem[pointer]++`  
`-` = `mem[pointer]--`  
`.` = `print(mem[pointer])`  
`,` = `mem[pointer] = read()`  


`^` = `goto mem[pointer]`  
`?` = `if (mem[pointer - 1] != mem2[pointer]) {goto mem[pointer - 1]}`  

These aren't neccessary, but definitely reduce code size.
`!` = `mem[pointer] = 0`  
`*` = `mem[pointer] += 5`  
`%` = `mem[pointer] += 50`  

This mini programming language is small enough  
to have a full interpreter on the OS. Programs and games
will be written or compiled to it and imported into the OS.

## How to use
On boot, the usable commands are:
```
pgrm - Open programming interface  
help - show possible commands  
a - Run sample program (hello world in CrypticASM)  
```
