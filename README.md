# CrypticOS
Tiny Programmable Bootsector OS written in x86 Assembly

## Design
Design: It should not depend too much on CPU architecture. It also should be  
smaller than 512 bytes, and not have to squeeze out bytes in order to implement  
functionality.  

## Applications
CrypticOS has an extended version of BrainF* called CrypticFrick.  
The following is an instruction set:  
\> = +1 pointer  
\< = -1 pointer  
\+ = +1 value  
\- = -1 value  
\. = print  
\, = read  
[] = while
\! = Reset value to zero  
\*Note: ASCII starts at `'A'`, so `+.++.` will produce: `AB`.  

## How to use
On boot, the usable commands are:
```
pgrm - Open programming interface  
help - show possible commands  
a - Run sample program (hello world in CrypticFrick)  
```
