; CrypticOS 512 byte demo

section .text
	welcome: db ">CrypticOS", 0
	done: db "Done.", 0
	invalid: db "Invalid command.", 0
	%include "pgrms.asm"

; Main bootloader jump label
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

		runCommand_done:
		mov esi, done
		call printStr
	jmp terminal
cli
hlt

%include "func/pgrm.asm"
%include "func/keyboard.asm"
%include "func/newline.asm"
%include "func/print.asm"

; Start one byte away from code. Either NASM ignores the
; errors this way, or it is an x86 thing.
section .bss:1
	buffer: resb 10 ; command line input buffer
	memtop: resb 50 ; pgrm memory
	membottom: resb 500 ; pgrm memory
