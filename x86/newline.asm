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
