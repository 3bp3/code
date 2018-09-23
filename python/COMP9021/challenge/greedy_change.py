# Prompts the user for an amount, and outputs the minimal number of banknotes
# needed to match that amount, as well as the detail of how many banknotes
# of each type value are used.
# The available banknotes have a face value which is one of
# $1, $2, $5, $10, $20, $50, and $100.


# Insert your code here   
import sys
banknotes = [100,50,20,10,5,2,1]
try:
    desired_amount = int(input('Input the desired amount: '))
except ValueError:
    print('Incorrect Input!')
    sys.exit()
if desired_amount <= 0:
    raise ValueError('Invalid amount!')
detail = []
nb_of_notes = 0
banknote = banknotes[:]
#print(banknotes)
for i in banknotes:
    #print(i,'i')
    #print(desired_amount,'//',i,'desired_amount//i')
    if desired_amount//i != 0:
        nb_of_notes += desired_amount//i
        detail.append(desired_amount//i)
    else:
        #print('current i', i)
        banknote.remove(i)
    #print('banknotes',banknotes)
    desired_amount = desired_amount%i
print('\n',end = '')
if nb_of_notes == 1:
    print(f'{nb_of_notes} banknote is needed.')
else:
    print(f'{nb_of_notes} banknotes are needed.')
print('The detail is:')
count = 0
#print(detail,'detail')
#print(banknotes,'banknotes')
for e in banknote:
    print(f'{"$"+str(e):>4}: {detail[count]}\n', end = '')
    count += 1



