%define CHAR_START 0

; The "pgrm" app
; This is a simple BrainFlake interpreter.
; ebx = read from
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

	mov edx, 0 ; edx will store loop last char

	mov ah, 0x0E ; print char bios signal
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
		je pgrm_next
		cmp al, '<'
		je pgrm_back
		cmp al, '!'
		je pgrm_reset
		cmp al, '['
		je pgrm_start
		cmp al, ']'
		je pgrm_end
		cmp al, ','
		je pgrm_comma
		pgrm_donechar:
		add edx, 1
	jmp pgrm_top

	; .
	pgrm_dot:
		mov al, [si]
		add al, CHAR_START ; 65 == 'A', makes it easier to print messages
		mov ah, 0x0E
		int 0x10
	jmp pgrm_donechar

	; +
	pgrm_plus:
		add byte [si], 1
	jmp pgrm_donechar

	; *
	pgrm_plus5:
		add byte [si], 5
	jmp pgrm_donechar

	; %
	pgrm_plus50:
		add byte [si], 50
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
	 	mov edx, 1 ; offset as
	jmp pgrm_donechar

	; ]
	pgrm_end:
		cmp byte [si], 0 ; is value zero?
		je pgrm_donechar ; if zero, then resume parsing. If not zero, loop back
		sub ebx, edx
	jmp pgrm_donechar

	pgrm_comma:
		; get char
		mov ah, 0x0
		int 0x16

		; write char
		mov ah, 0x0E
		int 0x10
		sub al, CHAR_START
		mov [si], al
	jmp pgrm_donechar

	pgrm_done:
	call nextLine
ret

; Spahgetti crap code to print a register
; a:
; 	mov al, 'A'
; 	mov ah, 0x0E
; 	int 0x10
; dec edx
; cmp edx, 0
; jne a
