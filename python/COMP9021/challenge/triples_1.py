# Finds all triples of positive integers (i, j, k) such that
# i, j and k are two digit numbers, i < j < k,
# every digit occurs at most once in i, j and k,
# and the product of i, j and k is a 6-digit number
# consisting precisely of the digits that occur in i, j and k.


# Insert your code here
min_i = 10
max_i = 76
max_j = 87
max_k = 98

for i in range(min_i,max_i + 1):
    if i%10 == i//10%10:
        continue
    else:

        for j in range(i,max_j + 1):
            if j%10 == j//10%10:
                continue
            else:
                for k in range(j,max_k + 1):
                    if k%10 == k//10%10:
                        continue
                    else:
                        if len(set(str(i*j*k))) == 6:                            
                            if all((l in set(str(i)+str(j)+str(k))) for l in set(str(i*j*k))):
                                print(f'{i} x {j} x {k} = {i*j*k} is a solution.')
                    

