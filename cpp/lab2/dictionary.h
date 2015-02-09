#ifndef DICTIONARY_H
#define DICTIONARY_H
#define MAX_SIZE (25)

#include <string>
#include <vector>
#include <unordered_set>
#include "word.h"

using namespace std;

class Dictionary {
public:
	Dictionary();
	bool contains(const std::string& word) const;
	std::vector<std::string> get_suggestions(const std::string& word) const;
private:
	void add_trigram_suggestions(vector<string>& suggestions, const string& word) const; // can we have const here?
	void rank_suggestions(vector<string>& suggestions, const string& word) const; // can we have const here?
	static bool compair(const pair<string, int>& p1, const pair<string, int>& p2);
	unordered_set<string> allwords;
	vector<Word> words[MAX_SIZE + 1]; 
};

#endif
