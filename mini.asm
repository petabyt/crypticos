; Bare bones to load program, run, and that's it.

bits 16
org 0x7c00

init:
	mov ebx, load
	call pgrm
	cli
	hlt

%include "kernel/newline.asm"
%include "pgrm.asm"

load: db ".", 0

times 510 - ($ - $$) db 0
dw 0xAA55

section .bss
	memtop resb 50 ; pgrm memory
	membottom resb 500 ; pgrm memory
