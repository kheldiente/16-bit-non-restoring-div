%include "io.inc"
section .data
VARN db 16 ;number of bits. for this case, n = 16 (n)
VARM dw 4 ;serves as divisor (M). should be same with VARMN
VARMN dw 4 ;serves as 2's complement of (M). should be same with VARM
VARQ dw 5 ;serves as dividend (Q)
VARA dw 0 ;serves as remainder. init value should be 0 (A)
section .bss
RES1 resd 1 ;container for shift left
section .text
global CMAIN
CMAIN:
    ;Get 2's complement of VARM
    not word [VARMN]
    add word [VARMN], 1 
    
    mov dx, [VARA]
    mov ax, [VARQ]
      
    call START

    xor eax, eax
    ret
START:
    PRINT_STRING "N: "
    PRINT_UDEC 1, VARN
    NEWLINE
    
    PRINT_STRING "dx: "
    PRINT_UDEC 2, dx
    PRINT_STRING " ax: "
    PRINT_UDEC 2, ax
    
    mov [RES1], ax
    mov [RES1 + 2], dx
    shl dword [RES1], 1
    
    NEWLINE
    PRINT_STRING "Shift left:"
    PRINT_UDEC 4, RES1
    NEWLINE
    
    ; Assign to respective registers
    mov dx, [RES1 + 2]
    mov ax, [RES1]
    
    PRINT_STRING "A: "
    PRINT_UDEC 2, dx
    NEWLINE
    
    cmp dx, 32767 ;0111111111111111 = max positive number if 16 bits. negative if 1xxxxxxxxxxxxxxx
    jbe A_MINUS_M
    call A_PLUS_M
    ret
A_MINUS_M:
    PRINT_STRING "Greater than zero"
    NEWLINE  
    
    PRINT_STRING "M="
    PRINT_UDEC 2, VARM
    mov bx, [VARMN]
    PRINT_STRING " -M: "
    PRINT_UDEC 2, bx
    NEWLINE 
    
    ;Perform A-M
    add dx, bx
    PRINT_STRING "A-M: "
    PRINT_UDEC 2, dx
    NEWLINE

    cmp dx, 32767 ;0111111111111111 = max positive number if 16 bits. negative if 1xxxxxxxxxxxxxxx
    jbe ADD_ONE_TO_Q
    call ADD_ZERO_TO_Q
    ret
A_PLUS_M:
    PRINT_STRING "Less than zero."
    NEWLINE
    
    mov bx, [VARM]
    add dx, bx
    PRINT_STRING "A+M: "
    PRINT_UDEC 2, dx
    NEWLINE
    
    cmp dx, 32767 ;0111111111111111 = max positive number if 16 bits. negative if 1xxxxxxxxxxxxxxx
    jbe ADD_ONE_TO_Q
    call ADD_ZERO_TO_Q
    ret
ADD_ZERO_TO_Q:
    PRINT_STRING "Add 0 to Q0"
    NEWLINE
    
    add word ax, 0h
    PRINT_STRING "A: "
    PRINT_UDEC 2, dx
    PRINT_STRING " Q: "
    PRINT_UDEC 2, ax
    NEWLINE
    NEWLINE
    
    dec byte [VARN]
    
    cmp byte [VARN], 1
    jae START
    call COUNT_IS_ZERO
    ret
ADD_ONE_TO_Q:
    PRINT_STRING "Add 1 to Q0"
    NEWLINE
    
    add word ax, 1h
    PRINT_STRING "A: "
    PRINT_UDEC 2, dx
    PRINT_STRING " Q: "
    PRINT_UDEC 2, ax
    NEWLINE
    NEWLINE
    
    dec byte [VARN] 
    
    cmp byte [VARN], 1
    jae START
    call COUNT_IS_ZERO
    ret
COUNT_IS_ZERO:
    PRINT_STRING "N: "
    PRINT_UDEC 1, VARN
    NEWLINE
    
    cmp dx, 32767 ;0111111111111111 = max positive number if 16 bits. negative if 1xxxxxxxxxxxxxxx
    jbe END
    
    mov bx, [VARM]
    add dx, bx
    call END
    ret
END:
    PRINT_STRING "A: "
    PRINT_UDEC 1, dx
    PRINT_STRING " Q: "
    PRINT_UDEC 1, ax
    NEWLINE
    ret
    
    