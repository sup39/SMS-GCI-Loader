def int2bytes(x):
  return x.to_bytes(4, 'big')

def makeC0(arg):
  ## read bin file
  with open(arg, 'rb') as f:
    raw = f.read()
  ## .align 2
  if len(raw) % 4:
    raw += b'\x00'*(4 - len(raw)%4)
  ## add `blr` to align 3
  if len(raw) % 8:
    raw += b'\x4E\x80\x00\x20'
  ## add C0 header
  raw = b'\xC0\x00\x00\x00' + int2bytes(len(raw) >> 3) + raw
  return raw

def make06(dst, fn):
  ## read bin file
  with open(fn, 'rb') as f:
    raw = f.read()
  size06 = len(raw)
  ## .align 3
  if len(raw) % 8:
    raw += b'\x00'*(8 - len(raw)%8)
  ## header
  return int2bytes(0x06<<24 | dst & 0x1ffffff) + int2bytes(size06) + raw
