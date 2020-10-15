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
