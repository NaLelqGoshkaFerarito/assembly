# Assembly (NASM) tutorial
by Stephen Cruz Wright and Vladislav Serafimov

This is a tutorial for anyone who wants to start programming 

## Setting up the environment and running code 

### **I. Setup**

### 1. (optional) Set up the text editor

In this tutorial, I’ll be using Notepad++ (but you can use whatever you want). The syntax highlighting and setup instructions I’m using can be found here:
```https://github.com/xram64/6502-npp-syntax```

Your code should look like this now

![](https://i.imgur.com/VE4X4Xg.png)

 

### 2. Download Ubuntu for Windows 

The instructions for this part can be found on Blackboard (APC->General information-> Installing Ubuntu 22.04 LTS on Windows) 

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

I saved it as `ex.asm` and that’s what I’ll use from now on. 

### 5. Check your default directory

This can be done by running the command: explorer.exe `wslpath -w "$PWD"` 

Create a new folder (`proj` for me) in the default directory and save `ex.asm` there 


### **II.Running code**

### 1. Create object (.o) file

Use this command: `nasm -f elf64 –o ex.o ex.asm` 
`-f` specifies the file type
`-o` specifies the output

*Note: The .asm and .o files can have different names*

### 2. Create executable 

Use this command: `ld ex.o -o ex` 
`-o` specifies the output

*Note: The .o files and the executables can have different names*

### 3. Run your executable
Use this command: `./ex`
 
If (almost) everything up until now went fine, you should be looking at something like this 
![](https://i.imgur.com/JIdC1PY.png)

*Note: The example uses different names for demonstrational purposes*

## Writing assembly code

### Printing out
In order to be able to print something out you first need to understand what **system calls** are.

>A **system call** can be thought of as a function that requests some functionality from the kernel

There's hundreds of system calls and in order to be able to use the one you need you have to know:
- Its unique **ID**
- What **arguments** it takes

When you know that you also need to know **which registers you need to store them in**. For your convenience here's a list:

0. **ID**: in ```rax```
1. Argument **1**: in ```rdi```
2. Argument **2**: in ```rsi```
3. Argument **3**: in ```rdx```
4. Argument **4**: in ```r10```
5. Argument **5**: in ```r8```
6. Argument **6**: in ```r9```

After you have everything in place you need to **call the kernel** using`int 0x80`

For `sys_write` we need:
- ID = 4
- Argument 1 = 1 (denoting the use of the standard output)
- Argument 2 = the address of what you want to output
- Argument 3 = the number of characters that you want to output

In assembly code this would look like this

This should work (but it doesn't):
```assembly=
section .text
    global _start
_start: 
;printing
    mov rax, 4         ;id
    mov rdi, 1         ;stdout used
    mov rsi, myVar     ;data
    mov rdx, myLen     ;length
    int 0x80           ;kernel call
    
;exiting
    mov eax, 1         ;id
    mov ebx, 0         ;exit code
    int 80h            ;kernel call

section .data
    myVar db "Hi", 0xa ;the 0xa(=10=LF(stands for linefeed)) is equvalent to \n
    myLen equ $-myVar  ;the length of myVar
```
This shouldn't work (but it does):
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
