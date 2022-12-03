; assemble: nasm -f elf64 cat.asm
; link:     ld -m elf_x86_64 cat.o -o cat
;
; usage: cat [file] ...
; concatenate the given files (up to a total of 4 KiB) and print onto stdout
; any errors results in aborting and not printing anything
SYS_READ    equ 0x00
SYS_WRITE   equ 0x01
SYS_OPEN    equ 0x02
SYS_CLOSE   equ 0x03
SYS_EXIT    equ 0x3c

STDOUT      equ 1

O_RDONLY    equ 0o00        ; from bits/fcntl-linux.h

global _start

section .text
_start:
    pop r12                 ; save argc - 1
    dec r12
    add rsp, 8              ; files to read begin at argv[1]

    test r12, r12           ; no files? done
    jz  .exit               ; rax startx off at 0

    mov r15, buf            ; get the start of our buffer

.get_fd:
    mov rax, SYS_OPEN       ; grab a file descriptor
    mov rdi, [rsp]          ; name
    mov rsi, O_RDONLY       ; flags
    syscall
    mov r13, rax            ; save fd in r13

    neg rax                 ; syscalls return -ERRNO on errors
    jg  .exit               ; is the fd good? (exit if originally < 0)

    mov rax, SYS_READ       ; read as much of the file as possible, will either
    mov rdi, r13            ; fill the buffer in one go, or read the entire file
    mov rsi, r15
    mov rdx, buf_end
    sub rdx, r15
    syscall

    mov rdx, rax
    neg rax                 ; did the read succeed?
    jg  .exit
    add r15, rdx            ; then move our pointer up

    mov rax, SYS_CLOSE      ; close the fd
    mov rdi, r13
    syscall

    cmp r15, buf_end        ; have we filled the buffer?
    je  .print

    add rsp, 8              ; otherwise go to the next file
    dec r12
    jnz .get_fd

.print:
    mov rax, SYS_WRITE      ; finally, write the stuff
    mov rdi, STDOUT
    mov rsi, buf
    mov rdx, r15            ; get the length from the pointer position
    sub rdx, rdi
    syscall

    mov rax, 0              ; success

.exit:
    mov rdi, rax            ; grab the exit code from rax
    mov rax, SYS_EXIT
    syscall

section .bss
buf:        resb    4096    ; buffer to store our concatenated files in before
buf_end:                    ; printing

; vim: filetype=asm syntax=nasm:
