#include "saveToFile.h"

#include <iostream>

using namespace std;

vector<newsgroup>& SaveToFile::readNewsgroups(int& nid, int& aid){

}

void SaveToFile::writeNewsgroups(const vector<newsgroup>& ngs, int nid, int aid){
	ofstream file(fileName);
	if(file.is_open()){		
		file << nid << endl;
		file << aid << endl;
		file << ngs.size() << endl;
		for(const newsgroup& ng : ngs) {
			file << ng.id << "\t" << ng.name << "\t" << ng.articles.size() << "\t";
			for(const article& a : ng.articles){
				file << a.id << "\t" << a.title << "\t" << a.author << "\t" << a.article_text << "\t";
			}
			file.flush();
		}
		file.close()
	}
}

