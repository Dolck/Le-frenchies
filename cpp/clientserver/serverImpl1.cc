/* myserver.cc: sample server program */
#include "server.h"
#include "connection.h"
#include "connectionclosedexception.h"
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

/*
 * Send an integer to the client as four bytes.
 */
void writeNumber(const shared_ptr<Connection>& conn, int value) {
	conn->write((value >> 24) & 0xFF);
	conn->write((value >> 16) & 0xFF);
	conn->write((value >> 8)	 & 0xFF);
	conn->write(value & 0xFF);
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

void deleteNG(vector<newsgroup>& v, const int& id){
  int index = 0;
  for(newsgroup ng : v){
    if(ng.id == id){
      break;
    }
    ++index;
  }
  v.erase(v.begin()+index);
}

/*
 * Send a string to a client.
 */
void writeString(const shared_ptr<Connection>& conn, const string& s) {
	for (char c : s) {
		conn->write(c);
	}
	//conn->write('$');
}

void listNG(const shared_ptr<Connection>& conn, const vector<newsgroup>& groups){
  char end = readChar(conn);
  int num = groups.size();
  conn->write(Protocol::ANS_LIST_NG);
  conn->write(Protocol::PAR_NUM);
  writeNumber(conn, num);
  for(newsgroup ng : groups){
    conn->write(Protocol::PAR_NUM);
    writeNumber(conn, ng.id);
    conn->write(Protocol::PAR_STRING);
    writeNumber(conn, ng.name.size());
    writeString(conn, ng.name);
  }
  conn->write(Protocol::ANS_END);
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
					case Protocol::COM_LIST_NG:{
						listNG(conn, groups);
					}
					case Protocol::COM_CREATE_NG: {
						char c = readChar(conn);
						if(c == Protocol::PAR_STRING){
							int n = readNumber(conn);
							string newTitle = readString(conn, n);
							char end = readChar(conn);
							if(ngExists(groups, newTitle)){
								string output;
								output += Protocol::ANS_CREATE_NG;
								output += Protocol::ANS_NAK;
                output += Protocol::ERR_NG_ALREADY_EXISTS;
								output += Protocol::ANS_END;
								writeString(conn, output);
              } else {
                newsgroup ng;
								ng.name = newTitle;
								ng.id = ++groupId;
								groups.push_back(ng);
								string output;
								output += Protocol::ANS_CREATE_NG;
								output += Protocol::ANS_ACK;
								output += Protocol::ANS_END;
								writeString(conn, output);
							}
						}else{
							throw ConnectionClosedException();
						}
						break;
					}
					case Protocol::COM_DELETE_NG:
            char c = readChar(conn);
            if(c == Protocol::PAR_NUM){
              int n = readNumber(conn);
              char end = readChar(conn);
              if(ngExists(groups, n)){
                deleteNG(groups, n);
                string output;
                output += Protocol::ANS_DELETE_NG;
                output += Protocol::ANS_ACK;
                output += Protocol::ANS_END;
                writeString(conn, output);
              } else {
                string output;
                output += Protocol::ANS_DELETE_NG;
                output += Protocol::ANS_NAK;
                output += Protocol::ERR_NG_DOES_NOT_EXIST;
                output += Protocol::ANS_END;
                writeString(conn, output);
              }
            } else {
              throw ConnectionClosedException();
            }
						break;
					case Protocol::COM_LIST_ART:
						break;
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
