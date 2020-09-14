; mov si, welcome
; call printStr
printStr:
	mov ah, 0x0E ; print char bios
	printStr_loop:
		mov al, [si]
		inc si
		int 0x10
		cmp al, 0 ; check for null terminator
		jne printStr_loop ; if not equal, then loop
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
