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
		inc si
		inc di

		jmp compareString_top

	; All chars match
	compareString_correct:
		mov eax, 1 ; set to true

	compareString_done:
ret
