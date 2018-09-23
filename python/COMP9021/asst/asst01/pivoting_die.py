#Written by z5140430

import sys


while True:
	cell_number = 0
	try:
		cell_number = int(input('Enter the desired goal cell number: '))
		if cell_number <= 0:
			print('Incorrect value, try again')
		else:
			break
	except ValueError:
		print('Incorrect value, try again')

dice_dict = {'up':3,'down':4,'front':2,'back':5,'left':6,'right':1}
temp = 0
cell_number = int(cell_number)
  


def right_n_times(times):
    for _ in range(times):
        temp = dice_dict['up']
        dice_dict['up'] = dice_dict['left']
        dice_dict['left'] = dice_dict['down']
        dice_dict['down'] = dice_dict['right']
        dice_dict['right'] = temp
        
    
def down_n_times(times):
    for _ in range(times):
        temp = dice_dict['down']
        dice_dict['down'] = dice_dict['front']
        dice_dict['front'] = dice_dict['up']
        dice_dict['up'] = dice_dict['back']
        dice_dict['back'] = temp

def left_n_times(times):
    for _ in range(times):
        temp = dice_dict['down']
        dice_dict['down'] = dice_dict['left']
        dice_dict['left'] = dice_dict['up']
        dice_dict['up'] = dice_dict['right']
        dice_dict['right'] = temp

def up_n_times(times):
    for _ in range(times):
        temp = dice_dict['front']
        dice_dict['front'] = dice_dict['down']
        dice_dict['down'] = dice_dict['back']
        dice_dict['back'] = dice_dict['up']
        dice_dict['up'] = temp

def get_nb_operations():
    global move_times
    global cell_number
    global sum_cell
    sum_cell = 1
    while sum_cell <= cell_number:
            move_times += 1
            sum_cell = (move_times+1)*move_times + 1
    move_times = move_times - 1
    sum_cell = (move_times+1)*move_times + 1

    
move_times = 0    
get_nb_operations()
remainder = move_times % 2
quotinent = move_times // 2
i = 0


if move_times >= 2:
    for _ in range(quotinent):
        i += 1
        right_n_times(i)
        down_n_times(i)
        i += 1
        left_n_times(i)
        up_n_times(i)
else:
    if cell_number-1 == 0:
        print(f"On cell {cell_number}, {dice_dict['up']} is at the top, {dice_dict['front']} at the front, and {dice_dict['right']} on the right.")
    if cell_number-1 == 1:
        right_n_times(1)
        print(f"On cell {cell_number}, {dice_dict['up']} is at the top, {dice_dict['front']} at the front, and {dice_dict['right']} on the right.")
    if cell_number-1 == 2:
        right_n_times(1)
        down_n_times(1)
        print(f"On cell {cell_number}, {dice_dict['up']} is at the top, {dice_dict['front']} at the front, and {dice_dict['right']} on the right.")
    if (cell_number-1) in [3,4]:
        right_n_times(1)
        down_n_timesn(1)
        left_n_times(cell_number-1-2)
        print(f"On cell {cell_number}, {dice_dict['up']} is at the top, {dice_dict['front']} at the front, and {dice_dict['right']} on the right.")
    if cell_number-1 == 5:
        right_n_times(1)
        down_n_timesn(1)
        left_n_times(2)
        up_n_times(1)
        print(f"On cell {cell_number}, {dice_dict['up']} is at the top, {dice_dict['front']} at the front, and {dice_dict['right']} on the right.")


if remainder == 0:
    if (cell_number - sum_cell) <= move_times:
        right_n_times(cell_number-sum_cell)
    else:
        right_n_times(move_times+1)
        down_n_times(cell_number-sum_cell-move_times-1)
else:
    right_n_times(move_times)
    down_n_times(move_times)
    if (cell_number - sum_cell) <= move_times:
        left_n_times(cell_number-sum_cell)
    else:
        left_n_times(move_times)
        up_n_times(cell_number-sum_cell-move_times)

if move_times >= 2:
    print(f"On cell {cell_number}, {dice_dict['up']} is at the top, {dice_dict['front']} at the front, and {dice_dict['right']} on the right.")	
