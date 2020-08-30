bits 16
org 0x7c00

start:                     ;tell linker entry point
    mov eax, a
	mov byte [eax], 'B'
	add eax, 1
	mov byte [eax], 'A'
	sub eax, 1
	mov al, [eax]
	mov ah, 0x0E
	int 0x10
	hlt

times 510 - ($ - $$) db 0
dw 0xAA55

section	.bss
    a resb 10
