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

;addition
%macro addition 2
	mov rsi, %1        ;variable
	mov rsi, %2        ;variable
	; Convert from ascii to decimal
    sub var1, '0'
    sub var2, '0'

    ; Add
    add var1, var2

    ; Conversion from decimal to ascii
    add var1, '0'

    ; We move the result
    mov [answer], var1

    ; We end the program
    syscall
%endmacro

;subtraction
%macro subtraction 2
	; We end the program
    syscall
%endmacro

;multiplication
%macro multiplication 2
	; We end the program
    syscall
%endmacro

;division
%macro division 2
	; We end the program
    syscall
%endmacro

section .data
	intro db "----------Calculator----------"
	introLen equ $-intro
	sNum1 db "Please enter your first number: "
	sNum1Len equ $-sNum1
	sNum2 db "Please enter your second number: "
	sNum2Len equ $-sNum2
	oops db "Operations:", 10, "1.Add", 10, "2.Subtract", 10, "3.Multiply", 10, "4.Divide", 10, "5.Quit", 10
	oopsLen equ $-oops
	ans db "Answer:"
	ansLen equ $-ans
	var1Len equ 10
	var2Len equ 10

section .bss
	var1 resb var1Len
	var2 resb var2Len
	choice resb 2
	answer resb 2

section .text
	global _start
_start:
		
		print intro, introLen 	;prints title
		
	StartofLoop:
	
		print sNum1, sNum1Len   ;asks user for num1
		read var1, var1Len
		
		print sNum2, sNum2Len   ;asks user for num2
		read var2, var2Len
		
		print oops, oopsLen		;displays choices
		read choice, 2			;reads user's choice
		
		cmp choice, 1
		je Addition
		
		cmp choice, 2
		je Subtraction
		
		cmp choice, 3
		je Multiplication
		
		cmp choice, 4
		je Division
		
		;cmp choice, 5
		je quit
		
		
	Addition:
		addition var1, var2
		
	Subtraction:
		subtraction var1, var2
		
	Multiplication:
		multiplication var1, var2
		
	Division:
		division var1, var2
		
		print ans,ansLen
		
		jmp StartofLoop	;restarts loop
		
	Quit:
		quit ;ends program