; CrypticOS Bootsector
; Includes command line and extended BrainFlake interpreter

bits 16
org 0x7c00

; Start main os
init:
	mov si, welcome
	call printStr
	terminal:
		; Get input in buffer
		mov di, buffer
		call input

		call runCommand
	jmp terminal

; Execute command via the input buffer
runCommand:
	mov si, buffer
	mov al, [si]

	; Check "pgrm"
	cmp al, 'p'
	je runCommand_pgrm

	; Check custom program
	cmp al, 'a'
	je runCommand_pgrmA

	; Else, invalid command (or done)
	mov si, invalid
	call printStr
	ret

	runCommand_pgrm:
		; Get input
		mov di, buffer
		call input
		mov ebx, buffer ; reset di

		mov al, [ebx]
		cmp al, 'q'
		je runCommand_done

		call pgrm ; execute program
		jmp runCommand_pgrm ; back to prompt

	runCommand_pgrmA:
		mov ebx, pgrm_a
		call pgrm
		ret

	runCommand_done:
	mov si, done
	call printStr
ret

%include "pgrm.asm"
%include "kernel/keyboard.asm"
%include "kernel/print.asm"

welcome db ">CrypticOS v0.3", 0
done db "Done", 0
invalid db "Invalid cmd", 0
cmd_help db "help", 0
cmd_pgrm db "pgrm", 0
pgrm_a db "!%********+>!%********+++>|<<.>><.>d^a+^dva$", 0

times 510 - ($ - $$) db 0
dw 0xAA55

section .bss
	buffer resb 50 ; command line input buffer
	memtop resb 10 ; pgrm memory
	membottom resb 100 ; pgrm memory
