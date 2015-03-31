#ifndef SAVE_TO_FILE_H
#define SAVE_TO_FILE_H

#include <string>
#include <vector>
#include <memory>
#include "newsobjects.h"

class SaveToFile{
  public:
    static void readNewsgroups(std::vector<newsgroup>& ngs, int& nid, int& aid);
    static void writeNewsgroups(const std::vector<newsgroup>& ngs, int nid, int aid);
  private:
    static std::string fileName;
};
#endif

