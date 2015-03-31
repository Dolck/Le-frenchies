#ifndef SAVE_TO_FILE_H
#define SAVE_TO_FILE_H

#include <string>
#include <vector>
#include <memory>
#include "newsobjects.h"

class SaveToFile{
  public:
    static std::vector<newsgroup>& readNewsgroups(int& nid, int& aid);
    static void writeNewgroups(const std::vector<newsgroup>& ngs, int nid, int aid);
  private:
    static std::string fileName = "database.txt";
};
#endif

