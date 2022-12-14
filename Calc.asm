; Filename: calculator.asm
; this code was made by Vladislav Serafimov and Stephen Cruz Wright

;macros here	
;output to stdout
;args: input variable, length
%macro print 2
	mov rax, 1         ;id
	mov rdi, 1         ;stdout used
	mov rsi, %1        ;data
	mov rdx, %2 	   ;length
	syscall	           ;kernel call
%endmacro

;read from stdin
;args: output variable
%macro read 1
	mov rax, 0         ;id
	mov rdi, 0         ;stdin used
	mov rsi, %1        ;variable
	mov rdx, 2   	   ;length of variable
	syscall
%endmacro

;addition macro
;args: number 1, number 2
%macro addition 2
	; Perform the addition
    mov rax, %1
    mov rbx, %2
	
	sub rax, 48
	sub rbx, 48
	
	add rax, rbx
	
	add rax, 48
	
	mov [answer], rax
	syscall
%endmacro

;subtraction macro
;args: number 1, number 2
%macro subtraction 2
	mov rax, %1
	sub rax, 48
	mov rbx, %2
	sub rbx, 48
	sub rax, rbx
	add rax, 48
	mov [answer], rax
	syscall
%endmacro

;multiplication macro
;args: number 1, number 2
%macro multiplication 2
	;mov rax, %1
	;mul rax, %2
	;mov [answer], rax
%endmacro

;division macro
;args: number 1, number 2
%macro division 2
;	mov rax, %1 ; move the first operand into rax register
;	mov rbx, %2 ; move the second operand into rbx register
;	cqo ; sign-extend rax into rdx:rax
;	idiv rbx ; divide rdx:rax by rbx
	
;	cmp rdx, 0 ; check if the remainder is zero
;	jz roundDown ; if the remainder is zero, round down
	
;	cmp rdx, rbx/2 ; check if the remainder is greater than half of the divisor
;	jg roundUp ; if the remainder is greater than half of the divisor, round up
;	jmp result ; otherwise, return the result as is
	
;	roundUp:
;	inc rax ; increment the result by 1 to round up
;	jmp result ; return the result
	
;	roundDown:
	;no need to round down
	
;	result:
;	mov %0, rax ; move the result into the destination register
	
;	syscall
%endmacro

;just exit the program
%macro quit 0
	mov rax, 60        ;id
	mov rdi, 0         ;exit code
	syscall
%endmacro

section .data
	intro db "------------Calculator------------", 10
	introLen equ $-intro
	sNum1 db 10, "Please enter your first number: "
	sNum1Len equ $-sNum1
	sNum2 db "Please enter your second number: "
	sNum2Len equ $-sNum2
	oops db 10, "Choose one of the following operations:", 10, "1.Add", 10, "2.Subtract", 10, "3.Multiply", 10, "4.Divide", 10, "Enter anything else to quit", 10, 10
	oopsLen equ $-oops
	ans db 10, "Answer:"
	ansLen equ $-ans
	
section .bss ;used to reserve data
	var1 resb 2 ;reserve 2 bytes for var 1
	var2 resb 2
	choice resb 2
	answer resb 2
	
section .text
	global _start
_start:
		
		print intro, introLen 	;prints title
		
	StartofLoop:
	
		print sNum1, sNum1Len   ;asks user for num1
		read var1
		
		print sNum2, sNum2Len   ;asks user for num2
		read var2
		
		print oops, oopsLen		;displays choices
		read choice  		;reads user's choice
		mov ah, [choice]        ; Move the selected option []as a pointer] to the registry ah
		sub ah, 48     		; Convert from ascii to decimal
		
		cmp ah, 1
		je Addition
		
		cmp ah, 2
		je Subtraction
		
		cmp ah, 3
		je Multiplication
		
		cmp ah, 4
		je Division
		
		;cmp choice, 5
		je Quit
		
	Addition:
		addition var1, var2
		jmp Print ;jumps to printer

	Subtraction:
		subtraction var1, var2
		jmp Print ;jumps to printer
		
	Multiplication:
		multiplication var1, var2
		jmp Print ;jumps to printer
		
	Division:
		division var1, var2
		jmp Print ;jumps to printer
	
	Print:
		
		print ans, ansLen
		
		print answer, 8 
		jmp StartofLoop	;restarts loop
		
	Quit:
		quit ;ends program