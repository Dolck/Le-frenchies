#include "protocolHandler.h"
#include "exceptions.h"
#include "messagehandler.h"
#include "protocol.h"

using namespace std;

void ProtocolHandler::listNG(const shared_ptr<Connection>& conn, const vector<newsgroup>& groups){
  MessageHandler::expectInputChar(conn, Protocol::COM_END);
  int num = groups.size();
  vector<char> bytes {Protocol::ANS_LIST_NG};
  MessageHandler::addNumberToBytesVector(bytes, num);
  for(newsgroup ng : groups){
    MessageHandler::addNumberToBytesVector(bytes, ng.id);
    MessageHandler::addStringBytesToVector(bytes, ng.name);
  }
  bytes.push_back(Protocol::ANS_END);
  MessageHandler::writeByteVector(conn, bytes);
}

void ProtocolHandler::createNG(const shared_ptr<Connection>& conn, vector<newsgroup>& groups, int& groupId){
  string newTitle = MessageHandler::readString(conn);
  MessageHandler::expectInputChar(conn, Protocol::COM_END);
  vector<char> bytes;
  if(ngExists(groups, newTitle)){
    bytes = {Protocol::ANS_CREATE_NG, Protocol::ANS_NAK, Protocol::ERR_NG_ALREADY_EXISTS, Protocol::ANS_END};
  } else {
    createNewsgroup(groups, newTitle, groupId);
    bytes = {Protocol::ANS_CREATE_NG, Protocol::ANS_ACK, Protocol::ANS_END};
  }
  MessageHandler::writeByteVector(conn, bytes);
}

void ProtocolHandler::delNG(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
  int n = MessageHandler::readNumber(conn);
  MessageHandler::expectInputChar(conn, Protocol::COM_END);
  vector<char> bytes;
  try{
    deleteNG(groups, n);
    bytes = {Protocol::ANS_DELETE_NG, Protocol::ANS_ACK, Protocol::ANS_END};
  } catch(NewsgroupDoesNotExistException e) {
    bytes = {Protocol::ANS_DELETE_NG, Protocol::ANS_NAK, Protocol::ERR_NG_DOES_NOT_EXIST, Protocol::ANS_END};
  }
  MessageHandler::writeByteVector(conn, bytes);
}

void ProtocolHandler::listArts(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
  int n = MessageHandler::readNumber(conn);
  MessageHandler::expectInputChar(conn, Protocol::COM_END);
  vector<char> bytes;
  try{
    newsgroup& ng = getNG(groups, n);
    vector<article> articles = ng.articles;
    size_t nbra = articles.size();
    bytes = {Protocol::ANS_LIST_ART, Protocol::ANS_ACK};
    MessageHandler::addNumberToBytesVector(bytes, nbra);
    for(article a : articles){
      MessageHandler::addNumberToBytesVector(bytes, a.id);
      MessageHandler::addStringBytesToVector(bytes, a.title);
    }
    bytes.push_back(Protocol::ANS_END);
  } catch(NewsgroupDoesNotExistException e) {
    bytes = {Protocol::ANS_LIST_ART, Protocol::ANS_NAK, Protocol::ERR_NG_DOES_NOT_EXIST, Protocol::ANS_END};
  }
  MessageHandler::writeByteVector(conn, bytes);
}

void ProtocolHandler::createArt(const shared_ptr<Connection>& conn, vector<newsgroup>& groups, int & articleId){
  vector<char> bytes;
  try{
    int n = MessageHandler::readNumber(conn);
    string title = MessageHandler::readString(conn);
    string author = MessageHandler::readString(conn);
    string text = MessageHandler::readString(conn);
    MessageHandler::expectInputChar(conn, Protocol::COM_END);
    newsgroup& ng = getNG(groups, n);
    createArticle(ng.articles, title, author, text, articleId);
    bytes = {Protocol::ANS_CREATE_ART, Protocol::ANS_ACK, Protocol::ANS_END};
  } catch (NewsgroupDoesNotExistException e){
    bytes = {Protocol::ANS_CREATE_ART, Protocol::ANS_NAK, Protocol::ERR_NG_DOES_NOT_EXIST, Protocol::ANS_END};
  }
  MessageHandler::writeByteVector(conn, bytes);
}

