#include "connection.h"
#include "connectionclosedexception.h"
#include "protocol.h"

#include <iostream>
#include <string>
#include <stdexcept>
#include <cstdlib>

using namespace std;

/*
 * Send an integer to the server as four bytes.
 */
void writeNumber(const Connection& conn, int value) {
    conn.write((value >> 24) & 0xFF);
    conn.write((value >> 16) & 0xFF);
    conn.write((value >> 8)  & 0xFF);
    conn.write(value & 0xFF);
}

/*
 * Read a string from the server.
 */
string readString(const Connection& conn) {
    string s;
    char ch;
    while ((ch = conn.read()) != '$') {
        s += ch;
    }
    return s;
}

int readInt(const Connection& conn) {
    unsigned char byte1 = conn.read();
    unsigned char byte2 = conn.read();
    unsigned char byte3 = conn.read();
    unsigned char byte4 = conn.read();
    return (byte1 << 24) | (byte2 << 16) | (byte3 << 8) | byte4;
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

void listNewsGroups(const Connection& conn){
    conn.write(Protocol::COM_LIST_NG);
    conn.write(Protocol::COM_END);
    //{Protocol::ANS_LIST_NG, Protocol::PAR_NUM};
    if(conn.read() != Protocol::ANS_LIST_NG || conn.read() != Protocol::PAR_NUM)
        throw ExceptionClosedException();

    int nbrNgs = readInt();

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
    
    Connection conn(argv[1], port);
    if (!conn.isConnected()) {
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
        }catch(Exception e){
            //something is wrong
        }

        welcomePrompt();
    }
}

