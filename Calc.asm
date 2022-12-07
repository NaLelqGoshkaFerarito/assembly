;output to stdout
;args: variable, length
%macro print 2
	mov rax, 1         ;id
	mov rdi, 1         ;stdout used
	mov rsi, %1        ;data
	mov rdx, %2 	    ;length
	syscall	           ;kernel call
%endmacro

;read from stdin
;args: variable, length
%macro read 2
	mov rax, 0         ;id
	mov rdi, 0         ;stdin used
	mov rsi, %1        ;variable
	mov rdx, %2   	    ;length of variable
	syscall    
%endmacro

;just exit the program
%macro quit 0
	mov rax, 60        ;id
	mov rdi, 0         ;exit code
	syscall
%endmacro

;weww
%macro addition 2
	mov rax, 60
%endmacro

section .data
	intro db "----------Calculator----------"
	introLen equ $-intro
	sNum1 db "Please enter your first number: "
	sNum1Len equ $-sNum1
	sNum2 db "Please enter your second number: "
	sNum2Len equ $-sNum2
	oops db "Operations:", 10, "1.Add", 10, "2.Subtract", 10, "3.Multiply", 10, "4.Divide", 10
	oopsLen equ $-oops
		
	varLen equ 10

section .bss
	var resb varLen
	;var stdin

section .text
	global _start
	_start:
        ;four lines of code
		print oops, oopsLen
		;read var, varLen
		;print var,varLen
		;finishhim
		quit