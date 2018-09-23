--Q1
select name from Beers
where manf = 'Toohey''s';

--Q2
select name as "Beer", manf as "Brewer"
from Beers;

--Q3
select name 
from beers b join likes l on （b.name = l.beer)
where l.drinker = 'John';

--Q4
select b1.name,b2.name 
from beers b1 join beers b2 on (b1.manf = b2.manf)
where b1.name < b2.name;

--Q5
select name 
from beers
where name in (select name from beers group by manf having count(*)=1);

