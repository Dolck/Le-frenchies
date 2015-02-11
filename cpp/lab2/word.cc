#include <string>
#include <vector>
#include "word.h"

using namespace std;

Word::Word(const string& w, const vector<string>& t) : word(w), trigrams(t) {}

string Word::get_word() const {
	return word;
}

unsigned int Word::get_matches(const vector<string>& t) const {
	unsigned int count(0);
	for(const string& s : t){
		for(const string& tri : trigrams){
			if(s == tri){
				++count;
			}else if(tri > s){
				continue;
			}
		}
	}
	return count;
}
