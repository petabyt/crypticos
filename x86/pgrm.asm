; Simple implementation of CrypticASM. Stack isn't used much, just
; fast registers.

; eax = for chars
; ecx = char number
; edx = none
; ebx = read from
; edi = memtop
; esi = membottom

; ebx = read from
pgrm:
	; Store the memory
	mov edi, memtop
	mov esi, membottom

	mov ecx, 0 ; ecx will store char num

	pgrm_top:
		; Increment char
		mov al, [ebx + ecx]
		inc ecx ; increment char

		; check for null terminator
		or al, al
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
		mov al, [esi]
		mov [edi], al
	jmp pgrm_top

	; v
	pgrm_top_bottom:
		mov al, [edi]
		mov [esi], al
	jmp pgrm_top

	; !
	pgrm_reset:
		mov byte [esi], 0
	jmp pgrm_top

	; ?
	pgrm_if:
		mov dl, [edi + 1] ; store in dl (first of edx)
		mov dh, [edi + 2] ; store in dh (second of edx)
		cmp dh, dl ; compare both values
		jne pgrm_top ; if equal, do loop

	pgrm_doLoop:
		mov ecx, 0 ; reset char reading pointer
		mov dl, [edi] ; dl will hold desired goto label, will decrease to 0.
		pgrm_doLoop_top:
			; Set char (ebx), then go back
			mov al, [ebx + ecx]

			; Increment char
			inc ecx

			cmp al, '|' ; reached a label?
			jne pgrm_doLoop_top ; if not, keep searching
			dec dl ; decrease labels found
			or dl, dl
			jne pgrm_doLoop_top ; if not, keep searching
		; else loop is done
	jmp pgrm_top

	pgrm_sys:
		push ecx
		push edx

		; Set registers needed for interrupt
		mov ah, [esi]
		mov al, [esi + 1]
		mov ch, [esi + 2]
		mov cl, [esi + 3]
		mov dh, [esi + 4]
		mov dl, [esi + 5]
		int 0x10

		pop edx
		pop ecx
	jmp pgrm_top

	pgrm_comma:
		mov ah, 0x0
		int 0x16
		mov [esi], al
	jmp pgrm_top

	pgrm_done:
	call nextLine
ret
