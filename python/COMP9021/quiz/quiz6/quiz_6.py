# Creates a class to represent a permutation of 1, 2, ..., n for some n >= 0.
#
# An object is created by passing as argument to the class name:
# - either no argument, in which case the empty permutation is created, or
# - "length = n" for some n >= 0, in which case the identity over 1, ..., n is created, or
# - the numbers 1, 2, ..., n for some n >= 0, in some order, possibly together with "lengh = n".
#
# __len__(), __repr__() and __str__() are implemented, the latter providing the standard form
# decomposition of the permutation into cycles (see wikepedia page on permutations for details)
#
# Objects have:
# - nb_of_cycles as an attribute
# - inverse() as a method
#
# The * operator is implemented for permutation composition, for both infix and in-place uses.
#
# Written by z5140430 and Eric Martin for COMP9021

class PermutationError(Exception):
    def __init__(self, message):
        self.message = message

class Permutation:
    def __init__(self, *args, length = None):
        self.length = length
        self.args = args
        if any(isinstance(i,list) for i in self.args):
            raise PermutationError('Cannot generate permutation from these arguments')
        if len(self.args) > 0:
            if not all(i for i in self.args) != 0:
                raise PermutationError('Cannot generate permutation from these arguments')
            if self.length != None and len(self.args) != self.length:
                raise PermutationError('Cannot generate permutation from these arguments')
            if any(isinstance(i,str) for i in self.args):
                raise PermutationError('Cannot generate permutation from these arguments')
        if length and length < 0:
            raise PermutationError('Cannot generate permutation from these arguments')
        
        # Replace pass above with your code
        length = len(self.args)
        if len(self.args) == 0:
            result = []
        else:
            argcopy = list(self.args[:])
            result = [[argcopy[0]]]
            next_element = self.args[0]
        nb_of_cycles = 0
        
        
        
        
        while self.args != () and sum(len(i) for i in result) != len(self.args):
            last_element = next_element
            next_element = self.args[last_element - 1]
                    
            if next_element != result[nb_of_cycles][0]:
                result[nb_of_cycles].append(next_element)
                #print (f"Append next element {next_element} to result {result[nb_of_cycles]}")
                
                
            else:
                max_index = result[nb_of_cycles].index(max(result[nb_of_cycles]))
                temp = result[nb_of_cycles]
                result[nb_of_cycles] = temp[max_index:] + temp[0:max_index]
                
                nb_of_cycles += 1
                #print (f"After sort {result[nb_of_cycles-1]}")
                result.append([])
                
                for e in result[nb_of_cycles - 1]:
                    argcopy.remove(e)
                
                next_element = argcopy[0]
                #print (f"Append next element {next_element} to result {result[nb_of_cycles]}")
                result[nb_of_cycles].append(next_element)
                
        self.nb_of_cycles = nb_of_cycles
        #print (f"result {result} sorted {sorted(result, key = lambda x: x[0])}")
        self.output = sorted(result, key = lambda x: x[0])
               
    def __len__(self):
        return len(self.args)
        # Replace pass above with your code

    def __repr__(self):
        
        return f'Permutation{self.args}'
        # Replace pass above with your code

    def __str__(self):
        outstring = ''
        for i in self.output:            
            outstring += f"({' '.join(str(e) for e in i)})"
        if outstring == '':
            outstring = '()'
        return outstring
        # Replace pass above with your code

    def __mul__(self, permutation):
        length = len(self.args)
        if length != len(permutation.args):
            raise PermutationError('Cannot compose permutations of different lengths')
        q = []
        for i in range(len(self.args)):
            q.append(permutation.args[self.args[i] - 1])
        return Permutation(*tuple(q))
        # Replace pass above with your code

    def __imul__(self, permutation):
        return self.__mul__(permutation)
        # Replace pass above with your code

    def inverse(self):
        args_copy = [0]*len(self.args)
        for i in range(len(self.args)):
            args_copy[self.args[i] - 1] = i+1
        
        return Permutation(*tuple(args_copy))
        # Replace pass above with your code
        
    # Insert your code for helper functions, if needed




                
        

