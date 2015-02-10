include "globals.mzn";

int: del_add;     % duration for addition
int: del_mul;     % duration for multiplication
int: number_add;  % number of adders
int: number_mul;  % number of multiplicators
int: n;           % number of tasks
set of int: last; % the final tasks that have to be run
set of int: add;  % all tasks that require additions
set of int: mul;  % all tasks that require multiplications
array[1..n] of set of int: dependencies; % all dependencies between tasks, index task before set of tasks at index

var 1..52: totalCycles;
array[1..n] of var 0..50: startTimes;   % x
array[1..n] of var 0..5: durations;     % dx
array[1..n] of var 0..10: workers;      % y
array[1..n] of var 1..1: required;      % dy



%array[1..12] of var del_add..del_add: dur_add;
%array[1..16] of var del_mul..del_mul: dur_mul;
%array[1..12] of var 1..1: req_add;
%array[1..16] of var 1..1: req_mul;

%array[1..12] of var 0..1000: addStart;
%array[1..16] of var 0..1000: mulStart;

constraint forall (a in 1..12) (durations[add[a]] = del_add);
constraint forall (m in 1..16) (durations[mul[m]] = del_mul);
constraint forall (i in 1..n) (forall (d in dependencies[i]) (startTimes[d] >= startTimes[i]+durations[i]));
constraint forall (a in 1..12) (workers[add[a]] < number_add);
constraint forall (m in 1..16) (workers[mul[m]] >= number_add /\ workers[mul[m]] < number_add + number_mul);
constraint diffn(startTimes, workers, durations, required);
%constraint forall (a in add) (req_add[a] = 1 /\ req_mul[a] = 5);
%constraint forall (a in 1..12) (addStart[a] = startTimes[add[a]]);
%constraint forall (m in mul) (req_mul[m] = 1 /\ req_add[m] = 5);
%constraint forall (m in 1..16) (mulStart[m] = startTimes[mul[m]]);
%constraint cumulative(addStart, dur_add, req_add, number_add);
%constraint cumulative(mulStart, dur_mul, req_mul, number_mul);
%constraint diffn(startTimes, adders, durations, req_add);
%constraint diffn(startTimes, multipliers, durations, req_mul);
constraint forall (l in last) (totalCycles >= startTimes[l]+durations[l]);

solve minimize totalCycles;
output[show(durations),"\n",show(startTimes),"\n",show(totalCycles)];
