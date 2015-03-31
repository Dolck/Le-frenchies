#include "saveToFile.h"

#include <iostream>

using namespace std;

vector<newsgroup>& SaveToFile::readNewsgroups(int& nid, int& aid){

}

void SaveToFile::writeNewgroups(const vector<newsgroup>& ngs, int nid, int aid){
	ofstream file(fileName);
	if(file.is_open()){		
		myfile << ngId << endl;
		myfile << aId << endl;
		
		for(newsgroup ng : ngs) {
			myfile << 
		}
	}
}

