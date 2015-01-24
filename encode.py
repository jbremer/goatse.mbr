# import hd

buf = open('goatse.txt').read()

hist = {}
for ch in buf:
    if ch == '0':
        continue

    hist[ch] = hist.get(ch, 0) + 1

lengths = {}

# Remove all newlines and extend each line to 80 characters.
# buf = ''.join(x.ljust(80, ' ') for x in buf.split('\n'))

maxlen = max(len(line) for line in buf.split('\n'))
buf = '\n'.join(' '*((70-maxlen)/2) + line for line in buf.split('\n'))

print 'non-whitespace characters..', len(buf.replace(' ', ''))
print buf

a, b, c, d = 0, 0, 0, 0

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
        print 'whitespaces..', l, (l+15)/16
        if len(out) & 1:
            out.append(' ')
            l -= 1
            idx += 1

        for x in xrange(0, l, 15):
            print l, x, l-x
            out.append(' ')
            out.append(min(15, l-x))

        a += 2
        b += (l + 15) / 16
        c += (l + 14) / 15
        d += 1

        # out.append(None)
        # out.append(l * 2)
        idx += l
        continue

    out.extend([buf[idx]] * l)
    idx += l

# Place the space as first character.
hist = ' ' + ''.join(hist.keys()).replace(' ', '')
print len(hist), repr(hist)

open('lut.bin', 'wb').write(''.join(hist))

idx, buf = 0, ''
while idx != len(out):
    print repr(out[idx]), repr(out[idx+1])
    i0 = out[idx+0] if isinstance(out[idx+0], int) else hist.index(out[idx+0])
    i1 = out[idx+1] if isinstance(out[idx+1], int) else hist.index(out[idx+1])
    buf += chr((i0 << 4) + i1)
    idx += 2

open('goatse.bin', 'wb').write(buf)

print 'length..', len(buf)
print a, b, c, d
