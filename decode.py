buf = open('goatse.bin', 'rb').read()
lut = open('lut.bin', 'rb').read()

out = ''
for ch in buf:
    if ch == '\x00':
        out += '\n'
        continue

    if not ord(ch) >> 4:
        out += ' '*(ord(ch) & 15)
        continue

    out += lut[ord(ch) >> 4] + lut[ord(ch) & 15]

print out
