import sys
import os
from GeckoFactory import int2bytes, make06, makeC0

validArguments = '''
  C0:{input.bin}
  hook:{input.map}:{input.bin}:{symbol=fromAddr}...
'''[1:-1]

def exitInvalidSyntax(arg):
  print('Invalid argument `%s`\nValid arguments:\n%s'%(arg, validArguments))
  sys.exit(1)
def exitMessage(msg):
  print(msg)
  sys.exit(1)

def printCode(raw, file=sys.stdout):
  assert len(raw)%8 == 0, \
      f'Expect code with length of multiple of 8, got {len(raw)}'
  for i in range(0, len(raw), 8):
    print(raw[i:i+4].hex().upper(), raw[i+4:i+8].hex().upper(), file=file)

def loadHookDB(fn):
  import csv
  with open(fn) as f:
    reader = csv.DictReader(f)
    return {
      row['symbol']: row
      for row in reader
    }

def parseMap(fn):
  with open(fn) as f:
    sections = {}
    symbols = {}
    for line in f:
      args = line.split()
      try:
        if line.startswith('.') and len(args) == 3:
          # .text 0x00000000817fe800 0x1dc
          sections[args[0]] = int(args[1], 16)
        elif len(args) == 2:
          # 0x00000000817fe800 loadCard
          symbols[args[1]] = int(args[0], 16)
      except: pass
  return sections, symbols

if __name__ == '__main__':
  if len(sys.argv) < 2:
    print('Usage: %s {ARG}...\nARG:\n%s'%(sys.argv[0], validArguments))
    sys.exit(1)

  __dirname = os.path.dirname(__file__)
  hookDB = loadHookDB(os.path.join(__dirname, './hook.csv'))

  code = b''
  for arg0 in sys.argv[1:]:
    toks = arg0.split(':', 1)
    if len(toks) != 2: exitInvalidSyntax(arg)
    ct, arg = toks
    if ct == 'C0':
      code += makeC0(arg)
    elif ct == 'hook':
      args = arg.split(':')
      if len(args) < 3: exitInvalidSyntax(arg)
      fnMap, fnBin, *entries = args
      ## parse map file
      sections, symbols = parseMap(fnMap)
      assert '.text' in sections, f'.text section does not exists in file {fnMap}'
      dst = sections['.text']
      ## 06
      code += make06(dst, fnBin)
      ## 04 entries
      for entry in entries:
        toks = entry.split('=')
        name = toks[0]
        if len(toks) == 1:
          version = os.environ.get('GAME_VERSION')
          if not version: exitMessage('Environment variable `GAME_VERSION` is not set. Please set the GAME_VERSION environment variable or specify the address manually')
          if name not in hookDB: exitMessage('The address for symbol `%s` is unknown. Please specify it manually\nSyntax: {name}={addr}'%name)
          hook = hookDB[name]
          if version not in hook: exitMessage(f'Invalid GAME_VERSION: {version}')
          addr0 = int(hook[version], 16)
        elif len(toks) == 2:
          try:
            addr0 = int(toks[1], 16)
          except ValueError:
            exitInvalidSyntax(arg)
        else:
          exitInvalidSyntax(arg)
        assert name in symbols, f'symbol `{name}` does not exists in file {fnMap}'
        addr1 = symbols[name]
        dis = addr1 - addr0
        assert -0x200_0000 <= dis < 0x200_0000, 'too far to branch from %s(%08X) to %08X'%(name, addr0, addr1)
        ## make 04
        code += int2bytes(0x0400_0000 | addr0 & 0x1ff_ffff)
        code += int2bytes(0x4800_0001 | dis   & 0x3ff_ffff)
    else:
      exitInvalidSyntax(arg)

  printCode(code)
