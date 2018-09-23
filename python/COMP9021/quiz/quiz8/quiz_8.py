# Randomly fills a grid of size 10 x 10 with digits between 0
# and bound - 1, with bound provided by the user.
# Given a point P of coordinates (x, y) and an integer "target"
# also all provided by the user, finds a path starting from P,
# moving either horizontally or vertically, in either direction,
# so that the numbers in the visited cells add up to "target".
# The grid is explored in a depth-first manner, first trying to move north,
# always trying to keep the current direction,
# and if that does not work turning in a clockwise manner.
#
# Written by z5140430 and Eric Martin for COMP9021


import sys
from random import seed, randrange

from stack_adt import *


def display_grid():
    for i in range(len(grid)):
        print('   ', ' '.join(str(grid[i][j]) for j in range(len(grid[0]))))

def explore_depth_first(x, y, target):
    total = Stack()
    e_path = Stack()
    e_path.push([(x,y)])
    total.push([grid[x][y],'N'])
    sum = total.peek()[0]
    if target < grid[x][y]:
        return None
    while True:
        if total.peek()[0] == target:
            return e_path.peek()
        # North direction
        if x-1 < 0:
            grid[x][y] = -1
            e_path.push(e_path.peek() + [(x, y + 1)])
            total.push([total.peek()[0] + grid[x][y + 1], 'E'])
            y = y+1
        else:
            while total.peek()[1] == 'N':

                if sum >= target:
                    if sum != target:
                        grid[x][y] = -1
                        e_path.pop()
                        total.pop()
                        x = x + 1
                        e_path.push(e_path.peek() + [(x, y + 1)])
                        total.push([total.peek()[0] + grid[x][y + 1], 'E'])
                        y = y + 1
                        if total.peek()[0] == target:
                            return e_path.peek()
                        break
                    else:
                        return e_path.peek()
                else:
                    if x == 0:
                        e_path.push(e_path.peek() + [(x, y+1)])
                        total.push([total.peek()[0] + grid[x][y+1], 'E'])
                        y = y + 1
                        if total.peek()[0] == target:
                            return e_path.peek()
                        break
                    if grid[x - 1][y] == -1:
                        e_path.push(e_path.peek() + [(x, y + 1)])
                        total.push([total.peek()[0] + grid[x][y + 1], 'E'])
                        y = y + 1
                        if total.peek()[0] == target:
                            return e_path.peek()
                        break
                grid[x][y] = -1
                x = x - 1
                e_path.push(e_path.peek() + [(x, y)])
                total.push([total.peek()[0] + grid[x][y], 'N'])
                sum = total.peek()[0]

        # East direction
        if y+1 > 9:
            e_path.push(e_path.peek() + [(x + 1, y)])
            total.push([total.peek()[0] + grid[x + 1][y], 'S'])
            x = x + 1
        else:
            while total.peek()[1] == 'E':
                 if sum >= target:
                     if sum != target:
                         grid[x][y] = -1
                         e_path.pop()
                         total.pop()
                         y = y - 1
                         e_path.push(e_path.peek() + [(x + 1, y)])
                         total.push([total.peek()[0] + grid[x + 1][y], 'S'])
                         x = x + 1
                         if total.peek()[0] == target:
                             return e_path.peek()
                         break
                     else:
                         return e_path.peek()
                 else:
                     if y == 9:
                         e_path.push(e_path.peek() + [(x+1, y)])
                         total.push([total.peek()[0] + grid[x+1][y], 'S'])
                         x = x + 1
                         if total.peek()[0] == target:
                             return e_path.peek()
                         break
                     if grid[x][y + 1] == -1:
                         e_path.push(e_path.peek() + [(x + 1,y)])
                         total.push([total.peek()[0] + grid[x + 1][y], 'S'])
                         x = x + 1
                         if total.peek()[0] == target:
                             return e_path.peek()
                         break
                 grid[x][y] = -1
                 y = y + 1
                 e_path.push(e_path.peek() + [(x, y)])
                 total.push([total.peek()[0] + grid[x][y], 'E'])
                 sum = total.peek()[0]

        # South direction
        if x+1 > 9:
            e_path.push(e_path.peek() + [(x, y - 1)])
            total.push([total.peek()[0] + grid[x][y - 1], 'W'])
            y = y - 1
        else:
            while total.peek()[1] == 'S':
                 if sum >= target:
                     if sum != target:
                         grid[x][y] = -1
                         e_path.pop()
                         total.pop()
                         x = x - 1
                         e_path.push(e_path.peek() + [(x, y - 1)])
                         total.push([total.peek()[0] + grid[x][y - 1], 'W'])
                         y = y - 1
                         if total.peek()[0] == target:
                             return e_path.peek()
                         break
                     else:
                         return e_path.peek()
                 else:
                     if x == 9:
                         e_path.push(e_path.peek() + [(x, y-1)])
                         total.push([total.peek()[0] + grid[x][y-1], 'W'])
                         y = y - 1
                         if total.peek()[0] == target:
                             return e_path.peek()
                         break
                     if grid[x + 1][y] == -1:
                         e_path.push(e_path.peek() + [(x, y - 1)])
                         total.push([total.peek()[0] + grid[x][y - 1], 'W'])
                         y = y - 1
                         if total.peek()[0] == target:
                             return e_path.peek()
                         break
                 grid[x][y] = -1
                 x = x + 1
                 e_path.push(e_path.peek() + [(x, y)])
                 total.push([total.peek()[0] + grid[x][y], 'S'])
                 sum = total.peek()[0]
            sum = total.peek()[0]


        # West direction
        if y-1 < 0:
            e_path.push(e_path.peek() + [(x - 1, y)])
            total.push([total.peek()[0] + grid[x - 1][y], 'N'])
            x = x - 1
        else:
            while total.peek()[1] == 'W':

                 if sum >= target:
                     if sum != target:
                         grid[x][y] = -1
                         e_path.pop()
                         total.pop()
                         y = y + 1
                         e_path.push(e_path.peek() + [(x - 1, y)])
                         total.push([total.peek()[0] + grid[x - 1][y], 'N'])
                         x = x - 1
                         if total.peek()[0] == target:
                             return e_path.peek()
                         break
                     else:
                         return e_path.peek()
                 else:

                     if y == 0:
                         e_path.push(e_path.peek() + [(x - 1, y)])
                         total.push([total.peek()[0] + grid[x - 1][y], 'N'])
                         x = x - 1
                         if total.peek()[0] == target:
                             return e_path.peek()
                         break
                     if grid[x][y - 1] == -1:
                         e_path.push(e_path.peek() + [(x - 1, y)])
                         total.push([total.peek()[0] + grid[x - 1][y], 'N'])
                         x = x - 1
                         if total.peek()[0] == target:
                             return e_path.peek()
                         break
                 grid[x][y] = -1
                 y = y - 1
                 e_path.push(e_path.peek() + [(x, y)])
                 total.push([total.peek()[0] + grid[x][y], 'W'])
                 sum = total.peek()[0]




try:
    for_seed, bound, x, y, target = [int(x) for x in input('Enter five integers: ').split()]
    if bound < 1 or x not in range(10) or y not in range(10) or target < 0:
        raise ValueError
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()
seed(for_seed)
grid = [[randrange(bound) for _ in range(10)] for _ in range(10)]
print('Here is the grid that has been generated:')
display_grid()
path = explore_depth_first(x, y, target)
if not path:
    print(f'There is no way to get a sum of {target} starting from ({x}, {y})')
else:
    print('With North as initial direction, and exploring the space clockwise,')
    print(f'the path yielding a sum of {target} starting from ({x}, {y}) is:')
    print(path)
