

from linked_list_adt import *


class ExtendedLinkedList(LinkedList):
    def __init__(self,L=None):
        super().__init__(L)

    def remove_duplicates(self):
        if not self.head:
            return
        current_node = self.head
        while current_node:
            current_node2 = current_node
            while current_node2.next_node:

                if current_node2.next_node.value == current_node.value:
                    current_node2.next_node = current_node2.next_node.next_node
                else:
                    current_node2 = current_node2.next_node
            current_node = current_node.next_node
 




