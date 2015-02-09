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
				trigrams.push_back(line.substr(0, pos));
				line.erase(0, pos + 1);
			}
			Word w(word, trigrams);
			if(word.length() <= MAX_SIZE)
				words[word.length()].push_back(w);
		}
	}

}

bool Dictionary::contains(const string& word) const {
	auto found = allwords.find(word);

	return found != allwords.end();
}

vector<string> Dictionary::get_suggestions(const string& word) const {
	vector<string> suggestions;
	add_trigram_suggestions(suggestions, word);
	rank_suggestions(suggestions, word);
  trim_suggestions(suggestions);
	return suggestions;
}

void Dictionary::add_trigram_suggestions(vector<string>& suggestions, const string& word) const{
	//get size of word
	int size = word.size();
	vector<string> wordtris;

	if(size > 2){
		//get trigrams
		for(unsigned long i = 0; i <= word.length() - 3; ++i){
			wordtris.push_back(word.substr(i, 3));
		}
		//sort trigrams
		sort(wordtris.begin(), wordtris.end());
		//get list of words -1/=/+1 size
		for(int i = size-1; i<=size+1 && i < MAX_SIZE; ++i){
			for(Word w : words[i]){
				//exract words that have atleast 50% trigrams that exists in word
				if(w.get_matches(wordtris) >= static_cast<float>(wordtris.size()) / 2.0){
					suggestions.push_back(w.get_word());
				}
			}
		}
	}
}

void Dictionary::rank_suggestions(vector<string>& suggestions, const string& word) const{
	vector<pair<string, int>> pairs;

	for(string s : suggestions){
		int d[26][26];
		d[0][0] = 0;
		for (int x = 1; x < 26; ++x) {
			d[x][0] = x;
			d[0][x] = x;
		}

		for (int x = 1; x <= word.length(); ++x)
		{
			for (int y = 1; y <= s.length(); ++y)
			{
				int diag = word[x-1] == s[y-1] ? d[x-1][y-1] : 1 + d[x-1][y-1];
				d[x][y] = min(min(diag, d[x-1][y] + 1), d[x][y-1] + 1);
			}
		}

		pair<string, int> p (s, d[word.length()][s.length()]);
		pairs.push_back(p);
	}

	sort(pairs.begin(), pairs.end(), compair);

	suggestions.clear();

	//trim top 5
	for (auto p : pairs)
	{
		suggestions.push_back(p.first);
	}
}

void Dictionary::trim_suggestions(vector<string>& suggestions) const{
  if(suggestions.size() > 5){
    suggestions.erase(suggestions.begin()+5, suggestions.end());
  }
}

bool Dictionary::compair(const pair<string,int>& p1, const pair<string,int>& p2){
	return p1.second < p2.second;
}
