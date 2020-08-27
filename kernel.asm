; mov si, welcome
; call printStr
printStr:
	mov ah, 0x0E ; print char bios
	printStr_loop:
		lodsb ; mov al, [si] inc si
		int 0x10
		cmp al, 0 ; check for null terminator
		jne printStr_loop ; if not equal, then loop
	call nextLine
ret

; Take input and put in input buffer
; di = buffer
input:
	mov eax, 0
	input_loop:
		; Read char
		mov ah, 0x0
		int 0x16

		cmp al, 13 ; compare with backspace
		je input_done ; if key == backspace, quit
		cmp al, 8 ; compare with backspace
		je input_back ; if key == backspace, quit

		; Write char, already in al
		mov ah, 0x0E
		int 0x10

		; Append read char to buffer
		mov [di], al
		add di, 1

		jmp input_loop ; else, repeat loop

	input_back:
		sub di, 1
	jmp input_loop

	input_done:
	mov byte [di], 0 ; null terminator
	call nextLine
ret

; Next line and beginning of line
nextLine:
	; set to char print
	mov ah, 0x0E

	; newline
	mov al, 0xA
	int 0x10

	; beginning of row
	mov al, 0xD
	int 0x10
ret

; si = string 1
; di = string 2
; Out: eax = 0/1 (bool)
compareString:
	mov eax, 0 ; set false as default

	compareString_top:
		mov al, [si] ; buffer
		mov ah, [di] ; to check for

		cmp al, ah ; check if both chars are equal
		jne compareString_done ; if NOT equal, quit

		cmp ah, 0 ; else, check for null
		je compareString_correct ; if null, then we can
		; assume al is also null, and all matching is correct

		; Increment char
		add si, 1
		add di, 1

		jmp compareString_top

	; All chars match
	compareString_correct:
		mov eax, 1 ; set to true

	compareString_done:
ret
