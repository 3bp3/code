# Prompts the user for a strictly positive number N
# and outputs an equilateral triangle of height N.
# The top of the triangle (line 1) is labeled with the letter A.
# For all nonzero p < N, line p+1 of the triangle is labeled
# with letters that go up in alphabetical order modulo 26
# from the beginning of the line to the middle of the line,
# starting wth the letter that comes next in alphabetical order
# modulo 26 to the letter in the middle of line p,
# and then down in alphabetical order modulo 26
# from the middle of the line to the end of the line.


# Insert your code here

import sys
try:
    N = int(input('Enter strictly positive number: '))
except ValueError:
    print('Please enter again')
    sys.exit()
last_letter = 65
for i in range(1,N+1):
    print(' '*(N-i), end = '')
    for j in range(1,i):
        print(chr(last_letter), end = '')
        last_letter = (last_letter - 65 + 1) % 26 + 65
    print(chr(last_letter), end = '')
    for e in range(1,i):
        print(chr((last_letter - 65 - e) % 26 + 65), end='')
    print('\n',end = '')
    last_letter = (last_letter - 65 + 1) % 26 + 65
