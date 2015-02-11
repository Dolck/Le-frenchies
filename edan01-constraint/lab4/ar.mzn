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

constraint forall (a in 1..12) (durations[add[a]] = del_add);
constraint forall (m in 1..16) (durations[mul[m]] = del_mul);
constraint forall (i in 1..n) (forall (d in dependencies[i]) (startTimes[d] >= startTimes[i]+durations[i]));
constraint forall (a in 1..12) (workers[add[a]] < number_add);
constraint forall (m in 1..16) (workers[mul[m]] >= number_add /\ workers[mul[m]] < number_add + number_mul);
constraint diffn(startTimes, workers, durations, required);
constraint forall (l in last) (totalCycles >= startTimes[l]+durations[l]);

solve :: seq_search([
    int_search(startTimes, smallest, indomain_min, complete)]) 
  minimize totalCycles;

output[show(durations),"\n",show(startTimes),"\n",show(totalCycles)];

/*
results:
Config        ClockCycles   runtime[s]    
1,1           34            1.705
1,2           18            0.345
1,3           16            0.242
2,2           18            0.486
2,3           15            0.216
2,4           11            0.232
ALL OPTIMAL
*/
