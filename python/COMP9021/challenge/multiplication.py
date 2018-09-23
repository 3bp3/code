# Decodes all multiplications of the form
#
#                        *  *  *
#                   x       *  *
#                     ----------
#                     *  *  *  *
#                     *  *  *
#                     ----------
#                     *  *  *  *
#
# such that the sum of all digits in all 4 columns is constant.


# Insert your code here.
def digit1():
    return x*y%10*2 + x%10 + y%10 
def digit2():
    return x//10%10 + y//10%10 + x*y//10%10*2
def digit3():
    return x//100%10 + x*y//100%10*2
def digit4():
    return x*y//1000%10*2

for x in range(100,1000):
    for y in range(10,100):
        if x*y//10000 != 0:
            continue
        if digit1() == digit2() == digit3() == digit4():
            print(f'{x} * {y} = {x*y}, all columns adding up to {digit1()}.')

