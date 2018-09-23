#Written by z5140430


import os
import sys


class SudokuError(Exception):
    def __init__(self, message):
       self.message = message


class Sudoku:
    def __init__(self, filename):
        from copy import deepcopy
        self.filename = filename
        grid = [[[0] for i in range(9)] for _ in range(9)]
        self.grid = grid
        centercell = [(1,1),(1,4),(1,7),(4,1),(4,4),(4,7),(7,1),(7,4),(7,7)]
        self.centercell = centercell
        #print_cancel = [[[] for _ in range(9)] for _ in range(9)]
        #self.print_cancel = print_cancel

        with open(filename) as sf:
            countrow = 0
            for line in sf:
                if not line.strip():
                    continue
                else:
                    countrow += 1
                    countcol = 0
                    for character in line.replace(" ","").strip():
                        countcol += 1
                        #print(character,'char')
                        try:
                            grid[countrow-1][countcol-1] = int(character)
                        except ValueError:
                            raise SudokuError('Incorrect input')
                        if not character.isdigit():
                            raise SudokuError('Incorrect input')
                    if countcol != 9:
                        raise SudokuError('Incorrect input')
            if countrow != 9:
                raise SudokuError('Incorrect input')
        possible_grid = deepcopy(self.grid)
        self.possible_grid = possible_grid

    #check if there are any duplicate number in the row
    def checkrow(self):
        for i in self.grid:
            i = [x for x in i if x != 0]
            if len(i) != len(set(i)):
                return False
            # deplicate return false
        else:
            return True
    #check if there are any duplicate number in the col
    def checkcol(self):
        for j in range(9):
            temp = []
            for i in range(9):
                temp.append(self.grid[i][j])
            temp = [x for x in temp if x != 0]
            if len(temp) != len(set(temp)):
                return False
            #deplicate return false
        else:
            return True
    #check if there are any duplication number in the box
    def checkbox(self):
        for i,j in self.centercell:
            temp = [x for x in [self.grid[i][j], self.grid[i-1][j-1], self.grid[i-1][j+1], self.grid[i+1][j-1], self.grid[i+1][j+1], \
                                self.grid[i][j-1], self.grid[i][j+1], self.grid[i-1][j], self.grid[i+1][j]] if x != 0]
            if len(temp) != len(set(temp)):
                return False
                # deplicate return false
        else:
            return True

    def preassess(self):
        #print(self.checkrow(),'check row')
        #print(self.checkcol(),'check col')
        #print(self.checkbox(),'check box')
        if all([self.checkrow(),self.checkcol(),self.checkbox()]):
            print('There might be a solution.')
        else:
            print('There is clearly no solution.')

    def gotit(self,btf):
        print('\\documentclass[10pt]{article}\n'
              '\\usepackage[left=0pt,right=0pt]{geometry}\n'
              '\\usepackage{tikz}\n'
              '\\usetikzlibrary{positioning}\n'
              '\\usepackage{cancel}\n'
              '\\pagestyle{empty}\n'
              '\n'
              '\\newcommand{\\N}[5]{\\tikz{\\node[label=above left:{\\tiny #1},\n'
              r'                               label=above right:{\tiny #2},''\n'
              r'                               label=below left:{\tiny #3},''\n'
              r'                               label=below right:{\tiny #4}]{#5};}}''\n'
              '\n'
              '\\begin{document}\n'
              '\n'
              '\\tikzset{every node/.style={minimum size=.5cm}}\n'
              '\n'
              '\\begin{center}\n'
              '\\begin{tabular}{||@{}c@{}|@{}c@{}|@{}c@{}||@{}c@{}|@{}c@{}|@{}c@{}||@{}c@{}|@{}c@{}|@{}c@{}||}\hline\hline',
              file=btf
              )
        for i in range(9):
            print(f'% Line {i+1}\n', end='', file=btf)
            for j in range(9):
                if self.grid[i][j] != 0:
                    print(r'\N{}{}{}{}{' + f'{self.grid[i][j]}' + '} ', end='', file=btf)
                else:
                    print('\\N{}{}{}{}{} ', end='', file=btf)
                if j == 8:
                    print(r'\\ \hline', end='', file=btf)
                elif j in [2, 5]:
                    print('&\n', end='', file=btf)
                else:
                    print('& ', end='', file=btf)
            if i in [2, 5, 8]:
                print('\hline\n', end='', file=btf)
            else:
                print('\n', end='', file=btf)
            if i <= 7:
                print('\n', end='', file=btf)
        print('\\end{tabular}\n'
              '\\end{center}\n'
              '\n'
              '\\end{document}', file=btf)

    #yield bare tex file
    def bare_tex_output(self):
        with open(self.filename.replace('.txt','_bare.tex'),'w+') as btf:
            self.gotit(btf)

    #generate possible box
    def possiblebox(self,possible_box,index):
        #input initial possiblebox, box index, output possible box
        boxno = 0
        for line in index:
            for x,y in line:
                    if self.grid[x][y] != 0:
                        possible_box[boxno].remove(self.grid[x][y])
            boxno += 1
            if boxno >=9:
                break
        return possible_box

    #get empty cell in each box
    def emptycell(self,empty_cell,index):
        #input initial empty cell, box index, output emptycell
        boxno = 0
        for line in index:
            for x,y in line:
                if self.grid[x][y] == 0:
                    empty_cell[boxno].append((x,y))
            boxno += 1
            if boxno >= 9:
                break
        return empty_cell

    #check from 1 to 9 to see if it the only one value
    def checkonly(self, possible_row,possible_col,possible_box,possible_val, empty_cell, boxno):
        from itertools import chain
        forced_index = []

        c = 1
        while True:
            if list(chain.from_iterable(possible_val)).count(c) == 1:
                for x,y in empty_cell[boxno]:
                    if c in self.possible_grid[x][y]:
                        #print('self.grid[x][y]',x,y,c)
                        #print(possible_grid[x][y],'grid x y')
                        self.grid[x][y] = c
                        #print(self.grid)
                        value = self.grid[x][y]
                        possible_row[x].remove(value)
                        possible_col[y].remove(value)
                        possible_box[boxno].remove(value)
                        possible_val.remove(self.possible_grid[x][y])
                        self.possible_grid[x][y] = value
                        empty_cell[boxno].remove((x, y))
                        forced_index.append((x,y))
                        c = 0
            c += 1
            if c == 10:
                break
        if not forced_index:
            return False
        else:
            return True





    #yield forced tex file
    def forced_tex_output(self):
        possible_row = []
        possible_col = [list(range(1, 10)) for _ in range(9)]
        possible_box = [list(range(1, 10)) for _ in range(9)]
        possible_val = []
        global empty_cell
        empty_cell = [[] for _ in range(9)]
        #get the possible row and column

        for i in range(9):
            possible_row.append([x for x in list(range(1, 10)) if x not in self.grid[i]])
            for j in range(9):
                if self.grid[i][j] != 0:
                    possible_col[j].remove(self.grid[i][j])
        boxno = 0
        box_index = [[(i - 1, j - 1), (i - 1, j), (i - 1, j + 1), \
                      (i, j - 1), (i, j), (i, j + 1), \
                      (i + 1, j - 1), (i + 1, j),(i + 1, j + 1)] for i, j in self.centercell]

        #get possible box first for each box everytime
        possible_box = self.possiblebox(possible_box, box_index)
        #then get empty cell in current box
        empty_cell = self.emptycell(empty_cell, box_index)
        #print(possible_box,'possiblebox',empty_cell,'empty_cell')

        while True:
            for x,y in empty_cell[boxno]:
                #print(self.grid, 'grid before')
                self.possible_grid[x][y] = list(set(possible_box[boxno]) & set(possible_row[x]) & set(possible_col[y]))
                #print(self.grid, 'grid after')
                possible_val.append(self.possible_grid[x][y])
                #print(x,y,'empty_cell x,y')
            check_result = self.checkonly(possible_row,possible_col,possible_box,possible_val, empty_cell, boxno)
            if not check_result:
                boxno += 1
                possible_val = []
            else:
                boxno = 0
            if boxno == 9:
                break
        #print(self.grid,'grid',self.possible_grid,'possiblegrid')
        with open(self.filename.replace('.txt', '_forced.tex'), 'w+') as btf:
            self.gotit(btf)



    def sortbynumber(self,line,btf):

        global j
        j = 0
        for e in line:
            if isinstance(e, int):
                print('\\N{}{}{}{}{'+ f'{e}' +'}', end='',file=btf)
            else:
                po1 = []
                po2 = []
                po3 = []
                po4 = []
                for no in sorted(e):
                    if no in [1,2]:
                        po1.append(no)
                    elif no in [3,4]:
                        po2.append(no)
                    elif no in [5,6]:
                        po3.append(no)
                    else:
                        po4.append(no)
                print('\\N{' + ' '.join(map(str, po1)) + '}{' + ' '.join(map(str, po2)) + '}{' + ' '.join(map(str, po3)) + '}{' + ' '.join(map(str, po4)) + '}' + '{}', end='',file=btf)
            if j == 8:
                print(r' \\ \hline', end='',file=btf)
            elif j in [2, 5]:
                print(' &\n', end='',file=btf)
            else:
                print(' & ', end='',file=btf)
            j += 1


    def marked_tex_output(self):
        self.forced_tex_output()
        #print(self.possible_grid,'possiblegrid')
        with open(self.filename.replace('.txt', '_marked.tex'), 'w+') as btf:
            print('\\documentclass[10pt]{article}\n'
                  '\\usepackage[left=0pt,right=0pt]{geometry}\n'
                  '\\usepackage{tikz}\n'
                  '\\usetikzlibrary{positioning}\n'
                  '\\usepackage{cancel}\n'
                  '\\pagestyle{empty}\n'
                  '\n'
                  '\\newcommand{\\N}[5]{\\tikz{\\node[label=above left:{\\tiny #1},\n'
                  r'                               label=above right:{\tiny #2},''\n'
                  r'                               label=below left:{\tiny #3},''\n'
                  r'                               label=below right:{\tiny #4}]{#5};}}''\n'
                  '\n'
                  '\\begin{document}\n'
                  '\n'
                  '\\tikzset{every node/.style={minimum size=.5cm}}\n'
                  '\n'
                  '\\begin{center}\n'
                  '\\begin{tabular}{||@{}c@{}|@{}c@{}|@{}c@{}||@{}c@{}|@{}c@{}|@{}c@{}||@{}c@{}|@{}c@{}|@{}c@{}||}\hline\hline',file=btf
                  )
            i = 0

            for line in self.possible_grid:
                print(f'% Line {i+1}\n', end='', file=btf)
                # print(self.possible_grid, 'possiblegrid')
                #print(line, 'possiblegrid line')
                self.sortbynumber(line,btf)
                if i in [2, 5, 8]:
                    print('\hline\n', end='', file=btf)
                else:
                    print('\n', end='', file=btf)
                if i <= 7:
                    print('\n', end='', file=btf)
                i += 1

            print('\\end{tabular}\n'
                  '\\end{center}\n'
                  '\n'
                  '\\end{document}', file=btf)


    def convert_list_to_number(self,list):
        c = 0
        for e in list:
            c |= 1 << (e - 1)
        return c

    def convert_number_to_list(self,number):
        l = []
        count = 10
        while number:
            if number & 1:
                l.append(count)
            number >>= 1
            count += 1
        return l

