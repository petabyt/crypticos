
; Simple implementation of CrypticASM. Stack or reserved mem 
; isn't used much, just registers.

; What each register is used for:
; eax = for chars
; ecx = char number
; edx = none
; ebx = read from
; edi = memtop
; esi = membottom

; Note that each cell is 16 bit, not 8 bit. So we must increase
; by 2 bytes instead of 1. 
pgrm:
	; Store the memory
	mov edi, memtop
	mov esi, membottom

	mov ecx, 0 ; ecx will store char num

	pgrm_top:
		; Increment char
		mov al, [ebx + ecx]
		inc ecx ; increment char

		or al, al ; Is al zero (null terminator)?
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
		cmp al, '@'
			je pgrm_sys
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
		add word [esi], 1
	jmp pgrm_top

	; *
	pgrm_plus5:
		add word [esi], 5
	jmp pgrm_top

	; %
	pgrm_plus50:
		add word [esi], 50
	jmp pgrm_top

	; -
	pgrm_minus:
		sub word [esi], 1
	jmp pgrm_top

	; >
	pgrm_bottom_next:
		add esi, 2
		;inc esi
	jmp pgrm_top

	; <
	pgrm_bottom_back:
		sub esi, 2
		;dec esi
	jmp pgrm_top

	; d
	pgrm_top_next:
		add edi, 2
	jmp pgrm_top

	; a
	pgrm_top_back:
		sub edi, 2
	jmp pgrm_top

	; ^
	pgrm_bottom_top:
		xor ax, ax
		mov ax, [esi]
		mov [edi], ax
	jmp pgrm_top

	; v
	pgrm_top_bottom:
		xor ax, ax
		mov ax, [edi]
		mov [esi], ax
	jmp pgrm_top

	; !
	pgrm_reset:
		mov word [esi], 0
	jmp pgrm_top

	; ?
	pgrm_if:
		mov dx, [edi + 2] ; store in dl (first of edx)
		mov ax, [edi + 4] ; store in dh (second of edx)
		cmp ax, dx ; compare both values
		jne pgrm_top ; if equal, do loop

	pgrm_doLoop:
		mov ecx, 0 ; reset char reading pointer
		mov dx, [edi] ; dl will hold desired goto label, will decrease to 0.
		add dx, 1 ; December 2020 CISN revision
		pgrm_doLoop_top:
			; Set char (ebx), then go back
			mov al, [ebx + ecx]

			; Increment char
			inc ecx

			cmp al, '|' ; reached a label?
			jne pgrm_doLoop_top ; if not, keep searching
			dec dx ; decrease labels found
			or dx, dx
			jne pgrm_doLoop_top ; if not, keep searching
		; else loop is done
	jmp pgrm_top

	pgrm_sys:
		push ecx
		push edx
		push ebx

		; Set registers needed for interrupt
		mov ah, [esi]
		mov al, [esi + 2]
		mov ch, [esi + 4]
		mov cl, [esi + 6]
		mov dh, [esi + 8]
		mov dl, [esi + 10]
		mov bh, [esi + 12]
		mov bl, [esi + 14]
		int 0x10 ; Main interupt

		pop ebx
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
