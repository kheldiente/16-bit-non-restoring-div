%include "io.inc"
section .data
VARN db 0 ;number of bits. for this case, n = 8 (n)
VARM db 0 ;serves as divisor (M)
VARMN db 0 ;serves as 2's complement of (M)
VARQ db 0 ;serves as dividend (Q)
VARA db 0 ;serves as remainder. init value should be 0 (A)
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;Operation: 7 / 4
    mov byte [VARN], 8
    mov byte [VARA], 0
    mov byte [VARM], 4 ;should be same with VARMN
    mov byte [VARMN], 4 ;should be same with VARM
    mov byte [VARQ], 7
    not byte [VARMN]
    add byte [VARMN], 1h 
    
    mov dx, [VARA]
    mov ax, [VARQ]
    
    call START
    
    ;NEWLINE
    ;PRINT_STRING "Result: "
    ;PRINT_DEC 1, ah
    xor eax, eax
    ret
START:
    ;NEWLINE
    ;PRINT_STRING "dx: "
    ;PRINT_UDEC 1, dx
    ;PRINT_STRING " ax: "
    ;PRINT_UDEC 1, ax
    ;NEWLINE
    
    PRINT_STRING "N: "
    PRINT_UDEC 1, VARN

    mov bh, dl
    mov bl, al
    shl bx, 1
    
    NEWLINE
    PRINT_STRING "Shift left:"
    PRINT_UDEC 1, bx
    NEWLINE
    
    ; Assign to respective registers
    mov dl, bh
    mov al, bl
    
    PRINT_STRING "A: "
    PRINT_UDEC 1, dl
    NEWLINE
    
    cmp dl, 127 ;01111111 = max positive number if 8 bits. negative if 1xxxxxxx
    jbe A_MINUS_M
    call A_PLUS_M
    ret
A_MINUS_M:
    PRINT_STRING "Greater than zero"
    NEWLINE  
    
    PRINT_STRING "M="
    PRINT_UDEC 1, VARM
    mov bx, [VARMN]
    PRINT_STRING " -M: "
    PRINT_UDEC 1, bl
    NEWLINE 
    
    ;Perform A-M
    add dl, bl
    PRINT_STRING "A-M: "
    PRINT_UDEC 1, dx
    NEWLINE

    cmp dx, 127 ;01111111 = max positive number if 8 bits. negative if 1xxxxxxx
    jle ADD_ONE_TO_Q
    call ADD_ZERO_TO_Q
    ret
A_PLUS_M:
    PRINT_STRING "Less than zero."
    NEWLINE
    
    mov bx, [VARM]
    add dl, bl
    PRINT_STRING "A-M: "
    PRINT_UDEC 1, dx
    NEWLINE
    
    cmp dx, 127 ;01111111 = max positive number if 8 bits. negative if 1xxxxxxx
    jle ADD_ONE_TO_Q
    call ADD_ZERO_TO_Q
    ret
ADD_ZERO_TO_Q:
    PRINT_STRING "Add 0 to Q0"
    NEWLINE
    
    add byte al, 0h
    PRINT_STRING "A: "
    PRINT_UDEC 1, dx
    PRINT_STRING " Q: "
    PRINT_UDEC 1, ax
    NEWLINE
    NEWLINE
    
    dec byte [VARN]
    
    cmp byte [VARN], 1
    jge START
    ret
ADD_ONE_TO_Q:
    PRINT_STRING "Add 1 to Q0"
    NEWLINE
    
    add byte al, 1h
    PRINT_STRING "A: "
    PRINT_UDEC 1, dx
    PRINT_STRING " Q: "
    PRINT_UDEC 1, ax
    NEWLINE
    NEWLINE
    
    dec byte [VARN] 
    
    cmp byte [VARN], 1
    jge START
    ret
    
    