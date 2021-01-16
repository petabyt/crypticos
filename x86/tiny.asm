; Standalone Minimal 256 byte OS

bits 16
org 0x7c00

os_top:
	mov edi, buffer
	input_loop:
		; Read char
		mov ah, 0x0
		int 0x16

		cmp al, 13 ; compare with enter
		je input_done ; if key == enter, quit

		; Write char, already in al
		mov ah, 0x0E
		int 0x10

		; Append read char to buffer
		mov [edi], al
		inc edi

		jmp input_loop ; else, repeat loop
	input_done:
		mov byte [edi], 0 ; null terminator

		; Print newline
		mov ah, 0x0E
		mov al, 0xA
		int 0x10
		mov al, 0xD
		int 0x10

		; Prepare to interpret
		mov edi, memtop
		mov esi, membottom
		xor ecx, ecx
		mov ebx, buffer

; Execute program
pgrm_top:
	; Store char
	mov al, [ebx + ecx]
	inc ecx ; increment char

	; check for null terminator
	or al, al
	je os_top

	; Instruction tester
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
	cmp al, '!'
		je pgrm_reset

	; Else, print char.
	mov al, [esi]
	mov ah, 0x0E
	int 0x10
jmp pgrm_top

; +
pgrm_plus:
	inc byte [esi]
jmp pgrm_top

; -
pgrm_minus:
	dec byte [esi]
jmp pgrm_top

; *
pgrm_plus5:
	add byte [esi], 5
jmp pgrm_top

; %
pgrm_plus50:
	add byte [esi], 50
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
	mov al, [esi] ; works? mov al, [esi]
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
	jne pgrm_top ; not equal, return. Else, doLoop is below.

pgrm_doLoop:
	xor ecx, ecx ; reset char reading pointer
	mov dl, [edi] ; dl will hold desired goto label, will decrease to 0.
	inc dl ; dec 2020 revision
	pgrm_doLoop_top:
		; Set char (ebx), then go back
		mov al, [ebx + ecx]

		; Increment char
		inc ecx

		cmp al, '|' ; reached a label?
		jne pgrm_doLoop_top ; if not, keep searching
		dec dl ; decrease labels found
		or dl, dl ; is dl to zero yet? CMP DL, DL
		jne pgrm_doLoop_top ; if not, keep searching
	; else loop is done
jmp pgrm_top

pgrm_comma:
	mov ah, 0x0
	int 0x16
	mov [esi], al
jmp pgrm_top

times 510 - ($ - $$) db 0
dw 0xAA55

section .bss
	buffer resb 100 ; input buffer
	memtop resb 100 ; pgrm memory
	membottom resb 1000 ; pgrm memory
