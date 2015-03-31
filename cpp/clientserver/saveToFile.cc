#include "saveToFile.h"

#include <iostream>

using namespace std;

vector<newsgroup>& SaveToFile::readNewsgroups(int& nid, int& aid){

}

void SaveToFile::writeNewgroups(const vector<newsgroup>& ngs, int nid, int aid){
	ofstream file(fileName);
	if(file.is_open()){		
		myfile << nid << endl;
		myfile << aid << endl;
		myfile << ngs.size() << endl;
		for(const newsgroup& ng : ngs) {
			myfile << ng.id << "\t" << ng.name << "\t" << ng.articles.size() << "\t";
			for(const article& a : ng.articles){
				myfile << a.id << "\t" << a.title << "\t" << a.author << "\t" << a.article_text << "\t";
			}
		}
	}
}

