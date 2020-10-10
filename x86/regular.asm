; CrypticOS 512 byte demo

bits 16
org 0x7c00

; Start main os
init:
	mov si, welcome
	call printStr

	terminal:
		; Get input
		mov edi, buffer
		call input
		mov ebx, buffer ; reset edi

		call pgrm ; execute program
	jmp terminal ; back to prompt
cli
hlt

%include "pgrm.asm"
%include "kernel/keyboard.asm"
%include "kernel/newline.asm"
%include "kernel/print.asm"

welcome: db ">CrypticOS", 0

times 510 - ($ - $$) db 0
dw 0xAA55

section .bss
	buffer resb 1000 ; command line input buffer
	memtop resb 50 ; pgrm memory
	membottom resb 500 ; pgrm memory
