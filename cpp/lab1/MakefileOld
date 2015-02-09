# The following rule means: "if ltest is older than ltest.o or list.o,
# then link ltest".
ltest: ltest.o list.o
	g++ -o ltest ltest.o list.o

# Rules to create the object files.
ltest.o: ltest.cc list.h
	g++ -c ltest.cc -std=c++11
list.o: list.cc list.h
	g++ -c list.cc -std=c++11
