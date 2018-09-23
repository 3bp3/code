from random import seed, randint
from math import sqrt
from statistics import mean, median, pstdev
import sys


# Prompt the user for a seed for the random number generator,
# and for a strictly positive number, nb_of_elements.
#
# See previous challenge.


# Generate a list of nb_of_elements random integers between -50 and 50.
#
# See previous challenge.


# Print out the list, compute the mean, standard deviation and median of the list,
# and print them out.
#
# To compute the mean, use the builtin sum() function.
# To compute the standard deviation, use sum(), the sqrt() from the math module,
# and the ** operator (exponentiation).
# To compute the median, first sort the list.
#
# The following interaction at the python prompt gives an idea of how these functions work:
# >>> from math import sqrt
# >>> sqrt(16)
# 4.0
# >>> L = [2, 1, 3, 4, 0, 5]
# >>> L.sort()
# >>> L
# [0, 1, 2, 3, 4, 5]
# >>> L = [2, 1, 3, 4, 0, 5]
# >>> sum(L)
# 15
# >>> sum(x ** 2 for x in L)
# 55
# >>> L.sort()
# >>> L
# [0, 1, 2, 3, 4, 5]
#
# Then use the imported functions from the statistics module to check the results.

arg_for_seed = input('Input a seed for the random number generator: ')
try:
    arg_for_seed = int(arg_for_seed)    
except ValueError:
    print('Input is not an integer , giving up')
    sys.exit()

nb_of_elements = input('How many elements do you want to generate? ')
try:
    nb_of_elements = int(nb_of_elements)
except ValueError:
    print('Input is not an integer , giving up')
    sys.exit()
if nb_of_elements <= 0:
    print('Input is not a strictly positive number , giving up')
    sys.exit()

seed(arg_for_seed)
L = [randint(-50,51) for _ in range(nb_of_elements)]
print('\nThe list is:',L)


mean_cal = sum(L)/nb_of_elements
deviation_cal = sqrt(sum(i**2 for i in ([(L[i]-mean_cal) for i in range(nb_of_elements)]))/nb_of_elements)
L.sort()
median_cal = L[int((nb_of_elements-1)/2)] if nb_of_elements%2 else (L[int(nb_of_elements/2 - 1)] + L[int(nb_of_elements/2)])/2


print(f'\nThe mean is {mean_cal:.2f}.')
print(f'The median is {median_cal:.2f}.')
print(f'The standard deviation is {deviation_cal:.2f}.')
print('')
print('Confirming with functions from the statistics module:')
print(f'The mean is {mean(L):.2f}.')
print(f'The median is {median(L):.2f}.')
print(f'The standard deviation is {pstdev(L):.2f}.')


#Do not use function name as a variable name !!!!!

