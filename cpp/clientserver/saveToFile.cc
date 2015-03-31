#include "saveToFile.h"

#include <iostream>

using namespace std;

vector<newsgroup> SaveToFile::readNewsgroups(){

}

void SaveToFile::writeNewgroups(const vector<newsgroup>& ngs){
	ofstream file(fileName);
	if(file.is_open()){		
		myfile << ngId << endl;
		myfile << aId << endl;
		
		for(newsgroup ng : ngs) {
			myfile << 
		}
	}
}