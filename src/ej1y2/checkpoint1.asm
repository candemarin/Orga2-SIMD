
section .text

global invertirQW_asm

; void invertirQW_asm(uint64_t* p)

invertirQW_asm:
	push rbp
	mov rbp, rsp
	movdqu xmm0, [rdi]
	shufpd xmm0, xmm0, 01
	movdqu [rdi], xmm0
	pop rbp
	ret
