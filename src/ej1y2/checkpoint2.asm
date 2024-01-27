
section .rodata

ocho: times 8 dw 8
unos: times 16 db 1

section .text

global checksum_asm

; uint8_t checksum_asm(void* array, uint32_t n)
; A y B son enteros sin signo de 16 bits y C son enteros sin signo de 32 bits

checksum_asm:
	push rbp
	push rbx
	sub rsp, 8
	mov rbp, rsp
	xor rax, rax
	mov rax, 1
	pxor xmm6, xmm6 
	pxor xmm7, xmm7
	movdqu xmm6, [ocho]
	movdqu xmm7, [unos]
	
.ciclo:
	cmp rsi, 0
	je .fin
	dec rsi
	movdqu xmm0, [rdi] ; A
	movdqu xmm1, [rdi + 16] ; B
	movdqu xmm2, [rdi + 32] ; C 0-3
	movdqu xmm3, [rdi + 48] ; C 4-7
	paddW xmm0, xmm1 ; xmm0 = A+B
	movdqu xmm4, xmm0 ; xmm4 = A+B
	PMULlW xmm0, xmm6 ; D low
	PMULhW xmm4, xmm6 ; D high
	movdqu xmm5, xmm0
	punpcklwd xmm0, xmm4 ; xmm0 = D 0-3
	punpckhwd xmm5, xmm4 ; xmm4 = D 4-7
	
	PCMPEQd xmm0, xmm2
	pxor xmm0, xmm7
	ptest xmm0, xmm7
	jne .cero

	PCMPEQd xmm5, xmm3
	pxor xmm5, xmm7
	ptest xmm5, xmm7
	jne .cero

	add rdi, 64 ; 64 bytes una terna ABC
	jmp .ciclo

.cero:
	mov rax, 0
.fin:
	add rsp, 8
	pop rbx
	pop rbp
	ret

