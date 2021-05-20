; Standalone Minimal 8 bit OS
; MUST be under 256 bytes

; (sometime in 2020)				242 bytes
; May 19 2021 (made user friendly)	253 bytes

bits 16
org 0x7c00

os_top:
	call newline
	add al, 3
	int 0x10
		
	mov edi, buffer
	input_loop:
		; Read char
		mov ah, 0x0
		int 0x16

		; Write char, already in al
		mov ah, 0x0E
		int 0x10

		cmp al, 13 ; compare with enter
		je input_done ; if key == enter, quit

		; Append read char to buffer
		mov [edi], al
		inc edi

		jmp input_loop ; else, repeat loop
	input_done:
		mov byte [edi], 0 ; null terminator

		; Print newline, carriage return already
		; printed by user, when enter pressed
		call newline

		; Prepare to interpret
		mov ebx, memtop
		mov ecx, membottom
		mov esi, buffer
		xor edi, edi ; current char
; end of input

run_top:
	mov al, [esi + edi]
	
	inc edi ; increment to next
	
	or al, al ; is char null terminator?
	je os_top ; then goto end if 0
	
	cmp al, '*'
	je run_asterisk
	cmp al, '%'
	je run_percent
	cmp al, '+'
	je run_plus
	cmp al, '-'
	je run_minus
	cmp al, '!'
	je run_mark
	cmp al, '.'
	je run_dot
	cmp al, '>'
	je run_bracket_right
	cmp al, '<'
	je run_bracket_left
	cmp al, 'a'
	je run_a
	cmp al, 'd'
	je run_d
	cmp al, '^'
	je run_up
	cmp al, 'v'
	je run_v
	cmp al, '$'
	je run_loop
	cmp al, '?'
	je run_if
jmp run_top


; Jump/logic instructions
run_if:
	mov dx, [ebx + 1]
	mov ax, [ebx + 2]
	cmp ax, dx ; compare both values
	jne run_top ; if equal, do, run_loop

run_loop:
	xor edi, edi ; reset char reading pointer
	mov dx, [ebx] ; DX holds goto label.
	inc dx ; labels start at zero
	run_loop_top:
		; Set char (ebx), then go back
		mov al, [esi + edi]
		inc edi ; Increment char

		cmp al, '|' ; reached a label?
		jne run_loop_top ; if not, keep searching
		or dx, dx ; is dx zero?
		dec dx ; decrease labels found
		jne run_loop_top ; if not, keep searching
	; else, loop is done
jmp run_top


; Memory instructions
run_bracket_right:
	inc ecx
jmp run_top

run_bracket_left:
	dec ecx
jmp run_top

run_a:
	dec ebx
jmp run_top

run_d:
	inc ebx
jmp run_top

run_up:
	mov al, [ecx]
	mov [ebx], al
jmp run_top

run_v:
	mov al, [ebx]
	mov [ecx], al
jmp run_top


; Reset
run_mark:
	mov byte [ecx], 0
jmp run_top


; add/sub
run_percent:
	mov al, 50
jmp run_addSomething

run_asterisk:
	mov al, 5
jmp run_addSomething

run_plus:
	mov al, 1
jmp run_addSomething

run_minus:
	mov al, -1

run_addSomething:
	add [ecx], al
jmp run_top

; print a 10 newline, carriage return
; must be printed after or before this call
newline:
	mov ah, 0x0E
	mov al, 10
	int 0x10
ret

; Input/Output
run_dot:
	mov ah, 0x0E
	mov al, [ecx]
	int 0x10
jmp run_top

%ifndef SIZE
	times 510 - ($ - $$) db 0
	dw 0xAA55
%endif

section .bss
	buffer: resb 100 ; input buffer
	memtop: resb 100 ; pgrm memory
	membottom: resb 1000 ; pgrm memory
