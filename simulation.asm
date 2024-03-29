%include "io.inc"
section .data
VARN db 16 ;number of bits. for this case, n = 16 (n)
VARM dw 1 ;serves as divisor (M)
VARQ dw 1 ;serves as dividend (Q)
VARA dw 0 ;serves as remainder. init value should be 0 (A)
section .bss
RESMN resw 1 ;serves as 2's complement of (M)
RES1 resd 1 ;container for shift left
section .text
global CMAIN
CMAIN:
    ;Get inputs separated by new line. Expected format Q / M e.g 8 / 3
    GET_UDEC 2, [VARQ]
    NEWLINE
    GET_UDEC 2, [VARM]

    ;Get 2's complement of VARM and assign to RESMN
    mov bx, [VARM]
    mov [RESMN], bx
    not word [RESMN]
    add word [RESMN], 1 
    
    mov dx, [VARA]
    mov ax, [VARQ]
      
    call START

    xor eax, eax
    ret
START:
    PRINT_STRING "Cycle: "
    PRINT_UDEC 1, VARN
    PRINT_STRING ","
    
    mov [RES1], ax
    mov [RES1 + 2], dx
    shl dword [RES1], 1
    
    ; Assign to respective registers
    mov dx, [RES1 + 2]
    mov ax, [RES1]
    
    cmp dx, 32767 ;0111111111111111 = max positive number if 16 bits. negative if 1xxxxxxxxxxxxxxx
    jbe A_MINUS_M
    call A_PLUS_M
    ret
A_MINUS_M:
    mov bx, [RESMN]
    add dx, bx
    
    cmp dx, 32767 ;0111111111111111 = max positive number if 16 bits. negative if 1xxxxxxxxxxxxxxx
    jbe ADD_ONE_TO_Q
    call ADD_ZERO_TO_Q
    ret
A_PLUS_M:
    mov bx, [VARM]
    add dx, bx
    
    cmp dx, 32767 ;0111111111111111 = max positive number if 16 bits. negative if 1xxxxxxxxxxxxxxx
    jbe ADD_ONE_TO_Q
    call ADD_ZERO_TO_Q
    ret
ADD_ZERO_TO_Q:    
    add word ax, 0h
    PRINT_STRING " A: "
    PRINT_HEX 2, dx
    PRINT_STRING " Q: "
    PRINT_HEX 2, ax
    NEWLINE
    
    dec byte [VARN]
    cmp byte [VARN], 1
    jae START
    call COUNT_IS_ZERO
    ret
ADD_ONE_TO_Q:
    add word ax, 1h
    PRINT_STRING " A: "
    PRINT_HEX 2, dx
    PRINT_STRING " Q: "
    PRINT_HEX 2, ax
    NEWLINE
    
    dec byte [VARN] 
    cmp byte [VARN], 1
    jae START
    call COUNT_IS_ZERO
    ret
COUNT_IS_ZERO:    
    cmp dx, 32767 ;0111111111111111 = max positive number if 16 bits. negative if 1xxxxxxxxxxxxxxx
    jbe END
    
    mov bx, [VARM]
    add dx, bx
    call END
    ret
END:
    PRINT_STRING "Cycle: "
    PRINT_UDEC 1, VARN
    PRINT_STRING ","
    PRINT_STRING " A: "
    PRINT_HEX 2, dx
    PRINT_STRING " Q: "
    PRINT_HEX 2, ax
    NEWLINE
    ret
    
    