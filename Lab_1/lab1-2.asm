section .data
    ; масив рядків для букви Я
    letter db \
    "  █████████", 10, \
    " ███     ███", 10, \
    " ███     ███", 10, \
    "  █████████", 10, \
    "      █████", 10, \
    "     ██  ██", 10, \
    "    ██   ██", 10, \
    "  ███    ██", 10, \
    "███      ██", 10

    len equ $ - letter

section .text
    global _start

_start:
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, letter
    mov edx, len
    int 0x80

    mov eax, 1          ; sys_exit
    xor ebx, ebx
    int 0x80

