/* myserver.cc: sample server program */
#include "server.h"
#include "connection.h"
#include "connectionclosedexception.h"
#include "exceptions.h"
#include "protocol.h"

#include <memory>
#include <iostream>
#include <string>
#include <stdexcept>
#include <cstdlib>

using namespace std;

/*
 * Read an integer from a client.
 */
int readNumber(const shared_ptr<Connection>& conn) {
	unsigned char byte1 = conn->read();
	unsigned char byte2 = conn->read();
	unsigned char byte3 = conn->read();
	unsigned char byte4 = conn->read();
	return (byte1 << 24) | (byte2 << 16) | (byte3 << 8) | byte4;
}

/*
 * Read a char from a client
 */
char readChar(const shared_ptr<Connection>& conn) {
	return conn->read();
}

/*
 * Reads a string
 */
string readString(const shared_ptr<Connection>& conn, const int nbrChars) {
	string s;
	for (int i = 0; i < nbrChars; ++i){
		s += readChar(conn);
	}
	return s;
}

void addNumberToBytesVector(vector<unsigned char>& bytes, const int& num){
  bytes.push_back((num >> 24) & 0xFF);
  bytes.push_back((num >> 16) & 0xFF);
  bytes.push_back((num >> 8) & 0xFF);
  bytes.push_back(num & 0xFF);
}

void addStringBytesToVector(vector<unsigned char>& bytes, const string& s){
  for (char c : s) {
    bytes.push_back(c);
  }
}

struct article {
	string title;
	string author;
	string article_text;
	unsigned int id;
};

struct newsgroup {
	string name;
	unsigned int id;
	vector<article> articles;
};

bool ngExists(const vector<newsgroup>& v, const string& newTitle){
	for(newsgroup ng : v){
		if(ng.name == newTitle){
			return true;
		}
	}
	return false;
}

