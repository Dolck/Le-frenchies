/* myserver.cc: sample server program */
#include "server.h"
#include "connection.h"
#include "connectionclosedexception.h"
#include "exceptions.h"
#include "newsobjects.h"
#include "savetofile.h"
#include "protocol.h"
#include "messagehandler.h"

#include <memory>
#include <iostream>
#include <string>
#include <stdexcept>
#include <cstdlib>

using namespace std;

void createNewsgroup(vector<newsgroup>& v, string& title, int& id){
  newsgroup ng;
  ng.name = title;
  ng.id = ++id;
  v.push_back(ng);
}

bool ngExists(const vector<newsgroup>& v, const string& newTitle){
  for(newsgroup ng : v){
    if(ng.name == newTitle){
      return true;
    }
  }
  return false;
}

newsgroup& getNG(vector<newsgroup>& v, const unsigned int& id){
  for(newsgroup& ng : v){
    if(ng.id == id){
      return ng;
    }
  }
  throw NewsgroupDoesNotExistException();
}

bool deleteNG(vector<newsgroup>& v, const unsigned int& id){
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

void createArticle(vector<article>& v, string& title, string& author, string& text, int& id){
  article art;
  art.title = title;
  art.author = author;
  art.article_text = text;
  art.id = ++id;
  v.push_back(art);
}

bool deleteArticle(vector<article>& v, const unsigned int& id){
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

article& getArticle(vector<article>& v, unsigned int id){
  for(article& a : v){
    if(a.id == id){
      return a;
    }
  }
  throw new ArticleDoesNotExistException();
}

void listNG(const shared_ptr<Connection>& conn, const vector<newsgroup>& groups){
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

void createNG(const shared_ptr<Connection>& conn, vector<newsgroup>& groups, int& groupId){
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

void createArt(const shared_ptr<Connection>& conn, vector<newsgroup>& groups, int & articleId){
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

void delNG(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
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

void listArts(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
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

void deleteArt(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
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

void getArt(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
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


int main(int argc, char* argv[]){
  if (argc != 2) {
    cerr << "Usage: myserver port-number" << endl;
    exit(1);
  }
  
  int port = -1;
  try {
    port = stoi(argv[1]);
  } catch (exception& e) {
    cerr << "Wrong port number. " << e.what() << endl;
    exit(1);
  }
  
  Server server(port);
  if (!server.isReady()) {
    cerr << "Server initialization error." << endl;
    exit(1);
  }

  int groupId, articleId;
  vector<newsgroup> groups;
  SaveToFile::readNewsgroups(groups, groupId, articleId);
  
  while (true) {
    auto conn = server.waitForActivity();
    if (conn != nullptr) {
      try {
        char cmd = MessageHandler::readChar(conn);
        switch(cmd){
          case Protocol::COM_LIST_NG:
            listNG(conn, groups);
            break;
          case Protocol::COM_CREATE_NG:
            createNG(conn, groups, groupId);
            break;
          case Protocol::COM_DELETE_NG:
            delNG(conn, groups);
            break;
          case Protocol::COM_LIST_ART:
            listArts(conn, groups);
            break;
          case Protocol::COM_CREATE_ART:
            createArt(conn, groups, articleId);
            break;
          case Protocol::COM_DELETE_ART:
            deleteArt(conn, groups);
            break;
          case Protocol::COM_GET_ART:
            getArt(conn, groups);
            break;
          default: throw ConnectionClosedException();
            break;
        }
        SaveToFile::writeNewsgroups(groups, groupId, articleId);
      } catch (ConnectionClosedException&) {
        server.deregisterConnection(conn);
        cout << "Client closed connection" << endl;
      }
    } else {
      conn = make_shared<Connection>();
      server.registerConnection(conn);
      cout << "New client connects" << endl;
    }
  }
}
