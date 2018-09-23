
'''
Dispatches the integers from 0 to 8, with 0 possibly changed to None,
as a list of 3 lists of size 3, to represent a 9 puzzle.
For instance, [[4, 0, 8], [1, 3, 7], [5, 2, 6]] or [[4, None ,8], [1, 3, 7], [5, 2, 6]]
represents the 9 puzzle   4     8
                          1  3  7
                          5  2  6
with the 8 integers being printed on 8 tiles that are placed in a frame
with one location being tile free.
The aim is to slide tiles horizontally or vertically
so as to eventually reach the configuration
                          1  2  3
                          4  5  6
                          7  8
It can be shown that the puzzle is solvable iff the permutation of
the integers 1,..., 8, determined by reading those integers off the puzzle
from top to bottom and from left to right, is even.
This is clearly a necessary condition since:
- sliding a tile horizontally does not change the number of inversions;
- sliding a tile vertically changes the number of inversions by -2, 0 or 2;
- the parity of the identity is even.

'''


from itertools import chain
from collections import deque


def grid_if_valid_and_solvable_9_puzzle(grid):
    pass
    # Replace pass above with your code


def validate_9_puzzle(grid):
    if grid_if_valid_and_solvable_9_puzzle(grid):
        print('This is a valid 9 puzzle, and it is solvable')
    else:
        print('This is an invalid or unsolvable 9 puzzle')
    
def solve_9_puzzle(grid):
    grid = grid_if_valid_and_solvable_9_puzzle(grid)
    if not grid:
        return
    # Insert your code here
                  
            
