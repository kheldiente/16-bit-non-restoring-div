%include "io.inc"
section .data
VARN db 0 ;number of bits. for this case, n = 4 (n)
VARM db 0 ;serves as divisor (M)
VARMN db 0 ;serves as 2's complement of (M)
VARQ db 0 ;serves as dividend (Q)
VARA db 0 ;serves as remainder. init value should be 0 (A)
section .text
global CMAIN
CMAIN:
    ;Operation: 7 / 4
    mov byte [VARN], 5
    mov byte [VARA], 0
    mov byte [VARM], 4
    mov byte [VARQ], 7
    
    shl byte [VARQ], 1
    PRINT_STRING "SL: "
    PRINT_UDEC 1, VARQ
    NEWLINE
    
    mov ax, [VARQ]
    
    cmp ah, 0
    jle A_MINUS_M
    call A_PLUS_M
    NEWLINE
    
    ;PRINT_HEX 2, VARQ
    ;NEWLINE
    ;PRINT_UDEC 2, VARQ
    xor eax, eax
    ret
A_MINUS_M:
    PRINT_STRING "Less than zero."
    NEWLINE
    PRINT_STRING "A="
    PRINT_UDEC 1, ah
    PRINT_STRING ", M="
    PRINT_UDEC 1, VARM
    
    not byte [VARM]
    and byte [VARM], 0fh
    add byte [VARM], 1h
    mov bx, [VARM]
    PRINT_STRING ", -M: "
    PRINT_UDEC 1, bl
    NEWLINE
    
    ;Perform A-M
    add ah, bl
    PRINT_STRING "Result: "
    PRINT_UDEC 1, ah
    ret
A_PLUS_M:
    PRINT_STRING "Greater than zero"
    ret
ADD_ZERO_TO_Q:
    PRINT_STRING "Add 0 to Q0"
    ret
ADD_ONE_TO_Q:
    PRINT_STRING "Add 1 to Q0"
    
    