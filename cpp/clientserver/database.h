#ifndef DATABASE_H
#define DATABASE_H

#include <string>
#include <vector>
#include <memory>
#include "newsobjects.h"

class Database{
  public:
    static std::vector<newsgroup>& readNewsgroups(int& nid, int& aid);
    static void writeNewsgroups(const std::vector<newsgroup>& ngs, int nid, int aid);
  private:
    static std::string fileName;
};
#endif

