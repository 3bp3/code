# Prompts the user for a string w of lowercase letters and outputs the
# longest sequence of consecutive letters that occur in w,
# but with possibly other letters in between, starting as close
# as possible to the beginning of w.


#owercase = [input('Please input a string of lowercase letters: ')]
lowercase_number = [ord(e) for e in input('Please input a string of lowercase letters: ')]
solution = []
for e in range(len(lowercase_number)):
    temp = lowercase_number[e]
    long_sequence = [lowercase_number[e]]
    #print(temp,'temp')
    #print(lowercase_number,'lowercase number')
    while temp+1 in lowercase_number[e+1:]:
        long_sequence.append(temp+1)
        temp = temp + 1
    if len(long_sequence) > len(solution):
        solution = long_sequence[:]
        long_sequence = []
    else:
        long_sequence = []

print(f'The solution is: {"".join(chr(i) for i in solution)}')



