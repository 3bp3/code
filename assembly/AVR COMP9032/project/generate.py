
while True:
    try:
        number,length = input('enter number we need to generate and the length:').split()
    except ValueError:
        print('Incorrect input, enter again!')
        continue

    try:
        number, length = int(number), int(length)
    except ValueError:
        print('enter integer')
        continue
    else:
        break
print(', '.join([str(number) for x in range(length)]))
