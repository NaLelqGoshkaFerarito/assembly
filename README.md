# Assembly (NASM) tutorial
by Stephen Cruz Wright and Vladislav Serafimov 
(with a lot of help from the book: "x86-64 Assembly Language Programming with Ubuntu", authored by Ed Jorgensen)

This is a tutorial for anyone who wants to start programming in Assembly (NASM). While Windows users might be tempted to use MASM instead, we advise against that due to syntactic differences (and because *Microsoft is yucky* ~(>_<。)＼)

## Setting up the environment and running code
The process of setting up your environment is more involved than modern languages, but it's possible to skip certain steps or optimize others. This tutorial doesn't focus on that, as demonstrating how the language works is more important.

### **I. Setup**

### 1. (optional) Set up the text editor

In this tutorial, I’ll be using Notepad++ (but you can use whatever you want). The syntax highlighting and setup instructions I’m using can be found here:
```https://github.com/xram64/6502-npp-syntax```

Your code should look like this now
![](https://i.imgur.com/VE4X4Xg.png)

 

### 2. Download Ubuntu for Windows 

The instructions for this part can be found on Blackboard (APC->General information-> Installing Ubuntu 22.04 LTS on Windows) or alternatively go to the site directly on https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-10#1-overview.


### 3. Run Ubuntu and download NASM 

Once you’re in the terminal, you need to run:```sudo apt-get install -y nasm```

### 4. Write (or Ctrl-C/Ctrl-V) the Hello World program 

```assembly=

section	.text 

	global _start       ;must be declared for using gcc 

_start:                     ;tell linker entry point 

	mov	edx, len    ;message length 

	mov	ecx, msg    ;message to write 

	mov	ebx, 1	    ;file descriptor (stdout) 

	mov	eax, 4	    ;system call number (sys_write) 

	int	0x80        ;call kernel 

	mov	eax, 1	    ;system call number (sys_exit) 

	int	0x80        ;call kernel 

  

section	.data 

  

msg	db	'Hello, world!',0xa	;our dear string 

len	equ	$ - msg			;length of our dear string 

 ```

I saved it as `ex.asm` and that’s what I’ll use from now on (check 5 for your default directory). 

### 5. Check your default directory 
This step is for Windows users, as it can't be accessed directly from the file explorer
You can do this by running the command: explorer.exe
>explorer.exe `wslpath -w "$PWD" 

Create a new folder (`proj` for me) in the default directory and save `ex.asm` there 


### **II.Running code**

### 1. Create object (.o) file

Use this command: `nasm -f elf64 –o ex.o ex.asm` 
`-f` specifies the file type
`-o` specifies the output

or if that doesnt work (if you have ubuntu v22+)
you can try the command: `nasm -f elf64 –i ex.o ex.asm` 
`-f` specifies the file type
`-i` specifies the output

*Note: The .asm and .o files can have different names*

### 2. Create executable 

Use this command: `ld ex.o -o ex` 
`ld` is the GNU linker
`-o` specifies the output

Or alternatively: `gcc -g -no-pie -o example example.o` which uses GCC instead

*Note: The .o files and the executables can have different names*

### 3. Run your executable
Use this command: `./ex`
 
If (almost) everything up until now went fine, you should be looking at something like this 
![](https://i.imgur.com/JIdC1PY.png)
*Note: The example uses different names for demonstrational purposes*

## Writing assembly code
### Your best friends
0. **Things you need to know off the bat**
- sizes
Here is a quick size list you'll need: 
byte - 8 bits
word - 2 bytes
doubleword - 2 words
quadword - 2 dwords (4 words)
They can be shortened to b, w, dw/dword, qw/qword

- sections 
There's 3 sections which are declared as follows
`section .data` - Put your **initialized** data here
`section .bss` - Put your **uninitialized** data here
`section .text` - Put your code in here; important to note is that you also need to put `global _start` and then `_start:` ( finally followed by your code) in here as well.  Simply put, this `_start` specifies your program's entry point.
>All sections end when the next one starts, no formal end is declared

- architecture 
For the sake of brevity, this part was omitted, but if you're curious you can check the book (http://www.egr.unlv.edu/~ed/x86.html, Chapter 2)

1. **mov**
From now on you will see `mov` a lot. In lamen's terms, `mov` moves `source` to `destination` using this template `mov destination, source` where **source** can be a **register**, **variable** or an **immediate** value (not saved as a variable or a register, similar to `rvalue`)

2. **equ**
Can be thought of as the equal sign in a normal programming language. The syntax is also similar: `variable equ value`

3. **db, dw, dd, dq**
Used in `.data` to declare a variable of size byte using the syntax `varName db variableContent`. 
*Note: strings are more peculiar in their definition, see the code examples for more information*

4. **resb, resw, resd, resq**
Used in `.bss` to declare an array of bytes, words, doublewords, quadwords of size `variableLength` using the syntax `varName resb variableLength`. 

### Printing out
In order to be able to print something out you first need to understand what **system calls** are.

>A **system call** can be thought of as a function that requests some functionality from the kernel

There's hundreds of system calls and in order to be able to use the one you need, you have to know:
- Its unique **ID**
- What **arguments** it takes

When you know that you also need to know **which registers you need to store them in**. For your convenience here's a list:

0. **ID**: in ```rax```
1. Argument **1**: in ```rdi```
2. Argument **2**: in ```rsi```
3. Argument **3**: in ```rdx```

Up to 6 arguments can be stored in registers (more arguments can *technically* be used), but this beyond the scope of this tutorial.

After you have everything in place you need to **call the kernel** using`syscall` (or `int 0x80`, although using the interrupt method requires using different registers). It then takes our input and runs code we don't have access to, but it does.

For `sys_write` we need:
- ID = 4
- Argument 1 = 1 (denoting the use of the standard output)
- Argument 2 = the address of what you want to output
- Argument 3 = the number of characters that you want to output

In assembly code this would look like this

**Using syscall** 
```assembly=
section .text
    global _start
_start: 
;printing
    mov rax, 1         ;id
    mov rdi, 1         ;stdout used
    mov rsi, myVar     ;data
    mov rdx, myLen     ;length
    syscall
    
;exiting
    mov rax, 60         ;id
    mov rdi, 0         ;exit code
    syscall

section .data
    myVar db "Hi", 0xa ;the 0xa(=10=LF(stands for linefeed)) is equvalent to \n
    myLen equ $-myVar  ;the length of myVar
```

**Using interrupts** 
```assembly=
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
    myVar db 'Hi, am string', 0xa       ;the 0xa(=10=LF(stands for linefeed)) is equvalent to \n
    myLen equ $-myVar			  ;the length of myVar
```

*For more on system calls see: http://www.egr.unlv.edu/~ed/x86.html (Chapter 13) for a thorough explanation or https://www.tutorialspoint.com/assembly_programming/assembly_system_calls.htm for a more surface-level explanation*


### Reading input 
For reading use 
- ID = 0
- Argument 1 = input medium (0 for stdin)
- Argument 2 = the variable that needs to be overwritten
- Argument 3 = the max length of characters that can be written
Arguments can also be on the stack (saved as variables), but that is not as efficient.

**Using syscall**
```assembly=
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
```
**Using interrupts**
```assembly=
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
		mov eax, 4       			  ;id
		mov ebx, 1       			  ;stdout used
		mov ecx, prompt   			  ;data
		mov edx, promptLen   		          ;length
		int 0x80         		 	  ;kernel call
		
		;wait for input
		mov eax, 3       			  ;id
		mov ebx, 2       			  ;stdin used
		mov ecx, input   			  ;variable
		mov edx, 10   		  	  	  ;length of variable
		int 0x80         		 	  ;kernel call
		
		;print input
		;now that we know how to print this should be easy :p
		mov eax, 4       			  ;id
		mov ebx, 1       			  ;stdout used
		mov ecx, input   			  ;data
		mov edx, 10   		  		  ;length
		int 0x80         		 	  ;kernel call
		
		; Exit code
		mov eax, 1
		mov ebx, 0
		int 0x80
```

### Macros
Macros are very similar to functions in high-level programming languages. A macro definition looks like this:
```assembly=
%macro macroName numberOfArguments
    ...some code...
%endmacro
```
Whenever you call a macro, its code "gets inserted" in place of the definition. 
An important thing to note is that arguments are accessed with a `%` preceding the argument index. The argument index **does not use array indexing** so the first argument is accessed with `%1`
Here's how you call a macro:

```assembly=
;macros come first
;macro syntax
;print variable length
%macro print 2
	mov rax, 1         ;id
	mov rdi, 1         ;stdout used
	mov rsi, %1        ;data
	mov rdx, %2        ;length
	syscall            ;kernel call
%endmacro

section .data
	var db "I'm pretty long", 0xa
	len equ $-var

section .text
	global _start
	_start:
		print var,len      ;run macro
	
		mov rax, 60        ;id
		mov rdi, 0         ;exit code
		syscall
```

As you can see we can use the predeclared functionality in `.text`. With this knowledge we can make our lives real easy for our next programs.

```assembly=
;output to stdout
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
               ;four lines of code
		print string, stringLen
		read var, varLen
		print var,varLen
		quit
		
```

### Labels (and jumps)
In order to program control structures (if, for, while, etc.) in assembly we need labels. They allow you to jump over or back to code.

There are 2 different types of labels, numeric and symbolic. while naming these labels, you may not use special characters other than the underscore character( _ ).

Using the suffixes f(forward), b(backward), and N(nearest) you can navigate to these labels, making it possible to program control structures

They are defined as:

```assembly=
5:                   ;define numeric label "5"
symnumber:           ;define symbolic label "symnumber"
```
and are called as:

```assembly=
jmp    symnumberf    ;jumps to next symbolic label "symnumber"
jmp    5f            ;jumps to next numeric label "5"
jmp    5N            ;jumps to nearest numeric label "5"
```

here is an example:
```assembly=
jmp    symnumberf    ;jumps to next symbolic label "symnumber"
jmp    5f            ;jumps to next numeric label "5"
jmp    5N            ;jumps to nearest numeric label "5"
```

used in paralell with these are **jumps** with many different features than the jmp used in the example. these must be used in conjunction with the cmp instruction used to compare 2 variables, and they are:

```assembly=
cmp <op1>, <op2>
je <label>;     if <op1> == <op2>
jne <label>;    if <op1> != <op2>
jl <label>;     signed, if <op1> < <op2>
jle <label>;    signed, if <op1> <= <op2>
jg <label>;     signed, if <op1> > <op2>
jge <label>;    signed; if <op1> >= <op2>
jb <label>;     unsigned, if <op1> < <op2>
jbe <label>;    unsigned, if <op1> <= <op2>
ja <label>;     unsigned, if <op1> > <op2>
jae <label>;    unsigned, if <op1> >= <op2>
```

For example, given the following pseudo-code for signed data:
```assembly=
if (currNum > myMax)
myMax = currNum;
```
And, assuming the following data declarations:
```assembly=
currNum dq 0
myMax dq 0
```



### Functions (oh boy)
When talking about macros, I mentioned that they are similar to funcions. Well, in assembly functions are also a thing. They are pretty similar to syscalls, but there are also some differences, which I'll explain in a bit. 

But before that it is important, when using functions we need to run our code differently.
Run  `nasm -g dwarf2 -f elf64 example.asm -l example.lst`
Then `gcc -g -o example example.o`

A function can be declared as follows:
```assembly=
global name
    name:
        ...some code... 
        ret ;return statement
```

As you might have noticed we don't return anything and because we can't. That is, if we use high-level programming concepts. Our return value is conveniently stored in `rax`. Another thing that's missing is our input arguments. They need to be stored in registers (just like `syscall`s). The list of registers is:
- Argument 1: `rdi`
- Argument 2: `rsi`
- Argument 3: `rdx`

If you scroll up a bit you'll see that they also coincide with the argument registeres used for `syscall`s! 
**Side note**: Floats are much harder to work with than integers and require a different set of operations. Keeping that in mind, the arguments are stored in `xmm0` to `xmm7` and the `return` overwrites `xmm0`. 

### Making the calculator 

Now that you have all the tools you need, you can begin building your very own simple calculator =D

Start off by making the skeleton that we talked about before, but this time more specific to our goal of creating a calculator (with the menu, varaibles and putting some calling to our functions so we know what needs to be done):

```assembly=
; Filename: calculator.asm
; this code was made by Vladislav Serafimov and Stephen Cruz Wright

;macros here


section .data
	intro db "------------Calculator------------", 10
	introLen equ $-intro
	sNum1 db 10, "Please enter your first number: "
	sNum1Len equ $-sNum1
	sNum2 db "Please enter your second number: "
	sNum2Len equ $-sNum2
	oops db 10, "Choose one of the following operations:", 10, "1.Add", 10, "2.Subtract", 10, "3.Multiply", 10, "4.Divide", 10, "5.Quit", 10, 10
	oopsLen equ $-oops
	ans db 10, "Answer:"
	ansLen equ $-ans
	
section .bss ;used to reserve data
	var1 resb 3 ;reserve 3 bytes for var 1
	var2 resb 3
	choice resb 2
	answer resb 10
	
section .text
	global _start
    
	; place functions here
    
_start:
		
		print intro, introLen 	;prints title
		
	StartofLoop:
	
		print sNum1, sNum1Len   ;asks user for num1
		read var1
		
		print sNum2, sNum2Len   ;asks user for num2
		read var2
		
		print oops, oopsLen		;displays choices
		read choice  		    ;reads user's choice
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
		
		lea esi,[answer]
		call toString
		print answer, 1
		
		jmp StartofLoop	;restarts loop
		
	Quit:
		quit ;ends program
```

after that we can get working on our more important macros such as reading from and writing to the terminal with syscalls:

```assembly=
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
```

After that, we begin programming the operations we will need in order to actually make our calulator function as it should:
```assembly= 
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
```
and of course, we need some way out of our little program as we did make it loop infinitely. Using a quit function, we can:
```assembly=
;just exit the program
%macro quit 0
	mov rax, 60        ;id
	mov rdi, 0         ;exit code
	syscall
%endmacro
```

finally, we have finished with the calculator... but whats this? it can only input and output one digit? there are a few ways to get out of this predicament but the one we chose was making a toString function that runs just before printing the answer:
```assembly=
toString:
	  add esi,9
	  mov byte [esi], 0

	  mov ebx,10         
	.next_digit:
	  xor edx,edx         ; Clear edx prior to dividing edx:eax by ebx
	  div ebx             ; eax /= 10
	  add dl,'0'          ; Convert the remainder to ASCII 
	  dec esi             ; store characters in reverse order
	  mov [esi],dl
	  test eax,eax
	  jnz .next_digit     ; Repeat until eax==0
	  mov eax,esi
	  ret
```

### Fin
And there you go, thats it!
Now that wasnt so hard, was it?
... it was? Well imagine doing millions of those instructions per second cos thats what your laptop has to go through most of the time.
Anyway, that was Vlad and Steve, hope you at least learnt something
