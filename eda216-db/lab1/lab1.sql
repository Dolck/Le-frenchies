-- lab1

-- 3
-- a) all students first and lastnames
select firstName, lastName 
from students;


-- b) all students first and lastnames, ordered
select firstName, lastName 
from students 
order by lastName, firstName;


-- c) students born -85
select pNbr, firstName, lastName
from students
where pNbr like '85%';


--d) find females using pNbr
select pNbr, firstName, lastName 
from students 
where mod(substr(pNbr from -2 for 1), 2) = 0;


--e) nbr of students
select count(pNbr)
from students;


--f) math courses
select courseName
from courses
where courseCode like 'FMA%';


--g) more than 7.5 credits
select courseCode, courseName
from courses
where credits > 7.5;


--h) How may courses are there on each level G1, G2 and A?
select count(courseCode) 
from courses 
where level = 'G1' or level = 'G2' or level = 'A';


--i) which courses have 910101-1234 taken
select courseCode 
from takenCourses 
where pNbr = '910101-1234';


--j) names and number of credits of above courses
select courseName, credits
from courses
where courseCode in (select courseCode 
                     from takenCourses 
                     where pNbr = '910101-1234');

--alternative with natural join:
select courseName, courseCode
from courses natural join takenCourses
where pNbr = '910101-1234';


--k) how many credits in total?
select sum(credits)
from courses
where courseCode in (select courseCode 
                     from takenCourses 
                     where pNbr = '910101-1234');


--alternative with natural join:
select sum(credits)
from courses natural join takenCourses
where pNbr = '910101-1234';


--l) avg grade?
select avg(grade)
from takenCourses
where pNbr = '910101-1234';


--m) Same questions as in questions i)–l), but for the student Eva Alm. [26]
-- taken courses:
select courseName, courseCode
from courses natural join takenCourses natural join students
where firstName = 'Eva' and lastName = 'Alm';

--names and credits
select courseName, credits
from courses natural join takenCourses natural join students
where firstName = 'Eva' and lastName = 'Alm';

--sum credits
select sum(credits)
from courses natural join takenCourses natural join students
where firstName = 'Eva' and lastName = 'Alm';

--avg grade
select avg(grade)
from takenCourses natural join students
where firstName = 'Eva' and lastName = 'Alm';


--n) Which students have taken 0 credits?
select firstName, lastName
from students
where pNbr not in (
    select pNbr
    from takenCourses);


--o) Which students have the highest grade average?
select *
from (  select students.pNbr, firstName, lastName, avg(grade) as average 
        from takenCourses left join students 
        on takenCourses.pNbr = students.pNbr
        group by students.pNbr) as unsorted
order by unsorted.average;

--p) List the person number and total number of credits for all students. 
create view creditsSum as
    select pNbr, sum(credits) as creditSum
    from courses, takenCourses
    where courses.courseCode = takenCourses.courseCode
    group by pNbr;

select students.pNbr, ifnull(creditSum, 0) as credits
from students left outer join creditsSum
on students.pNbr = creditsSum.pNbr;

--q) Is there more than one students with the same name?
create view nameDup as
    SELECT firstName, lastName, count(*) as c
    FROM students
    GROUP BY firstName, lastName HAVING c > 1;

select firstName, lastName, pNbr
from students
where (firstName, lastname) in (select firstName, lastName 
                                from nameDup);