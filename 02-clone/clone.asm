; The output may sometimes be a bit wonky due to race conditions in writing to
; stdout
%include "lib.h"

global _start

section .text
_start:
    call fork

    cmp rax, 0              ; clone(2) returns child TID in rax to parent and 0
    je  .in_child           ; to the child
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, .in_parent_str
    mov rdx, .in_parent_len
    syscall
    jmp .print_pid

.in_child:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, .in_child_str
    mov rdx, .in_child_len
    syscall

.print_pid
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

; Some strings
.in_parent_str:
    db  'In parent, PID: '
.in_parent_len: equ $ - .in_parent_str
.in_child_str:
    db  'In child, PID: '
.in_child_len:  equ $ - .in_child_str
.nl:
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
