;output to stdout
;args: variable, length
%macro print 2
	mov rax, 1         ;id
	mov rdi, 1         ;stdout used
	mov rsi, %1    	   ;data
	mov rdx, %2 	   ;length
	syscall			   ;kernel call
%endmacro

;read from stdin
;args: variable, length
%macro read 2
	mov rax, 0         ;id
	mov rdi, 0         ;stdin used
	mov rsi, %1        ;variable
	mov rdx, %2   	   ;length of variable
	syscall   
%endmacro

;just exit the program
%macro quit 0
	mov rax, 60        ;id
	mov rdi, 0         ;exit code
	syscall
%endmacro

section .data
	string db "Enter something: "
	stringLen equ $-string
	varLen equ 10

section .bss
	var resb varLen

section .text
	global _start
	_start:
		print string, stringLen
		read var, varLen
		print var,varLen
		quit
		