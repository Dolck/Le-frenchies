#ifndef TAGREMOVER_H
#define TAGREMOVER_H

#include <string>
#include <iostream>

using namespace std;

class TagRemover {
public:
	TagRemover(istream& in);
	void print(ostream& out) const;
private:
	istream& in;
};

#endif