#!/usr/bin/env python


l = []
for i in range(1,30):
    l.append((i*(i+1)/2)%26)

cipher= "gogqrcqyvkcobnezetzhrvasef"
plain = []
count = 0
number = 0
print 'l is ', l
for j in cipher:
    #print j, ord(j)
    number = ord(j)-l[count]
    if number < 97:
        number = 122-(97-number)+1
    plain.append(chr(number))

    count += 1


print ''.join(plain)
