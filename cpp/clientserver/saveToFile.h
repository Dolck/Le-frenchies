#ifndef SAVE_TO_FILE_H
#define SAVE_TO_FILE_H

#include <string>
#include <vector>
#include <memory>
#include "newsobjects.h"

class SaveToFile{
  public:
    static std::vector<newsgroup> readNewsgroups();
    static void writeNewgroups(const std::vector<newsgroup> ngs);
};
#endif

