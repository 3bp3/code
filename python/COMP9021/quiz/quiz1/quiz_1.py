# Written by z5140430 and Eric Martin for COMP9021


'''
Generates a list L of random nonnegative integers smaller than the length of L,
whose value is input by the user, and outputs two lists:
- a list M consisting of L's middle element, followed by L's first element,
  followed by L's last element, followed by L's second element, followed by
  L's penultimate element...;
- a list N consisting of L[0], possibly followed by L[L[0]], possibly followed by
  L[L[L[0]]]..., for as long as L[L[0]], L[L[L[0]]]... are unused, and then,
  for the least i such that L[i] is unused, followed by L[i], possibly followed by
  L[L[i]], possibly followed by L[L[L[i]]]..., for as long as L[L[i]], L[L[L[i]]]...
  are unused, and then, for the least j such that L[j] is unused, followed by L[j],
  possibly followed by L[L[j]], possibly followed by L[L[L[j]]]..., for as long as
  L[L[j]], L[L[L[j]]]... are unused... until all members of L have been used up.
'''


import sys
from random import seed, randrange


try:
    arg_for_seed, length = input('Enter two nonnegative integers: ').split()
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()
try:
    arg_for_seed, length = int(arg_for_seed), int(length)
    if arg_for_seed < 0 or length < 0:
        raise ValueError
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()

seed(arg_for_seed)
L = [randrange(length) for _ in range(length)]
print('\nThe generated list L is:')
print('  ', L)
M = []
N = []

# calculate M
M = [0]*length
start_position = length//2
M[0] = L[start_position]
for i in range(start_position):
    M[2*i+1] = L[i]
for j in range(start_position-(length+1)%2):
    M[2*(j+1)] = L[length-1-j]   

    
# calculate N 
N = [0] * length
L_cp=list(L)
N[0] = L_cp[0]
L_cp[0] = 'u'
i=1
while i < length:
    if L_cp[N[i-1]] != 'u':
        N[i] = L_cp[N[i-1]]
        L_cp[N[i-1]] = 'u'
    else:
        for j in range(length):
            if L_cp[j] != 'u':
                N[i] = L_cp[j]
                L_cp[j] = 'u'
                break
    i += 1
    
print('\nHere is M:')
print('  ', M)
print('\nHere is N:')
print('  ', N)
print('\nHere is L again:')
print('  ', L)


