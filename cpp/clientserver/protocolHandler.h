#ifndef PROTOCOL_HANDLER_H
#define PROTOCOL_HANDLER_H

#include "connection.h"
#include "newsobjects.h"
#include <string>
#include <vector>

class Protocolhandler{
public:
  void listNG(const std::shared_ptr<Connection>& conn, const std::vector<newsgroup>& groups);
  void createNG(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups, int& groupId);
  void delNG(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups);
  void listArts(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups);
  void createArt(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups, int & articleId);
  void delArt(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups);
  void getArt(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups);

private:
  void createNewsgroup(std::vector<newsgroup>& v, std::string& title, int& id);
  newsgroup& getNG(std::vector<newsgroup>& v, const unsigned int& id);
  bool ngExists(const std::vector<newsgroup>& v, const std::string& newTitle);
  bool deleteNG(std::vector<newsgroup>& v, const unsigned int& id);
  void createArticle(std::vector<article>& v, std::string& title, std::string& author, std::string& text, int& id);
  bool deleteArticle(std::vector<article>& v, const unsigned int& id);
  article& getArticle(std::vector<article>& v, unsigned int id);
};

#endif