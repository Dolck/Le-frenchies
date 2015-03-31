#include "article.h"
#include <string>
#include <vector>

class Newsgroup{
  friend class hiberlite::access;
  template<class Archive>
  void hibernate(Archive & ar){
      ar & HIBERLITE_NVP(id);
      ar & HIBERLITE_NVP(name);
      ar & HIBERLITE_NVP(articles);
  }
  public:
    unsigned int id;
    std::string name;
    std::vector<article> articles;
};
HIBERLITE_EXPORT_CLASS(Newsgroup)
