section .data
    A           dw 50      ; (word)
    B           db 5       ; (byte)
    C_val       db 12      ; (byte)
    D           db 20      ; (byte)
    E           dw 300     ; (word)
    K           equ 2513   ; константа K

    X           dd 0       ; результат
    newline     db 10      ; \n
    minus_sign  db '-'     ; то просто -

section .bss
    buffer      resb 11    ; буфер під , аналог sprintf, ну майже

section .text
    global _start

print_newline:          ; printf(\n);
    push eax            ; сейвим регістри в стек
    push ebx
    push ecx
    push edx

    mov eax, 4          ; кличем sys_write (4)
    mov ebx, 1          ; кидаєм все в stdout
    mov ecx, newline    ; вказівник на '\n'
    mov edx, 1          ; довжина(в нас тільки \n)
    int 0x80            ; syscall

    pop edx             ; згружаєм регістри з стеку
    pop ecx
    pop ebx
    pop eax
    ret                 ; RETURN back to where 'call' was made

_start:
    ; рахуєм A^2 / B
    mov ax, [A]            ; пхаєм A в ax
    imul ax                ; ax^2
    movzx ecx, byte [B]    ; байт B в ecx але так щоб решта 32-8 = 24 біти були 0(щоб правильно поділити)
    div cx                 ; ділить ax на cx, частка туди ж , залишок в dx
    movzx ebx, ax          ; тимчасово зберігаємо результат в ebx (Temp1)

    ; тепер (D + E - K), тут прості + і -
    movzx eax, byte [D]
    movzx ecx, word [E]
    add eax, ecx
    sub eax, K             ; ! результат в eax

    ; C * (D + E - K)
    movsx ecx, byte [C_val]; наше C
    imul eax, ecx          ; множимо (Temp2)

    ; Temp1 + Temp2
    add eax, ebx
    mov [X], eax           ; Зберігаємо результат в наш X

    call print_newline

    call print_int

    call print_newline
    call print_newline

    ; Кінець
    mov eax, 1             ; кличем sys_exit
    mov ebx, 0             ; return 0
    int 0x80               ; переривання

print_int:
    test eax, eax          ; оновляєм прапорці
    jns .prepare           ; +?

    ; якщо < 0
    push eax               ;ну тут просто сейв даних і '-' в консоль

    mov eax, 4
    mov ebx, 1
    mov ecx, minus_sign
    mov edx, 1
    int 0x80

    pop eax

    neg eax                ; ну і перетворюєм число з доповняльного в прямий

.prepare:
    mov ecx, buffer + 10   ; &кінець масиву
    mov ebx, 10            ; просто 10 <────┐
.loop:                     ;                |
    mov edx, 0             ;                |
    div ebx                ;ділим eax на 10─┘
    add dl, '0'            ; + '0' aka + 48, конвертуєм 2 в '2'
    dec ecx                ; зменшує адресу в ECX на 1
    mov [ecx], dl          ; наше '2' в ecx
    test eax, eax          ; перевіряє чи залишилося шось від нашого числа
    jnz .loop              ; якшо тут 0 , то кінець

    ; це вже просто std:cout << шо ми нам раніше нарахували
    mov eax, 4
    mov ebx, 1
    mov edx, buffer + 10
    sub edx, ecx           ; довжина рядка
    int 0x80
    ret
