# Prompts the user for two numbers, say available_digits and desired_sum, and
# outputs the number of ways of selecting digits from available_digits
# that sum up to desired_sum.


import sys
from itertools import combinations

def solve(available_digits, desired_sum):
    if desired_sum < 0:
        return 0
        # Replace pass above with your code
    if available_digits == 0:
        if desired_sum == 0:
            return 1
        return 0
        # Replace pass above with your code
    # Either take the last digit d form available_digits
    # and try to get desired_sum - d from the remaining digits,
    # or do not take the last digit and try to get desired_sum
    # from the remaining digits.
    #
    # Insert code here
    n = 0
    no = available_digits
    while no != 0:
        no = no // 10
        n += 1
    l = [int(e) for e in str(available_digits)]
    count = 0
    for i in range(1,n+1):
        number = list(combinations(l,i))
        for j in number:
            if sum(j) == desired_sum:
                count += 1
    return count
try:
    available_digits = abs(int(input('Input a number that we will use as available digits: ')))
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()
try:
    desired_sum = int(input('Input a number that represents the desired sum: '))
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()
nb_of_solutions = solve(available_digits, desired_sum)
if nb_of_solutions == 0:
    print('There is no solution.')
elif nb_of_solutions == 1:
    print('There is a unique solution.')
else:
    print(f'There are {nb_of_solutions} solutions.')
