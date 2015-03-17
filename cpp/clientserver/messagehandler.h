#ifndef MESSAGE_HANDLER.h
#define MESSAGE_HANDLER.h

#include <string>
#include <vector>
#include <connection.h>

using namespace std;

class MessageHandler{
  public:
    int readNumber(const shared_ptr<Connection>& conn);
    char readChar(const shared_ptr<Connection>& conn);
    void expectInputChar(const shared_ptr<Connection>& conn, const char& expected);
    string readString(const shared_ptr<Connection>& conn, const int nbrChars);
    void addNumberToBytesVector(vector<unsigned char>& bytes, const int& num);
    void addStringBytesToVector(vector<unsigned char>& bytes, const string& s);
}
#endif

