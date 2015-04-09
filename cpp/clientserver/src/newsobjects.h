#ifndef NEWSOBJECTS_H
#define NEWSOBJECTS_H

#include <string>
#include <vector>

struct article {
  std::string title;
  std::string author;
  std::string article_text;
  unsigned int id;
};

struct newsgroup {
  std::string name;
  unsigned int id;
  std::vector<article> articles;
};

#endif
