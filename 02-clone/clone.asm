; TODO:
;   - print whether in parent or child after fork
%include "lib.h"

global _start

section .text
_start:
    call fork

    mov rax, SYS_GETPID
    syscall

    mov rdi, rax
    call printu

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, .nl
    mov rdx, 1
    syscall

    mov rax, SYS_EXIT
    mov rdi, 0
    syscall

.nl:                        ; Just store a newline
    db  0x0a

; Implement fork(2) with clone(2)
; Basically just call clone(2) with flags set to SIGCHLD
fork:
    mov rax, SYS_CLONE
    mov rdi, SIGCHLD        ; flags
    mov rsi, NULL           ; new stack pointer (NULL means dup and use cow)
    mov rdx, NULL           ; child's TID pointer (in parent) (unused)
    mov r10, NULL           ; child's TID pointer (in child) (unused)
    mov r8, NULL            ; pointer to new TLS (unused)
    syscall

    ret

; vim: filetype=asm syntax=nasm:
