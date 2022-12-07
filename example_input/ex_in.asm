;section don't need to be in a certain order, the code is "ran" 2 times anyways
section .data
	prompt db "Circle radius: " 
	promptLen equ $-prompt 

section .bss
	input resb 10 ;this creates a 10 element byte array, resw - word, resd - dword, resq - qword

section .text
	global _start
	_start:
		;print prompt
		;now that we know how to print this should be easy :p
		mov rax, 1         ;id
		mov rdi, 1         ;stdout used
		mov rsi, prompt    ;data
		mov rdx, promptLen ;length
		syscall			   ;kernel call
		
		;wait for input
		mov rax, 0         ;id
		mov rdi, 0         ;stdin used
		mov rsi, input     ;variable
		mov rdx, 10   	   ;length of variable
		syscall            ;kernel call
		
		;print input
		;now that we know how to print this should be easy :p
		mov rax, 1         ;id
		mov rdi, 1         ;stdout used
		mov rsi, input     ;data
		mov rdx, 10    	   ;length
		syscall			   ;kernel call
		
		; Exit code
		mov rax, 60        ;id
		mov rdi, 0         ;exit code
		syscall