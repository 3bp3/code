#Written by z5140430

from collections import deque
import sys
import re


tree = deque()
used_set = set()

def row_exchange(old_list):
    tlist = list(old_list)
    new_list = tlist[4:] + tlist[:4]
    
    return new_list
    
def right_circular_shift(old_list):
    tlist = list(old_list)
    new_list = tlist[3:4] + tlist[:3] + tlist[7:] + tlist[4:7]
    return new_list

def middle_clockwise_rotation(old_list):
    tlist = list(old_list)
    new_list = [tlist[0]] + [tlist[5]] + [tlist[1]] + [tlist[3]] + [tlist[4]] + [tlist[6]] + [tlist[2]] + [tlist[7]]
    return new_list

def check_if_used(check_element):
    if tuple(check_element) in used_set:
        return False
    else:
        return True
        

def main():
    tree.append([['1','2','3','4','8','7','6','5'],0])
    used_set.add(tuple(['1','2','3','4','8','7','6','5']))
    final_configuration = input('Input final configuration: ')
    final_configuration = final_configuration.replace(" ","")
    if len(final_configuration) != 8 or not re.match("^[1-8]*$",final_configuration):
        print("Incorrect configuration, giving up...")
        sys.exit()
	
    final_configuration = list(final_configuration)
    final_configuration = final_configuration[:4] + [final_configuration[7], final_configuration[6], final_configuration[5], final_configuration[4]]
    if tree[0][0] == final_configuration:
        print(f'0 step is needed to reach the final configuration.')
        sys.exit()
    
    while len(tree)>0:
        tree_data = tree.popleft()
        tree_list, tree_count = tree_data
		
        element_row_exchange = row_exchange(tree_list)

        if check_if_used(element_row_exchange):
            tree.append([element_row_exchange, tree_count+1])
            used_set.add(tuple(element_row_exchange))
        element_right_shift = right_circular_shift(tree_list)
        if check_if_used(element_right_shift):
            tree.append([element_right_shift, tree_count+1])
            used_set.add(tuple(element_right_shift)) 
        element_clockwise_rotation = middle_clockwise_rotation(tree_list)
        if check_if_used(element_clockwise_rotation):
            tree.append([element_clockwise_rotation,tree_count+1])
            used_set.add(tuple(element_clockwise_rotation))
        
        choice = tree_list
        if choice == final_configuration:
            print(f'{tree_count} steps are needed to reach the final configuration.')
            break
        
    
    
if __name__ == '__main__':
    main()    
        


    
    

    
