import sys

if len(sys.argv) != 4:
  print('Usage: %s {block-count} {content.bin} {out.gci}'%sys.argv[0], file=sys.stderr)
  sys.exit(1)

blockCount = int(sys.argv[1])
contentPath = sys.argv[2]
outPath = sys.argv[3]

gameId = b'GMSJ01\xff\x00' # TODO other version
fileName = b'gct'

pad = lambda buf, size: buf+b'\x00'*(size-len(buf))
with open(contentPath, 'rb') as fr, open(outPath, 'wb') as fw:
  content = fr.read()
  bodySize = 0x2000*blockCount
  assert len(content)<=bodySize, f'{contentPath} is too big: expect at most {bodySize} bytes, got {len(content)}'
  fw.write(b''.join((
    # header
    gameId,
    pad(fileName, 0x20),
    b'\x00'*16,
    blockCount.to_bytes(2, 'big'),
    b'\xff'*6,
    # body
    pad(content, bodySize),
  )))
