bits 16
org 0x7c00

%define MEM_SIZE 100

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

	cli
hlt

; Execute command via the input buffer
runCommand:
	; Compare inputs

	; Check "help"
	mov di, cmd_help
	call runCommand_compare
	je runCommand_help

	; Check "pgrm"
	mov di, cmd_pgrm
	call runCommand_compare
	je runCommand_pgrm

	; Check custom program
	mov si, buffer
	mov al, [si]
	cmp al, 'a'
	je runCommand_pgrmA

	; Else, invalid command (or done)
	jmp runCommand_invalid

	runCommand_help:
		mov si, help
		call printStr
		ret ; exit runCommand

	runCommand_pgrm:
		; Get input
		mov di, buffer
		call input
		mov di, buffer ; reset di

		mov al, [di]
		cmp al, 'q'
		je runCommand_done

		call pgrm ; execute program
		jmp runCommand_pgrm ; back to prompt

	runCommand_pgrmA:
		mov di, pgrm_a
		call pgrm
		ret

	; Prep for comparing strings (movs n stuff)
	runCommand_compare:
		mov si, buffer
		call compareString
		cmp eax, 1
	ret

	runCommand_invalid:
	mov si, invalid
	call printStr
	ret
	runCommand_done:
	mov si, done
	call printStr
ret

%include "pgrm.asm"
%include "kernel.asm"

welcome db "[-] CrypticOS v0.3 [-]", 0
help db "pgrm, help, a", 0
done db "Done", 0
invalid db "Invalid command", 0
cmd_help db "help", 0
cmd_pgrm db "pgrm", 0
pgrm_a db "++[>++++++++.!+++++.!++++++++++++..!+++++++++++++++.!<-]", 0

times 510 - ($ - $$) db 0
dw 0xAA55

section .bss
	buffer resb 100 ; command line input buffer
	mem resb MEM_SIZE ; pgrm stack
