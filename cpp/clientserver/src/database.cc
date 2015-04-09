#include "newsobjects.h"
#include "database.h"

#include <iostream>
#include <fstream>

using namespace std;

void Database::readNewsgroups(vector<newsgroup>& ngs, int& nid, int& aid){
  ngs.clear();
  int nbrg;
  ifstream file("database.txt");
  if(file.is_open()){
    string line;
    getline(file, line);
    nid = stoi(line);
    getline(file, line);
    aid = stoi(line);
    getline(file, line);
    nbrg = stoi(line);
    for(int i = 0; i<nbrg; ++i){
      newsgroup ng;
      int ngid, ngsize;
      string name;
      vector<article> arts;

      getline(file, line, '\t');
      ngid = stoi(line);
      getline(file, line, '\t');
      name = line;
      getline(file, line, '\t');
      ngsize = stoi(line);

      ng.id = ngid;
      ng.name = name;
      for(int j = 0; j < ngsize; ++j){
        article art;
        int artid;
        string title, author, text;

        getline(file, line, '\t');
        artid = stoi(line);
        getline(file, line, '\t');
        title = line;
        getline(file, line, '\t');
        author = line;
        getline(file, line, '\t');
        text = line;

        art.id = artid;
        art.title = title;
        art.author = author;
        art.article_text = text;
        arts.push_back(art);
      }
      ng.articles = arts;
      ngs.push_back(ng);
    }
    file.close();
  }else{
  	nid = 0;
  	aid = 0;
  }
}

void Database::writeNewsgroups(const vector<newsgroup>& ngs, int nid, int aid){
	ofstream file("database.txt");
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
		file.close();
	}
}

