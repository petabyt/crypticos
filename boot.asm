; CrypticOS Bootable prompt
; Includes demo program, somewhat
; decent user interface, and an IDLE.

bits 16
org 0x7c00

; Start main os
init:
	mov si, welcome
	call printStr
	terminal:
		; Get input in buffer
		mov edi, buffer
		call input

		; Store first char
		mov esi, buffer
		mov al, [esi]

		; Check 'p' (pgrm)
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
			add esi, 1
			mov al, [esi]
			cmp al, 'a'
			je runCommand_preloaded_a
			ret

		runCommand_preloaded_a:
			mov ebx, pgrm_a
			call pgrm

		runCommand_done:
		mov esi, done
		call printStr
	jmp terminal
	cli
	hlt

%include "pgrm.asm"
%include "kernel/keyboard.asm"
%include "kernel/print.asm"

welcome: db ">CrypticOS v0.3", 0
done: db "Done", 0
invalid: db "Invalid cmd", 0
pgrm_a: db "!%%*-.+.", 0

times 510 - ($ - $$) db 0
dw 0xAA55

section .bss
	buffer resb 1000 ; command line input buffer
	memtop resb 10 ; pgrm memory
	membottom resb 100 ; pgrm memory
