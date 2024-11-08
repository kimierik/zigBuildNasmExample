section .data
message db 'Hello, nasm!', 10
.len: equ $ - message

section .text
global NasmGreet
NasmGreet:
    mov eax, 4
    mov ebx, 1 
    mov ecx, message
    mov edx, message.len
    int 0x80

    ret