const newsgroup& getNG(const vector<newsgroup>& v, const unsigned int& id){
  for(const newsgroup& ng : v){
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

void writeByteVector(const shared_ptr<Connection>& conn, const vector<unsigned char>& bytes){
  for(unsigned char byte : bytes){
    conn->write(byte);
  }
}

void listNG(const shared_ptr<Connection>& conn, const vector<newsgroup>& groups){
  char end = readChar(conn);
  if(end != Protocol::COM_END){
    throw ConnectionClosedException();
  }
  int num = groups.size();
  vector<unsigned char> bytes {Protocol::ANS_LIST_NG, Protocol::PAR_NUM};
  addNumberToBytesVector(bytes, num);
  for(newsgroup ng : groups){
    bytes.push_back(Protocol::PAR_NUM);
    addNumberToBytesVector(bytes, ng.id);
    bytes.push_back(Protocol::PAR_STRING);
    addNumberToBytesVector(bytes, ng.name.size());
    addStringBytesToVector(bytes, ng.name);
  }
  bytes.push_back(Protocol::ANS_END);
  writeByteVector(conn, bytes);
}

void createNG(const shared_ptr<Connection>& conn, vector<newsgroup>& groups, int& groupId){
  char c = readChar(conn);
  if(c == Protocol::PAR_STRING){
    int n = readNumber(conn);
    string newTitle = readString(conn, n);
    char end = readChar(conn);
    if(end != Protocol::COM_END){
      throw ConnectionClosedException();
    }
    vector<unsigned char> bytes;
    if(ngExists(groups, newTitle)){
      bytes = {Protocol::ANS_CREATE_NG, Protocol::ANS_NAK, Protocol::ERR_NG_ALREADY_EXISTS, Protocol::ANS_END};
    } else {
      newsgroup ng;
      ng.name = newTitle;
      ng.id = ++groupId;
      groups.push_back(ng);
      bytes = {Protocol::ANS_CREATE_NG, Protocol::ANS_ACK, Protocol::ANS_END};
    }
    writeByteVector(conn, bytes);
  }else{
    throw ConnectionClosedException();
  }
}

void createArticle(const shared_ptr<Connection>& conn, vector<newsgroup>& groups, int & articleId){
  if(readChar(conn) == Protocol::PAR_NUM){
    vector<unsigned char> bytes;
    try{
      int n = readNumber(conn);
      newsgroup ng = getNG(groups, n);
      if(readChar(conn) != Protocol::PAR_STRING){
        throw ConnectionClosedException();
      }
      int n1 = readNumber(conn);
      string title = readString(conn, n1);
      if(readChar(conn) != Protocol::PAR_STRING){
        throw ConnectionClosedException();
      }
      int n2 = readNumber(conn);
      string author = readString(conn, n2);
      if(readChar(conn) != Protocol::PAR_STRING){
        throw ConnectionClosedException();
      }
      int n3 = readNumber(conn);
      string text = readString(conn, n3);
      if(readChar(conn) != Protocol::COM_END){
        throw ConnectionClosedException();
      }
      article art;
      art.title = title;
      art.author = author;
      art.article_text = text;
      art.id = ++articleId;
      ng.articles.push_back(art);
      bytes = {Protocol::ANS_CREATE_ART, Protocol::ANS_ACK, Protocol::ANS_END};
    } catch (NewsgroupDoesNotExistException e){
      bytes = {Protocol::ANS_CREATE_ART, Protocol::ANS_NAK, Protocol::ERR_NG_DOES_NOT_EXIST, Protocol::ANS_END};
    }
    writeByteVector(conn, bytes);
  } else {
    throw ConnectionClosedException();
  }
}

void delNG(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
  char c = readChar(conn);
  if(c == Protocol::PAR_NUM){
    int n = readNumber(conn);
    char end = readChar(conn);
    if(end != Protocol::COM_END){
      throw ConnectionClosedException();
    }
    vector<unsigned char> bytes;
    try{
      deleteNG(groups, n);
      bytes = {Protocol::ANS_DELETE_NG, Protocol::ANS_ACK, Protocol::ANS_END};
    } catch(NewsgroupDoesNotExistException e) {
      bytes = {Protocol::ANS_DELETE_NG, Protocol::ANS_NAK, Protocol::ERR_NG_DOES_NOT_EXIST, Protocol::ANS_END};
    }
    writeByteVector(conn, bytes);
  } else {
    throw ConnectionClosedException();
  }
}

void listArts(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
  char c = readChar(conn);
  if(c == Protocol::PAR_NUM){
    int n = readNumber(conn);
    char end = readChar(conn);
    if(end != Protocol::COM_END){
      throw ConnectionClosedException();
    }
    vector<unsigned char> bytes;
    try{
      newsgroup ng = getNG(groups, n);
      vector<article> articles = ng.articles;
      size_t nbra = articles.size();
      bytes = {Protocol::ANS_ACK, Protocol::PAR_NUM};
      addNumberToBytesVector(bytes, nbra);
      for(article a : articles){
        bytes.push_back(Protocol::PAR_NUM);
        addNumberToBytesVector(bytes, a.id);
        bytes.push_back(Protocol::PAR_STRING);
        addNumberToBytesVector(bytes, a.title.size());
        addStringBytesToVector(bytes, a.title);
      }
      bytes.push_back(Protocol::ANS_END);
    } catch(NewsgroupDoesNotExistException e) {
      bytes = {Protocol::ANS_LIST_ART, Protocol::ANS_NAK, Protocol::ERR_NG_DOES_NOT_EXIST, Protocol::ANS_END};
    }
    writeByteVector(conn, bytes);
  } else {
    throw ConnectionClosedException();
  }
}

void deleteArt(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
  char c = readChar(conn);
  if(c == Protocol::PAR_NUM){
    int ngid = readNumber(conn);
    if(readChar(conn) != Protocol::PAR_NUM){
      throw ConnectionClosedException();
    }
    int aid = readNumber(conn);
    if(readChar(conn) != Protocol::COM_END){
      throw ConnectionClosedException();
    }
    vector<unsigned char> bytes;
    try{
      newsgroup ng = getNG(groups, ngid);
      deleteArticle(ng.articles, aid);
      bytes = {Protocol::ANS_DELETE_ART, Protocol::ANS_ACK, Protocol::ANS_END};
    } catch (NewsgroupDoesNotExistException e){
      bytes = {Protocol::ANS_DELETE_ART, Protocol::ANS_NAK, Protocol::ERR_NG_DOES_NOT_EXIST, Protocol::ANS_END};
    } catch (ArticleDoesNotExistException e){
      bytes = {Protocol::ANS_DELETE_ART, Protocol::ANS_NAK, Protocol::ERR_ART_DOES_NOT_EXIST, Protocol::ANS_END};
    }
    writeByteVector(conn, bytes);
  } else {
    throw ConnectionClosedException();
  }
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

	vector<newsgroup> groups; // Check this?
	int groupId = 1, articleId = 1;
	
	while (true) {
		auto conn = server.waitForActivity();
		if (conn != nullptr) {
			try {
				char cmd = readChar(conn);
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
            createArticle(conn, groups, articleId);
						break;
					case Protocol::COM_DELETE_ART:
            deleteArt(conn, groups);
						break;
					case Protocol::COM_GET_ART:
						break;
					default: throw ConnectionClosedException();
						break;
				}

				/*
				* Communicate with a client, conn->read()
				* and conn->write(c)
				*/
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
