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
	;sub rsi, '0'	   ; Convert from ascii to decimal
	mov rdx, 3   	   ;length of variable
	syscall
%endmacro


;addition macro
;args: number 1, number 2
%macro addition 2
	
    mov rax, [%1]
	sub rax, '0'
	
    mov rbx, [%2]
	sub rbx, '0'
	
	add rax, rbx	;Perform the addition
	add rax, '0'
	
	mov [answer], rax
%endmacro

;subtraction macro
;args: number 1, number 2
%macro subtraction 2
	mov rax, [%1]
	sub rax, '0'
	
	mov rbx, [%2]
	sub rbx, '0'
	
	sub rax, rbx
	add rax, '0'
	
	mov [answer], rax
%endmacro

;multiplication macro
;args: number 1, number 2
%macro multiplication 2
	mov rax, [%1]
	sub rax, '0'
	
	mov rbx, [%2]
	sub rbx, '0'
	
	imul rax, rbx
	add rax, '0'
	
	mov [answer], rax
%endmacro

;division macro
;args: number 1, number 2
%macro division 2
	mov al, [%1]; move the first operand into rax register
	sub al, '0'
	
	mov dx, 0; clears decimal points (rounds down)
    mov ah, 0
	
	mov bl, [%2]; move the second operand into rbx register
	sub bl, '0'
	
	idiv bl
	add ax, '0'
	
	mov [answer], ax	; move the result into the destination register
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
	var1 resb 3 ;reserve 3 bytes for var 1
	var2 resb 3
	choice resb 2
	answer resb 3
	
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
		mov ah, [choice]        ; Move the selected option [as a pointer] to the registry ah
		
		
		cmp ah, '1'
		je Addition
		
		cmp ah, '2'
		je Subtraction
		
		cmp ah, '3'
		je Multiplication
		
		cmp ah, '4'
		je Division
		
		cmp ah, '5'
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
		
		print answer, 1
		jmp StartofLoop	;restarts loop
		
	Quit:
		quit ;ends program