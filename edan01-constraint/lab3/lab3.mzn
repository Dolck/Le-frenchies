include "globals.mzn";

var 1..4: one;
var 1..4: two;
var 1..6: three;
var 1..7: four;
var 3..7: five;
var 3..8: six;
var 4..9: seven;
var 6..10: eight;
var 7..10: nine;
int: ten = 11;
int: root = 1;

var 1..10000: totalDistance;

int: tank = 10;
array[1..11, 1..11] of int: dist;

dist = [|99, 10, 11,  6, 99, 99, 99, 99, 99, 99,  0,
        |10,  0,  5,  8, 99, 99, 99, 99, 99, 99, 99,
        |11,  5,  0, 99,  3,  5, 99, 99, 99, 99, 99,
        | 6,  8, 99,  0,  2,  6,  7, 99, 99, 99, 99,
        |99, 99,  3,  2,  0, 99, 12, 99, 99, 99, 99,
        |99, 99,  5,  6, 99,  0, 99, 14, 99, 99, 99,
        |99, 99, 99,  7, 12, 99,  0,  5,  3, 99, 99,
        |99, 99, 99, 99, 99, 14,  5,  0,  1,  9, 99,
        |99, 99, 99, 99, 99, 99,  3,  1,  0,  2, 99,
        |99, 99, 99, 99, 99, 99, 99,  9,  2,  0,  0,
        | 0, 99, 99, 99, 99, 99, 99, 99, 99,  0, 99|];

array[1..11] of int: fuel = [10, 10, 8, 12, 13, 9, 10, 11, 12, 8, 99];

array[1..11] of var int: fd = [one,two,three,four,five,six,seven,eight,nine,ten,root];

constraint sum (i in fd) (dist[i,fd[i]]) = totalDistance;

constraint subcircuit(fd);

solve minimize totalDistance;

output[show(fd)];


