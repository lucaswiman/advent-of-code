from typing import *
from dataclasses import dataclass

@dataclass
class Directory:
    path: str
    parent: Optional["Directory"]
    files: Dict[str, int]
    subdirs: Dict[str, "Directory"]
    
    @classmethod
    def parse(cls, s: str):
        lines = s.strip().split('\n')
        root = Directory("/", None, {}, {})
        cur = None
        for line in lines:
            tokens = line.strip().split()
            if tokens[0:2] == ["$", "cd"]:
                loc = tokens[2]
                if loc == "/":
                    cur = root
                elif loc == '..':
                    cur = cur.parent
                else:
                    if loc not in cur.subdirs:
                        cur.subdirs[loc] = Directory(path=loc, parent=cur, files={}, subdirs={})
                    cur = cur.subdirs[loc]
            elif tokens[0:2]  == ["$", "ls"]:
                pass
            elif tokens[0] == "dir":
                pass
            else:
                cur.files[tokens[1]] = int(tokens[0])
        return root

    def descendants(self):
        yield self
        for d in self.subdirs.values():
            yield from d.descendants()

    @property
    def size(self):
        return sum(self.files.values()) + sum(d.size for d in self.subdirs.values())

if __name__ == "__main__":
    with open('input', 'r') as f:
        directory = Directory.parse(f.read())
    # part 1:
    dirs = [d for d in directory.descendants()]
    dirs.sort(key=lambda d: d.size)
    print(f"Part 1: {sum(d.size for d in dirs if d.size <= 100000)}")
    for d in dirs:
        if d.size >= 30000000:
            print(f"Part 2: {d.size}")
            break

