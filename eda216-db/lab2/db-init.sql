-- Delete the tables if they exist. Set foreign_key_checks = 0 to
-- disable foreign key checks, so the tables may be dropped in
-- arbitrary order.
set foreign_key_checks = 0;
drop table if exists Users;
drop table if exists Movies;
drop table if exists Theaters;
drop table if exists Reservations;
drop table if exists Performances;

-- Create the tables.
create table Users (
    userName    varchar(20) not null,
    name        varchar(20) not null,
    address     varchar(30),
    phone       char(10) not null,
    primary key (userName)
);

create table Movies (
    title       varchar(30) not null,
    primary key (title)
);

create table Theaters (
    name        varchar(30),
    nbrSeats    int unsigned,
    primary key (name)
);

create table Performances (
    movieTitle  varchar(30) not null,
    pDate       date not null,
    theaterName varchar(30) not null,
    primary key (movieTitle, pDate),
    foreign key (movieTitle) references Movies(title),
    foreign key (theaterName) references Theaters(name)
);

create table Reservations (
    id          integer auto_increment,
    userName    varchar(20) not null,
    movieTitle  varchar(30) not null,
    pDate       date not null,
    primary key (id),
    foreign key (userName) references Users(userName),
    foreign key (movieTitle, pDate) references Performances(movieTitle, pDate)
);

start transaction;

-- Insert data into the tables.
insert into Users values
    ('user1', 'name1', null, '0123456789');

insert into Movies values
    ('Star Wars');

insert into Theaters values
    ('SF', 10);

insert into Performances(movieTitle, pDate, theaterName) values
    ('Star Wars', curdate(), 'SF');

insert into Reservations(userName, movieTitle, pDate) values
    ('user1', 'Star Wars', curDate());

commit;

set foreign_key_checks = 1;