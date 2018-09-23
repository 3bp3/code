create table accounts(
    accountno text,
    balance float,
    branchname text,
    primary key (accountno),
    foreign key(branchname) references branches(branchname)

);

create table branches(
    branchname text,
    address text,
    assests integer,
    primary key(brachname)
);

create table customers(
    customerno integer,
    name text,
    address text,
    homebranch text,
    primary key (customerno),
    foreign key (homebranch) references branches(branchname)

);

create accountHeldbyCustomer(
    account text,
    customer integer,
    primary key (account,customer),
    foreign key (account) references accounts(accountno),
    foerign key (customer) references customers(customerno)
);