# get possible row,col, and empty_cell is global, already got in forced, juz use it
    def get_posssible(self):
        global total_set
        global empty_col
        global empty_row
        empty_row = list([] for _ in range(9))
        empty_col = [[] for _ in range(9)]
        for i in range(9):
            for j in range(9):
                if isinstance(self.possible_grid[i][j],list):
                    empty_row[i].append((i,j))
                    empty_col[j].append((i,j))



    #generate combined list and set
    def getsets(self,empty_list):
        global max_length
        global judge
        judge = []
        combined_list = []
        combined_set = []
        max_length = 0
        no = 0
        for x,y in empty_list:
            combined_list += self.possible_grid[x][y]
            judge.append(self.possible_grid[x][y])
            max_length += 1
        combined_set = set(combined_list)
        no += 1
        return combined_list,combined_set

    #check each row col and box forced. do not need to put this loop into whole loop.
    def check_forced(self):
        self.check_row_forced([0, 1, 2, 3, 4, 5, 6, 7, 8])
        self.check_col_forced([0, 1, 2, 3, 4, 5, 6, 7, 8])
        self.check_box_forced([0, 1, 2, 3, 4, 5, 6, 7, 8])


    def check_row_forced(self,no):
        for i in no:
            count1 = 0
            while True:
                count1 += 1
                combined_row_list,combined_row_set = self.getsets(empty_row[i])
                if combined_row_list.count(count1) == 1:
                    for x, y in empty_row[i]:
                        if count1 in self.possible_grid[x][y]:
                            empty_row[x].remove((x,y))
                            empty_col[y].remove((x,y))
                            empty_cell[(x//3*3+y//3)].remove((x,y))
                            #self.possible_grid[x][y].remove(count1)
                            #self.print_cancel[x][y] = self.possible_grid[x][y]
                            self.possible_grid[x][y] = count1
                            self.check_col_forced([y])
                            self.check_box_forced([(x//3*3+y//3)])
                            count1 = 0
                if count1 == 9:
                    break

    def check_col_forced(self,no):
        for j in no:
            count2 = 0
            while True:
                count2 += 1
                combined_col_list,combined_col_set = self.getsets(empty_col[j])
                if combined_col_list.count(count2) == 1:
                    for x, y in empty_col[j]:
                        if count2 in self.possible_grid[x][y]:
                            empty_row[x].remove((x,y))
                            empty_col[y].remove((x,y))
                            empty_cell[(x//3*3+y//3)].remove((x,y))
                            #self.possible_grid[x][y].remove(count2)
                            #self.print_cancel[x][y] = self.possible_grid[x][y]
                            self.possible_grid[x][y] = count2
                            self.check_row_forced([x])
                            self.check_box_forced([(x//3*3+y//3)])
                            count2 = 0
                if count2 == 9:
                    break

    def check_box_forced(self,no):
        for b in no:
            count3 = 0
            while True:
                count3 += 1
                combined_box_list,combined_box_set = self.getsets(empty_cell[b])
                if combined_box_list.count(count3) == 1:
                    for x, y in empty_cell[b]:
                        if count3 in self.possible_grid[x][y]:
                            empty_row[x].remove((x,y))
                            empty_col[y].remove((x,y))
                            empty_cell[(x//3*3+y//3)].remove((x,y))
                            #self.possible_grid[x][y].remove(count3)
                            #self.print_cancel[x][y] = self.possible_grid[x][y]
                            self.possible_grid[x][y] = count3
                            self.check_row_forced([x])
                            self.check_col_forced([y])
                            count3 = 0
                if count3 == 9:
                    break

    # conert set to number
    def convert_list_to_number(self,l):
        c = 0
        for e in l:
            c |= 1 << (e - 1)
        return c


    # get the number of subset of possible preemptive set
    def check_subset(self,candidate_list,s):
        global possible_preemptive_set
        remove_list = candidate_list[:]
        possible_preemptive_set = self.convert_list_to_number(s)
        count = 0
        for x,y in candidate_list:
            if self.convert_list_to_number(self.possible_grid[x][y]) | possible_preemptive_set == possible_preemptive_set:
                remove_list.remove((x,y))
                count += 1
        return count,remove_list

    def getpset(self,candidate_list):
        from itertools import combinations

        combined_list,combined_set = self.getsets(candidate_list)


        for size in range(2,max_length + 1):
            subsets = list(combinations(combined_set,size))
            #print(size,'size',subsets,'subsets')
            for s in subsets:
                count,remove_list = self.check_subset(candidate_list,s)
                #print(count,'get count')
                flag = False
                if count == size:
                    pset = s
                    #print(pset,'preemptive set')
                    if not remove_list:
                        flag = False
                    else:
                        flag = True
                        for x,y in remove_list:
                            self.possible_grid[x][y] = [x for x in self.possible_grid[x][y] if x not in pset]
                            if len(self.possible_grid[x][y]) == 1:
                                self.possible_grid[x][y] = self.possible_grid[x][y][0]
                                empty_row[x].remove((x,y))
                                empty_col[y].remove((x,y))
                                empty_cell[(x // 3 * 3 + y // 3)].remove((x, y))
                        return flag


    def check_row_worked(self):
        changed_flag1 = False
        for row in empty_row:
            flag = self.getpset(row)
            while flag:
                changed_flag1 = True
                flag = self.getpset(row)
        return changed_flag1


    def check_col_worked(self):
        changed_flag2 = False
        for col in empty_col:
            flag = self.getpset(col)
            while flag:
                changed_flag2 = True
                flag = self.getpset(col)
        return changed_flag2

    def check_box_worked(self):
        changed_flag3 = False
        for box in empty_cell:
            flag = self.getpset(box)
            while flag:
                changed_flag3 = True
                flag = self.getpset(box)
            return changed_flag3

    def printc(self):
        with open(self.filename.replace('.txt', '_marked.tex'), 'w+') as btf:
            print('\\documentclass[10pt]{article}\n'
                  '\\usepackage[left=0pt,right=0pt]{geometry}\n'
                  '\\usepackage{tikz}\n'
                  '\\usetikzlibrary{positioning}\n'
                  '\\usepackage{cancel}\n'
                  '\\pagestyle{empty}\n'
                  '\n'
                  '\\newcommand{\\N}[5]{\\tikz{\\node[label=above left:{\\tiny #1},\n'
                  r'                               label=above right:{\tiny #2},''\n'
                  r'                               label=below left:{\tiny #3},''\n'
                  r'                               label=below right:{\tiny #4}]{#5};}}''\n'
                  '\n'
                  '\\begin{document}\n'
                  '\n'
                  '\\tikzset{every node/.style={minimum size=.5cm}}\n'
                  '\n'
                  '\\begin{center}\n'
                  '\\begin{tabular}{||@{}c@{}|@{}c@{}|@{}c@{}||@{}c@{}|@{}c@{}|@{}c@{}||@{}c@{}|@{}c@{}|@{}c@{}||}\hline\hline',file=btf
                  )
            i = 0

            for line in self.possible_grid:
                print(f'% Line {i+1}\n', end='', file=btf)
                # print(self.possible_grid, 'possiblegrid')
                #print(line, 'possiblegrid line')
                self.sortbynumber(line,btf)
                if i in [2, 5, 8]:
                    print('\hline\n', end='', file=btf)
                else:
                    print('\n', end='', file=btf)
                if i <= 7:
                    print('\n', end='', file=btf)
                i += 1

            print('\\end{tabular}\n'
                  '\\end{center}\n'
                  '\n'
                  '\\end{document}', file=btf)
        
    #worked_tex_output
    def worked_tex_output(self):
        from copy import deepcopy
        self.forced_tex_output()
        print_cancel = deepcopy(self.possible_grid)
        self.get_posssible()
        self.check_forced()

        while True:
            changed_flag1 = self.check_row_worked()
            changed_flag2 = self.check_col_worked()
            changed_flag3 = self.check_box_worked()
            if all([changed_flag1,changed_flag2,changed_flag3]):
                break
        #self.print_grid(self.possible_grid)





