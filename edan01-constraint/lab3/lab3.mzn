include "globals.mzn"

% 10 10 8 12 13 9 10 11 12 8
int tank = 10;
array[1..10, 1..10] of int: dist;

dist = [| 0, 10, 11,  6,  0,  0,  0,  0,  0,  0,
		|10,  0,  5,  8,  0,  0,  0,  0,  0,  0,
		|11,  5,  0,  0,  3,  5,  0,  0,  0,  0,
		| 6,  8,  0,  0,  2,  6,  7,  0,  0,  0,
		| 0,  0,  3,  2,  0,  0, 12,  0,  0,  0,
		| 0,  0,  5,  6,  0,  0,  0, 14,  0,  0,
		| 0,  0,  0,  7, 12,  0,  0,  5,  3,  0,
		| 0,  0,  0,  0,  0, 14,  5,  0,  1,  9,
		| 0,  0,  0,  0,  0,  0,  3,  1,  0,  2,
		| 0,  0,  0,  0,  0,  0,  0,  9,  2,  0|];

array[1..10] of int: fuel;

fuel = [10, 10, 8, 12, 13, 9, 10, 11, 12, 8];

var 1..4: one;
var 1..4: two;
var 1..6: three;
var 1..7: four;
var 3..7: five;
var 3..8: six;
var 4..9: seven;
var 6..10: eight;
var 7..10: nine;
var 8..10: ten;

array[1..10]of var int: fd = [one,two,three,four,five,six,seven,eight,nine,ten];




