#include <iostream>
#include <regex>
#include "tagremover.h"

TagRemover::TagRemover(istream& in): in(in) { }

void TagRemover::print(ostream& out) const {
	istreambuf_iterator<char> eos;
	string test(std::istreambuf_iterator<char>(in), eos);
	test = regex_replace(test, regex("(<.*?(\n.*)*?>)"), "");
	test = regex_replace(test, regex("&lt"), "<");
	test = regex_replace(test, regex("&gt"), ">");
	test = regex_replace(test, regex("&nbsp"), " ");
	test = regex_replace(test, regex("&amp"), "&");
	out << test;
}

int main() {
	TagRemover tr(cin); // read from cin
	tr.print(cout); // print on cout
}
