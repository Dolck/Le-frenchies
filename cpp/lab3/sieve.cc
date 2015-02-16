#include "sieve.h"

using namespace std;

Sieve::Sieve(int M): M(M){
  seq = string(M+1, 'P');
  seq.replace(0,2,"CC");

  for(int i = 0; i <= M/2; ++i){
    if(seq[i] == 'P'){
      for(int j = 2*i; j <= M; j += i){
        seq.replace(j, 1, "C");
      }
    }
  }
}

vector<int> Sieve::getPrimes() const {
  vector<int> primes;
  return primes;
}

int Sieve::getTopPrime() const {
  return 0;
}

int main() {
  int val;
  cout << "Please enter the top value: ";
  cin >> val;

  Sieve s1(val);

  int t = s1.getTopPrime();
  cout << t << endl;

}
