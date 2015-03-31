#ifndef SAVE_TO_FILE_H
#define SAVE_TO_FILE_H

#include <string>
#include <vector>
#include <memory>
#include "newsobjects.h"

class SaveToFile{
  public:
    static vector<newsgroup> readNewsgroups();
    static void writeNewgroups(const vector<newsgroup> ngs);
};
#endif

