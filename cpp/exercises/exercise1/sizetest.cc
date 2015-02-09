/*
 * Explain the output of the following program.
 */

#include "point.h"

#include <iostream>

using namespace std;

int main() {
	Point p(1, 2);
	cout << "sizeof(p)      = " << sizeof(p) << endl; //size of two double values
	cout << "2*sizeof(double) = " << 2*sizeof(double) << endl;
	
	Point* pp = new Point(1, 2);
	cout << "sizeof(pp)     = " << sizeof(pp) << endl; // size of the actual pointer, 32 or 64 bit <=> 4 or 8 bytes
	cout << "sizeof(*pp)    = " << sizeof(*pp) << endl; // size of the object pointed to, size of two doubles
	
	delete pp;
}
