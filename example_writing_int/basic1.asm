section .text
    global _start
_start: 
;printing
    mov rax, 4       			  ;id
    mov rbx, 1       			  ;stdout used
    mov rcx, myVar   			  ;data
    mov rdx, myLen   			  ;length
    int 0x80         		 	  ;kernel call
    
;exiting
    mov rax, 1       			  ;id
    int 0x80         			  ;kernel call

section .data
    myVar db 'Hi, am string', 0xa ;the 0xa(=10=LF(stands for linefeed)) is equvalent to \n
    myLen equ $-myVar			  ;the length of myVar