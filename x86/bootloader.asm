; Main bootloader
bits 16
org 0x7c00

%define SIZE 8

mov ah, 2 ; Load sectors
mov al, SIZE ; Read 4 sectors
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

; 350 bytes for interpreter, the rest for programs
times (SIZE * 512) - ($ - $$) db 0
