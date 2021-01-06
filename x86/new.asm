bits 16
org 0x7c00

mov ah, 0x2 ; Load sector call
mov al, 1 ; Read x many sectors
mov ch, 0 ; Cylinder
mov cl, 2 ; Second sector
mov dh, 0 ; Head 0
mov bx, foo
int 0x13 ; Read sector

mov al, [foo]
mov ah, 0x0E
int 0x10

times 510 - ($ - $$) db 0
dw 0xAA55

times 512 db 'A'

section .bss
	foo resb 512
