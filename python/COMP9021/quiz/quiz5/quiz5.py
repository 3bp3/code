# Randomly fills a grid of size height and width whose values are input by the user,
# with nonnegative integers randomly generated up to an upper bound N also input the user,
# and computes, for each n <= N, the number of paths consisting of all integers from 1 up to n
# that cannot be extended to n+1.
# Outputs the number of such paths, when at least one exists.
#
# Written by z5140430 and Eric Martin for COMP9021


from random import seed, randint
import sys
from collections import defaultdict


def display_grid():
    for i in range(len(grid)):
        print('   ', ' '.join(str(grid[i][j]) for j in range(len(grid[0]))))

def get_paths(value,i,j):
    count = 1
    grid[i][j] = -1
    if j>0 and grid[i][j - 1] == value+1 and grid[i][j] > 0:
        count += get_paths(value+1,i,j - 1)
    elif j < width-1 and grid[i][j + 1] == value+1 and grid[i][j] > 0:
        count += get_paths(value+1,i,j + 1)
    elif i>0 and grid[i - 1][j] == value+1 and grid[i][j] > 0:
        count += get_paths(value+1,i - 1,j)
    elif i < height-1 and grid[i + 1][j] == value+1 and grid[i][j] > 0:
        count += get_paths(value+1,i+1,j)
    return count

# Insert your code for other functions
    
try:
    for_seed, max_length, height, width = [int(i) for i in
                                                  input('Enter four nonnegative integers: ').split()
                                       ]
    if for_seed < 0 or max_length < 0 or height < 0 or width < 0:
        raise ValueError
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()

seed(for_seed)
grid = [[randint(0, max_length) for _ in range(width)] for _ in range(height)]
print('Here is the grid that has been generated:')
display_grid()
paths = [0]*(max_length +1)
for i in range(height):
    for j in range(width):
        print(f'i,j = {i,j}')
        if grid[i][j] == 1:
            print((i,j),get_paths(1,i,j))
            paths[get_paths(1,i,j)] += 1
            


if paths:
    for length in range(1,max_length+1):
        print(f'The number of paths from 1 to {length} is: {paths[length]}')
