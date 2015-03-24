-- SQL script to create the tables necessary for our project in eda216
--
--
-- We disable foreign key checks temporarily so we can delete the
-- tables in arbitrary order, and so insertion is faster.

set FOREIGN_KEY_CHECKS = 0;

-- Drop the tables if they already exist.

drop table if exists RawMaterials;
drop table if exists RecipeDetails;
drop table if exists CookieNames;
drop table if exists Pallets;
drop table if exists OrderDetails;
drop table if exists Orders;
drop table if exists Customers;

-- Create the tables. The 'check' constraints are not effective in MySQL. 

create table RawMaterials (
    rawType     varchar(30) not null,
    quantity    integer default 100000000 check (quantity >= 0),
    unitOfM     enum('g', 'ml') not null,
    lastDeliv   datetime,
    lastDelivQ  integer,
    primary key (rawType)
);

create table RecipeDetails (
    cookieName  varchar(20) not null,
    rawType     varchar(30) not null,
    quantity    integer not null,
    primary key (cookieName, rawType),
    foreign key (cookieName) references CookieNames(cookieName),
    foreign key (rawType) references RawMaterials(rawType)
);

create table CookieNames (
    cookieName  varchar(20) not null,
    primary key (cookieName)
);

create table Pallets (
    id          integer auto_increment,
    prodTime    datetime not null,
    cookieName  varchar(20) not null,
    status      enum('free', 'blocked', 'ordered', 'delivered') not null default 'free',
    orderId     integer default null,
    primary key (id),
    foreign key (cookieName) references CookieNames(cookieName),
    foreign key (orderId) references OrderDetails(orderId)
);

create table Customers (
    cName       varchar(30) not null,
    cAddress    varchar(30) not null,
    primary key (cName, cAddress)
);

create table Orders (
    orderId     integer auto_increment,
    nbrPallets  integer not null check (nbrPallets > 0),
    incomeDate  datetime not null,
    delivDate   datetime not null,
    cName       varchar(30) not null,
    cAddress    varchar(30) not null,
    primary key (orderId),
    foreign key (cName, cAddress) references Customers(cName, cAddress)
);

create table OrderDetails (
    orderId     integer not null,
    cookieName  varchar(20) not null,
    nbrPallets  integer not null check (nbrPallets >= 0),
    primary key (orderId, cookieName),
    foreign key (orderId) references Orders(orderId),
    foreign key (cookieName) references CookieNames(cookieName)
);

-- We will do a lot of inserts, so we start a transaction to make it faster.

start transaction;

insert into Customers(cName, cAddress) values
    ('Finkakor AB', 'Helsingborg'),
    ('Småbröd AB', 'Malmö'),
    ('Kaffebröd AB', 'Landskrona'),
    ('Bjudkakor AB', 'Ystad'),
    ('Kalaskakor AB', 'Trelleborg'),
    ('Partykakor AB', 'Kristianstad'),
    ('Gästkakor AB', 'Hässleholm'),
    ('Skånekakor AB', 'Perstorp');

insert into CookieNames(cookieName) values
    ('Nut ring'),
    ('Nut cookie'),
    ('Amneris'),
    ('Tango'),
    ('Almond delight'),
    ('Berliner');

insert into RawMaterials(rawType, unitOfM) values
    ('Flour', 'g'),
    ('Butter', 'g'),
    ('Icing sugar', 'g'),
    ('Roasted, chopped nuts', 'g'),
    ('Fine-ground nuts', 'g'),
    ('Ground, roasted nuts', 'g'),
    ('Bread crumbs', 'g'),
    ('Sugar', 'g'),
    ('Egg whites', 'ml'),
    ('Chocolate', 'g'),
    ('Marzipan', 'g'),
    ('Eggs', 'g'),
    ('Potato starch', 'g'),
    ('Wheat flour', 'g'),
    ('Sodium bicarbonate', 'g'),
    ('Vanilla', 'g'),
    ('Chopped almonds', 'g'),
    ('Cinnamon', 'g'),
    ('Vanilla sugar', 'g');

insert into RecipeDetails(cookieName, rawType, quantity) values
    ('Nut ring', 'Flour', 24300),
    ('Nut ring', 'Butter', 24300),
    ('Nut ring', 'Icing Sugar', 10260),
    ('Nut ring', 'Roasted, chopped nuts', 12150),
    ('Nut cookie', 'Fine-ground nuts', 40500),
    ('Nut cookie', 'Ground, roasted nuts', 33750),
    ('Nut cookie', 'Bread crumbs', 6750),
    ('Nut cookie', 'Sugar', 20250),
    ('Nut cookie', 'Egg whites', 18900),
    ('Nut cookie', 'Chocolate', 2700),
    ('Amneris', 'Marzipan', 40500),
    ('Amneris', 'Butter', 13500),
    ('Amneris', 'Eggs', 13500),
    ('Amneris', 'Potato starch', 1350),
    ('Amneris', 'Wheat flour', 1350),
    ('Tango', 'Butter', 10800),
    ('Tango', 'Sugar', 13500),
    ('Tango', 'Flour', 16200),
    ('Tango', 'Sodium bicarbonate', 216),
    ('Tango', 'Vanilla', 108),
    ('Almond delight', 'Butter', 21600),
    ('Almond delight', 'Sugar', 14580),
    ('Almond delight', 'Chopped almonds', 15066),
    ('Almond delight', 'Flour', 21600),
    ('Almond delight', 'Cinnamon', 540),
    ('Berliner', 'Flour', 18900),
    ('Berliner', 'Butter', 13500),
    ('Berliner', 'Icing sugar', 5400),
    ('Berliner', 'Eggs', 2700),
    ('Berliner', 'Vanilla sugar', 270),
    ('Berliner', 'Chocolate', 2700);

insert into Orders (nbrpallets, incomedate, delivdate, cname, caddress) values 
    (100, now(), '2015-11-11 12:45:34', 'Småbröd AB', 'Malmö');

insert into OrderDetails values
    (1, 'Tango', 25),
    (1, 'Nut ring', 25),
    (1, 'Berliner', 25),
    (1, 'Amneris', 25);

-- Commit the transaction.

commit;

-- And re-enable foreign key checks.

set FOREIGN_KEY_CHECKS = 1;

