# Generates a binary tree T whose shape is random and whose nodes store
# random even positive integers, both random processes being directed by user input.
# With M being the maximum sum of the nodes along one of T's branches, minimally expands T
# to a tree T* such that:
# - every inner node in T* has two children,
# - the sum of the nodes along all of T*'s branches is equal to M.
#
# Written by z5140430 and Eric Martin for COMP9021


import sys
from random import seed, randrange

from binary_tree_adt import *


def create_tree(tree, for_growth, bound):
    if randrange(max(for_growth, 1)):
        tree.value = 2 * randrange(bound + 1)
        tree.left_node = BinaryTree()
        tree.right_node = BinaryTree()
        create_tree(tree.left_node, for_growth - 1, bound)
        create_tree(tree.right_node, for_growth - 1, bound)



def expand_tree(tree):
    expand(tree, max_value(tree))

def expand(tree, max_sum, current_value = 0):
    current_value += tree.value
    if current_value==max_sum:
        return
    # check left
    # can not use tree.node, because in some situations, tree.node is not None, but the value of it is None 
    if tree.left_node.value is not None:
        expand(tree.left_node, max_sum, current_value)
    elif (max_sum>current_value):
        tree.left_node = BinaryTree(max_sum - current_value)

    # check right
    if tree.right_node.value is not None:
        expand(tree.right_node,max_sum,current_value)
    else:
        if max_sum > current_value:
            tree.right_node = BinaryTree(max_sum - current_value)



def max_value(tree):

    if not tree.value:
        return 0
    else:

        return tree.value + max(max_value(tree.left_node), max_value(tree.right_node))



 # Replace pass above with your code


# Possibly define other functions


try:
    for_seed, for_growth, bound = [int(x) for x in input('Enter three positive integers: ').split()
                                   ]
    if for_seed < 0 or for_growth < 0 or bound < 0:
        raise ValueError
except ValueError:
    print('Incorrect input, giving up.')
    sys.exit()

seed(for_seed)
tree = BinaryTree()
create_tree(tree, for_growth, bound)
print('Here is the tree that has been generated:')
tree.print_binary_tree()
expand_tree(tree)
print('Here is the expanded tree:')
tree.print_binary_tree()



