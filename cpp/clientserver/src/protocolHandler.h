#ifndef PROTOCOL_HANDLER_H
#define PROTOCOL_HANDLER_H

#include "connection.h"
#include "newsobjects.h"
#include <string>
#include <vector>

class ProtocolHandler{
public:
  static void listNG(const std::shared_ptr<Connection>& conn, const std::vector<newsgroup>& groups);
  static void createNG(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups, int& groupId);
  static void delNG(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups);
  static void listArts(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups);
  static void createArt(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups, int & articleId);
  static void delArt(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups);
  static void getArt(const std::shared_ptr<Connection>& conn, std::vector<newsgroup>& groups);

private:
  static void createNewsgroup(std::vector<newsgroup>& v, std::string& title, int& id);
  static newsgroup& getNG(std::vector<newsgroup>& v, const unsigned int& id);
  static bool ngExists(const std::vector<newsgroup>& v, const std::string& newTitle);
  static bool deleteNG(std::vector<newsgroup>& v, const unsigned int& id);
  static void createArticle(std::vector<article>& v, std::string& title, std::string& author, std::string& text, int& id);
  static bool deleteArticle(std::vector<article>& v, const unsigned int& id);
  static article& getArticle(std::vector<article>& v, unsigned int id);
};

#endif