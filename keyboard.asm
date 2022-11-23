; ---------------------------------------------------------------
; Read a 2 digit decimal number and then print it to the console.
; Runs on 64-bit x86 Linux only.
; ---------------------------------------------------------------

section .bss
    variable: RESD 1               ; 4 bytes 

section .data
     newline db 10                  ; UNICODE 10 is new line character 
     prompt db "Enter a number: ", 13, 10, '$'
     input resd 1 ; something I can using to store the users input.

     
     number db "Number: ******", 13, 10, '$'

section .text
    global _start                  ; entry point for linker

    _start:                        ; start here
        ; read 2 bytes from stdin 
        mov rax, 3                 ; 3 is recognized by the system as meaning "read"
        mov rdx, 0                 ; read from standard input
        mov rcx, variable          ; address of number to input
        mov rdx, 2                 ; number of bytes
        int 0x80                   ; call the kernel

        mov ah, 9
        mov edx, prompt
        int 21h
        mov ah, 08h
        while:
            int 21h
                    ; some code that should store the input.
            mov [input], al
            cmp al, 13
            jz endwhile
            jmp while
        endwhile:

        mov ah, 9
            ; displaying the input.

        mov edx, number
        int 21h
        ret


        ; print a byte to stdout
        mov rax, 4                 ; the system interprets 4 as "write"
        mov rbx, 1                 ; standard output (print to terminal)
        mov rcx, variable          ; pointer to the value being passed
        mov rdx, 2                 ; length of output (in bytes)
        int 0x80                   ; call the kernel


        ; print a new line
        mov rax, 1
        mov rdi, 1

        mov rsi, newline

        mov rdx, 1

        syscall

        mov rax, 60                ; system call for exit 
        mov rdi, 0                 ; exit code 0 
        syscall                    ; invoke operating system to exit 