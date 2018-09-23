create table Employee(
    ssn text,
    birthdate date,
    name text,
    workin text not null,
    primary key (ssn),
    foreign key (workin) refernences Department(name),
    foreign key (manages) refernences Department(name)
);

create table Department(
    name text,
    phone text,
    location text,
    manager text not null,
    mdate date,
    primary key (name),
    foreign key (manager) references Employee(ssn)
);

create table Project(
    pname text,
    pnumber integer,
    primary key (panme,pnumber)
);


create table Dependant(
    relation text,
    birthdate date,
    name text,
    employee text,
    primary key (employee,name),
    foreign key (name) references Employee(ssn)
);


create table Participation(
    employee text,
    project text,
    time integer,
    primary key (employee,project),
    foreign key (employee) references Employee(ssn),
    foreign key (project) references Project(pname,pnumber)
    --is this right??????????

)

create table Participation(
    employee text,
    pna text,
    pno integer,
    time integer,
    primary key (employee,project),
    foreign key (employee) references Employee(ssn),
    foreign key (pna,pno) references Project(pname,pnumber)

)


