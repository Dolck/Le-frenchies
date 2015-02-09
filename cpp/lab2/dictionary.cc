#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include <algorithm>
#include "word.h"
#include "dictionary.h"

using namespace std;

Dictionary::Dictionary() {
	ifstream in("words.txt");
	if(in.is_open()){
		string line;
		while(getline (in, line)){
			size_t pos = 0;
			pos = line.find(" ");
			string word = line.substr(0, pos);
			allwords.insert(word);
			line.erase(0, pos + 1);
			
			pos = line.find(" ");
			int c = stoi(line.substr(0, pos));
			line.erase(0, pos + 1);

			vector<string> trigrams;
			for (int i = 0; i < c; ++i)
			{
				pos = line.find(" ");
				push_back(line.substr(0, pos));
				line.erase(0, pos + 1);
			}
			Word w(word, trigrams);
			if(word.length() <= MAX_SIZE)
				words[words.length()].push_back(w);
		}
	}

}

bool Dictionary::contains(const string& word) const {
	auto found = allwords.find(word);

	return found != words.end();
}

vector<string> Dictionary::get_suggestions(const string& word) const {
	vector<string> suggestions;
	return suggestions;
}
