section .rodata

four_black_pixels:  db 0,0,0,255,0,0,0,255,0,0,0,255,0,0,0,255 ; difine byte = 4 pixels negros con a = 255
black_white_pixels:  db 0,0,0,255,0,0,0,255,255,255,255,255,255,255,255,255 ; 2 pixels negros y 2 pixels blancos
white_black_pixels:  db 255,255,255,255,255,255,255,255,0,0,0,255,0,0,0,255 ; 2 pixels blancos y 2 pixels negros
four_white_pixels: db 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 ; 4 pixels blancos

section .data

section .text

global Pintar_asm

;void Pintar_asm(unsigned char *src, rdi
;              unsigned char *dst,   rsi
;              int width,			 rdx
;              int height,			 rcx
;              int src_row_size,	 r8
;              int dst_row_size);	 r9


Pintar_asm:
	push rbp
	mov rsp, rbp
	push r13
	push r14
	push r15
	push r12

	;lea r13, [rdi]
	;lea r14, [rsi]
	mov r14, rdx ; ancho img
	mov r12, r14
	mov r15, rcx ; alto img
	sub r15, 2
	xor r13, r13 ; contador de filas
	movdqu xmm0, [four_black_pixels]
	movdqu xmm1, [four_white_pixels]
	movdqu xmm2, [black_white_pixels]
	movdqu xmm3, [white_black_pixels]

.bordesArriba:
	cmp r14, 0 ; ancho img
	je .fila2
	movdqu [rsi], xmm0 ; 4 pixeles negros
	add rsi, 16
	sub r14, 4
	jmp .bordesArriba
.fila2:
	mov r14, r12 ; ancho img
	inc r13
	cmp r13, 2
	je .centro
	jne .bordesArriba
.centro:
	cmp r14, 0 ; ancho img
	je .siguenteFila
	cmp r14, r12
	je .bordesIzquierda
	cmp r14, 4
	je .bordesDerecha
	movdqu [rsi], xmm1 ; 4 pixeles blancos
	add rsi, 16
	sub r14, 4
	jmp .centro
.siguenteFila:
	mov r14, r12
	inc r13
	cmp r13, r15 ; llego ultima fila de blancos
	je .bordesAbajo
	jmp .centro
.bordesIzquierda:
	movdqu [rsi], xmm2 ; 2 pixeles negros y 2 blancos
	add rsi, 16
	sub r14, 4
	jmp .centro
.bordesDerecha:
	movdqu [rsi], xmm3 ; 2 pixeles blancos y 2 negros
	add rsi, 16
	sub r14, 4
	jmp .centro
.bordesAbajo:
	xor r13, r13
	jmp .bordesAbajo_
.bordesAbajo_
	cmp r14, 0 ; ancho img
	je .fila2_
	movdqu [rsi], xmm0 ; 4 pixeles negros
	add rsi, 16
	sub r14, 4
	jmp .bordesAbajo_
.fila2_:
	mov r14, r12 ; ancho img
	inc r13
	cmp r13, 2
	je .fin
	jne .bordesAbajo_

.fin:
	pop r12
	pop r15
	pop r14
	pop r13
	pop rbp
	ret
