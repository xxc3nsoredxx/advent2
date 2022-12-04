%ifndef _ADVENT2_LIB
%define _ADVENT2_LIB

%define SYS_READ    0x00
%define SYS_WRITE   0x01
%define SYS_OPEN    0x02
%define SYS_CLOSE   0x03
%define SYS_GETPID  0x27
%define SYS_CLONE   0x38
%define SYS_EXIT    0x3c

%define STDOUT      1

%define O_RDONLY    0o00    ; From bits/fcntl-linux.h

%define SIGCHLD     17      ; From bits/signum-arch.h

%define NULL        0

extern printu

%endif

; vim: filetype=asm syntax=nasm:
