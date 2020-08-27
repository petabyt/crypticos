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

	mov dl, 0 ; char number
	mov dh, 0 ; loop char

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
		cmp al, '['
		je pgrm_start
		cmp al, ']'
		je pgrm_end
		pgrm_donechar:
		add dl, 1
	jmp pgrm_top

	; .
	pgrm_dot:
		mov al, [si]
		add al, 64 ; 65 == 'A', makes it easier to print messages
		mov ah, 0x0E
		int 0x10
	jmp pgrm_donechar

	; +
	pgrm_plus:
		add byte [si], 1
	jmp pgrm_donechar

	; -
	pgrm_minus:
		sub byte [si], 1
	jmp pgrm_donechar

	; >
	pgrm_next:
		add si, 1
	jmp pgrm_donechar

	; <
	pgrm_back:
		sub si, 1
	jmp pgrm_donechar

	; !
	pgrm_reset:
		mov byte [si], 0
	jmp pgrm_donechar

	; [
	pgrm_start:
		push di ; push current char onto stack
	jmp pgrm_donechar

	; ]
	pgrm_end:
		cmp byte [si], 0 ; is value zero?
		jne pgrm_loopquit ; if zero, then resume parsing. If not zero, loop back
	jmp pgrm_donechar

	pgrm_loopquit:
		pop di
	jmp pgrm_donechar

	pgrm_done:
	call nextLine
ret
