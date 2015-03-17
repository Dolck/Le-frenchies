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

bool ngExists(const vector<newsgroup>& v, const int& id){
  for(newsgroup ng : v){
    if(ng.id == id){
      return true;
    }
  }
  return false;
}

const newsgroup& getNG(const vector<newsgroup>& v, const int& id){
  for(const newsgroup& ng : v){
    if(ng.id == id){
      return ng;
    }
  }
  throw NewsgroupDoesNotExistException();
}

bool deleteNG(vector<newsgroup>& v, const int& id){
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

void writeByteVector(const shared_ptr<Connection>& conn, const vector<unsigned char>& bytes){
  for(unsigned char byte : bytes){
    conn->write(byte);
  }
}

void listNG(const shared_ptr<Connection>& conn, const vector<newsgroup>& groups){
  char end = readChar(conn);
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

void delNG(const shared_ptr<Connection>& conn, vector<newsgroup>& groups){
  char c = readChar(conn);
  if(c == Protocol::PAR_NUM){
    int n = readNumber(conn);
    char end = readChar(conn);
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
					case Protocol::COM_DELETE_NG:{
            delNG(conn, groups);
						break;
          }
					case Protocol::COM_LIST_ART:{
            char c = readChar(conn);
            if(c == Protocol::PAR_NUM){
              int n = readNumber(conn);
              char end = readChar(conn);
              try{
                newsgroup ng = getNG(groups, n);
                vector<article> articles = ng.articles;
                size_t nbra = articles.size();
                //Protocol::ANS_ACK;
                //Protocol::PAR_NUM;
                //writeNumber(nbra);
                for(article a : articles){
                  //Protocol::PAR_NUM;
                  //writeNumber(a.id);
                  //Protocol::PAR_STRING;
                  //writeNumber(a.title.size());
                  //writeString(a.title);
                }
                //Protocol::ANS_END;
              } catch(NewsgroupDoesNotExistException e) {
                string output;
                output += Protocol::ANS_LIST_ART;
                output += Protocol::ANS_NAK;
                output += Protocol::ERR_NG_DOES_NOT_EXIST;
                output += Protocol::ANS_END;
                //writeString(conn, output);
              }
            } else {
              throw ConnectionClosedException();
            }
						break;
					}
          case Protocol::COM_CREATE_ART:
						break;
					case Protocol::COM_DELETE_ART:
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
