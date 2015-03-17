#include "connection.h"
#include "connectionclosedexception.h"
#include "protocol.h"

#include <iostream>
#include <string>
#include <stdexcept>
#include <cstdlib>

using namespace std;

int readInt(const shared_ptr<Connection>& conn) {
    unsigned char byte1 = conn->read();
    unsigned char byte2 = conn->read();
    unsigned char byte3 = conn->read();
    unsigned char byte4 = conn->read();
    return (byte1 << 24) | (byte2 << 16) | (byte3 << 8) | byte4;
}

char readChar(const shared_ptr<Connection>& conn) {
    return conn->read();
}

string readString(const shared_ptr<Connection>& conn) {
    if(conn->read() != Protocol::PAR_STRING){
        throw ConnectionClosedException();
    }
    int nbrChars = readInt(conn);
    string s;
    for (int i = 0; i < nbrChars; ++i){
        s += readChar(conn);
    }
    return s;
}

void welcomePrompt(){
    cout << "Welcome to our newsclient. Please choose a command: " << endl;
    cout << "1: List newsgroups" << endl;
    cout << "2: Create newsgroup" << endl;
    cout << "3: Delete newsgroup" << endl;
    cout << "4: List articles" << endl;
    cout << "5: Create article" << endl;
    cout << "6: Delete article" << endl;
    cout << "Type a number: ";
}

void listNewsGroups(const shared_ptr<Connection>& conn){
    conn->write(Protocol::COM_LIST_NG);
    conn->write(Protocol::COM_END);
    //{Protocol::ANS_LIST_NG, Protocol::PAR_NUM};
    if(conn->read() != Protocol::ANS_LIST_NG || conn->read() != Protocol::PAR_NUM)
        throw ConnectionClosedException();

    int nbrNgs = readInt(conn);
    cout << endl;
    cout << "Newsgroups: " << endl;
    for (int i = 0; i < nbrNgs; ++i){
        if(conn->read() != Protocol::PAR_NUM){
            throw ConnectionClosedException();
        }
        int id = readInt(conn);
        string title = readString(conn);
        cout << id << " " << title << endl;
    }

    cout << endl;
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        cerr << "Usage: clientImpl host-name port-number" << endl;
        exit(1);
    }
    
    int port = -1;
    try {
        port = stoi(argv[2]);
    } catch (exception& e) {
        cerr << "Wrong port number. " << e.what() << endl;
        exit(1);
    }
    
    //Connection cnn(argv[1], port);
    shared_ptr<Connection> conn = make_shared<Connection>(argv[1], port);
    if (!conn->isConnected()) {
        cerr << "Connection attempt failed" << endl;
        exit(1);
    }
    welcomePrompt();
    int nbr;
    while (cin >> nbr) {
        try{
            switch(nbr){
                case 1: 
                    listNewsGroups(conn);
                    break;
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                default:
                    cout << "You must choose a command from the list.." << endl;
                    break;
            }
        }catch(ConnectionClosedException e){
            cout << e.what() << endl;
        }

        welcomePrompt();
    }
}

