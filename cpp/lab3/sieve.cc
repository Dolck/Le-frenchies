#include <iostream>
#include <regex>
//#include "tagremover.h"

using namespace std;

int main() {
  int M;
  cout << "Please enter the top value: ";
  cin >> M;

  string seq(M+1, 'P');
  seq.replace(0, 2, "CC");

  for(int i = 0; i <= M/2; ++i){
    if(seq[i] == 'P'){
      for(int j = 2*i; j <= M; j += i){
        seq.replace(j, 1, "C");
      }
    }
  }

}
