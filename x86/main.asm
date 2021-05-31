; Main CrypticOS 16 bit Bootable
; Type in any CINS code, and it will run.

; To execute the second sector program A, leave 50
; in bottom pointer: `!%`
; You can run program B with 51 (!%+) too.

; Register usage map:
; eax temp
; ebx memtop
; ecx membottom
; esi load location
; edi current char


; Compile Config

; Allow CrypticOS CINS extension for
; graphics, cursor movement
%define SYSCALLS

; Remove paramter from membottom to
; prevent random recursion/crashes
;%define RESETPARAM

; No shift keypresses (ergonomical and stuff)
; eg (1 for !, 5 for %)
%define NOSHIFT

; Include arrow and other special
; char support (+7 bytes)
; Keys:
;  14 up
;  22 down
;  17 left
;  19 right
%define ARROWS

; ',' char printing feedback
;%define INPUTFEEDBACK

; Max sectors to load in (5.1k)
; anything else is leftover memory
%define SECTORS 12

; Save 4 bytes by not zeroing out data
; segment register. Text won't work on
; real hardware.
%define ZEROOUT


bits 16
org 0x7c00

%ifdef ZEROOUT
	; Zero out the data segment register
	xor bx, bx
	mov ds, bx
%endif

start:
	mov ah, 0x2 ; Load sector call
	mov al, SECTORS ; How many sectors to read
	xor ch, ch ; Cylinder zero
	mov cl, 2 ; Second sector
	xor dh, dh ; Head 0
	mov bx, afterProgram
	int 0x13 ; Read sector

	; Load memory pointers first so that it
	; isn't reset on every run
	mov ebx, memtop
	mov ecx, membottom
	
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
			xor ah, ah ; ah = 0x0
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

	; DemoA (!%)
	cmp byte [ecx], 50
	mov esi, demoA
	je run

	; DemoB (!%+)
	cmp byte [ecx], 51
	mov esi, demoB
	je run
	
	call printNewline
jmp prompt


; Main emulate "function", Takes esi
; as code address
run:
	%ifdef RESETPARAM
		mov word [ecx], 0
	%endif
	
	xor edi, edi ; 0 current char
	run_top:
		mov al, [esi + edi]
		inc edi ; increment to next
		
		cmp al, 0 ; is char null terminator?
		je prompt_done ; then goto

		cmp al, '-'
		je run_minus
		cmp al, '.'
		je run_dot
		cmp al, ','
		je run_comma
		cmp al, 'v'
		je run_v
		cmp al, 'a'
		je run_a
		cmp al, 'd'
		je run_d
		cmp al, '>'
		je run_bracket_right
		cmp al, '<'
		je run_bracket_left

		%ifdef NOSHIFT
			cmp al, '6'
			je run_up
			cmp al, '4'
			je run_loop
			cmp al, '/'
			je run_if
			cmp al, '1'
			je run_mark
			cmp al, '8'
			je run_asterisk
			cmp al, '5'
			je run_percent
			cmp al, '='
			je run_plus
		%endif

		cmp al, '+'
		je run_plus
		cmp al, '^'
		je run_up
		cmp al, '$'
		je run_loop
		cmp al, '?'
		je run_if
		cmp al, '!'
		je run_mark
		cmp al, '*'
		je run_asterisk
		cmp al, '%'
		je run_percent
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
		%ifdef SYSCALLS
		cmp word [ebx], 50
		je run_setVideo
		cmp word [ebx], 51
		je run_setPixel
		cmp word [ebx], 52
		je run_setCursor
		%endif

		; Else, just print the character
		mov al, [ecx]
		mov ah, 0x0E
		int 0x10
	jmp run_top
	
	%ifdef SYSCALLS
	run_setCursor:
		mov dh, [ebx + 4] ; row
		mov dl, [ebx + 2] ; column
		push bx ; push bx, higher 8 bits of bx
		xor bh, bh ; set page number (0)
		mov ah, 0x02 ; set cursor pos
		int 0x10
		pop bx
	jmp run_top

	run_setVideo:
		; note:
		; 2 = default text
		; 19 = 13h
		
		xor ah, ah ; mov ah, 0x0
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
	%endif

	run_comma:
		%ifdef ARROWS
			xor ah, ah ; 0x0
			int 0x16
			sub ah, 58
			cmp al, 0
			jne noarrow
			mov al, ah
			noarrow:
			mov [ecx], al
		%else
			xor ah, ah ; 0x0
			int 0x16
		%endif

		%ifdef INPUTFEEDBACK
			mov ah, 0x0E
			int 0x10
		%endif
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

; Store text here:
welcome: db ">CrypticOS", 0

%ifndef SIZE
	times 510 - ($ - $$) db 0
	dw 0xAA55
%endif

afterProgram:

; Second sector contains demo program
demoA:
%ifndef SIZE
	incbin "a"
	db 0
%endif

demoB:
%ifndef SIZE
	incbin "b"
	db 0
%endif

%ifndef SIZE
	times (SECTORS * 512) + 510 - ($ - $$) db 0
%endif

; Declare reserved memory
section .bss
	memtop: resb 500
	membottom: resb 10000
	buffer: resb 10000
