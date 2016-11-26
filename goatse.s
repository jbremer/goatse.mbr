bits 16                 ;16-bit mode
org 0x7c00

init:
    ; assumes bx=0
    mov ax, 3           ;because some BIOS crash without this
    int 0x10

    push bx             ;\
    pop ds              ; \These two lines not always nessesary, but leaving them in
    push 0xb800         ;text video memory
    pop es              ;into es register
    mov si, text        ;source index has pointer to goatse image
    xor di, di          ;clear destination index
    mov dx, lut         ;character set pointer to dx register
    jmp iter

nextimage:
    mov si, text + 0x013d           ;location of next image in goatse.bin
    mov bx, 0x0460                  ;location on screen to print anus
    mov di, bx                      ;likewise
    mov byte [color + 1], 0x04      ;change the color to red (self-modifying code)
    mov word [lastline + 2], 0x0a00

iter:
    ;The main loop to print all of the characters
    lodsb               ;get character from goatse image (and store in al register)
    test al, al         ;is it null? (end of a line)
    jz endline          ;if so, do the end-of-line routine

    movzx cx, al        ;goatse chars into cx
    and cl, 0x0f        ;mask for the 2nd char (still in cl)
    shr al, 0x04        ;shift for first char in al
    test al, al         ;if there is no char
    jz skipspace        ;then it is a command for how many spaces to skip

    mov al, byte [edx+eax]      ;character to use in lut.bin set, indexed with eax
    color: mov ah, 0x0e                ;Yellow text on black background
    stosw                       ;display the pixel
    mov al, byte [edx+ecx]      ;;character to use in lut.bin set, indexed with ecx
    stosw                       ;display the pixel
    xor ax, ax                  ;clear a register
    jmp iter                    ;repeat

skipspace:
    add di, cx                  ;increment video buffer by cx characters (if character was less than 16)
    add di, cx                  ;^^^
    jmp iter                    ;next character

endline:
    add bx, 80*2        ;amount of chars for a line
    mov di, bx          ;put the next into the new di location
    lastline: cmp bx, 0x0dc0      ;Is it the last line?
    jb iter             ;if not, keep going

done:
    cmp bx, 0x0dc0      ;if it was the last line
    je nextimage        ;go to the next image
    mov ah, 2           ;set cursor position
    xor bh, bh          ;page number is 0
    mov dx, 0x0b23      ;Row 0x0b, Column 0x23 (put cursor in the butthole)
    int 0x10            ;call the BIOS function

lut:
    ;an index of characters used for display
    incbin "lut.bin"

text:
    ;If byte is less than 0x0f, skip that many spaces (if 0x0c, then skip 12 spaces)
    ;otherwise, high nibble first, low nibble next; as an index into the lut.bin character list
    incbin "goatse.bin"

;BIOS sig and padding
times 510-($-$$) db 0
dw 0xAA55
