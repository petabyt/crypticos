# CrypticOS
Tiny Programmable Bootsector OS written in x86 Assembly.

## Design
Design: It should not depend too much on CPU architecture. It also must be 
smaller 512 bytes, and not have to squeeze out bytes in order to implement   
basic functionality.  

## Applications
CrypticOS has an Assembly-like version of BrainF* called CrypticASM.  
The following is an instruction set:  
`>` = `pointer++`  
`<` = `pointer--`  
`+` = `mem[pointer]++`  
`-` = `mem[pointer]--`  
`.` = `print(mem[pointer])`  
`,` = `mem[pointer] = read()`  
`^` = `goto mem[pointer]`  
`?` = `if (mem[pointer - 1] != 0) {goto mem[pointer]}`  
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
