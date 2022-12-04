%include "lib.h"

section .text
; void printu (u64 num)
; print u64 as decimal
printu:
    xor rdx, rdx            ; Prep for division
    xor rax, rax            ; div does rdx:rax / r/m64
    mov rax, rdi            ; Quot in rax, rem in rdx
    mov rcx, 10             ; Divisor

    std                     ; Build the string in reverse
    lea rdi, [.buf + 19]

.loop:
    div rcx                 ; Get the next digit
    xchg rax, rdx
    add al, '0'
    stosb

    xchg rax, rdx           ; Restore correct register ordering for div and wipe
    xor rdx, rdx            ; the remainder
    cmp rax, 0
    jne .loop

    cld                     ; Restore forward direction

    lea rdx, [.buf + 20]    ; Get the final length
    sub rdx, rdi

    mov rax, SYS_WRITE      ; Print the string
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

    ret

section .bss
printu.buf:                 ; Buffer for the stringified int
    resb 20

; vim: filetype=asm syntax=nasm:
