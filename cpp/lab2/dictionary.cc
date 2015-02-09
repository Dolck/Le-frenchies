#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include <algorithm>
#include "word.h"
#include "dictionary.h"

using namespace std;

Dictionary::Dictionary() {
	//Load word-file here :)

	ifstream in("words.txt");
	if(in.is_open()){
		string line;
		while(getline (in, line)){
			size_t pos = 0;
			pos = line.find(" ");
			words.push_back(line.substr(0, pos));
			line.erase(0, pos + 1);
			// Läs in resten här
		}
	}

}

bool Dictionary::contains(const string& word) const {
	auto found = words.find(word);

	return found != words.end();
}

vector<string> Dictionary::get_suggestions(const string& word) const {
	vector<string> suggestions;
	return suggestions;
}
