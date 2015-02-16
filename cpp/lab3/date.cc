#include <ctime>  // time and localtime
#include <iomanip>
#include <iostream>
#include "date.h"

int Date::daysPerMonth[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

Date::Date() {
	time_t timer = time(0); // time in seconds since 1970-01-01
	tm* locTime = localtime(&timer); // broken-down time
	year = 1900 + locTime->tm_year;
	month = 1 + locTime->tm_mon;
	day = locTime->tm_mday;
}

Date::Date(int y, int m, int d){
  if(y > 999 && y <= 9999){
    year = y;
    if(m > 0 && m <=12){
      month = m;
      if(d > 0 && d <= daysPerMonth[month-1]){
        day = d;
      } else{
        cerr << "Wrong day format.." << endl;
        exit(1);
      }
    } else {
      cerr << "Wrong month format.." << endl;
      exit(1);
    }
  } else {
    cerr << "Wrong year format.." << endl;
    exit(1);
  }
}

int Date::getYear() const {
	return year;
}

int Date::getMonth() const {
	return month;
}

int Date::getDay() const {
	return day;
}

void Date::next() {
  day++;
  if(day > daysPerMonth[month - 1]){
    day = 1;
    month++;
    if(month > 12){
      month = 1;
      year++;
    }
  }
}

ostream& operator<<(ostream& out, const Date& date) {
	out << date.getYear() << "-";
	out << setfill('0') << setw(2) << date.getMonth() << "-";
	out << setfill('0') << setw(2) << date.getDay();
	return out;
}

istream& operator>>(istream& is, Date& date){
	int year, month, day;
	return is;
}

