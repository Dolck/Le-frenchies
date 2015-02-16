#include <string>
#include <iostream>
#include <sstream>
#include "date.h"

using namespace std;

template<typename T>
string toString(T const& obj){
  ostringstream out;
  out << obj;
  return out.str();
}

int main(){
  double d = 1.234;
  Date today;
  string sd = toString(d);
  string st = toString(today);
  cout << sd << endl;
  cout << st << endl;
}
