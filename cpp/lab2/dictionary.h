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
	unordered_set<string> allwords;
	vector<Word> words[MAX_SIZE]; 
};

#endif
