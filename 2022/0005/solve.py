import pathlib, re, sys, os, time
from typing import *

def beat(n=1):
    # input("")
    time.sleep(0.01 * n)

def solve(fname):
    text = pathlib.Path('./input').read_text()
    grid_text, commands = text.split('\n\n')
    g = Grid("\n".join(reversed(grid_text.split("\n"))) + "\n")
    g.show()
    grids = [g]
    for i, command in enumerate(commands.strip().split("\n")):
        num, from_col, to_col = map(int, re.findall(r"move (\d+) from (\d+) to (\d+)", command)[0])
        while num > 0:
            g = g.move(from_col, to_col)
            grids.append(g)
            os.system('clear')
            g.show(fixed=True)
            print_there(0, 0, f"Executing command {i}: move {num} from {from_col} to {to_col}")
            num -= 1
            beat(0)
    tops = ""
    for col in range(1, g.cols + 1):
        try:
            tops += g.pop(col)[0][1]
        except ValueError as e:
            print(repr(e))
    part1_solution = f"Part 1: {tops}"


    g = Grid("\n".join(reversed(grid_text.split("\n"))) + "\n")
    g.show()
    grids = [g]
    for i, command in enumerate(commands.strip().split("\n")):
        num, from_col, to_col = map(int, re.findall(r"move (\d+) from (\d+) to (\d+)", command)[0])
        acc = []
        while num > 0:
            item, g = g.pop(from_col)
            acc.append(item)
            grids.append(g)
            os.system('clear')
            g.show(fixed=True)
            print_there(0, 0, f"Executing command {i}: move {num} from {from_col} to {to_col}")
            num -= 1
            beat(0)
        for item in reversed(acc):
            g = g.push(to_col,item)
        
    tops = ""
    for col in range(1, g.cols + 1):
        try:
            tops += g.pop(col)[0][1]
        except ValueError as e:
            print(repr(e))
    part2_solution = f"Part 2: {tops}"


    os.system('clear')
    print(part1_solution)
    print(part2_solution)
        
    return grids

def print_there(x, y, text):
    # https://stackoverflow.com/a/7415537/303931
    sys.stdout.write("\x1b7\x1b[%d;%df%s\x1b8" % (x, y, text))
    sys.stdout.flush()

EMPTY = '   '
class Grid:
    def __init__(self, grid):
        self.grid = grid
        if len(self.grid) % 4 != 0:
            raise ValueError(len(self.grid))
        self.cols = (1 + grid.index('\n')) // 4
        self.rows = len(self.grid) // (self.cols * 4)  # includes header (effectively 1-indexed)

    def move(self, from_column, to_column, show=False) -> "Grid":
        """
        Returns a Grid with one item moved from `from_column` to `to_column`.
        """
        item, grid = self.pop(from_column)
        if show:
            grid.show(fixed=True)
        return grid.push(to_column, item)

    def position(self, row, col):
        return (row * self.cols * 4) + 4 * (col - 1)

    @property
    def empty_row(self):
        row = "    " * (self.cols - 1) + "   \n"
        assert len(row) % 4 == 0
        return row

    def set(self, row, col, val, overwrite=False) -> "Grid":
        cur = self[row, col]
        if not overwrite and cur != EMPTY:
            raise ValueError(f"Attempting to overwrite an existing value {row=}, {col=}, {val=}, {cur=}")
        grid = self.grid
        if row >= self.rows:
            grid += self.empty_row * (1 + row - self.rows)
        pos = self.position(row, col)
        before = grid[:pos]
        after = grid[pos+3:]
        grid = f"{before}{val}{after}"
        return Grid(grid)
    
    def __getitem__(self, pos):
        row, col = pos  # row is 1-indexed (zero-th row is the column header), col is 1-indexed
        if col > self.cols:
            raise ValueError(col)
        if row < 0:
            row = self.rows + row
        pos = self.position(row, col)
        if pos >= len(self.grid):
            return EMPTY
        return self.grid[pos:pos+3]

    def show(self, fixed=False):
        if fixed:
            print_there(2, 0, '\n'.join(self.grid.split('\n')[:20]))
        else:
            print(self.grid)

    def pop(self, col) -> Tuple[str, "Grid"]:
        """
        Pops the topmost element from the given column.

        Raises an error if there are no entries in that column.
        """
        for row in range(self.rows, 0, -1):
            value = self[row, col]
            if value != EMPTY:
                grid = self.set(row, col, EMPTY, overwrite=True)
                assert grid[row, col] == EMPTY
                return value, grid
        raise ValueError(f"Empty stack {col}")

    def push(self, col, val) -> "Grid":
        topmost_row = None
        for row in range(-1, -self.rows - 1, -1):
            value = self[row, col]
            if value != EMPTY:
                topmost_row = self.rows + row + 1
                break
        assert topmost_row is not None, f"{col}, {val}"
        return self.set(topmost_row, col, val, overwrite=False)
        

if __name__ == "__main__":
    grids = solve(sys.argv[1])