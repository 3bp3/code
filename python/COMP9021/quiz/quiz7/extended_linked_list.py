# Written by z5140430 for COMP9021

from linked_list_adt import *

class ExtendedLinkedList(LinkedList):
    def __init__(self, L = None):
        super().__init__(L)

    def rearrange(self):
        odd_L = LinkedList()
        even_L = LinkedList()
        current_node = self.head
        odd_start = odd_L.head
        even_start = even_L.head
        last_node = current_node
        
        while(current_node):
            
            if current_node.value & 1:
                if not odd_L:
                    odd_L.head = current_node
                    odd_start = odd_L.head
                    last_node = current_node
                else:
                    odd_start.next_node = current_node
                    odd_start = odd_start.next_node
                    last_node = current_node
            else:
                if not even_L:
                    even_L.head = current_node
                    even_start = even_L.head
                    
                else:
                    even_start.next_node = current_node
                    even_start = even_start.next_node
            temp = current_node.next_node
            current_node.next_node = None
            current_node = temp
            
            
        if len(odd_L) > 0 and len(even_L) >0:
            self.head = odd_L.head
            last_node.next_node = even_L.head
        elif len(odd_L) > 0 and len(even_L) == 0:
            self.head = odd_L.head
        elif len(odd_L) == 0 and len(even_L) > 0:
            self.head = even_L.head


        

        

                        
                
                
                
        
            
                
                
         
	 
        # Replace pass above with your code
    
    
    

