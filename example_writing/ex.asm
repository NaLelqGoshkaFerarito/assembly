section .text
    global _start
_start: 
;printing
    mov rax, 1         ;id
    mov rdi, 1         ;stdout used
    mov rsi, myVar     ;data
    mov rdx, myLen     ;length
    syscall
    
;exiting
    mov rax, 60         ;id
    mov rdi, 0         ;exit code
    syscall

section .data
    myVar db "Hi", 0xa ;the 0xa(=10=LF(stands for linefeed)) is equvalent to \n
    myLen equ $-myVar  ;the length of myVar