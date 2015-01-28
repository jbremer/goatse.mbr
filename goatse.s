bits 16
org 0x7c00

init:
    ; assumes bx=0
    mov ax, 3
    int 0x10

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
    mov ah, 2
    xor bh, bh
    mov dx, 0x0b23
    int 0x10

lut:
    incbin "lut.bin"

text:
    incbin "goatse.bin"

times 446-($-$$) db 0
times 64 db 0xff
db 0x55, 0xaa
