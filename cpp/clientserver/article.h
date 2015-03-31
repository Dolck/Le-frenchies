#include <string>

class Article{
  friend class hiberlite::access;
  template<class Archive>
  void hibernate(Archive & ar){
      ar & HIBERLITE_NVP(id);
      ar & HIBERLITE_NVP(title);
      ar & HIBERLITE_NVP(author);
      ar & HIBERLITE_NVP(article_text);
  }
  public:
    unsigned int id; 
    std::string title;
    std::string author;
    std::string article_text;
};
HIBERLITE_EXPORT_CLASS(Article)
