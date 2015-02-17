#include <string>
#include <iostream>
#include <sstream>
#include "date.h"
#include <stdexcept>

using namespace std;

template <typename T>
T string_cast(const string& s){
	istringstream in(s);
	T result;
	in >> result;
	if(!in){
		in.clear();
		in.ignore(numeric_limits<streamsize>::max(), '\n');
		throw std::invalid_argument("Invalid syntax.");
	}
	return result;
}

int main()
{
	try {
		int i = string_cast<int>("123");
		double d = string_cast<double>("12.34");
		Date date = string_cast<Date>("2015-01-10");
		cout << i << endl;
		cout << d << endl;
		cout << date << endl;
	} catch (std::invalid_argument& e) {
		cout << "Error: " << e.what() << endl;
	}
}