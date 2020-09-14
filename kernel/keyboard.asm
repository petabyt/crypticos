; Take input and put in input buffer
; edi = buffer
input:
	mov ah, 0x0E
	mov al, ':'
	int 0x10
	input_loop:
		; Read char
		mov ah, 0x0
		int 0x16

		cmp al, 13 ; compare with enter
		je input_done ; if key == enter, quit
		cmp al, 8 ; compare with backspace
		je input_backspace ; if key == backspace, quit

		; Write char, already in al
		mov ah, 0x0E
		int 0x10

		; Append read char to buffer
		mov [edi], al
		add edi, 1

		jmp input_loop ; else, repeat loop

	input_backspace:
		sub edi, 1 ; sub 1 char
		mov ah, 0x0E ; print backspace char
		int 0x10
	jmp input_loop

	input_done:
	mov byte [edi], 0 ; null terminator
	call nextLine
ret
