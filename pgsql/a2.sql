
--Q1
create or replace view Q1(Name,Country) as
select name,country
from company
where country != 'Australia'; 

--Q2
create or replace view Q2(Code) as
select code, count(code) 
from executive group by code 
having count(code) > 5;

--Q3
create or replace view Q3(Name) as 
select c.name
from company c join category ca on (c.code=ca.code)
where ca.sector = 'Technology';

--Q4
create or replace view Q4(Sector, number) as
select sector, count(distinct(industry))
from category
group by sector;

--Q5
create or replace view Q5(Name) as
select e.person 
from executive e join category c on (e.code=c.code)
where c.sector = 'Technology';


--Q6
create or replace view Q6(Name) as
select c.name 
from company c join category ca on (c.code=ca.code)
where ca.sector='Services' and country = 'Australia' and zip ~ '^2'; 

--Q7
create or replace view Q7("Date", Code, Volume, PrevPrice, Price, Change, Gain) as
select a2."Date", a2.code, a2.volume, a1.price, a2.price, a2.price-a1.price, round((a2.price-a1.price)/a1.price*100,2)
from asx a1 join asx a2 on (a1.code=a2.code) and  a1."Date" =(select max("Date") from asx where code=a2.code and "Date" < a2."Date");

--Q8
create or replace view Q8("Date",Code,Volume) as
select a2."Date", a1.code, a1.volume
from asx a1 join (select "Date", max(volume) from asx group by "Date") a2 on (a1."Date"=a2."Date") and (a1.volume=a2.max)
order by "Date", code;

--Q9
create or replace view Q9(Sector, Industry, Number) as
select distinct a.sector,b.industry,b.count
from category a join (select industry,count(code) from category group by industry) b on (a.industry=b.industry)
order by sector,industry;

--Q10
create or replace view Q10(Code, Industry) as
select a1.code,a2.industry 
from category a1 join (select industry,count(*) from category group by industry ) a2 on (a1.industry=a2.industry)
where a2.count = 1; 

--Q11
create or replace view avgrate(sector,avgrating) as
select a.sector, b.avg 
from category a join (select code,avg(star) from rating group by code ) b on ( a.code = b.code);

create or replace view Q11(sector, avgrating) as
select sector, avg(avgrating)
from avgrate
group by sector
order by avg desc;

--Q12
create or replace view Q12(Name) as
select person 
from executive
group by person
having count(person) > 1; 

--Q13
create or replace view Q13(Code, Name, Address, Zip, Sector) as
select c.code, c.name, c.address, c.zip, ca.sector
from company c join category ca on (c.code=ca.code)
where ca.sector not in (select distinct(sector) from category where code in (select code from company where country != 'Australia')); 

--Q14
create or replace view Q14(Code, BeginPrice, EndPrice, Change, Gain) as
select a2.code, a1.price, a2.price, a2.price-a1.price, round((a2.price-a1.price)/a1.price*100,2) gain
from asx a1 join asx a2 on (a1.code=a2.code) and  a1."Date" =(select min("Date") from asx where code=a2.code and "Date" < a2."Date") and a2."Date" = (select max("Date") from asx where code=a1.code and "Date" > a1."Date")
order by gain desc,code desc;

--Q15
create or replace view pricev(code,minprice,avgprice,maxprice) as
select code, min(price), round(avg(price),2),max(price) 
from asx
group by code;

create or replace view gainv(code,mindaygain,avgdaygain,maxdaygain) as
select code,min(gain), round(avg(gain),2), max(gain)
from Q7
group by code;

create or replace view Q15(Code, MinPrice, AvgPrice, MaxPrice, MinDayGain, AvgDayGain, MaxDayGain) as
select g1.code, g2.minprice, g2.avgprice, g2.maxprice, g1.mindaygain, g1.avgdaygain, g1.maxdaygain
from gainv g1 join pricev g2 on (g1.code=g2.code); 

--Q16
create or replace function
	disallow() returns trigger
as $$
begin
	if TG_OP = 'INSERT' and (select count(person) from executive where person=new.person) > 0 then
	raise exception 'Error,the person already exists';
	elsif TG_OP = 'UPDATE' then
		if old.person=new.person and old.code=new.code then
		raise exception 'Error, No change to the table.';
		elsif new.person!=old.person and (select count(new.person) from executive) > 0 then
		raise exception 'Error, the person already exits';
		end if;	
	end if;
	return new;
end;
$$ language 'plpgsql';

drop trigger if exists CheckExecutive on executive;
create trigger CheckExecutive 
before insert or update on executive
for each row
execute procedure disallow();

--Q18
create or replace function 
	addlog() returns trigger
as $$
begin
	if old.price != new.price or old.volume != new.volume then
	insert into asxlog ("Timestamp",code,"Date",oldprice,oldvolume) values (now(),old.code,old."Date", old.price,old.volume);
	end if;
	return null;
end;
$$ language 'plpgsql';
 
drop trigger if exists Createlog on asx;
create trigger Createlog
after update on asx
for each row
execute procedure addlog();

