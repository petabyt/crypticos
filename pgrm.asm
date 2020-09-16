; Simple implementation of CrypticASM. Actual memory isn't used
; that much, mostly just registers.

; ebx = read from
pgrm:
	; Store the memory
	mov edi, memtop
	mov esi, membottom

	mov ecx, 0 ; ecx will store char num

	pgrm_top:
		; Increment char
		add ebx, ecx ; move to char
		mov al, [ebx]
		sub ebx, ecx ; move back
		add ecx, 1 ; increment char

		; check for null terminator
		cmp al, 0
		je pgrm_done

		; Instruction tester
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
		cmp al, '$'
			je pgrm_doLoop
	jmp pgrm_top

	; .
	pgrm_dot:
		mov al, [esi]
		mov ah, 0x0E
		int 0x10
	jmp pgrm_top

	; +
	pgrm_plus:
		add byte [esi], 1
	jmp pgrm_top

	; *
	pgrm_plus5:
		add byte [esi], 5
	jmp pgrm_top

	; %
	pgrm_plus50:
		add byte [esi], 50
	jmp pgrm_top

	; -
	pgrm_minus:
		sub byte [esi], 1
	jmp pgrm_top

	; >
	pgrm_bottom_next:
		inc esi
	jmp pgrm_top

	; <
	pgrm_bottom_back:
		dec esi
	jmp pgrm_top

	; d
	pgrm_top_next:
		inc edi
	jmp pgrm_top

	; a
	pgrm_top_back:
		dec edi
	jmp pgrm_top

	; ^
	pgrm_bottom_top:
		push ecx
		mov al, [esi]
		mov [edi], al
		pop ecx
	jmp pgrm_top

	; v
	pgrm_top_bottom:
		push ecx
		mov ecx, [edi]
		mov [esi], ecx
		pop ecx
	jmp pgrm_top

	; !
	pgrm_reset:
		mov byte [esi], 0
	jmp pgrm_top

	; ?
	pgrm_if:
		inc edi ; move to first value
		mov dl, [edi] ; store in dl (first of edx)
		inc edi ; move to second value
		mov dh, [edi] ; store in dh (second of edx)
		sub edi, 2 ; go back to label
		cmp dh, dl ; compare both values
		je pgrm_doLoop ; if equal, do loop
	jmp pgrm_top

	pgrm_doLoop:
		mov ecx, 0 ; reset char reading pointer
		mov dl, [edi] ; dl will hold desired goto label, will decrease to 0.
		pgrm_doLoop_top:
			; Set char (ebx), then go back
			add ebx, ecx
			mov al, [ebx]
			sub ebx, ecx

			; Increment char
			add ecx, 1

			cmp al, '|' ; reached a label?
			jne pgrm_doLoop_top ; if not, keep searching
			sub dl, 1 ; decrease labels found
			cmp dl, 0 ; is dl to zero yet?
			jne pgrm_doLoop_top ; if not, keep searching
		; else loop is done
	jmp pgrm_top

	pgrm_comma:
		; get char
		mov ah, 0x0
		int 0x16

		; write char
		mov ah, 0x0E
		int 0x10
		mov [esi], al
	jmp pgrm_top

	pgrm_done:
	call nextLine
ret
