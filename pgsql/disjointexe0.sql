create table student(
    sid integer primary key,
    name text,
    address text
);

create table undergrad(
    degree text,
    sid integer references student(sid),
    primary key (sid)
);

create table student(
    major text,
    sid integer references student(sid),
    primary key (sid)
);


create table student(
    thesis text,
    sid integer references student(sid),
    primary key (sid)
);






