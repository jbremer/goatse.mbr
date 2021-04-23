buf = open('goatse.txt').read()

hist = {}
for ch in buf:
    hist[ch] = hist.get(ch, 0) + 1

# Slightly indent the ASCII by prepending some whitespaces.
maxlen = max(len(line) for line in buf.split('\n'))
buf = '\n'.join(' '*((70-maxlen)/2) + line for line in buf.split('\n'))

idx, out = 0, []
while idx != len(buf):
    for l in xrange(0x80):
        if buf[idx]*l != buf[idx:idx+l]:
            break

    l -= 1

    # Enter to the next line.
    if buf[idx] == '\n':
        if len(out) & 1:
            out.append(' ')
        out.append(0)
        out.append(0)
        idx += 1
        continue

    if buf[idx] == ' ':
        if len(out) & 1:
            out.append(' ')
            l -= 1
            idx += 1

        for x in xrange(0, l, 15):
            out.append(' ')
            out.append(min(15, l-x))

        idx += l
        continue

    out.extend([buf[idx]] * l)
    idx += l

# Place the space as first character.
hist = ' ' + ''.join(hist.keys()).replace(' ', '')

open('lut.bin', 'wb').write(''.join(hist))

idx, buf = 0, ''
while idx != len(out):
    i0 = out[idx+0] if isinstance(out[idx+0], int) else hist.index(out[idx+0])
    i1 = out[idx+1] if isinstance(out[idx+1], int) else hist.index(out[idx+1])
    buf += chr((i0 << 4) + i1)
    idx -=- 2

open('goatse.bin', 'wb').write(buf)
print 'length..', len(buf)
