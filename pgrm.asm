; The "pgrm" app
; This is a simple BrainFlake interpreter.
; ebx = read from
pgrm:
	; Store the memory
	mov si, memtop
	mov di, membottom

	pgrm_top:
		; Increment char
		mov al, [ebx]
		add ebx, 1

		; check for null terminator
		cmp al, 0
		je pgrm_done

		cmp al, '.'
			je pgrm_dot
		cmp al, '+'
			je pgrm_plus
		cmp al, '*'
			je pgrm_plus5
		cmp al, '%'
			je pgrm_plus50
		cmp al, '-'
			je pgrm_minus
		cmp al, '>'
			je pgrm_bottom_next
		cmp al, '<'
			je pgrm_bottom_back
		cmp al, 'd'
			je pgrm_top_next
		cmp al, 'a'
			je pgrm_top_back
		cmp al, '!'
			je pgrm_reset
		cmp al, '^'
			je pgrm_bottom_top
		cmp al, 'v'
			je pgrm_top_bottom
		cmp al, ','
			je pgrm_comma
		cmp al, '?'
			je pgrm_if
	; .
	pgrm_dot:
		mov al, [si]
		mov ah, 0x0E
		int 0x10
	jmp pgrm_top

	; +
	pgrm_plus:
		add byte [si], 1
	jmp pgrm_top

	; * (Not really needed, but makes reading code easier)
	pgrm_plus5:
		add byte [si], 5
	jmp pgrm_top

	; % (Same here)
	pgrm_plus50:
		add byte [si], 50
	jmp pgrm_top

	; -
	pgrm_minus:
		sub byte [si], 1
	jmp pgrm_top

	; >
	pgrm_bottom_next:
		add si, 1
	jmp pgrm_top

	; <
	pgrm_bottom_back:
		sub si, 1
	jmp pgrm_top

	; d
	pgrm_top_next:
		add di, 1
	jmp pgrm_top

	; a
	pgrm_top_back:
		sub di, 1
	jmp pgrm_top

	; ^
	pgrm_bottom_top:
		push ecx
		mov ecx, [si]
		mov [di], ecx
		pop ecx
	jmp pgrm_top

	; v
	pgrm_top_bottom:
		push ecx
		mov ecx, [di]
		mov [si], ecx
		pop ecx
	jmp pgrm_top

	; !
	pgrm_reset:
		mov byte [si], 0
	jmp pgrm_top

	; ?
	pgrm_if:
		cmp byte [si], 0 ; is value zero?
		je pgrm_top ; if zero, then resume parsing
		sub ebx, [di] ; If not zero, loop back
		sub ebx, 1
	jmp pgrm_top

	pgrm_comma:
		; get char
		mov ah, 0x0
		int 0x16

		; write char
		mov ah, 0x0E
		int 0x10
		mov [si], al
	jmp pgrm_top

	pgrm_done:
	call nextLine
ret
