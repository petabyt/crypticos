; Main CrypticOS 16 bit Bootable
; HOW TO USE:
; Type in any CINS code, and it will run.
; To execute the second sector program, run:
; !%



; Register usage:
; eax temp
; ebx memrun_top
; ecx membottom
; edx reserved for drive number
; esi
; edi current char

bits 16
org 0x7c00

%define SECTORS 6

; Zero out the data segment register
xor bx, bx
mov ds, bx

start:
	mov esi, welcome
	call printString

	prompt:
		; print terminal char,
		; (ah always kept from printString or printNewline)
		mov al, ':'
		int 0x10

		mov esi, buffer
		prompt_top:
			; Read keyboard (0)
			xor ah, ah
			int 0x16

			; Write char, already in al
			mov ah, 0x0E
			int 0x10

			cmp al, 13 ; compare with enter
			je input_done ; if enter, quit
			cmp al, 8 ; compare with backspace
			je input_backspace ; if backspace, quit

			; Append read char to buffer
			mov [esi], al
			inc esi
		jmp prompt_top ; else, repeat loop

		input_backspace:
			dec esi ; sub 1 char
		jmp prompt_top
		
		input_done:
		mov byte [esi], 0
		call printNewline
	; end of getting input
	

	; Run buffer input and go back
	mov esi, buffer
	call run
	prompt_done:

	; The program can return a value to the
	; operating system via the current bottom
	; cell. System calls start at 50+.

	; Load sector program (!%)
	cmp byte [ecx], 50
	je prompt_load
	
	call printNewline
jmp prompt


; Read second sector data
prompt_load:
	mov ah, 0x2 ; Load sector call
	mov al, 6 ; How many sectors to read
	xor ch, ch ; Cylinder zero
	mov cl, 2 ; Second sector
	xor dh, dh ; Head 0
	mov bx, copy
	int 0x13 ; Read sector
	mov esi, copy
; will go to run


; Main emulate "function". Takes esi as code
; address
run:
	mov ebx, memtop
	mov ecx, membottom
	xor edi, edi ; 0 current char
	run_top:
		mov al, [esi + edi]
		inc edi ; increment to next
		
		cmp al, 0 ; is char null terminator?
		je prompt_done ; then goto end if 0
		
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
		cmp al, ','
		je run_comma
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
		mov dx, [ebx + 2]
		mov ax, [ebx + 4]
		cmp ax, dx ; compare both values
		jne run_top ; if equal, do, run_loop

	run_loop:
		xor edi, edi ; reset char reading pointer
		mov dx, [ebx] ; DX holds goto label.
		inc dx ; labels start at zero
		run_loop_top:
			; Set char (ebx), then go back
			mov al, [copy + edi]
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
		add ecx, 2
	jmp run_top

	run_bracket_left:
		sub ecx, 2
	jmp run_top

	run_a:
		sub ebx, 2
	jmp run_top

	run_d:
		add ebx, 2
	jmp run_top

	run_up:
		mov ax, [ecx]
		mov [ebx], ax
	jmp run_top

	run_v:
		mov ax, [ebx]
		mov [ecx], ax
	jmp run_top


	; Reset
	run_mark:
		mov word [ecx], 0
	jmp run_top


	; add/sub
	run_percent:
		mov ax, 50
	jmp run_addSomething

	run_asterisk:
		mov ax, 5
	jmp run_addSomething

	run_plus:
		mov ax, 1
	jmp run_addSomething

	run_minus:
		mov ax, -1

	run_addSomething:
		add word [ecx], ax
	jmp run_top


	; Input/Output
	run_dot:
		cmp word [ebx], 50
		je run_setVideo
		cmp word [ebx], 51
		je run_setPixel

		; Else, just print the character
		mov al, [ecx]
		mov ah, 0x0E
		int 0x10
	jmp run_top

	run_comma:
		xor ah, ah ; 0x0
		int 0x16
		mov [ecx], al
	jmp run_top

	run_setVideo:
		; note: 2 = default, 19 = 13h
		xor ah, ah ; ah = 0x0
		mov al, [ebx + 2] ; mode
		int 0x10
	jmp run_top

	run_setPixel:
		mov ax, 0xA000
		mov es, ax
		mov bp, [ebx + 2] ; base stack reg for offset/location
		mov ax, [ebx + 4] ; ax for color
		mov word [es:bp], ax
	jmp run_top
; End of run

; Print a string. esi = location
printString:
	mov ah, 0x0E ; print char bios
	printString_loop:
		lodsb ; mov al, [si], inc si
		int 0x10 ; print it
		or al, al ; is al zero?
	jne printString_loop ; if not equal, then loop
	call printNewline
ret

printNewline:
	mov ah, 0x0E ; print char bios
	mov al, 10 ; newline
	int 0x10
	add al, 3 ; carriage return
	int 0x10
ret

; OS Text stored here:
welcome: db ">CrypticOS", 0

times 510 - ($ - $$) db 0
dw 0xAA55

; Second sector contains
; demo program
copy:
%include "build.asm"
times 512 + (512 * SECTORS) - ($ - $$) db 0

; Program reserved memory here
section .bss
	memtop: resb 500
	membottom: resb 2000
	buffer: resb 100
