#!/usr/bin/env python
print "It is a simple script calculate the bits of security\n"
password = list(raw_input("Please enter the password you want to test, the password will display on the screen. Be careful!\n"))
number = [i for i in range(48,58)]
capital = [i for i in range(65,91)]
lower = [i for i in range(97,123)]
sumofpossible = 0

for word in password:
	if ord(word) in number:
                sumofpossible+= 10
	    	break
for word in password:
    	if ord(word) in capital:
		sumofpossible+= 26
	    	break
for word in password:
    	if ord(word) in lower:
		sumofpossible+= 26
        	break
for word in password:
        if ord(word) in [i for i in range(32,127)]:
            if ord(word) in lower or ord(word) in capital or ord(word) in number:
                continue
            else:
	        sumofpossible+= 34 
        	break
for i in range(10):
    	if 2**i >= sumofpossible:
		if (2**i - sumofpossible) > (2**(i-1) - sumofpossible):
	    		print i
            		bits = i-1
		else:
	    		bits = i
		break
bitsofsec = bits * len(password)
print "The bits of security is:",bitsofsec

hz, number = raw_input("Enter how many GHZ of your computer CPU and the number of your CPU spliting with space").split()
time = 2**bitsofsec/(int(number)*float(hz)*(10**9))
print "It takes", time, "maximum seconds to brute-force your password"

 
