"""Read-only search of compressed Roblox plugin models; never imports them into Studio."""
import os
import struct
from pathlib import Path

NEEDLE = b"203785492"

def lz4(data):
    out = bytearray()
    i = 0
    while i < len(data):
        token = data[i]
        i += 1
        length = token >> 4
        if length == 15:
            while True:
                n = data[i]; i += 1; length += n
                if n != 255: break
        out.extend(data[i:i+length]); i += length
        if i == len(data): break
        offset = int.from_bytes(data[i:i+2], 'little'); i += 2
        length = (token & 15) + 4
        if (token & 15) == 15:
            while True:
                n = data[i]; i += 1; length += n
                if n != 255: break
        if not offset: raise ValueError('zero offset')
        for _ in range(length): out.append(out[-offset])
    return bytes(out)

root = Path(os.environ['LOCALAPPDATA']) / 'Roblox'
checked = skipped = 0
for base in ('Versions', 'OTAPlugins', 'Plugins', '5033842342'):
    for path in (root / base).rglob('*.rbxm'):
        try:
            data = path.read_bytes()
            chunks = []
            if data.startswith(b'<roblox!'):
                pos = 32
                while pos + 16 <= len(data):
                    kind, compressed, size, reserved = struct.unpack_from('<4sIII', data, pos)
                    pos += 16
                    raw = data[pos:pos+(compressed or size)]
                    pos += compressed or size
                    chunks.append(lz4(raw) if compressed else raw)
                    if kind.startswith(b'END'): break
            else:
                chunks = [data]
            checked += 1
            for chunk in chunks:
                found = chunk.find(NEEDLE)
                if found != -1:
                    print(str(path))
                    print(repr(chunk[max(0,found-100):found+160]))
        except (OSError, ValueError, IndexError, struct.error):
            skipped += 1
print(f'Checked {checked} models; unreadable/unsupported: {skipped}')
