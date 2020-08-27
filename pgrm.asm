; The "pgrm" app
; This is a simple BrainFlake interpreter.
; di = read from
pgrm:
	; Clear out stack memory
	mov si, mem
	mov eax, 0
	pgrm_clearmem:
		mov byte [si], 0
		cmp eax, MEM_SIZE
		add si, 1
		jne pgrm_clearmem
	sub si, MEM_SIZE

	mov eax, 0 ; char number
	mov ebx, 0 ; loop char

	mov ah, 0x0E ; print char bios signal
	pgrm_top:
		; Increment char
		mov al, [di]
		add di, 1

		; check for null terminator
		cmp al, 0
		je pgrm_done

		cmp al, '.'
		je pgrm_dot
		cmp al, '+'
		je pgrm_plus
		cmp al, '-'
		je pgrm_minus
		cmp al, '>'
		je pgrm_next
		cmp al, '<'
		je pgrm_back
		cmp al, '!'
		je pgrm_reset
		pgrm_donechar:
		add eax, 1
	jmp pgrm_top

	; '.' : Print
	pgrm_dot:
		mov al, [si]
		add al, 64 ; 65 == 'A', makes it easier to print messages
		mov ah, 0x0E
		int 0x10
	jmp pgrm_donechar

	pgrm_plus:
		add byte [si], 1
	jmp pgrm_donechar

	pgrm_minus:
		sub byte [si], 1
	jmp pgrm_donechar

	pgrm_next:
		add byte [si], 1
	jmp pgrm_donechar

	pgrm_back:
		sub byte [si], 1
	jmp pgrm_donechar

	pgrm_reset:
		mov byte [si], 0
	jmp pgrm_donechar

	pgrm_done:
	call nextLine
ret
