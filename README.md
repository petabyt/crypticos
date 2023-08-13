### World's Smallest Operating System
CrypticOS is an operating system mostly written in a custom bytecode, which can be emulated anywhere.  

![](https://raw.githubusercontent.com/CrypticOS/CrypticOS.github.io/master/logo.png)

## Design
1. Any program should be loaded on any emulator, and run perfectly.
2. X86 bootable should be usable within **256 bytes**.
3. "Make it simple, and keep it simple"

## Huh??
- Yes, this is a hobby project, mainly for keeping me sane in 2020/2021 during the lockdowns.
- Yeah, it sucks. It's way worse than DOS and runs on an obscure BrainFuck clone.
- The custom bytecode has 16 commands. It's mostly BrainFuck, but with some extra things that make it easier
to write operating systems with (insane idea)
- That being said, I recommend you *don't* make another BrainFuck clone. You'd be better off making another *memory-safe general-purpose
systems programming language*, and rewrite every major piece of software in it.

## Goals
- [x] Write OS in <512 bytes  
- [x] Write simple programs for it
- [x] Write assembler that compiles to it (casm)  
- [x] Write operating environment in the assembler  
- [ ] Self host the assembler or make a C compiler  

## Building
### Install CASM assembler (for main test binary)
```
make b_casm
```
Note: Make sure you are in the `x86` directory.  
### Main test binary
```
sudo apt install qemu-system-x86 nasm
make b_x86
```
Try: `!%***.`  
Also try `!%` to load the edit app. Press ESC to exit.  

### 256 byte Version
Very basic. Type `!%***.` and enter to test it out.
```
cd x86 && make tiny
```

## So what does it do?
CrypticOS uses a BrainF* inspired esoteric language as its main runtime.  
It is different in many ways, mainly with logic and loops. In design it should  
have the simplicity of BrainF*, but be more usable, efficient, and Assembly-like.

You can see the full specification in standard/
