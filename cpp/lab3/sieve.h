#ifndef SIEVE_H
#define SIEVE_H

#include <string>
#include <iostream>
#include <vector>

using namespace std;

class Sieve {
  public:
    Sieve(int M);
    vector<int> getPrimes() const;
    int getTopPrime() const;
  private:
    int M;
    string seq;
};

#endif
