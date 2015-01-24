bits 16
org 0x7c00

init:
    mov ax, 3
    int 0x10

    xor bx, bx
    push bx
    pop ds
    push 0xb800
    pop es
    mov si, text
    xor di, di
    mov dx, lut

iter:
    lodsb
    test al, al
    jz endline

    movzx cx, al
    and cl, 0x0f
    shr al, 0x04
    test al, al
    jz skipspace

    mov al, byte [edx+eax]
    stosb
    inc di
    mov al, byte [edx+ecx]
    stosb
    inc di
    jmp iter

skipspace:
    add di, cx
    add di, cx
    jmp iter

endline:
    add bx, 80*2
    mov di, bx
    cmp bh, 0x0e
    jnz iter

done:
    mov ch, 0x20
    mov ah, 0x01
    int 0x10

    ; xor ax, ax
    ; int 0x16

    ; ljmp 0xfff0, 0xf000
    ; db 0xea, 0xf0, 0xff, 0x00, 0xf0

lut:
    incbin "lut.bin"

text:
    incbin "goatse.bin"

times 446-($-$$) db 0
times 64 db 0xff
db 0x55, 0xaa
