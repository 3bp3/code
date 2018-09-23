create table stores(
    phone varchar(15) primary key,
    address text not null,
);
create table customers(
    cust_id integer primary key,
    name varchar(50) not null,
    address text not null,
    hasfavourite text references stores(phone)

);


create table accounts(
    acct_id integer primary key,
    balance integer not null,
    for_use_at varchar(30) not null refernces stores(phone)
);

create table has(
    account integer not null,
    customer integer not null,
    primary key(account,customer)
)
