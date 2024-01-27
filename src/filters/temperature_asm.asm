global temperature_asm

section .rodata
tres: times 2 dd 3  
mascara: dq 0xFFFFFFFF00FFFFFF, 0xFFFFFFFFFFFFFFFF
section .text
;void temperature_asm(unsigned char *src,   ->rdi
;              unsigned char *dst,          ->rsi
;              int width,                   ->rdx
;              int height,                  ->rcx
;              int src_row_size,            ->r8
;              int dst_row_size);           ->r9

temperature_asm:
    mov rax, rcx        
    mul edx     
    shl rdx, 32     
    mov edx, eax    
    mov rcx, rdx    
    shr rcx, 1
    movdqu xmm3, [tres]         
    cvtdq2pd xmm3, xmm3         
    movdqu xmm4, [mascara]      
    xorps xmm5, xmm5

    loop_temperature:
        ; Trabajo de a dos pixeles
        movd xmm0, [rdi]        
        movd xmm1, [rdi + 4]    
        add rdi, 8              
        ; APlico mascara
        andps xmm0, xmm4        
        andps xmm1, xmm4
        ; convierto a enteros sin signo
        pmovzxbd xmm0, xmm0     
        pmovzxbd xmm1, xmm1
        ; sumo los pixeles
        phaddd xmm0, xmm1
        phaddd xmm0, xmm5
        ; divido por 3 y convierto a flotante
        cvtdq2pd xmm0, xmm0     
        divpd xmm0, xmm3        
        cvttpd2dq xmm0, xmm0    
        mov r11, 0
        
        comparacion:
        ; extraigo el valor de temperatura
        movd r10D, xmm0

        psrldq xmm0, 4
        pslldq xmm6, 4
        cmp r10B, 32d
        jb primerCaso
        cmp r10B, 96d
        jb segundoCaso
        cmp r10B, 160d
        jb tercerCaso
        cmp r10B, 224d
        jb cuartoCaso
        jmp quintoCaso

        primerCaso:
            inc r11
            shl r10, 2      
            add r10, 128       ;128+t*4
            mov r8, 0xFF

            pinsrb xmm6, r8B, 0x03
            xor r8, r8
            pinsrb xmm6, r8B, 0x02
            pinsrb xmm6, r8B, 0x01
            pinsrb xmm6, r10B, 0x00
            cmp r11, 2
            jne comparacion
            jmp fin_comparacion
        segundoCaso:
            inc r11
            sub r10, 32
            shl r10, 2      
            mov r8, 0xFF
            pinsrb xmm6, r8B, 0x03
            pinsrb xmm6, r10B, 0x01
            pinsrb xmm6, r8B, 0x0  
            xor r8, r8
            pinsrb xmm6, r8B, 0x02
            cmp r11, 2
            jne comparacion
            jmp fin_comparacion
        tercerCaso:
            inc r11
            mov r8, 0xFF
            sub r10, 96
            shl r10, 2
            sub r8, r10
            mov r9, 0xFF
            pinsrb xmm6, r9B, 0x03
            pinsrb xmm6, r10B, 0x02
            pinsrb xmm6, r9B, 0x01
            pinsrb xmm6, r8B, 0x0
            cmp r11, 2
            jne comparacion
            jmp fin_comparacion
        cuartoCaso:
            inc r11
            mov r8, 0xFF
            sub r10, 160
            shl r10, 2
            sub r8, r10
            mov r9, 0xFF
            pinsrb xmm6, r9B, 0x03
            xor r10, r10
            pinsrb xmm6, r9B, 0x02
            pinsrb xmm6, r8B, 0x01
            pinsrb xmm6, r10B, 0x0
            cmp r11, 2
            jne comparacion
            jmp fin_comparacion
        quintoCaso:
            inc r11
            mov r8, 0xFF
            sub r10, 224
            shl r10, 2
            sub r8, r10
            mov r9, 0xFF
            pinsrb xmm6, r9B, 0x03
            xor r9, r9
            pinsrb xmm6, r8B, 0x02
            pinsrb xmm6, r9B, 0x01
            pinsrb xmm6, r9B, 0x00
            cmp r11, 2
            jne comparacion
            jmp fin_comparacion

    fin_comparacion:
        pshufd xmm6, xmm6, 11100001b
        pextrq [rsi], xmm6, 0           
        add rsi, 8
        sub rcx, 1
        cmp rcx, 0
        jne loop_temperature

    ret
