; assemble: nasm -f elf64 clone.asm
%include "lib.h"

global _start

section .text
_start:
    mov rax, SYS_GETPID
    syscall

    mov rdi, rax
    call printu

    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