void ProtocolHandler::delArt(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
  int ngid = MessageHandler::readNumber(conn);
  int aid = MessageHandler::readNumber(conn);
  MessageHandler::expectInputChar(conn, Protocol::COM_END);
  vector<char> bytes;
  try{
    newsgroup& ng = getNG(groups, ngid);
    deleteArticle(ng.articles, aid);
    bytes = {Protocol::ANS_DELETE_ART, Protocol::ANS_ACK, Protocol::ANS_END};
  } catch (NewsgroupDoesNotExistException e){
    bytes = {Protocol::ANS_DELETE_ART, Protocol::ANS_NAK, Protocol::ERR_NG_DOES_NOT_EXIST, Protocol::ANS_END};
  } catch (ArticleDoesNotExistException e){
    bytes = {Protocol::ANS_DELETE_ART, Protocol::ANS_NAK, Protocol::ERR_ART_DOES_NOT_EXIST, Protocol::ANS_END};
  }
  MessageHandler::writeByteVector(conn, bytes);
}

void ProtocolHandler::getArt(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
  int ngid = MessageHandler::readNumber(conn);
  int artid = MessageHandler::readNumber(conn);
  MessageHandler::expectInputChar(conn, Protocol::COM_END);
  vector<char> bytes;
  try{
    newsgroup& ng = getNG(groups, ngid);
    article& art = getArticle(ng.articles, artid);
    bytes = {Protocol::ANS_GET_ART, Protocol::ANS_ACK};
    MessageHandler::addStringBytesToVector(bytes, art.title);
    MessageHandler::addStringBytesToVector(bytes, art.author);
    MessageHandler::addStringBytesToVector(bytes, art.article_text);
    bytes.push_back(Protocol::ANS_END);
  } catch(NewsgroupDoesNotExistException e){
    bytes = {Protocol::ANS_GET_ART, Protocol::ANS_NAK, Protocol::ERR_NG_DOES_NOT_EXIST, Protocol::ANS_END};
  } catch(ArticleDoesNotExistException e){
    bytes = {Protocol::ANS_GET_ART, Protocol::ANS_NAK, Protocol::ERR_ART_DOES_NOT_EXIST, Protocol::ANS_END};
  }
  MessageHandler::writeByteVector(conn, bytes);
}

void ProtocolHandler::createNewsgroup(vector<newsgroup>& v, string& title, int& id){
  newsgroup ng;
  ng.name = title;
  ng.id = ++id;
  v.push_back(ng);
}

newsgroup& ProtocolHandler::getNG(vector<newsgroup>& v, const unsigned int& id){
  for(newsgroup& ng : v){
    if(ng.id == id){
      return ng;
    }
  }
  throw NewsgroupDoesNotExistException();
}

bool ProtocolHandler::ngExists(const vector<newsgroup>& v, const string& newTitle){
  for(newsgroup ng : v){
    if(ng.name == newTitle){
      return true;
    }
  }
  return false;
}

bool ProtocolHandler::deleteNG(vector<newsgroup>& v, const unsigned int& id){
  int index = 0;
  for(newsgroup ng : v){
    if(ng.id == id){
      v.erase(v.begin()+index);
      return true;
    }
    ++index;
  }
  throw NewsgroupDoesNotExistException();
}

void ProtocolHandler::createArticle(vector<article>& v, string& title, string& author, string& text, int& id){
  article art;
  art.title = title;
  art.author = author;
  art.article_text = text;
  art.id = ++id;
  v.push_back(art);
}

bool ProtocolHandler::deleteArticle(vector<article>& v, const unsigned int& id){
  int index = 0;
  for(article a : v){
    if(a.id == id){
      v.erase(v.begin()+index);
      return true;
    }
    ++index;
  }
  throw ArticleDoesNotExistException();
}

article& ProtocolHandler::getArticle(vector<article>& v, const unsigned int& id){
  for(article& a : v){
    if(a.id == id){
      return a;
    }
  }
  throw new ArticleDoesNotExistException();
}
