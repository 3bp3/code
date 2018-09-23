# Randomly generates N distinct integers with N provided by the user,
# inserts all these elements into a priority queue, and outputs a list
# L consisting of all those N integers, determined in such a way that:
# - inserting the members of L from those of smallest index of those of
#   largest index results in the same priority queue;
# - L is preferred in the sense that the last element inserted is as large as
#   possible, and then the penultimate element inserted is as large as possible, etc.
#
# Written by z5140430 and Eric Martin for COMP9021


import sys
from random import seed, sample

from priority_queue_adt import *


# Possibly define some functions
def pqcopy(pq):
    pq_copy = PriorityQueue()
    pq_copy._data = list(pq._data)
    pq_copy._length = pq._length
    return pq_copy

def remove_value(pq,value):
    index = 0
    for i in range(1,pq._length+1):
        if pq._data[i] == value:
            index = i
            break
    pq._data[index], pq._data[pq._length] = pq._data[pq._length], pq._data[index]
    pq._length -= 1
    pq._bubble_down(index)
    return pq




def got_one_value(pref,pq):
    gotone = False
    count = 1
    while not gotone:
        value = pq._data[count]
        pq_copy = pqcopy(pq)
        pq_copy = remove_value(pq_copy, value)
        pq_copy.insert(value)
        #print('value', value, '\n', 'pq_copy data', pq_copy._data, '\n', 'pq data', '\n', pq._data,pref,'pref')
        if pq_copy._data == pq._data:
            gotone = True
            pref.appendleft(value)
            pq = remove_value(pq, value)
        count += 1

    return pref, pq




def preferred_sequence():
    from collections import deque
    global pq
    pref = deque()

    while len(pq) > 1:
        pref,pq = got_one_value(pref,pq)

    pref.appendleft(pq._data[1])
    return list(pref)


    # Replace pass above with your code (altogether, aim for around 24 lines of code)


try:
    for_seed, length = [int(x) for x in input('Enter 2 nonnegative integers, the second one '
                                              'no greater than 100: '
                                              ).split()
                        ]
    if for_seed < 0 or length > 100:
        raise ValueError
except ValueError:
    print('Incorrect input (not all integers), giving up.')
    sys.exit()
seed(for_seed)
L = sample(list(range(length * 10)), length)

pq = PriorityQueue()
for e in L:
    pq.insert(e)
print('The heap that has been generated is: ')
print(pq._data[: len(pq) + 1])
print('The preferred ordering of data to generate this heap by successsive insertion is:')
print(preferred_sequence())

