#!/usr/bin/env python
import sys
import matplotlib.pyplot as plt


if len(sys.argv) != 2:
    print "Usage: ./coincidence.py filename\n"
l = []
with open(sys.argv[1]) as c:
    for line in c:
        for word in line:
            l += word.split()
count = 0
D =  0 #number of coincidence(D)
move = 1 #how many letters need to move
for character in l[1:]:
    if character == l[0]:
        break
    else:
       move += 1

for character in l[move:]:
    count += 1
    if character == l[count-1]:
        D += 1
    else:
        continue
CI = float(D)/float(len(l)-move) * 26
print "CI is:", CI

num_list = [0] * 26
name_list = [chr(i) for i in range(65,91)]
for character in l:
    num_list[ord(character) - 65] += 1

plt.bar(range(len(num_list)), num_list, tick_label=name_list)
plt.show()
