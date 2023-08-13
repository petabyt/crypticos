# CASM
The official language for CrypticOS.  
Try out the HTML/CSS/JS demo: https://github.com/CrypticOS/playground  
Read the CrypticOS bytecode specification: https://github.com/CrypticOS/cins  

## Building
```
# Needs C99 compiler
make
```

## Syntax
CASM is based on a stripped down version of the NASM Syntax.  
```
; Infinite loop
var a 'A'
top:
prt a
prt "Hello, World."
jmp top

; In order to compare two values/variables:
var a 'A'
equ a 'B' mylbl ; this will not jump
mylbl:

; These instructions are fairly straightforward.
sub a 1
add a 1
add a '0'
set a 'Z'
```

## Instructions
| Instruction | Arguments | Note |
|--|--|--|
| `jmp` | [label] |
| `got` | [int/variable] | Moves the bottom pointer to a variable/number. WKSP can be used to go to the workspace cell. |
| `ret` | | Returns from `run` instruction |
| `inl` | [string] | Paste any text in output |
| `prt` | [string/int/char/variable] |
| `equ` | [first value (string/int/char/variable)] [second value] [label to jump to] |
| `set` | [variable name] [value] |
| `var` | [variable name] [value] |
| `arr` | [array name] [length] [initializing value (optional)] |
| `add` | [variable name] [char/int] |
| `sub` | [variable name] [char/int] |
| `run` | [label name] | Runs a label like a function. Must use ret to go back. |
| `inc` | [file name, string] | Include another CASM file, basically a copy/paste. |
| `fre` | [variable name] | Free a variable. Can be used in functions. |

Etc:
- WKSP is a built-in variable. It points to the bottom memory cell  
directly after the last variable defined.


## Preprocessor
Similar to C's preprocessor, but `#end` instead of `#endif`.  
Not implemented in web editor.  
```
#define FOO 'Z'
#ifdef FOO
	prt "Foo is defined\n"
	prt FOO
#ifndef FOO
	prt "Foo is defined\n"
	prt FOO
#end
```
