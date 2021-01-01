; Main bootloader
bits 16
org 0x7c00

; Size of the OS, in sectors
%define SIZE 8

mov ah, 0x2 ; Load sector
mov al, SIZE ; Read x many sectors
mov ch, 0 ; Cylinder
mov cl, 2 ; High bits of cylinder
mov dh, 0 ; Head 0
mov bx, main ; Start label
int 0x13 ; Read sector
jmp init

times 510 - ($ - $$) db 0
dw 0xAA55

main:
bits 16


; CrypticOS 512 byte demo

section .text
	welcome: db ">CrypticOS", 0
	done: db "Done.", 0
	invalid: db "Invalid command.", 0

	; Include the pgrm.asm built on compilation
	%include "build/pgrms.asm"

; Main bootloader jump label
init:
	; Zero data segment register
	xor bx, bx
	mov ds, bx

	; Set up stack
	mov sp, 0x7e0
	mov ss, sp
	mov sp, 0xfffe

	mov si, welcome
	call printStr

	terminal:
		; Get input in buffer
		mov edi, buffer
		call input

		; Store first char
		mov esi, buffer
		mov al, [esi]

		; Check 'p' (pgrm mode)
		cmp al, 'p'
		je runCommand_pgrm

		; Check custom program
		cmp al, '>'
		je runCommand_preloaded

		; Else, invalid command
		mov esi, invalid
		call printStr
		jmp terminal

		runCommand_pgrm:
			; Get input
			mov edi, buffer
			call input
			mov ebx, buffer ; reset edi

			mov al, [ebx]
			cmp al, 'q'
			je runCommand_done

			call pgrm ; execute program
			jmp runCommand_pgrm ; back to prompt
			
		runCommand_preloaded:
			; Check second char
			add esi, 1
			mov al, [esi]

			cmp al, 'a'
			je runCommand_preloaded_a
			cmp al, 'b'
			je runCommand_preloaded_b
			cmp al, 'c'
			je runCommand_preloaded_c
			cmp al, 'd'
			je runCommand_preloaded_d
			cmp al, 'e'
			je runCommand_preloaded_e

			runCommand_preloaded_back:
			call pgrm
		jmp terminal

		runCommand_preloaded_a:
			mov ebx, pgrm_a
			jmp runCommand_preloaded_back

		runCommand_preloaded_c:
			mov ebx, pgrm_c
		jmp runCommand_preloaded_back

		runCommand_preloaded_b:
			mov ebx, pgrm_b
		jmp runCommand_preloaded_back

		runCommand_preloaded_d:
			mov ebx, pgrm_d
		jmp runCommand_preloaded_back
		
		runCommand_preloaded_e:
			mov ebx, pgrm_e
		jmp runCommand_preloaded_back

		runCommand_done:
		mov esi, done
		call printStr
	jmp terminal
cli
hlt

%include "pgrm.asm"
%include "keyboard.asm"
%include "newline.asm"
%include "print.asm"

; Start one byte away from code. Either NASM ignores the
; errors this way, or it is an x86 thing.
section .bss:1
	buffer: resb 100 ; command line input buffer
	memtop: resw 50 ; pgrm memory
	membottom: resw 500 ; pgrm memory

; 350 bytes for interpreter, the rest for programs
times (SIZE * 512) - ($ - $$) db 0
