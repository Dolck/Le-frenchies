#ifndef MESSAGE_HANDLER_H
#define MESSAGE_HANDLER_H

#include <string>
#include <vector>
#include "connection.h"

using namespace std;

class MessageHandler{
  public:
    static int readNumber(const shared_ptr<Connection>& conn);
    static char readChar(const shared_ptr<Connection>& conn);
    static void expectInputChar(const shared_ptr<Connection>& conn, const char& expected);
    static string readString(const shared_ptr<Connection>& conn);
    static void addNumberToBytesVector(vector<unsigned char>& bytes, const int& num);
    static void addStringBytesToVector(vector<unsigned char>& bytes, const string& s);
    static void writeByteVector(const shared_ptr<Connection>& conn, const vector<unsigned char>& bytes);
  private:
  	static int readInteger(const shared_ptr<Connection>& conn);
};
#endif

