-- COMP9311 17s2 Assignment 1
-- Schema for OzCars
--
-- Date:
-- Student Name:
-- Student ID:
--

-- Some useful domains; you can define more if needed.

create domain URLType as
	varchar(100) check (value like 'http://%');

create domain EmailType as
	varchar(100) check (value like '%@%.%');

create domain PhoneType as
	char(10) check (value ~ '[0-9]{10}');

create domain MoneyType as
    numeric(6,4) check (value > 0);
-- EMPLOYEE

create table Employee (
	EID          serial,
    TFN          char(9) not null,
    salary       integer not null check (salary > 0),
	firstname    varchar(50) not null,
    lastname     varchar(50) not null,
	primary key (EID)
);

create table Admin (
    EID          integer references Employee(EID),
    primary key (EID)
);



create table Mechanic (
    license      char(8) not null check (license ~ '^[A-Za-z]+$'),
    EID          integer references Employee(EID),
    primary key (EID)
);



create table Salesman (
    commRate     integer not null check ( commRate >= 5 and commRate <= 20 ),
    EID          integer references Employee(EID),
    primary key (EID)
);


-- CLIENT

create table Client (
    CID          serial,
    name         varchar(100) not null,
    phone        PhoneType not null,
    email        EmailType,
    address      varchar(200) not null,
	primary key (CID)
);


create table Company (
	CID          integer references Client(CID),
	url          URLType,
    ABN          char(11),
	primary key (CID)
);

-- CAR

create domain CarLicenseType as
        varchar(6) check (value ~ '[0-9A-Za-z]{1,6}');

create domain OptionType as varchar(12)
	check (value in ('sunroof','moonroof','GPS','alloy wheels','leather'));

create domain VINType as char(17) check (value ~ '[0-9A-HJ-NPR-Z]{17}');



create table Car (
    VIN          VINType,
    year         integer check ( year >= 1970 and year <= 2099 ),
    model        varchar(40),
    manufacturer varchar(40),
    primary key(VIN)
);

create table Caroptions (
    VIN          VINType references Car(VIN),
    options      OptionType,
    primary key (VIN,options)

);

create table NewCar (
    cost         MoneyType,
    charges      MoneyType,
    VIN          VINType references Car(VIN),
    primary key (VIN)
);



create table UsedCar (
    plateNumber  varchar(6) check (plateNumber ~ '^[A-Za-z]+$'),
    VIN          VINType references Car(VIN),
    primary key (VIN)

);

--repairjob
create table RepairJob (
    parts        MoneyType,
    work         MoneyType,
    "date"       date,
    description  varchar(250),
    "number"     integer check ("number" >= 1 and "number" <= 999),
    Repairs      char(17) not null references UsedCar(VIN),
    PaidBy       integer not null references Client(CID),
    primary key ("number",Repairs)
);

create table MechanicDoesRepairJob (
    Mechanic     integer references Mechanic(EID),
    "number"     integer,
    Repairs      char(17),
    primary key (Mechanic,"number",Repairs),
    foreign key ("number",Repairs) references RepairJob("number",Repairs)

);

--Relation
create table Buys (
    price        MoneyType,
    commission   MoneyType,
    "date"       date,
    VIN          VINType references Car(VIN),
    salesman     integer references Salesman(EID),
    CID          integer references Client(CID),
    primary key (VIN,CID,"date")

);

create table Sells (
    "date"       date,
    price        MoneyType,
    commission   MoneyType,
    VIN          VINType references Car(VIN),
    CID          integer references Client(CID),
    salesman     integer references Salesman(EID),
    primary key (VIN,CID,"date")
);

create table SellsNew (
    "date"       date,
    price        MoneyType,
    commission   MoneyType,
    plateNumber  varchar(6) check (plateNumber ~ '^[A-Za-z]+$'),
    CID          integer references Client(CID),
    VIN          VINType references Car(VIN),
    salesman     integer references Salesman(EID),
    primary key (VIN,CID,"date")
);
