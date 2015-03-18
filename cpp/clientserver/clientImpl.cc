#include "connection.h"
#include "connectionclosedexception.h"
#include "protocol.h"
#include "messagehandler.h"

#include <iostream>
#include <string>
#include <stdexcept>
#include <cstdlib>

using namespace std;

void listNewsGroups(const shared_ptr<Connection>& conn){
    MessageHandler::writeByteVector(conn, {Protocol::COM_LIST_NG, Protocol::COM_END});

    MessageHandler::expectInputChar(conn, Protocol::ANS_LIST_NG);
    int nbrNgs = MessageHandler::readNumber(conn);
    cout << endl;
    cout << "Newsgroups: " << endl;
    for (int i = 0; i < nbrNgs; ++i){
        int id = MessageHandler::readNumber(conn);
        string title = MessageHandler::readString(conn);
        cout << id << " " << title << endl;
    }
    MessageHandler::expectInputChar(conn, Protocol::ANS_END);
    cout << endl;
}

int chooseNewsGroup(const shared_ptr<Connection>& conn){
    listNewsGroups(conn);
    cout << "Choose newsgroup-id: ";
    int id;
    cin >> id;
    return id;
}

void simpleAckNacHandler(const shared_ptr<Connection>& conn, const unsigned char ans, const unsigned char fail, const string& success, const string& error){
    MessageHandler::expectInputChar(conn, ans);
    try{
        MessageHandler::expectInputChar(conn, Protocol::ANS_ACK);
        MessageHandler::expectInputChar(conn, Protocol::ANS_END);
        cout << success << endl;
    }catch(ConnectionClosedException e){
        MessageHandler::expectInputChar(conn, fail);
        MessageHandler::expectInputChar(conn, Protocol::ANS_END);
        cout << error << endl;
    }
    cout << endl;
}

void createNewsGroup(const shared_ptr<Connection>& conn){
    cout << "Enter title: ";
    string title;
    cin >> title;
    vector<unsigned char> bytes = {Protocol::COM_CREATE_NG};
    MessageHandler::addStringBytesToVector(bytes, title);
    bytes.push_back(Protocol::COM_END);
    MessageHandler::writeByteVector(conn, bytes);

    simpleAckNacHandler(conn, Protocol::ANS_CREATE_NG, Protocol::ERR_NG_ALREADY_EXISTS, "Successfully created newsgroup!", "Couldn't create newsgroup. Newsgroup already exists!");
}

void deleteNewsGroup(const shared_ptr<Connection>& conn){
    int id = chooseNewsGroup(conn);
    vector<unsigned char> bytes = {Protocol::COM_DELETE_NG};
    MessageHandler::addNumberToBytesVector(bytes, id);
    bytes.push_back(Protocol::COM_END);
    MessageHandler::writeByteVector(conn, bytes);

    simpleAckNacHandler(conn, Protocol::ANS_DELETE_NG, Protocol::ERR_NG_DOES_NOT_EXIST, "Successfully deleted newsgroup!", "Couldn't delete newsgroup. Newsgroup does not exists exists!");
}

void listArticles(const shared_ptr<Connection>& conn){
    int id = chooseNewsGroup(conn);
    vector<unsigned char> bytes = {Protocol::COM_LIST_ART};
    MessageHandler::addNumberToBytesVector(bytes, id);
    bytes.push_back(Protocol::COM_END);
    MessageHandler::writeByteVector(conn, bytes);

    MessageHandler::expectInputChar(conn, Protocol::ANS_LIST_ART);
    try{
        MessageHandler::expectInputChar(conn, Protocol::ANS_ACK);
        int nbra = MessageHandler::readNumber(conn);
        for (int i = 0; i < nbra; ++i){
            int aid = MessageHandler::readNumber(conn);
            string title = MessageHandler::readString(conn);
            cout << aid << " " << title << endl;
        }
        MessageHandler::expectInputChar(conn, Protocol::ANS_END);

    }catch(ConnectionClosedException e){
        MessageHandler::expectInputChar(conn, Protocol::ERR_NG_DOES_NOT_EXIST);
        MessageHandler::expectInputChar(conn, Protocol::ANS_END);
    }
    cout << endl;
}

void createArticle(const shared_ptr<Connection>& conn){
    int id = chooseNewsGroup(conn);
    cout << "Enter title: ";
    string title;
    cin >> title;
    cout << "Enter author: ";
    string author;
    cin >> author;
    string text;
    cout << "Enter text (end with a $ sign): " << endl;
    char c;
    while (cin.get(c)){
        if(c == '$')
            break;
        text += c;
    }

    vector<unsigned char> bytes = {Protocol::COM_CREATE_ART};
    MessageHandler::addNumberToBytesVector(bytes, id);
    MessageHandler::addStringBytesToVector(bytes, title);
    MessageHandler::addStringBytesToVector(bytes, author);
    MessageHandler::addStringBytesToVector(bytes, text);
    bytes.push_back(Protocol::COM_END);
    MessageHandler::writeByteVector(conn, bytes);

    simpleAckNacHandler(conn, Protocol::ANS_CREATE_ART, Protocol::ERR_NG_DOES_NOT_EXIST, "Successfully created article!", "Couldn't create article. Newsgroup does not exists exists!");
}

void deleteArticle(const shared_ptr<Connection>& conn){
    chooseNewsGroup(conn);
}

void welcomePrompt(){
    cout << "Welcome to our newsclient. Please choose a command: " << endl;
    cout << "1: List newsgroups" << endl;
    cout << "2: Create newsgroup" << endl;
    cout << "3: Delete newsgroup" << endl;
    cout << "4: List articles" << endl;
    cout << "5: Create article" << endl;
    cout << "6: Delete article" << endl;
    cout << "7: View article" << endl;
    cout << "Type a number: ";
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
                    createNewsGroup(conn);
                    break;
                case 3:
                    deleteNewsGroup(conn);
                    break;
                case 4:
                    listArticles(conn);
                    break;
                case 5:
                    createArticle(conn);
                    break;
                case 6:
                    break;
                case 7:
                    break;
                default:
                    cout << "You must choose a command from the list.." << endl;
                    break;
            }
        }catch(ConnectionClosedException e){
            cout << "exception cc" << endl;
        }

        welcomePrompt();
    }
}

