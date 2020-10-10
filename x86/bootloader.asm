; Main bootloader
bits 16
org 0x7c00

mov ah, 2 ; Load sectors
mov al, 1 ; Read 1 sector
mov ch, 0 ; Cylinder
mov cl, 2 ; Where to start
mov dh, 0 ; Head 0
mov bx, main ; Start label
int 19 ; Read sector
jmp init

times 510 - ($ - $$) db 0
dw 0xAA55

main:
bits 16

; Load regular
%include "main.asm"

times 5000 - ($ - $$) db 0
;dw 0AA55h
