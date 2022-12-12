; Filename: calculator.asm
;this code was made by Vladislav Serafimov and Stephen Cruz Wright
section .data
	intro db "------------Calculator------------"
	introLen equ $-intro
	sNum1 db 10, "Please enter your first number: "
	sNum1Len equ $-sNum1
	sNum2 db "Please enter your second number: "
	sNum2Len equ $-sNum2
	oops db 10, "Choose one of the following operations:", 10, "1.Add", 10, "2.Subtract", 10, "3.Multiply", 10, "4.Divide", 10, "Enter anything else to quit", 10, 10
	oopsLen equ $-oops
	ans db 10, "Answer:"
	ansLen equ $-ans
	
section .bss
	var1 resb 2
	var2 resb 2
	choice resb 2
	answer resb 2
	
;output to stdout
;args: variable
;args: variable, length
%macro print 2
	mov rax, 1         ;id
	mov rdi, 1         ;stdout used
	mov rsi, %1        ;data
	mov rdx, %2 	   ;length
	syscall	           ;kernel call
%endmacro

;read from stdin
;args: variable, length
%macro read 1
	mov rax, 0         ;id
	mov rdi, 0         ;stdin used
	mov rsi, %1        ;variable
	mov rdx, 8   	   ;length of variable
	syscall    
%endmacro

;addition macro
%macro addition 2
	; Perform the addition
    mov eax, %1
    add eax, %2
	syscall
%endmacro

;subtraction macro
%macro subtraction 2
	mov eax, %1
	sub eax, %2
	syscall
%endmacro

;multiplication macro
%macro multiplication 2
	mov eax, %1
	imul eax, %2
	syscall
%endmacro

;division macro
%macro division 2
	; Code here
%endmacro

;just exit the program
%macro quit 0
	mov rax, 60        ;id
	mov rdi, 0         ;exit code
	syscall
%endmacro

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
		mov ah, [choice]        ; Move the selected option to the registry ah
		sub ah, '0'     		; Convert from ascii to decimal
		
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

		mov rax, [answer]
		sub rax, '0'
		
		print answer, 2
		jmp StartofLoop	;restarts loop
		
	Quit:
		quit ;ends program