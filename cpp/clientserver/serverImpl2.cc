/* myserver.cc: sample server program */
#include "server.h"
#include "connection.h"
#include "connectionclosedexception.h"
#include "exceptions.h"
#include "newsobjects.h"
#include "database.h"
#include "protocol.h"
#include "messagehandler.h"

#include <memory>
#include <iostream>
#include <string>
#include <stdexcept>
#include <cstdlib>

using namespace std;

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
  Database::readNewsgroups(groups, groupId, articleId);
  
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
        Database::writeNewsgroups(groups, groupId, articleId);
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
