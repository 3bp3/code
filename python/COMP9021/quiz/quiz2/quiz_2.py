# Written by z5140430 and Eric Martin for COMP9021


'''
Generates a list L of random nonnegative integers, the largest possible value
and the length of L being input by the user, and generates:
- a list "fractions" of strings of the form 'a/b' such that:
    . a <= b;
    . a*n and b*n both occur in L for some n
    . a/b is in reduced form
  enumerated from smallest fraction to largest fraction
  (0 and 1 are exceptions, being represented as such rather than as 0/1 and 1/1);
- if "fractions" contains then 1/2, then the fact that 1/2 belongs to "fractions";
- otherwise, the member "closest_1" of "fractions" that is closest to 1/2,
  if that member is unique;
- otherwise, the two members "closest_1" and "closest_2" of "fractions" that are closest to 1/2,
  in their natural order.
'''


import sys
from random import seed, randint
from math import gcd


try:
    arg_for_seed, length, max_value = input('Enter three nonnegative integers: ').split()
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()
try:
    arg_for_seed, length, max_value = int(arg_for_seed), int(length), int(max_value)
    if arg_for_seed < 0 or length < 0 or max_value < 0:
        raise ValueError
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()

seed(arg_for_seed)
L = [randint(0, max_value) for _ in range(length)]
if not any(e for e in L):
    print('\nI failed to generate one strictly positive number, giving up.')
    sys.exit()
print('\nThe generated list is:')
print('  ', L)

fractions = []
spot_on, closest_1, closest_2 = [None] * 3

fractions2 = []
raw_f = []
new_f = []

from fractions import Fraction
if length == 1:
    closest_1 = max_value
    fractions.append(str(max_value))
else:
    new_L = sorted(L)

    for i in range(length-1):
        for j in range(i+1,length):
            if new_L[i]<=new_L[j] and new_L[j] != 0:
                raw_f.append((new_L[i],new_L[j]))

    next_f = list(set(raw_f))
    next_f.sort(key = lambda x: x[0]/x[1])
   

    for f1,f2 in next_f:
        new_f= str(Fraction(f1,f2))
        if new_f == '1/2':
            spot_on = True
        fractions2.append(new_f)
    fractions2.append('1')
    for i in fractions2:
        if not i in fractions:
            fractions.append(i) 
    
    
    f = list(next_f).copy()
    f_choose = lambda x: abs(x[0]-x[1]/2)
    f.sort(key = lambda x: abs(x[0]-x[1]/2))
    f_choose1 = lambda x: x[0]
    f_choose2 = lambda x: x[1]
    if f_choose(f[0]) == f_choose(f[1]):
        closest_1 = str(Fraction(f_choose1(f[0]),f_choose2(f[0])))
        closest_2 = str(Fraction(f_choose1(f[1]),f_choose2(f[1])))
    else:
        closest_1 = str(Fraction(f_choose1(f[0]),f_choose2(f[0])))
        closest_2 = None

print('\nThe fractions no greater than 1 that can be built from L, from smallest to largest, are:')
print('  ', '  '.join(e for e in fractions))
if spot_on:
    print('One of these fractions is 1/2')
elif closest_2 is None:
    print('The fraction closest to 1/2 is', closest_1)
else:
    print(closest_1, 'and', closest_2, 'are both closest to 1/2')

