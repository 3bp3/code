#!/usr/bin/env python

l = '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.++++++.-----------.++++++.++++++++++++++++++++++++++++++++++++++++++++++++++++.------------------------------------------------------.++++++++++++++.----.+++++.---------------.+++++++++++++.---------.------.++++++++++++++++++++++++++++.-------------------.-----------.+++++++++++++.-------.++++++++++++++.--------------------.++++++.--.++++++++++++++.++++++++++++.------------------------------.+++++++++++++++++.-------------.++++++++++++++++++++++++++.-------------------------.+++++++++++++++.-------.---------------------------------------------.++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
l = l.split('.')
print l
n = [len(i) for i in l]
print n
initial = 0
number = []
for i in range(len(n)):
    if l[i][0] == '+':
        initial += n[i]
        number.append(initial)
    else:
        initial -= n[i]
        number.append(initial)

str1 = ''.join([chr(i) for i in number])

print str1   
