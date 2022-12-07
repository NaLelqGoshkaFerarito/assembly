;macros come first
;macro syntax
;print variable length
%macro print 2
	mov rax, 1         ;id
	mov rdi, 1         ;stdout used
	mov rsi, %1    	   ;data
	mov rdx, %2 	   ;length
	syscall			   ;kernel call
%endmacro


section .data
	var db "I'm pretty long", 0xa
	len equ $-var

section .text
	global _start
	_start:
		print var,len
	
		mov rax, 60        ;id
		mov rdi, 0         ;exit code
		syscall