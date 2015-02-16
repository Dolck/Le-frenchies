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
  for (int i = 0; i <= M; ++i){
    if(seq[i] == 'P'){
      primes.push_back(i);
    }
  }

  return primes;
}

int Sieve::getTopPrime() const {
  return seq.find_last_of("P");
}

int main() {
  int val;
  cout << "Please enter the top value: ";
  cin >> val;
  cout << endl;

  Sieve s1(val);

  int t = s1.getTopPrime();
  cout << "Top prime: " << t << endl;

  cout << "All primes:";
  vector<int> p = s1.getPrimes();
  for (auto it = p.cbegin(); it != p.cend(); ++it){
    cout << ' ' << *it;
  }
  cout << endl;

}
