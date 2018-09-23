# Uses data available at http://data.worldbank.org/indicator
# on Forest area (sq. km) and Agricultural land area (sq. km).
# Prompts the user for two distinct years between 1990 and 2004
# as well as for a strictly positive integer N,
# and outputs the top N countries where:
# - agricultural land area has increased from oldest input year to most recent input year;
# - forest area has increased from oldest input year to most recent input year;
# - the ratio of increase in agricultural land area to increase in forest area determines
#   output order.
# Countries are output from those whose ratio is largest to those whose ratio is smallest.
# In the unlikely case where many countries share the same ratio, countries are output in
# lexicographic order.
# In case fewer than N countries are found, only that number of countries is output.


# Written by Written and Eric Martin for COMP9021


import sys
import os
import csv
from collections import defaultdict


agricultural_land_filename = 'API_AG.LND.AGRI.K2_DS2_en_csv_v2.csv'
if not os.path.exists(agricultural_land_filename):
    print(f'No file named {agricultural_land_filename} in working directory, giving up...')
    sys.exit()
forest_filename = 'API_AG.LND.FRST.K2_DS2_en_csv_v2.csv'
if not os.path.exists(forest_filename):
    print(f'No file named {forest_filename} in working directory, giving up...')
    sys.exit()
try:
    years = {int(year) for year in
                           input('Input two distinct years in the range 1990 -- 2014: ').split('--')
            }
    if len(years) != 2 or any(year < 1990 or year > 2014 for year in years):
        raise ValueError
except ValueError:
    print('Not a valid range of years, giving up...')
    sys.exit()
try:
    top_n = int(input('Input a strictly positive integer: '))
    if top_n < 0:
        raise ValueError
except ValueError:
    print('Not a valid number, giving up...')
    sys.exit()


countries = []
year_1, year_2 = None, None

# Insert your code here
year1_dict =defaultdict(float)
year2_dict =defaultdict(float)
country = []


years_list = list(years)
if years_list[0] > years_list[1]:
    year_1 = years_list[1]
    year_2 = years_list[0]
else:
    year_1 = years_list[0]
    year_2 = years_list[1]

d_bound = int(year_1)-1960+4
u_bound = int(year_2)-1960+4



with open("API_AG.LND.AGRI.K2_DS2_en_csv_v2.csv","r",encoding="utf-8") as f_agri:
    i = 0
    for row1 in csv.reader(f_agri):
        i += 1
        if i <= 5:
            continue 
        else:
            try:
                year1_dict[row1[0]]=float(row1[u_bound])-float(row1[d_bound])
            except ValueError:
                continue
            except ZeroDivisionError:
                continue
        
    
with open("API_AG.LND.FRST.K2_DS2_en_csv_v2.csv","r",encoding="utf-8") as f_frst:
    i = 0
    
    for row2 in csv.reader(f_frst):
        i += 1
        if i <= 5:
            continue 
        else:
            
            try:
                year2_dict[row2[0]]=float(row2[u_bound])-float(row2[d_bound])
            except ValueError:
                continue
            except ZeroDivisionError:
                continue
             
             
            try:    
                country_value = year1_dict[row2[0]] / year2_dict[row2[0]]
            except ValueError:
                continue
            except ZeroDivisionError:
                continue
            
            country.append([row2[0],country_value])
                
                
            if year2_dict[row2[0]] < 0 and year1_dict[row2[0]] < 0 :
                try:
                    country_value = - year1_dict[row2[0]] / year2_dict[row2[0]]
                except ValueError:
                    continue
                except ZeroDivisionError:
                    continue
            
                            

                
countries1 = sorted(country,key = lambda x: x[1],reverse=True)



print(f'Here are the top {top_n} countries or categories where, between {year_1} and {year_2},\n'
      '  agricultural land and forest land areas have both strictly increased,\n'
      '  listed from the countries where the ratio of agricultural land area increase\n'
      '  to forest area increase is largest, to those where that ratio is smallest:')
for j in range(2*top_n):
    print(countries1[j][0],f"({countries1[j][1]:.2f})",sep = ' ')
