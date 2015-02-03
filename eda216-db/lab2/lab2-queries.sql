--7b) List all movies that are shown, list dates when a movie is shown, list all data concerning a movie performance.
select *
from movies;

select movieTitle, pDate
from performances
where movieTitle = 'Star Wars';

select *
from performances
where movieTitle = 'Star Wars' and pDate = '2015-02-03';

--7c) create reservation
insert into Reservations(userName, movieTitle, pDate) values
    ('user2', 'Star Wars', '2015-02-02');


--8) Check constraints
--two theaters with same name:
insert into Theaters values
    ('SF', 123); 
    --gives duplicate entry error

--two performances with same movie && date
insert into Performances(movieTitle, pDate, theaterName, availSeats) values
    ('Star Wars', '2015-02-03', 'SF', (select nbrSeats from Theaters where name = 'SF'));
    --gives duplicate entry error

--insert a performance with an non-existing theater
insert into Performances(movieTitle, pDate, theaterName, availSeats) values
    ('Star Wars', '2015-02-04', 'Mamma mia', (select nbrSeats from Theaters where name = 'Mamma mia'));
    --Column cannot be null
    --If value is given, a foreign key constraint fails

--insert a ticket reservation where the user doesn’t exist
insert into Reservations(userName, movieTitle, pDate) values
    ('userUnknown', 'Star Wars', '2015-02-03');
    --foreign key constraint, username

--insert a ticket reservation where the performance doesn’t exist
insert into Reservations(userName, movieTitle, pDate) values
    ('user2', 'Star Wars', '2015-01-01');
    --foreign key constraint, performance

--9) What problems can arise if several bookings is done simultaniously?
--Too many bookings can be done