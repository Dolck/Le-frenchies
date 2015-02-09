#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include <algorithm>

using namespace std;

int main()
{
	ifstream in("dict-words");
	ofstream out("words.txt");
	if(in.is_open()){
		string line;
		while(getline (in,line)){ // one word on each line
			//lowercase
			transform(line.begin(), line.end(), line.begin(), ::tolower);
			vector<string> trigrams;
			
			if(line.length() > 2){
				//get trigrams
				for(unsigned long i = 0; i <= line.length() - 3; ++i){
					trigrams.push_back(line.substr(i, 3));
				}
				//sort trigrams
				sort(trigrams.begin(), trigrams.end());
			}
			//output line + nbrTrigrams + trigrams
			out << line << " " << trigrams.size();
			for(string t : trigrams){
				out << " " << t;
			}
			out << endl;
		}
	}else{
		cout << "Couldnt open file" << endl;
	}
}