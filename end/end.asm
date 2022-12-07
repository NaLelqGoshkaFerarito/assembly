;output to stdout
;args: variable, length
%macro print 2
	mov rsi, %1        ;data
	mov rdx, %2 	   ;length
	mov rax, 1         ;id
	mov rdi, 1         ;stdout used
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

;w
%macro addition 1
	mov rax, 2
	add rax, %1
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
		print intro, introLen
		print oops, oopsLen
		print sNum1, sNum1Len
		read var, varLen
		addition var
		add var, rax
		print var, 10
		;finishhim
		quit